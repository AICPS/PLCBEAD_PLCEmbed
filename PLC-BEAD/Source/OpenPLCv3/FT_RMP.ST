FUNCTION_BLOCK T_PLC_MS_block
	VAR_OUTPUT
		T_PLC_MS :	UDINT;
	END_VAR

	VAR_EXTERNAL
		PLC_TICKS_PER_SEC :	INT;
		PLC_SYS_TICK_CNT :	DINT;
	END_VAR

	VAR
		debug :	BOOL;(*Debug-Mode ON / OFF*)
		N :	INT;(*Debug-Faktor*)
		Offset :	UDINT;(*Debug-Offset*)
		temp :	DWORD := DWORD#1;(*Debug-Offset*)
		mode :	BOOL;(*modus*)
		faktor :	UDINT;(*Systemtakt-Faktor*)
		init :	BOOL;
		v_plc_ticks_per_sec :	UDINT;
		base :	UDINT := UDINT#1000;
	END_VAR


	IF init = FALSE THEN
		v_plc_ticks_per_sec := INT_TO_UDINT(PLC_TICKS_PER_SEC);
		IF v_plc_ticks_per_sec = UDINT#1024 THEN
			faktor := UDINT#1;
			mode := FALSE;
		ELSIF v_plc_ticks_per_sec > UDINT#0 THEN
			IF v_plc_ticks_per_sec <= base THEN
				faktor := base / v_plc_ticks_per_sec;
				mode := FALSE;
			ELSE
				faktor := v_plc_ticks_per_sec / base;
				mode := TRUE;
			END_IF;
		ELSE
			faktor := UDINT#1;
		END_IF;
		init := TRUE;
	END_IF;

	IF mode THEN
		T_PLC_MS := DINT_TO_UDINT(PLC_SYS_TICK_CNT) / faktor;
	ELSE
		T_PLC_MS := DINT_TO_UDINT(PLC_SYS_TICK_CNT) * faktor;
	END_IF;

	IF debug THEN
		T_PLC_MS := (DWORD_TO_UDINT(SHL(UDINT_TO_DWORD(T_PLC_MS),N) OR SHL(temp,N)) - UDINT#1) + Offset;
	END_IF;
END_FUNCTION_BLOCK

FUNCTION_BLOCK FT_RMP

	VAR_INPUT
		RMP :	BOOL := TRUE;
		IN :	REAL;
		KR :	REAL;
		KF :	REAL;
	END_VAR

	VAR_OUTPUT
		OUT :	REAL;
		BUSY :	BOOL;
		UD :	BOOL;
	END_VAR

	VAR
		tx :	TIME;
		last :	TIME;
		init :	BOOL;
		T_PLC_MS :	T_PLC_MS_block;
	END_VAR

	T_PLC_MS();
	tx:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS) - last;

	IF NOT init THEN
		init := TRUE;
		last := tx;
		tx := t#0s;
		out := in;
	END_IF;
	IF NOT rmp THEN
		out := in;
		busy := FALSE;
	ELSIF out > in THEN
		(* ramp down *)
		out := out - TIME_TO_REAL(tx) * 0.001 * KF;
		out := MAX(in, out);
	ELSIF out < in THEN
		(* ramp up *)
		out := out + TIME_TO_REAL(tx) * 0.001 * KR;
		out := MIN(in, out);
	END_IF;

	(* set busy and dir flags *)
	IF out < in THEN
		busy := TRUE;
		ud := TRUE;
	ELSIF out > in THEN
		busy := TRUE;
		ud := FALSE;
	ELSE
		busy := FALSE;
	END_IF;
	last := last + tx;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		RMP :	BOOL := TRUE;
		IN :	REAL;
		KR :	REAL;
		KF :	REAL;

		OUT :	REAL;
		BUSY :	BOOL;
		UD :	BOOL;

		func_block : FT_RMP;
	END_VAR
	func_block.RMP := RMP;
	func_block.IN := IN;
	func_block.KR := KR;
	func_block.KF := KF;
	func_block();
	OUT := func_block.OUT;
	BUSY := func_block.BUSY;
	UD := func_block.UD;
	
END_PROGRAM

CONFIGURATION Config0
	
	VAR_GLOBAL
		PLC_TICKS_PER_SEC :	INT;
		PLC_SYS_TICK_CNT :	DINT;
	END_VAR

	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE

END_CONFIGURATION