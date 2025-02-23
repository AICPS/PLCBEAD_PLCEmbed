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
		OffsET :	UDINT;(*Debug-OffsET*)
		temp :	DWORD := DWORD#1;(*Debug-OffsET*)
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
		T_PLC_MS := (DWORD_TO_UDINT(SHL(UDINT_TO_DWORD(T_PLC_MS),N) OR SHL(temp,N)) - UDINT#1) + OffsET;
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
		TX :	TIME;
		STARTup :	BOOL;
		T_PLC_MS :	T_PLC_MS_block;
	END_VAR

	(* check for RST input *)
	IF RST OR ET >= TMAX THEN
		PT := t#0ms;
		ET := t#0ms;
		STARTup := FALSE;
		RUN := FALSE;
	END_IF;

	(* avoid timers to START when input is true at STARTup *)
	IF NOT STARTup THEN
		edge := START;
		STARTup := TRUE;
	END_IF;

	(* read system timer *)
	T_PLC_MS();
	TX:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

	(* dETect rising edge on START *)
	IF START AND NOT edge AND NOT STOP THEN
		T0 := TX;
		RUN := TRUE;
		PT := t#0s;
	ELSIF STOP AND RUN THEN
		PT := ET;
		RUN := FALSE;
	END_IF;
	edge := START;
	IF RUN THEN ET := SUB_TIME(TX , T0); END_IF;

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

