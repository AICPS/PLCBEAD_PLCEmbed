TYPE
  	oscat_arr_0_7               : ARRAY [0..7]    OF REAL;
END_TYPE

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
		CNT :	INT;
		last :	TIME;
		TX :	TIME;
		init :	BOOL;
		T_PLC_MS :	T_PLC_MS_block;
	END_VAR

	T_PLC_MS();
	TX:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

	TRIG := FALSE;
	IF NOT init THEN
		X[CNT] := IN;
		init := TRUE;
		last := TX;
	ELSIF SUB_TIME(TX, last) >= DIVTIME(T, length) THEN
		IF CNT = length - 1 THEN CNT := 0; ELSE CNT := CNT + 1; END_IF;
		OUT := X[CNT];
		X[CNT] := IN;
		last := TX;
		TRIG := TRUE;
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

