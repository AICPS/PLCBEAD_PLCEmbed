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

FUNCTION_BLOCK SCHEDULER_Block

	VAR_INPUT
		E0 :	BOOL;
		E1 :	BOOL;
		E2 :	BOOL;
		E3 :	BOOL;
		T0 :	TIME;
		T1 :	TIME;
		T2 :	TIME;
		T3 :	TIME;
	END_VAR

	VAR_OUTPUT
		Q0 :	BOOL;
		Q1 :	BOOL;
		Q2 :	BOOL;
		Q3 :	BOOL;
	END_VAR

	VAR
		T_PLC_MS :	T_PLC_MS_Block;
		init :	BOOL;
		s0 :	TIME;
		s1 :	TIME;
		s2 :	TIME;
		s3 :	TIME;
		tx :	TIME;
		c :	INT;
	END_VAR


	T_PLC_MS();
	tx:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

	IF NOT init THEN
		init := TRUE;
		s0 := tx - T0;
		s1 := tx - T1;
		s2 := tx - T2;
		s3 := tx - T3;
	END_IF;

	Q0 := FALSE;
	Q1 := FALSE;
	Q2 := FALSE;
	Q3 := FALSE;

	CASE c OF
		0: 	IF tx - s0 >= T0 THEN
				Q0 := E0;
				s0 := tx;
			END_IF;
			c := 1;
		1: 	IF tx - s1 >= T1 THEN
				Q1 := E1;
				s1 := tx;
			END_IF;
			c := 2;
		2: 	IF tx - s2 >= T2 THEN
				Q2 := E2;
				s2 := tx;
			END_IF;
			c := 3;
		3: 	IF tx - s3 >= T3 THEN
				Q3 := E3;
				s3 := tx;
			END_IF;
			c := 0;
	END_CASE;

END_FUNCTION_BLOCK

PROGRAM program0

	VAR
		E0 :	BOOL;
		E1 :	BOOL;
		E2 :	BOOL;
		E3 :	BOOL;
		T0 :	TIME;
		T1 :	TIME;
		T2 :	TIME;
		T3 :	TIME;
		Q0 :	BOOL;
		Q1 :	BOOL;
		Q2 :	BOOL;
		Q3 :	BOOL;
		func_block : SCHEDULER_Block;
  	END_VAR
	func_block.E0  :=	E0;
	func_block.E1  :=	E1;
	func_block.E2  :=	E2;
	func_block.E3  :=	E3;
	func_block.T0  :=	T0;
	func_block.T1  :=	T1;
	func_block.T2  :=	T2;
	func_block.T3  :=	T3;
	func_block();
	Q0 := func_block.Q0;
	Q1 := func_block.Q1;
	Q2 := func_block.Q2;
	Q3 := func_block.Q3;


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