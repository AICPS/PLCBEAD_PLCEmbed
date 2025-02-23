TYPE
	oscat_ESR_collect_data      : ARRAY [0..7]    OF BYTE;
END_TYPE
TYPE oscat_ESR_data :
  STRUCT
	typ    : BYTE;
	ADRESS : STRING;
	DS     : UDINT;
	TS     : TIME;
	data   : oscat_ESR_collect_data;
  END_STRUCT;
END_TYPE

TYPE
  oscat_ESR_3                : ARRAY [0..3] OF oscat_ESR_data;
  oscat_ESR_31               : ARRAY [0..31] OF oscat_ESR_data;
END_TYPE

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
		ESR_OUT :	oscat_ESR_3;
	END_VAR

	VAR_OUTPUT
		ESR_FLAG :	BOOL;
	END_VAR

	VAR
		X0 :	BOOL;
		X1 :	BOOL;
		X2 :	BOOL;
		X3 :	BOOL;
		X4 :	BOOL;
		X5 :	BOOL;
		X6 :	BOOL;
		X7 :	BOOL;
		TX :	TIME;
		CNT :	INT;
		T_PLC_MS :	T_PLC_MS_block;
	END_VAR

	T_PLC_MS();
	TX:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

	ESR_FLAG := FALSE;
	ESR_OUT[3].typ := BYTE#0;
	ESR_OUT[2].typ := BYTE#0;
	ESR_OUT[1].typ := BYTE#0;
	ESR_OUT[0].typ := BYTE#0;
	CNT := 0;

	IF S0 <> X0 THEN
		ESR_OUT[CNT].typ := INT_TO_BYTE(10 + BOOL_TO_INT(S0));
		ESR_OUT[CNT].ADRESS := A0;
		ESR_OUT[CNT].DS := DT_IN;
		ESR_OUT[CNT].TS := TX;
		X0 := S0;
		CNT := CNT + 1;
		ESR_FLAG := TRUE;
	END_IF;
	IF S1 <> X1 THEN
		ESR_OUT[CNT].typ := INT_TO_BYTE(10 + BOOL_TO_INT(S1));
		ESR_OUT[CNT].ADRESS := A1;
		ESR_OUT[CNT].DS := DT_IN;
		ESR_OUT[CNT].TS := TX;
		X1 := S1;
		CNT := CNT + 1;
		ESR_FLAG := TRUE;
	END_IF;
	IF S2 <> X2 THEN
		ESR_OUT[CNT].typ := INT_TO_BYTE(10 + BOOL_TO_INT(S2));
		ESR_OUT[CNT].ADRESS := A2;
		ESR_OUT[CNT].DS := DT_IN;
		ESR_OUT[CNT].TS := TX;
		X2 := S2;
		CNT := CNT + 1;
		ESR_FLAG := TRUE;
	END_IF;
	IF S3 <> X3 THEN
		ESR_OUT[CNT].typ := INT_TO_BYTE(10 + BOOL_TO_INT(S3));
		ESR_OUT[CNT].ADRESS := A3;
		ESR_OUT[CNT].DS := DT_IN;
		ESR_OUT[CNT].TS := TX;
		X3 := S3;
		CNT := CNT + 1;
		ESR_FLAG := TRUE;
	END_IF;
	IF S4 <> X4 AND CNT < 4 THEN
		ESR_OUT[CNT].typ := INT_TO_BYTE(10 + BOOL_TO_INT(S4));
		ESR_OUT[CNT].ADRESS := A4;
		ESR_OUT[CNT].DS := DT_IN;
		ESR_OUT[CNT].TS := TX;
		X4 := S4;
		CNT := CNT + 1;
		ESR_FLAG := TRUE;
	END_IF;
	IF S5 <> X5  AND CNT < 4 THEN
		ESR_OUT[CNT].typ := INT_TO_BYTE(10 + BOOL_TO_INT(S5));
		ESR_OUT[CNT].ADRESS := A5;
		ESR_OUT[CNT].DS := DT_IN;
		ESR_OUT[CNT].TS := TX;
		X5 := S5;
		CNT := CNT + 1;
		ESR_FLAG := TRUE;
	END_IF;
	IF S6 <> X6  AND CNT < 4 THEN
		ESR_OUT[CNT].typ := INT_TO_BYTE(10 + BOOL_TO_INT(S6));
		ESR_OUT[CNT].ADRESS := A6;
		ESR_OUT[CNT].DS := DT_IN;
		ESR_OUT[CNT].TS := TX;
		X6 := S6;
		CNT := CNT + 1;
		ESR_FLAG := TRUE;
	END_IF;
	IF S7 <> X7  AND CNT < 4 THEN
		ESR_OUT[CNT].typ := INT_TO_BYTE(10 + BOOL_TO_INT(S7));
		ESR_OUT[CNT].ADRESS := A7;
		ESR_OUT[CNT].DS := DT_IN;
		ESR_OUT[CNT].TS := TX;
		X7 := S7;
		CNT := CNT + 1;
		ESR_FLAG := TRUE;
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

		ESR_OUT :	oscat_ESR_3;

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
	func_block(ESR_OUT := ESR_OUT);
	ESR_OUT := func_block.ESR_OUT;
	ESR_FLAG := func_block.ESR_FLAG;

END_PROGRAM

