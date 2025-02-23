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

FUNCTION_BLOCK SWITCH_I_Block

	VAR_INPUT
		SET :	BOOL;
		IN :	BOOL;
		RST :	BOOL;
		T_DEBOUNCE :	TIME := T#10ms;
		T_RECONFIG :	TIME := T#1s;
		T_ON_MAX :	TIME := T#0h;
	END_VAR


	VAR_OUTPUT
		Q :	BOOL := FALSE;
	END_VAR


	VAR
		state :	BYTE := BYTE#0;
		edge :	BOOL := FALSE;
		_r_edge :	BOOL := FALSE;
		T_on :	TIME;
		tx :	TIME;
		T_PLC_MS :	T_PLC_MS_Block;
	END_VAR

	T_PLC_MS();
	tx:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

	IF set AND NOT rst THEN
		Q := TRUE;
		T_on := tx;
	ELSIF rst THEN
		Q := FALSE;
	ELSIF (in XOR edge) AND NOT (state = BYTE#1) THEN
		state := BYTE#1;
		T_on := Tx;
	ELSIF (state = BYTE#1) AND (Tx - t_debounce >= T_on) THEN
		state := BYTE#2;
		IF _r_edge XOR in THEN Q := NOT Q; 
	END_IF;
	ELSIF state = BYTE#2 AND Tx - t_reconfig >= T_on THEN
		_r_edge := in;
	END_IF;
	IF Q AND T_on_max > t#0ms AND Tx >= T_on + T_on_max THEN
		Q := FALSE;
	END_IF;
	edge := in;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		SET :	BOOL;
		IN :	BOOL;
		RST :	BOOL;
		T_DEBOUNCE :	TIME := T#10ms;
		T_RECONFIG :	TIME := T#1s;
		T_ON_MAX :	TIME := T#0h;
		Q :	BOOL := FALSE;

		func_block : SWITCH_I_Block;
	END_VAR
	func_block.SET := SET;
	func_block.IN := IN;
	func_block.RST := RST ;
	func_block.T_DEBOUNCE := T_DEBOUNCE ;
	func_block.T_RECONFIG := T_RECONFIG ;
	func_block.T_ON_MAX := T_ON_MAX ;

	func_block();
	Q  := func_block.Q;
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