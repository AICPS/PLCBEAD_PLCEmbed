FUNCTION_BLOCK T_PLC_MS_block
	VAR_OUTPUT
		T_PLC_MS :	UDINT;
	END_VAR

	VAR
		PLC_TICKS_PER_SEC :	INT;
		PLC_SYS_TICK_CNT :	DINT;
	END_VAR

	VAR
		debug :	BOOL;(*Debug-Mode ON / OFF*)
		N :	INT;(*Debug-Faktor*)
		Offset :	UDINT;(*Debug-Offset*)
		temp :	DWORD := DWORD#1;(*Debug-Offset*)
		MODE :	BOOL;(*modus*)
		faktor :	UDINT;(*Systemtakt-Faktor*)
		init :	BOOL;
		v_plc_ticks_per_sec :	UDINT;
		base :	UDINT := UDINT#1000;
	END_VAR


	IF init = FALSE THEN
		v_plc_ticks_per_sec := INT_TO_UDINT(PLC_TICKS_PER_SEC);
		IF v_plc_ticks_per_sec = UDINT#1024 THEN
			faktor := UDINT#1;
			MODE := FALSE;
		ELSIF v_plc_ticks_per_sec > UDINT#0 THEN
			IF v_plc_ticks_per_sec <= base THEN
				faktor := base / v_plc_ticks_per_sec;
				MODE := FALSE;
			ELSE
				faktor := v_plc_ticks_per_sec / base;
				MODE := TRUE;
			END_IF;
		ELSE
			faktor := UDINT#1;
		END_IF;
		init := TRUE;
	END_IF;

	IF MODE THEN
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
		TX :	TIME;
		last :	TIME;
		init :	BOOL;
		T_PLC_MS :	T_PLC_MS_block;
	END_VAR

	T_PLC_MS();
	TX:= SUB_TIME(UDINT_TO_TIME(T_PLC_MS.T_PLC_MS), last);

	IF NOT init THEN
		init := TRUE;
		last := TX;
		TX := t#0s;
		OUT := IN;
	END_IF;
	IF NOT RMP THEN
		OUT := IN;
		BUSY := FALSE;
	ELSIF OUT > IN THEN
		(* ramp down *)
		OUT := OUT - TIME_TO_REAL(TX) * 0.001 * KF;
		OUT := MAX(IN, OUT);
	ELSIF OUT < IN THEN
		(* ramp up *)
		OUT := OUT + TIME_TO_REAL(TX) * 0.001 * KR;
		OUT := MIN(IN, OUT);
	END_IF;

	(* set BUSY and DIR flags *)
	IF OUT < IN THEN
		BUSY := TRUE;
		UD := TRUE;
	ELSIF OUT > IN THEN
		BUSY := TRUE;
		UD := FALSE;
	ELSE
		BUSY := FALSE;
	END_IF;
	last := ADD_TIME(last, TX);

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

