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
		debug :	BOOL;
		N :	INT;
		Offset :	UDINT;
		temp :	DWORD := DWORD#1;
		mode :	BOOL;
		faktor :	UDINT;
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

FUNCTION_BLOCK GEN_PW2_Block

	VAR_INPUT
		ENQ :	BOOL;
		TH1 :	TIME;
		TL1 :	TIME;
		TH2 :	TIME;
		TL2 :	TIME;
		TS :	BOOL;
	END_VAR


	VAR_OUTPUT
		Q :	BOOL;
		TH :	TIME;
		TL :	TIME;
	END_VAR


	VAR
		T_PLC_MS :	T_PLC_MS_Block;
		t_high :	TIME;
		t_low :	TIME;
		tx :	TIME;
		start :	TIME;
		init :	BOOL;
		et :	TIME;
	END_VAR

	T_PLC_MS();
	tx:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

	IF NOT init THEN
		start := tx;
		init := TRUE;
		TH := T#0s;
		TL := T#0s;
	END_IF;

	IF TS THEN
		t_high := TH2;
		t_low := TL2;
	ELSE
		t_high := TH1;
		t_low := TL1;
	END_IF;

	IF ENQ THEN
		et := tx - start;
		IF NOT Q THEN
			IF et >= t_low THEN
				Q := TRUE;
				start := tx;
				TL := T#0s;
			ELSE
				TL := et;
			END_IF;
		ELSE
			IF et >= t_high THEN
				Q := FALSE;
				start := tx;
				TH := T#0s;
			ELSE
				TH := et;
			END_IF;
		END_IF;
	ELSE
		Q := FALSE;
		TH := T#0s;
		TL := T#0s;
		start := tx;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	ENQ :	BOOL;
	TH1 :	TIME;
	TL1 :	TIME;
	TH2 :	TIME;
	TL2 :	TIME;
	TS :	BOOL;
	Q :	BOOL;
	TH :	TIME;
	TL :	TIME;
	func_block : GEN_PW2_Block;
  END_VAR
	func_block.ENQ  :=ENQ;
	func_block.TH1  :=TH1;
	func_block.TL1  :=TL1;
	func_block.TH2  :=TH2;
	func_block.TL2  :=TL2;
	func_block.TS  :=TS;
	func_block.TS  :=TS;
	func_block();
	Q := func_block.Q;
	TH := func_block.TH;
	TL := func_block.TL;

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