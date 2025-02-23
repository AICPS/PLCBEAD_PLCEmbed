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

FUNCTION_BLOCK M_TX_Block

	VAR_INPUT
		IN :	BOOL;
		TMAX :	TIME := t#10d;
		RST :	BOOL;
	END_VAR


	VAR_OUTPUT
		TH :	TIME;
		TL :	TIME;
		DC :	REAL;
		F :	REAL;
		ET :	TIME;
	END_VAR


	VAR
		edge :	BOOL;
		START :	TIME;
		STOP :	TIME;
		TX :	TIME;
		rise :	BOOL;
		fall :	BOOL;
		STARTup :	BOOL;
		T_PLC_MS :	T_PLC_MS_block;
	END_VAR

	IF RST OR (ET >= TMAX) THEN
		rise := FALSE;
		fall := FALSE;
		STARTup := FALSE;
		TH := t#0ms;
		TL := t#0ms;
		DC := 0.0;
		F := 0.0;
		ET := t#0s;
	END_IF;

	(* avoid timers to START when input is true at STARTup *)
	IF NOT STARTup THEN
		edge := IN;
		STARTup := TRUE;
	END_IF;

	(* read system timer *)
	T_PLC_MS();
	TX:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

	(* edge TRIGger rising and falling edge *)
	IF IN XOR edge THEN
		edge := IN;
		(* rising edge STARTs measurement *)
		IF IN THEN
			START := TX;
			rise := TRUE;
			IF fall THEN TL := SUB_TIME(START, STOP); END_IF;
			IF TH > t#0ms AND TL > t#0ms THEN
				DC := TIME_TO_REAL(TH) / TIME_TO_REAL(ADD_TIME(TH, TL));
				F := 1000.0 / TIME_TO_REAL(ADD_TIME(TH, TL));
			END_IF;
		(* falling edge STARTs second cycle measurement *)
		ELSE
			STOP := TX;
			fall := TRUE;
			IF rise THEN TH := SUB_TIME(START, STOP); END_IF;
			IF TH > t#0ms AND TL > t#0ms THEN
				DC := TIME_TO_REAL(TH) /  TIME_TO_REAL(ADD_TIME(TH, TL));
				F := 1000.0 / TIME_TO_REAL(ADD_TIME(TH, TL));
			END_IF;
		END_IF;
	END_IF;
	IF rise THEN ET := SUB_TIME(TX, START); END_IF;

	(* check FOR RST input *)
	IF RST OR (ET >= TMAX) THEN
		rise := FALSE;
		fall := FALSE;
		STARTup := FALSE;
		TH := t#0ms;
		TL := t#0ms;
		DC := 0.0;
		F := 0.0;
		ET := t#0s;
	END_IF;

	(* avoid timers to START when input is true at STARTup *)
	IF NOT STARTup THEN
		edge := IN;
		STARTup := TRUE;
	END_IF;

	(* read system timer *)
	T_PLC_MS();
	TX:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

	(* edge TRIGger rising and falling edge *)
	IF IN XOR edge THEN
		edge := IN;
		(* rising edge STARTs measurement *)
		IF IN THEN
			START := TX;
			rise := TRUE;
			IF fall THEN TL := SUB_TIME(START, STOP); END_IF;
			IF TH > t#0ms AND TL > t#0ms THEN
				DC := TIME_TO_REAL(TH) / TIME_TO_REAL(ADD_TIME(TH, TL));
				F := 1000.0 / TIME_TO_REAL(ADD_TIME(TH, TL));
			END_IF;
		(* falling edge STARTs second cycle measurement *)
		ELSE
			STOP := TX;
			fall := TRUE;
			IF rise THEN TH := SUB_TIME(START, STOP); END_IF;
			IF TH > t#0ms AND TL > t#0ms THEN
				DC := TIME_TO_REAL(TH) /  TIME_TO_REAL(ADD_TIME(TH, TL));
				F := 1000.0 / TIME_TO_REAL(ADD_TIME(TH, TL));
			END_IF;
		END_IF;
	END_IF;
	IF rise THEN ET := SUB_TIME(TX, START); END_IF;

END_FUNCTION_BLOCK

PROGRAM program0

	VAR
		IN :	BOOL;
		TMAX :	TIME := t#10d;
		RST :	BOOL;

		TH :	TIME;
		TL :	TIME;
		DC :	REAL;
		F :	REAL;
		ET :	TIME;

		func_block : M_TX_Block;
	END_VAR
	func_block.IN := IN;
	func_block.TMAX := TMAX;
	func_block.RST := RST;

	func_block();
	TH := func_block.TH;
	TL := func_block.TL;
	DC := func_block.DC;
	F := func_block.F;
	ET := func_block.ET;

END_PROGRAM

