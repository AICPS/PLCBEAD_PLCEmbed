FUNCTION TIME_TO_UDINT2:UDINT
	VAR_INPUT
		X :	TIME;
	END_VAR

	TIME_TO_UDINT2 := DINT_TO_UDINT(TIME_TO_DINT(X));
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

FUNCTION FRMP_B:BYTE
	VAR_INPUT
		START :	BYTE;
		DIR :	BOOL;
		TD :	TIME;
		TR :	TIME;
	END_VAR

	IF TD < TR THEN
		FRMP_B := MIN(UDINT_TO_BYTE(DWORD_TO_UDINT(SHL(TIME_TO_DWORD(TD), 8)) / TIME_TO_UDINT2(TR)), SEL(DIR, START, USINT_TO_BYTE(USINT#255 - BYTE_TO_USINT(START))));
		IF DIR THEN
			FRMP_B := USINT_TO_BYTE(BYTE_TO_USINT(START) + BYTE_TO_USINT(FRMP_B));
		ELSE
			FRMP_B := USINT_TO_BYTE(BYTE_TO_USINT(START) - BYTE_TO_USINT(FRMP_B));
		END_IF;
	ELSE
		FRMP_B := SEL(DIR, BYTE#0, BYTE#255);
	END_IF;
END_FUNCTION

FUNCTION_BLOCK _RMP_B
	VAR_INPUT
		DIR :	BOOL;
		E :	BOOL := TRUE;
		TR :	TIME;
	END_VAR


	VAR_IN_OUT
		RMP :	BYTE;
	END_VAR


	VAR
		T_PLC_MS :	T_PLC_MS_block;
		tx :	TIME;
		tl :	TIME;
		tn :	TIME;
		init :	BOOL;
		last_dir :	BOOL;
		start :	BYTE;
	END_VAR


	T_PLC_MS();
	tx := UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

	IF E AND init AND (dir = last_dir) AND (RMP <> SEL(DIR, BYTE#0, BYTE#255)) AND TR = tn THEN
		RMP := FRMP_B(start, DIR, tx - tl, TR);
	ELSE
		init := TRUE;
		tl := tx;
		tn := tr;
		start := RMP;
	END_IF;
	last_dir := dir;
END_FUNCTION_BLOCK

FUNCTION_BLOCK RMP_B_Block

	VAR_INPUT
		SET :	BOOL;
		PT :	TIME;
		E :	BOOL := TRUE;
		UP :	BOOL := TRUE;
		RST :	BOOL;
	END_VAR


	VAR_OUTPUT
		OUT :	BYTE;
		BUSY :	BOOL;
		HIGH :	BOOL;
		LOW :	BOOL;
	END_VAR


	VAR
		rmp :	_RMP_B;
	END_VAR

	rmp(dir := UP, E := E, TR := PT, RMP := out);
	out := rmp.RMP;

	IF RST THEN
		out := BYTE#0;
	ELSIF SET THEN
		out := BYTE#255;
	END_IF;

low := out = BYTE#0;
high := out = BYTE#255;
busy := NOT (low OR high) AND E;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		SET :	BOOL;
		PT :	TIME;
		E :	BOOL := TRUE;
		UP :	BOOL := TRUE;
		RST :	BOOL;

		OUT :	BYTE;
		BUSY :	BOOL;
		HIGH :	BOOL;
		LOW :	BOOL;

		func_block : RMP_B_Block;
	END_VAR
		func_block.SET := SET;
		func_block.PT := PT;
		func_block.E := E;
		func_block.UP := UP;
		func_block.RST := RST;
		func_block();
		OUT := func_block.OUT;
		BUSY := func_block.BUSY;
		HIGH := func_block.HIGH;
		LOW := func_block.LOW;

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