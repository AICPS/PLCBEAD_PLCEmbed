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

FUNCTION INC1:INT

	VAR_INPUT
		X :	INT;
		N :	INT;
	END_VAR

	IF X >= N - 1 THEN
		INC1 := 0;
	ELSE
		INC1 := X + 1;
	END_IF;
END_FUNCTION

FUNCTION_BLOCK ESR_COLLECT
	VAR_INPUT
		ESR_0 :	oscat_ESR_3;
		ESR_1 :	oscat_ESR_3;
		ESR_2 :	oscat_ESR_3;
		ESR_3 :	oscat_ESR_3;
		ESR_4 :	oscat_ESR_3;
		ESR_5 :	oscat_ESR_3;
		ESR_6 :	oscat_ESR_3;
		ESR_7 :	oscat_ESR_3;
		RST :	BOOL;
	END_VAR

	VAR_IN_OUT
		POS :	INT;
	END_VAR

	VAR_OUTPUT
		ESR_OUT :	oscat_ESR_31;
	END_VAR


	VAR
		cnt :	INT := -1;
		max_in :	INT := 3;
		max_out :	INT := 32;
	END_VAR

	IF rst OR cnt < 0 THEN
		pos := -1;
	ELSE
		FOR cnt := 0 TO max_in DO
		IF esr_0[cnt].typ > BYTE#0 THEN pos := INC1(pos, max_out); esr_out[pos] := esr_0[cnt]; END_IF;
		IF esr_1[cnt].typ > BYTE#0 THEN pos := INC1(pos, max_out); esr_out[pos] := esr_1[cnt]; END_IF;
		IF esr_2[cnt].typ > BYTE#0 THEN pos := INC1(pos, max_out); esr_out[pos] := esr_2[cnt]; END_IF;
		IF esr_3[cnt].typ > BYTE#0 THEN pos := INC1(pos, max_out); esr_out[pos] := esr_3[cnt]; END_IF;
		IF esr_4[cnt].typ > BYTE#0 THEN pos := INC1(pos, max_out); esr_out[pos] := esr_4[cnt]; END_IF;
		IF esr_5[cnt].typ > BYTE#0 THEN pos := INC1(pos, max_out); esr_out[pos] := esr_5[cnt]; END_IF;
		IF esr_6[cnt].typ > BYTE#0 THEN pos := INC1(pos, max_out); esr_out[pos] := esr_6[cnt]; END_IF;
		IF esr_7[cnt].typ > BYTE#0 THEN pos := INC1(pos, max_out); esr_out[pos] := esr_7[cnt]; END_IF;
	END_FOR;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	ESR_0 :	oscat_ESR_3;
	ESR_1 :	oscat_ESR_3;
	ESR_2 :	oscat_ESR_3;
	ESR_3 :	oscat_ESR_3;
	ESR_4 :	oscat_ESR_3;
	ESR_5 :	oscat_ESR_3;
	ESR_6 :	oscat_ESR_3;
	ESR_7 :	oscat_ESR_3;
	RST   :	BOOL;

	POS   :	INT;

	ESR_OUT :	oscat_ESR_31;

	func_block : ESR_COLLECT;
  END_VAR
	func_block.ESR_0 :=ESR_0;
	func_block.ESR_1 :=ESR_1;
	func_block.ESR_2 :=ESR_2;
	func_block.ESR_3 :=ESR_3;
	func_block.ESR_4 :=ESR_4;
	func_block.ESR_5 :=ESR_5;
	func_block.ESR_6 :=ESR_6;
	func_block.ESR_7 :=ESR_7;
	func_block.RST   :=RST  ;
	func_block.POS   :=POS  ;

	func_block();
	POS := func_block.POS;
	ESR_OUT := func_block.ESR_OUT;

END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION