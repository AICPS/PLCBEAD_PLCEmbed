TYPE
  	oscat_arr_0_7               : ARRAY [0..7]    OF REAL;
END_TYPE

FUNCTION_BLOCK T_PLC_MS_Block
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


FUNCTION_BLOCK FT_TN8

	VAR_INPUT
		IN :	REAL;
		T :	TIME;
	END_VAR

	VAR_OUTPUT
		OUT :	REAL;
		TRIG :	BOOL;
	END_VAR

	VAR
		length :	INT := 8;
		X :	oscat_arr_0_7;
		cnt :	INT;
		last :	TIME;
		tx :	TIME;
		init :	BOOL;
		T_PLC_MS :	T_PLC_MS_Block;
	END_VAR

	T_PLC_MS();
	tx:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

	trig := FALSE;
	IF NOT init THEN
		x[cnt] := in;
		init := TRUE;
		last := tx;
	ELSIF tx - last >= (T / length) THEN
		IF cnt = length - 1 THEN cnt := 0; ELSE cnt := cnt + 1; END_IF;
		Out := X[cnt];
		x[cnt] := in;
		last := tx;
		trig := TRUE;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	IN :	REAL;
	T :	TIME;

	OUT :	REAL;
	TRIG :	BOOL;

	func_block : FT_TN8;
  END_VAR
	func_block.IN  :=IN ;
	func_block.T  :=T ;
	func_block();
	OUT := func_block.OUT;
	TRIG := func_block.TRIG;
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