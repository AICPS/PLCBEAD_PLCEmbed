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

FUNCTION_BLOCK ACTUATOR_UD_Block

	VAR_INPUT
		UD :	BOOL;
		_ON :	BOOL;
		MANUAL :	BOOL;
		UP :	BOOL;
		DN :	BOOL;
		OFF :	BOOL;
		YUP_IN :	BOOL;
		YDN_IN :	BOOL;
		_TON :	TIME;
		TOFF :	TIME;
		OUT_RETURN :	BOOL;
	END_VAR


	VAR_OUTPUT
		YUP :	BOOL;
		YDN :	BOOL;
		STATUS :	BYTE;
	END_VAR


	VAR
		tx :	TIME;
		last :	TIME;
		init :	BOOL;
		T_PLC_MS :	T_PLC_MS_Block;
	END_VAR

	T_PLC_MS();
	tx:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

	IF NOT init THEN
		last := tx;
		init := TRUE;
	ELSIF off THEN
		Yup := FALSE;
		Ydn := FALSE;
		last := tx;
		status := BYTE#101;

	ELSIF ((Yup OR Ydn) AND tx - last < _TON) THEN RETURN;
	ELSIF NOT yup AND NOT ydn AND tx - last < toff THEN	RETURN;

	ELSIF manual THEN
		status := BYTE#102;
		IF yup AND NOT up OR ydn AND NOT dn THEN
			ydn := FALSE;
			yup := FALSE;
			last := tx;
		ELSIF UP AND NOT DN AND NOT OFF THEN
			Ydn := FALSE;
			Yup := TRUE;
			last := tx;
			status := BYTE#103;
		ELSIF DN AND NOT UP AND NOT OFF THEN
			Yup := FALSE;
			Ydn := TRUE;
			last := tx;
			status := BYTE#104;
		ELSE
			IF YUP OR YDN THEN LAST := tx; END_IF;
			Yup := FALSE;
			Ydn := FALSE;
		END_IF;

	ELSE
		IF yup AND NOT ud OR ydn AND UD THEN
			yup := FALSE;
			ydn := FALSE;
			last := tx;
		ELSIF Ud AND _ON AND NOT OFF THEN
			Ydn := FALSE;
			Yup := TRUE;
			last := tx;
			status := BYTE#111;

		ELSIF NOT UD AND _ON AND NOT OFF THEN
			Yup := FALSE;
			Ydn := TRUE;
			last := tx;
			status := BYTE#112;
		ELSE
			IF Yup OR Ydn THEN last := tx; END_IF;
			Yup := FALSE;
			Ydn := FALSE;
			status := BYTE#110;
		END_IF;
	END_IF;

	IF Ydn AND Yup_in AND out_return THEN
		Ydn := FALSE;
		status := BYTE#1;
	END_IF;
	IF Yup AND Ydn_in AND out_return THEN
		Yup := FALSE;
		status := BYTE#2;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		UD :	BOOL;
		_ON :	BOOL;
		MANUAL :	BOOL;
		UP :	BOOL;
		DN :	BOOL;
		OFF :	BOOL;
		YUP_IN :	BOOL;
		YDN_IN :	BOOL;
		_TON :	TIME;
		TOFF :	TIME;
		OUT_RETURN :	BOOL;
		YUP :	BOOL;
		YDN :	BOOL;
		STATUS :	BYTE;
		func_block : ACTUATOR_UD_Block;
	END_VAR
	func_block.UD := UD;
	func_block._ON := _ON;
	func_block.MANUAL := MANUAL ;
	func_block.UP := UP;
	func_block.DN := DN;
	func_block.OFF := OFF ;
	func_block.YUP_IN := YUP_IN;
	func_block.YDN_IN := YDN_IN;
	func_block._TON := _TON ;
	func_block.TOFF := TOFF;
	func_block.OUT_RETURN := OUT_RETURN;
	func_block();
	YUP  := func_block.YUP;
	YDN  := func_block.YDN;
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