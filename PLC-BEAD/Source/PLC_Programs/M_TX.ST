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
		start :	TIME;
		stop :	TIME;
		tx :	TIME;
		rise :	BOOL;
		fall :	BOOL;
		startup :	BOOL;
		T_PLC_MS :	T_PLC_MS_block;
	END_VAR

	IF rst OR (et >= tmax) THEN
		rise := FALSE;
		fall := FALSE;
		startup := FALSE;
		th := t#0ms;
		tl := t#0ms;
		DC := 0.0;
		F := 0.0;
		ET := t#0s;
	END_IF;

	(* avoid timers to start when input is true at startup *)
	IF NOT startup THEN
		edge := in;
		startup := TRUE;
	END_IF;

	(* read system timer *)
	T_PLC_MS();
	tx:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

	(* edge trigger rising and falling edge *)
	IF in XOR edge THEN
		edge := in;
		(* rising edge starts measurement *)
		IF in THEN
			start := Tx;
			rise := TRUE;
			IF fall THEN tl := start - stop; END_IF;
			IF th > t#0ms AND tl > t#0ms THEN
				dc := TIME_TO_REAL(th) / TIME_TO_REAL(th+tl);
				f := 1000.0 / TIME_TO_REAL(th + tl);
			END_IF;
		(* falling edge starts second cycle measurement *)
		ELSE
			stop := Tx;
			fall := TRUE;
			IF rise THEN th := stop - start; END_IF;
			IF th > t#0ms AND tl > t#0ms THEN
				dc := TIME_TO_REAL(th) /  TIME_TO_REAL(th+tl);
				f := 1000.0 / TIME_TO_REAL(th + tl);
			END_IF;
		END_IF;
	END_IF;
	IF rise THEN et := tx - start; END_IF;

	(* check FOR rst input *)
	IF rst OR (et >= tmax) THEN
		rise := FALSE;
		fall := FALSE;
		startup := FALSE;
		th := t#0ms;
		tl := t#0ms;
		DC := 0.0;
		F := 0.0;
		ET := t#0s;
	END_IF;

	(* avoid timers to start when input is true at startup *)
	IF NOT startup THEN
		edge := in;
		startup := TRUE;
	END_IF;

	(* read system timer *)
	T_PLC_MS();
	tx:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

	(* edge trigger rising and falling edge *)
	IF in XOR edge THEN
		edge := in;
		(* rising edge starts measurement *)
		IF in THEN
			start := Tx;
			rise := TRUE;
			IF fall THEN tl := start - stop; END_IF;
			IF th > t#0ms AND tl > t#0ms THEN
				dc := TIME_TO_REAL(th) / TIME_TO_REAL(th+tl);
				f := 1000.0 / TIME_TO_REAL(th + tl);
			END_IF;
		(* falling edge starts second cycle measurement *)
		ELSE
			stop := Tx;
			fall := TRUE;
			IF rise THEN th := stop - start; END_IF;
			IF th > t#0ms AND tl > t#0ms THEN
				dc := TIME_TO_REAL(th) /  TIME_TO_REAL(th+tl);
				f := 1000.0 / TIME_TO_REAL(th + tl);
			END_IF;
		END_IF;
	END_IF;
	IF rise THEN et := tx - start; END_IF;

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

