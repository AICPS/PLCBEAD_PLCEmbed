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

FUNCTION_BLOCK STATUS_TO_ESR_Block

	VAR_INPUT
		STATUS :	BYTE;
		ADRESS :	STRING;
		DT_IN :	UDINT;
		TS :	TIME;
	END_VAR

	VAR_OUTPUT
		STATUS_TO_ESR :	oscat_esr_data;
	END_VAR


	IF status < BYTE#100 THEN
		status_to_ESR.typ := BYTE#1;
	ELSIF status < BYTE#200 THEN
		status_to_ESR.typ := BYTE#2;
	ELSE
		status_to_ESR.typ := BYTE#3;
	END_IF;
	status_to_ESR.adress:= adress;
	status_to_ESR.DS := DT_in;
	status_to_ESR.TS := TS;
	status_to_ESR.data[0] := status;
END_FUNCTION_BLOCK

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

FUNCTION_BLOCK ESR_MON_X8
	VAR_INPUT
		S0 :	BYTE;
		A0 :	STRING;
		S1 :	BYTE;
		A1 :	STRING;
		S2 :	BYTE;
		A2 :	STRING;
		S3 :	BYTE;
		A3 :	STRING;
		S4 :	BYTE;
		A4 :	STRING;
		S5 :	BYTE;
		A5 :	STRING;
		S6 :	BYTE;
		A6 :	STRING;
		S7 :	BYTE;
		A7 :	STRING;
		DT_IN :	UDINT;
		MODE :	BYTE := BYTE#3;
	END_VAR

	VAR_IN_OUT
		ESR_OUT :	oscat_ESR_3;
	END_VAR

	VAR_OUTPUT
		ESR_FLAG :	BOOL;
	END_VAR

	VAR
		x0 :	BYTE;
		x1 :	BYTE;
		x2 :	BYTE;
		x3 :	BYTE;
		x4 :	BYTE;
		x5 :	BYTE;
		x6 :	BYTE;
		x7 :	BYTE;
		tx :	TIME;
		cnt :	INT;
		status_to_ESR :	STATUS_TO_ESR_Block;
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

	IF s0 <> X0 AND ((s0 < BYTE#100) OR (S0 > BYTE#99 AND S0 < BYTE#200 AND mode >= BYTE#2) OR (S0 > BYTE#199 AND mode = BYTE#3)) THEN
		
		status_to_ESR.status := s0;
		status_to_ESR.adress := a0;
		status_to_ESR.DT_in  := DT_in;
		status_to_ESR.TS     := tx;
		status_to_ESR();
		esr_out[cnt] := status_to_ESR.status_to_ESR;

		X0 := S0;
		cnt := cnt + 1;
		esr_flag := TRUE;
	END_IF;
	IF s1 <> X1 AND ((s1 < BYTE#100) OR (S1 > BYTE#99 AND S1 < BYTE#200 AND mode >= BYTE#2) OR (S1 > BYTE#199 AND mode = BYTE#3)) THEN

		status_to_ESR.status := s1;
		status_to_ESR.adress := a1;
		status_to_ESR.DT_in  := DT_in;
		status_to_ESR.TS     := tx;
		status_to_ESR();
		esr_out[cnt] := status_to_ESR.status_to_ESR;

		X1 := S1;
		cnt := cnt + 1;
		esr_flag := TRUE;
	END_IF;
	IF s2 <> X2 AND ((s2 < BYTE#100) OR (S2 > BYTE#99 AND S2 < BYTE#200 AND mode >= BYTE#2) OR (S2 > BYTE#199 AND mode = BYTE#3)) THEN

		status_to_ESR.status := s2;
		status_to_ESR.adress := a2;
		status_to_ESR.DT_in  := DT_in;
		status_to_ESR.TS     := tx;
		status_to_ESR();
		esr_out[cnt] := status_to_ESR.status_to_ESR;

		X2 := S2;
		cnt := cnt + 1;
		esr_flag := TRUE;
	END_IF;
	IF s3 <> X3 AND ((s3 < BYTE#100) OR (S3 > BYTE#99 AND S3 < BYTE#200 AND mode >= BYTE#2) OR (S3 > BYTE#199 AND mode = BYTE#3)) THEN

		status_to_ESR.status := s3;
		status_to_ESR.adress := a3;
		status_to_ESR.DT_in  := DT_in;
		status_to_ESR.TS     := tx;
		status_to_ESR();
		esr_out[cnt] := status_to_ESR.status_to_ESR;

		X3 := S3;
		cnt := cnt + 1;
		esr_flag := TRUE;
	END_IF;
	IF cnt < 4 AND s4 <> X4 AND ((s4 < BYTE#100) OR (S4 > BYTE#99 AND S4 < BYTE#200 AND mode >= BYTE#2) OR (S4 > BYTE#199 AND mode = BYTE#3)) THEN

		status_to_ESR.status := s4;
		status_to_ESR.adress := a4;
		status_to_ESR.DT_in  := DT_in;
		status_to_ESR.TS     := tx;
		status_to_ESR();
		esr_out[cnt] := status_to_ESR.status_to_ESR;

		X4 := S4;
		cnt := cnt + 1;
		esr_flag := TRUE;
	END_IF;
	IF cnt < 4 AND s5 <> X5 AND ((s5 < BYTE#100) OR (S5 > BYTE#99 AND S5 < BYTE#200 AND mode >= BYTE#2) OR (S5 > BYTE#199 AND mode = BYTE#3)) THEN

		status_to_ESR.status := s5;
		status_to_ESR.adress := a5;
		status_to_ESR.DT_in  := DT_in;
		status_to_ESR.TS     := tx;
		status_to_ESR();
		esr_out[cnt] := status_to_ESR.status_to_ESR;

		X5 := S5;
		cnt := cnt + 1;
		esr_flag := TRUE;
	END_IF;
	IF cnt < 4 AND s6 <> X6 AND ((s6 < BYTE#100) OR (S6 > BYTE#99 AND S6 < BYTE#200 AND mode >= BYTE#2) OR (S6 > BYTE#199 AND mode = BYTE#3)) THEN

		status_to_ESR.status := s6;
		status_to_ESR.adress := a6;
		status_to_ESR.DT_in  := DT_in;
		status_to_ESR.TS     := tx;
		status_to_ESR();
		esr_out[cnt] := status_to_ESR.status_to_ESR;

		X6 := S6;
		cnt := cnt + 1;
		esr_flag := TRUE;
	END_IF;
	IF cnt < 4 AND s7 <> X7 AND ((s7 < BYTE#100) OR (S7 > BYTE#99 AND S7 < BYTE#200 AND mode >= BYTE#2) OR (S7 > BYTE#199 AND mode = BYTE#3)) THEN

		status_to_ESR.status := s7;
		status_to_ESR.adress := a7;
		status_to_ESR.DT_in  := DT_in;
		status_to_ESR.TS     := tx;
		status_to_ESR();
		esr_out[cnt] := status_to_ESR.status_to_ESR;

		X7 := S7;
		cnt := cnt + 1;
		esr_flag := TRUE;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0

	VAR
	S0 :	BYTE;
	A0 :	STRING;
	S1 :	BYTE;
	A1 :	STRING;
	S2 :	BYTE;
	A2 :	STRING;
	S3 :	BYTE;
	A3 :	STRING;
	S4 :	BYTE;
	A4 :	STRING;
	S5 :	BYTE;
	A5 :	STRING;
	S6 :	BYTE;
	A6 :	STRING;
	S7 :	BYTE;
	A7 :	STRING;
	DT_IN :	UDINT;
	MODE :	BYTE;

	ESR_OUT :	oscat_ESR_3;

	ESR_FLAG :	BOOL;

		func_block : ESR_MON_X8;
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
	func_block.MODE := MODE;
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