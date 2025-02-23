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
		tx :	UDINT;
		now :	UDINT;
		T_PLC_MS :	T_PLC_MS_Block;
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
		tx := now - last;
		IF (self_act_cycle > T#0s) AND (tx >= TIME_TO_UDINT2(self_act_cycle)) THEN
			OUT := TRUE;
			STATUS := BYTE#102;
			IF tx >= TIME_TO_UDINT2(self_act_cycle + self_act_time) THEN
				last := now;
				OUT := FALSE;
				STATUS := BYTE#100;
			END_IF;
		END_IF;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		IN :	BOOL;
		SELF_ACT_CYCLE :	TIME := T#10d;
		SELF_ACT_TIME :	TIME := T#1s;
		OUT :	BOOL;
		STATUS :	BYTE;
		func_block : ACTUATOR_COIL_Block;
	END_VAR
	func_block.IN := IN;
	func_block.SELF_ACT_CYCLE := SELF_ACT_CYCLE;
	func_block.SELF_ACT_TIME := SELF_ACT_TIME ;
	func_block();
	OUT  := func_block.OUT;
	STATUS  := func_block.STATUS;
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