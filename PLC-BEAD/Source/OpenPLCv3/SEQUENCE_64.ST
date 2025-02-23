TYPE
	oscat_array64_time          : ARRAY [0..63]   OF TIME;
END_TYPE

FUNCTION INC2:INT

	VAR_INPUT
		X :	INT;
		D :	INT;
		L :	INT;
		U :	INT;
	END_VAR

	VAR
		tmp :	INT;
	END_VAR

	tmp := U - L + 1;
	INC2 := (X + D - L + tmp) MOD tmp + L;

END_FUNCTION

FUNCTION UDINT_TO_TIME2:TIME

	VAR_INPUT
		IN :	UDINT;
	END_VAR


	UDINT_TO_TIME2 := DINT_TO_TIME(UDINT_TO_DINT(IN));

END_FUNCTION

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

FUNCTION_BLOCK SEQUENCE_64_Block

	VAR_INPUT
		START :	BOOL;
		SMAX :	INT;
		RST :	BOOL;
	END_VAR

	VAR_OUTPUT
		STATE :	INT := INT#-1;
		TRIG :	BOOL;
	END_VAR

	VAR_IN_OUT
		PROG :	oscat_array64_time;
	END_VAR

	VAR
		T_PLC_MS :	T_PLC_MS_block;
		tx :	TIME;
		last :	TIME;
		edge :	BOOL;
	END_VAR

	T_PLC_MS();
	tx:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);
	TRIG := FALSE;

	IF RST THEN
		STATE := -1;

	ELSIF START AND NOT edge THEN
		STATE := 0;
		last := tx;
		TRIG := TRUE;

	ELSIF (STATE >= 0) THEN
		IF (tx - last) >= PROG[STATE] THEN
			STATE := INC2(STATE, 1, -1, SMAX);
			last := tx;
			TRIG := TRUE;
		END_IF;
	END_IF;

	edge := START;
END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		START :	BOOL;
		SMAX :	INT;
		RST :	BOOL;
		STATE :	INT := INT#-1;
		TRIG :	BOOL;
		func_block : SEQUENCE_64_Block;
  	END_VAR
	func_block.START  :=START;
	func_block.SMAX  :=SMAX;
	func_block.RST  :=RST;
	func_block();
	STATE := func_block.STATE;
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
