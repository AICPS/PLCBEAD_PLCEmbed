FUNCTION_BLOCK TONOF

	VAR_INPUT
		IN :	BOOL;
		T_ON :	TIME;
		T_OFF :	TIME;
	END_VAR


	VAR_OUTPUT
		Q :	BOOL;
	END_VAR


	VAR
		X :	TON;
		old :	BOOL;
		MODE :	BOOL;
	END_VAR

	IF IN XOR old THEN
	X(IN := FALSE, PT := SEL_TIME(IN,T_OFF,T_ON));
	MODE := IN;
	old := IN;
	END_IF;
	X(IN := TRUE);
	IF X.Q THEN Q := MODE;END_IF;

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

FUNCTION TIME_TO_UDINT2:UDINT
	VAR_INPUT
		X :	TIME;
	END_VAR

	TIME_TO_UDINT2 := DINT_TO_UDINT(TIME_TO_DINT(X));
END_FUNCTION

FUNCTION_BLOCK ACTUATOR_COIL_Block

	VAR_INPUT
		IN :	BOOL;
		SELF_ACT_CYCLE :	TIME := T#10d;
		SELF_ACT_TIME :	TIME := T#1s;
	END_VAR


	VAR_OUTPUT
		OUT :	BOOL;
		STATUS :	BYTE;
	END_VAR


	VAR
		last :	UDINT;
		init :	BOOL;
		TX :	UDINT;
		now :	UDINT;
		T_PLC_MS :	T_PLC_MS_block;
	END_VAR

	T_PLC_MS();
	now := T_PLC_MS.T_PLC_MS;

	IF NOT init THEN
		last := now;
		init := TRUE;
	ELSIF IN THEN
		OUT := TRUE;
		STATUS := BYTE#101;
		LAST := now;
	ELSE
		OUT := FALSE;
		STATUS := BYTE#100;
		TX := now - last;
		IF (self_act_cycle > T#0s) AND (TX >= TIME_TO_UDINT2(self_act_cycle)) THEN
			OUT := TRUE;
			STATUS := BYTE#102;
			IF TX >= TIME_TO_UDINT2(self_act_cycle + self_act_time) THEN
				last := now;
				OUT := FALSE;
				STATUS := BYTE#100;
			END_IF;
		END_IF;
	END_IF;

END_FUNCTION_BLOCK

FUNCTION_BLOCK TANK_LEVEL_Block

	VAR_INPUT
		LEVEL :	BOOL;
		LEAK :	BOOL;
		ACLR :	BOOL;
		MAX_VALVE_TIME :	TIME;
		LEVEL_DELAY_TIME :	TIME;
	END_VAR


	VAR_OUTPUT
		VALVE :	BOOL;
		ALARM :	BOOL;
		STATUS :	BYTE;
	END_VAR


	VAR
		CX :	ACTUATOR_COIL_Block;
		tn :	TON;
		TL :	TONOF;
		open :	BOOL;
	END_VAR

	TL(IN := level, T_ON := level_DELAY_time, T_OFF := level_DELAY_time);
	open := TL.Q;

	IF ALARM THEN
		IF ACLR THEN
			ALARM := FALSE;
			STATUS := BYTE#101;
			CX(IN := FALSE);
		END_IF;
		RETURN;
	ELSIF LEAK THEN
		CX(IN := FALSE);
		ALARM := TRUE;
		STATUS := BYTE#1;	
	ELSIF open THEN
		CX(IN := TRUE);
		STATUS := BYTE#102;
	ELSE
		CX(IN := FALSE);
		STATUS := BYTE#100;
	END_IF;

	tn(IN := CX.OUT AND (MAX_VALVE_TIME > T#0s), PT := MAX_VALVE_TIME);
	IF tn.Q THEN
		ALARM := TRUE;
		STATUS := BYTE#2; 
		CX(IN := FALSE);
	END_IF;

	VALVE := CX.OUT;
END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		LEVEL :	BOOL;
		LEAK :	BOOL;
		ACLR :	BOOL;
		MAX_VALVE_TIME :	TIME;
		LEVEL_DELAY_TIME :	TIME;
		VALVE :	BOOL;
		ALARM :	BOOL;
		STATUS :	BYTE;

		func_block : TANK_LEVEL_Block;
	END_VAR
	func_block.LEVEL := LEVEL;
	func_block.LEAK := LEAK;
	func_block.ACLR := ACLR ;
	func_block.MAX_VALVE_TIME := MAX_VALVE_TIME;
	func_block.LEVEL_DELAY_TIME := LEVEL_DELAY_TIME ;
	func_block();
	VALVE  := func_block.VALVE;
	ALARM  := func_block.ALARM;
	STATUS  := func_block.STATUS;
END_PROGRAM

