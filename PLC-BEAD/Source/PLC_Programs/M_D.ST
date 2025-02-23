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

FUNCTION_BLOCK M_D_Block

	VAR_INPUT
		START :	BOOL;
		STOP :	BOOL;
		TMAX :	TIME := t#10d;
		RST :	BOOL;
	END_VAR

	VAR_OUTPUT
		PT :	TIME;
		ET :	TIME;
		RUN :	BOOL;
	END_VAR

	VAR
		edge :	BOOL;
		T0 :	TIME;
		tx :	TIME;
		startup :	BOOL;
		T_PLC_MS :	T_PLC_MS_Block;
	END_VAR

	(* check for rst input *)
	IF rst OR et >= tmax THEN
		pt := t#0ms;
		et := t#0ms;
		startup := FALSE;
		run := FALSE;
	END_IF;

	(* avoid timers to start when input is true at startup *)
	IF NOT startup THEN
		edge := start;
		startup := TRUE;
	END_IF;

	(* read system timer *)
	T_PLC_MS();
	tx:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

	(* detect rising edge on start *)
	IF start AND NOT edge AND NOT stop THEN
		t0 := tx;
		run := TRUE;
		pt := t#0s;
	ELSIF stop AND run THEN
		pt := et;
		run := FALSE;
	END_IF;
	edge := start;
	IF run THEN et := tx - t0; END_IF;

END_FUNCTION_BLOCK

PROGRAM program0

	VAR
		START :	BOOL;
		STOP :	BOOL;
		TMAX :	TIME := t#10d;
		RST :	BOOL;

		PT :	TIME;
		ET :	TIME;
		RUN :	BOOL;

		func_block : M_D_Block;
	END_VAR
	func_block.START := START;
	func_block.STOP := STOP;
	func_block.TMAX := TMAX;
	func_block.RST := RST;

	func_block();
	PT := func_block.PT;
	ET := func_block.ET;
	RUN := func_block.RUN;

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
