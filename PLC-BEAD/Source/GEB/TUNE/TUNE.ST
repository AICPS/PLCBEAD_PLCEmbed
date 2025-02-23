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

FUNCTION_BLOCK TUNE_Block

	VAR_INPUT
		SET :	BOOL;
		SU :	BOOL;
		SD :	BOOL;
		RST :	BOOL;
		SS :	REAL := 0.1;
		LIMIT_L :	REAL;
		LIMIT_H :	REAL := 100.0;
		RST_VAL :	REAL;
		SET_VAL :	REAL := 100.0;
		T1 :	TIME := T#500ms;
		T2 :	TIME := T#2s;
		S1 :	REAL := 2.0;
		S2 :	REAL := 10.0;
	END_VAR


	VAR_OUTPUT
		Y :	REAL;
	END_VAR


	VAR
		TX :	UDINT;
		START :	UDINT;
		START2 :	UDINT;
		STATE :	INT;
		IN :	BOOL;
		STEP2 :	REAL;
		SPEED :	REAL;
		Y_START :	REAL;
		Y_START2 :	REAL;
		T_PLC_MS :	T_PLC_MS_block;
	END_VAR


	T_PLC_MS();
	TX:= T_PLC_MS.T_PLC_MS;

	IF RST THEN
		Y := RST_VAL;
		STATE := 0;
	ELSIF SET THEN
		Y := SET_VAL;
		STATE := 0;
	ELSIF STATE > 0 THEN
		IF STATE = 1 THEN
			IN := su;
		ELSE
			IN := sd;
		END_IF;
		IF NOT IN AND TX - START <= TIME_TO_UDINT2(T1) THEN
			Y := Y_START + STEP2;
			STATE := 0;
		ELSIF IN AND TX - START >= TIME_TO_UDINT2(T2) THEN
			Y := Y_START2 + UDINT_TO_REAL(TX - START2) * S2 / SPEED;
		ELSIF IN AND TX - START >= TIME_TO_UDINT2(T1) THEN
			Y := Y_START + UDINT_TO_REAL(TX - START - TIME_TO_UDINT2(T1)) * S1 / SPEED;
			START2 := TX;
			Y_START2 := Y;
		ELSIF NOT IN THEN
			STATE := 0;
		END_IF;
	ELSIF su THEN
		STATE := 1;
		START := TX;
		STEP2 := ss;
		SPEED := 1000.0;
		Y_START := Y;
	ELSIF sd THEN

		STATE := 2;
		START := TX;
		STEP2 := -ss;
		SPEED := -1000.0;
		Y_START := Y;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
  	VAR
		SET :	BOOL;
		SU :	BOOL;
		SD :	BOOL;
		RST :	BOOL;
		SS :	REAL := 0.1;
		LIMIT_L :	REAL;
		LIMIT_H :	REAL := 100.0;
		RST_VAL :	REAL;
		SET_VAL :	REAL := 100.0;
		T1 :	TIME := T#500ms;
		T2 :	TIME := T#2s;
		S1 :	REAL := 2.0;
		S2 :	REAL := 10.0;
		Y :	REAL;
		func_block : TUNE_Block;
  	END_VAR
	func_block.SET := SET;
	func_block.SU := SU;
	func_block.SD := SD;
	func_block.RST := RST;
	func_block.SS:= SS;
	func_block.LIMIT_L := LIMIT_L;
	func_block.LIMIT_H := LIMIT_H;
	func_block.RST_VAL := RST_VAL;
	func_block.SET_VAL := SET_VAL;
	func_block.T1 := T1;
	func_block.T2 := T2;
	func_block.S1 := S1;
	func_block.S2 := S2;
	func_block();
	Y := func_block.Y;
END_PROGRAM

