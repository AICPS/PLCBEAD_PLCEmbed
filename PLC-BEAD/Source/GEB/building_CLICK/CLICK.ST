FUNCTION_BLOCK SW_RECONFIG_Block

	VAR_INPUT
		IN :	BOOL;
		TD :	TIME;
		TR :	TIME;
	END_VAR


	VAR_OUTPUT
		Q :	BOOL;
	END_VAR


	VAR
		T1 :	TON;
		T2 :	TON;
		INV :	BOOL;
	END_VAR

	t1(IN := IN, PT := TD);

	IF TR > t#0s THEN
		Q := t1.Q XOR inv;
		T2(IN := Q, PT := TR);
		IF T2.Q THEN INV := NOT INV; END_IF;
	ELSE
		Q := t1.Q;
	END_IF;

END_FUNCTION_BLOCK

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

FUNCTION_BLOCK CLICK_Block

	VAR_INPUT
		IN :	BOOL;
		T_DEBOUNCE :	TIME := T#10ms;
		T_SHORT :	TIME := T#200ms;
		T_PAUSE :	TIME := T#500ms;
		T_RECONFIG :	TIME := T#1m;
	END_VAR


	VAR_OUTPUT
		Q :	BOOL;
		SINGLE :	BOOL;
		DOUBLE :	BOOL;
		TRIPLE :	BOOL;
		STATUS :	BYTE;
	END_VAR


	VAR
		s_IN :	SW_RECONFIG_Block;
		TX :	TIME;
		STATE :	INT;
		last :	TIME;
		T_PLC_MS :	T_PLC_MS_block;
	END_VAR

	s_in(IN := in, TD := T_debounce, TR := T_reconfig);

	T_PLC_MS();
	TX:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

	IF s_in.Q XOR Q THEN
		last := TX;
		IF s_in.Q THEN STATE := STATE + 1; END_IF;
	END_IF;
	Q := s_in.Q;

	IF STATE > 0 THEN
		IF (Q AND SUB_TIME(TX, last) > t_short) OR (NOT Q AND SUB_TIME(TX, last) > t_paUSE) THEN
			CASE STATE OF
				1:	single := TRUE;
					STATUS := BYTE#111;
				2:	double := TRUE;
					STATUS := BYTE#112;
				3:	triple := TRUE;
					STATUS := BYTE#113;
			END_CASE;
			STATE := 0;
		END_IF;
	ELSIF NOT q THEN
		single := FALSE;
		double := FALSE;
		triple := FALSE;
		STATUS := BYTE#110;
		last := TX;
		STATE := 0;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		IN :	BOOL;
		T_DEBOUNCE :	TIME := T#10ms;
		T_SHORT :	TIME := T#200ms;
		T_PAUSE :	TIME := T#500ms;
		T_RECONFIG :	TIME := T#1m;
		Q :	BOOL;
		SINGLE :	BOOL;
		DOUBLE :	BOOL;
		TRIPLE :	BOOL;
		STATUS :	BYTE;

		func_block : CLICK_Block;
	END_VAR
	func_block.IN := IN;
	func_block.T_DEBOUNCE := T_DEBOUNCE;
	func_block.T_SHORT := T_SHORT;
	func_block.T_PAUSE := T_PAUSE;
	func_block.T_RECONFIG := T_RECONFIG;

	func_block();
	Q  := func_block.Q;
	SINGLE  := func_block.SINGLE;
	DOUBLE  := func_block.DOUBLE;
	TRIPLE  := func_block.TRIPLE;
	STATUS  := func_block.STATUS;
END_PROGRAM

