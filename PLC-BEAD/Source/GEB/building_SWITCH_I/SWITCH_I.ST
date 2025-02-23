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
		STATE :	BYTE := BYTE#0;
		edge :	BOOL := FALSE;
		_r_edge :	BOOL := FALSE;
		T_on :	TIME;
		TX :	TIME;
		T_PLC_MS :	T_PLC_MS_block;
	END_VAR

	T_PLC_MS();
	TX:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

	IF SET AND NOT RST THEN
		Q := TRUE;
		T_on := TX;
	ELSIF RST THEN
		Q := FALSE;
	ELSIF (IN XOR edge) AND NOT (STATE = BYTE#1) THEN
		STATE := BYTE#1;
		T_on := TX;
	ELSIF (STATE = BYTE#1) AND (TX - t_debounce >= T_on) THEN
		STATE := BYTE#2;
		IF _r_edge XOR IN THEN Q := NOT Q; 
	END_IF;
	ELSIF STATE = BYTE#2 AND TX - t_reconfig >= T_on THEN
		_r_edge := IN;
	END_IF;
	IF Q AND T_on_max > t#0ms AND TX >= T_on + T_on_max THEN
		Q := FALSE;
	END_IF;
	edge := IN;

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

