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

FUNCTION_BLOCK REAL_TO_DW_Block
  VAR_INPUT
    X :	REAL;
  END_VAR

  VAR_OUTPUT
    REAL_TO_DW :	DWORD;
  END_VAR

  VAR
    REAL_TO_BUF :	REAL_TO_BUF;
    i :	INT;
  END_VAR

  FOR I := 0 TO 1 DO
    REAL_TO_BUF.REQ        := I > 0;
    REAL_TO_BUF.BUF_FORMAT := FALSE;
    REAL_TO_BUF.BUF_OFFS   := DINT#0;
    REAL_TO_BUF.BUF_CNT    := DINT#4;
    REAL_TO_BUF.SRC        := X;
    REAL_TO_BUF.BUFFER     := REAL_TO_DW;
    REAL_TO_BUF();
    X          := REAL_TO_BUF.SRC;
    REAL_TO_DW := REAL_TO_BUF.BUFFER;
  END_FOR;
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

FUNCTION_BLOCK ESR_MON_R4
	VAR_INPUT
		R0 :	REAL;
		A0 :	STRING;
		S0 :	REAL;
		R1 :	REAL;
		A1 :	STRING;
		S1 :	REAL;
		R2 :	REAL;
		A2 :	STRING;
		S2 :	REAL;
		R3 :	REAL;
		A3 :	STRING;
		S3 :	REAL;
		DT_IN :	UDINT;
	END_VAR

	VAR_IN_OUT
		ESR_OUT :	oscat_ESR_3;
	END_VAR

	VAR_OUTPUT
		ESR_FLAG :	BOOL;
	END_VAR

	VAR
		x0 :	REAL;
		x1 :	REAL;
		x2 :	REAL;
		x3 :	REAL;
		tx :	TIME;
		cnt :	INT;
		T_PLC_MS :	T_PLC_MS_block;
		REAL_TO_DW :	REAL_TO_DW_Block;
		tmp :	DWORD;
	END_VAR

	T_PLC_MS();
	tx:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

	ESR_Flag := FALSE;
	esr_out[3].typ := BYTE#0;
	esr_out[2].typ := BYTE#0;
	esr_out[1].typ := BYTE#0;
	esr_out[0].typ := BYTE#0;
	cnt := 0;

	IF differ(R0, X0, S0) THEN
		REAL_TO_DW(X:=R0);
		tmp := REAL_TO_DW.REAL_TO_DW;

		esr_out[cnt].typ := BYTE#20;
		esr_out[cnt].adress := a0;
		esr_out[cnt].DS := DT_in;
		esr_out[cnt].TS := TX;
		esr_out[cnt].data[0] := Byte_of_Dword(tmp,BYTE#0);
		esr_out[cnt].data[1] := Byte_of_Dword(tmp,BYTE#1);
		esr_out[cnt].data[2] := Byte_of_Dword(tmp,BYTE#2);
		esr_out[cnt].data[3] := Byte_of_Dword(tmp,BYTE#3);
		X0 := R0;
		cnt := cnt + 1;
		esr_flag := TRUE;
	END_IF;
	IF differ(R1, X1, S1) THEN
		REAL_TO_DW(X:=R1);
		tmp := REAL_TO_DW.REAL_TO_DW;

		esr_out[cnt].typ := BYTE#20;
		esr_out[cnt].adress := a1;
		esr_out[cnt].DS := DT_in;
		esr_out[cnt].TS := TX;
		esr_out[cnt].data[0] := Byte_of_Dword(tmp,BYTE#0);
		esr_out[cnt].data[1] := Byte_of_Dword(tmp,BYTE#1);
		esr_out[cnt].data[2] := Byte_of_Dword(tmp,BYTE#2);
		esr_out[cnt].data[3] := Byte_of_Dword(tmp,BYTE#3);
		X1 := R1;
		cnt := cnt + 1;
		esr_flag := TRUE;
	END_IF;
	IF differ(R2, X2, S2) THEN
		REAL_TO_DW(X:=R2);
		tmp := REAL_TO_DW.REAL_TO_DW;

		esr_out[cnt].typ := BYTE#20;
		esr_out[cnt].adress := a2;
		esr_out[cnt].DS := DT_in;
		esr_out[cnt].TS := TX;
		esr_out[cnt].data[0] := Byte_of_Dword(tmp,BYTE#0);
		esr_out[cnt].data[1] := Byte_of_Dword(tmp,BYTE#1);
		esr_out[cnt].data[2] := Byte_of_Dword(tmp,BYTE#2);
		esr_out[cnt].data[3] := Byte_of_Dword(tmp,BYTE#3);
		X2 := R2;
		cnt := cnt + 1;
		esr_flag := TRUE;
	END_IF;
	IF differ(R3, X3, S3) THEN
		REAL_TO_DW(X:=R2);
		tmp := REAL_TO_DW.REAL_TO_DW;

		esr_out[cnt].typ := BYTE#20;
		esr_out[cnt].adress := a3;
		esr_out[cnt].DS := DT_in;
		esr_out[cnt].TS := TX;
		esr_out[cnt].data[0] := Byte_of_Dword(tmp,BYTE#0);
		esr_out[cnt].data[1] := Byte_of_Dword(tmp,BYTE#1);
		esr_out[cnt].data[2] := Byte_of_Dword(tmp,BYTE#2);
		esr_out[cnt].data[3] := Byte_of_Dword(tmp,BYTE#3);
		X3 := R3;
		cnt := cnt + 1;
		esr_flag := TRUE;
	END_IF;
END_FUNCTION_BLOCK

PROGRAM program0

	VAR
	VAR_INPUT
		R0 :	REAL;
		A0 :	STRING;
		S0 :	REAL;
		R1 :	REAL;
		A1 :	STRING;
		S1 :	REAL;
		R2 :	REAL;
		A2 :	STRING;
		S2 :	REAL;
		R3 :	REAL;
		A3 :	STRING;
		S3 :	REAL;
		DT_IN :	UDINT;

		ESR_OUT :	oscat_ESR_3;

		ESR_FLAG :	BOOL;

		func_block : ESR_MON_R4;
  	END_VAR
	func_block.R0 := R0;
	func_block.A0 := A0;
	func_block.S0 := S0;
	func_block.R1 := R1;
	func_block.A1 := A1;
	func_block.S1 := S1;
	func_block.R2 := R2;
	func_block.A2 := A2;
	func_block.S2 := S2;
	func_block.R3 := R3;
	func_block.A3 := A3;
	func_block.S3 := S3;
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
