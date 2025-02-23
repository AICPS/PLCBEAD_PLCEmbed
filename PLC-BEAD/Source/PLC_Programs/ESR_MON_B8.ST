TYPE
	oscat_esr_collect_data      : ARRAY [0..7]    OF BYTE;
END_TYPE
TYPE oscat_esr_data :
  STRUCT
	typ    : BYTE;
	adress : STRING;
	DS     : UDINT;
	TS     : TIME;
	data   : oscat_esr_collect_data;
  END_STRUCT;
END_TYPE

TYPE
  oscat_ESR_3                : ARRAY [0..3] OF oscat_esr_data;
  oscat_ESR_31               : ARRAY [0..31] OF oscat_esr_data;
END_TYPE

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

FUNCTION_BLOCK ESR_MON_B8

	VAR_INPUT
		S0 :	BOOL;
		A0 :	STRING;
		S1 :	BOOL;
		A1 :	STRING;
		S2 :	BOOL;
		A2 :	STRING;
		S3 :	BOOL;
		A3 :	STRING;
		S4 :	BOOL;
		A4 :	STRING;
		S5 :	BOOL;
		A5 :	STRING;
		S6 :	BOOL;
		A6 :	STRING;
		S7 :	BOOL;
		A7 :	STRING;
		DT_IN :	UDINT;
	END_VAR

	VAR_IN_OUT
		ESR_Out :	oscat_ESR_3;
	END_VAR

	VAR_OUTPUT
		ESR_FLAG :	BOOL;
	END_VAR

	VAR
		x0 :	BOOL;
		x1 :	BOOL;
		x2 :	BOOL;
		x3 :	BOOL;
		x4 :	BOOL;
		x5 :	BOOL;
		x6 :	BOOL;
		x7 :	BOOL;
		tx :	TIME;
		cnt :	INT;
		T_PLC_MS :	T_PLC_MS_block;
	END_VAR

	T_PLC_MS();
	tx:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

	ESR_Flag := FALSE;
	esr_out[3].typ := BYTE#0;
	esr_out[2].typ := BYTE#0;
	esr_out[1].typ := BYTE#0;
	esr_out[0].typ := BYTE#0;
	cnt := 0;

	IF s0 <> X0 THEN
		esr_out[cnt].typ := INT_TO_BYTE(10 + BOOL_TO_INT(s0));
		esr_out[cnt].adress := a0;
		esr_out[cnt].DS := DT_in;
		esr_out[cnt].TS := TX;
		X0 := S0;
		cnt := cnt + 1;
		esr_flag := TRUE;
	END_IF;
	IF s1 <> X1 THEN
		esr_out[cnt].typ := INT_TO_BYTE(10 + BOOL_TO_INT(s1));
		esr_out[cnt].adress := a1;
		esr_out[cnt].DS := DT_in;
		esr_out[cnt].TS := TX;
		X1 := S1;
		cnt := cnt + 1;
		esr_flag := TRUE;
	END_IF;
	IF s2 <> X2 THEN
		esr_out[cnt].typ := INT_TO_BYTE(10 + BOOL_TO_INT(s2));
		esr_out[cnt].adress := a2;
		esr_out[cnt].DS := DT_in;
		esr_out[cnt].TS := TX;
		X2 := S2;
		cnt := cnt + 1;
		esr_flag := TRUE;
	END_IF;
	IF s3 <> X3 THEN
		esr_out[cnt].typ := INT_TO_BYTE(10 + BOOL_TO_INT(s3));
		esr_out[cnt].adress := a3;
		esr_out[cnt].DS := DT_in;
		esr_out[cnt].TS := TX;
		X3 := S3;
		cnt := cnt + 1;
		esr_flag := TRUE;
	END_IF;
	IF s4 <> X4 AND cnt < 4 THEN
		esr_out[cnt].typ := INT_TO_BYTE(10 + BOOL_TO_INT(s4));
		esr_out[cnt].adress := a4;
		esr_out[cnt].DS := DT_in;
		esr_out[cnt].TS := TX;
		X4 := S4;
		cnt := cnt + 1;
		esr_flag := TRUE;
	END_IF;
	IF s5 <> X5  AND cnt < 4 THEN
		esr_out[cnt].typ := INT_TO_BYTE(10 + BOOL_TO_INT(s5));
		esr_out[cnt].adress := a5;
		esr_out[cnt].DS := DT_in;
		esr_out[cnt].TS := TX;
		X5 := S5;
		cnt := cnt + 1;
		esr_flag := TRUE;
	END_IF;
	IF s6 <> X6  AND cnt < 4 THEN
		esr_out[cnt].typ := INT_TO_BYTE(10 + BOOL_TO_INT(s6));
		esr_out[cnt].adress := a6;
		esr_out[cnt].DS := DT_in;
		esr_out[cnt].TS := TX;
		X6 := S6;
		cnt := cnt + 1;
		esr_flag := TRUE;
	END_IF;
	IF s7 <> X7  AND cnt < 4 THEN
		esr_out[cnt].typ := INT_TO_BYTE(10 + BOOL_TO_INT(s7));
		esr_out[cnt].adress := a7;
		esr_out[cnt].DS := DT_in;
		esr_out[cnt].TS := TX;
		X7 := S7;
		cnt := cnt + 1;
		esr_flag := TRUE;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0

	VAR

		S0 :	BOOL;
		A0 :	STRING;
		S1 :	BOOL;
		A1 :	STRING;
		S2 :	BOOL;
		A2 :	STRING;
		S3 :	BOOL;
		A3 :	STRING;
		S4 :	BOOL;
		A4 :	STRING;
		S5 :	BOOL;
		A5 :	STRING;
		S6 :	BOOL;
		A6 :	STRING;
		S7 :	BOOL;
		A7 :	STRING;
		DT_IN   :	UDINT;

		ESR_Out :	oscat_ESR_3;

		ESR_FLAG :	BOOL;

		func_block : ESR_MON_B8;
  	END_VAR
	func_block.S0 := S0;
	func_block.A0 := A0;
	func_block.S1 := S1;
	func_block.A1 := A1;
	func_block.S2 := S2;
	func_block.A2 := A2;
	func_block.S3 := S3;
	func_block.A3 := A3;
	func_block.S4 := S4;
	func_block.A4 := A4;
	func_block.S5 := S5;
	func_block.A5 := A5;
	func_block.S6 := S6;
	func_block.A6 := A6;
	func_block.S7 := S7;
	func_block.A7 := A7;
	func_block.DT_IN := DT_IN;
	func_block.ESR_Out := ESR_Out;
	func_block();
	ESR_Out := func_block.ESR_Out;
	ESR_FLAG := func_block.ESR_FLAG;

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