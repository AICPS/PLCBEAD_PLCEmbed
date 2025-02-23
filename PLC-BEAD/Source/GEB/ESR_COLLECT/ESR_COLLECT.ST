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
		CNT :	INT := -1;
		max_IN :	INT := 3;
		max_OUT :	INT := 32;
	END_VAR

	IF RST OR CNT < 0 THEN
		POS := -1;
	ELSE
		FOR CNT := 0 TO max_IN DO
		IF ESR_0[CNT].typ > BYTE#0 THEN POS := INC1(POS, max_OUT); ESR_OUT[POS] := ESR_0[CNT]; END_IF;
		IF ESR_1[CNT].typ > BYTE#0 THEN POS := INC1(POS, max_OUT); ESR_OUT[POS] := ESR_1[CNT]; END_IF;
		IF ESR_2[CNT].typ > BYTE#0 THEN POS := INC1(POS, max_OUT); ESR_OUT[POS] := ESR_2[CNT]; END_IF;
		IF ESR_3[CNT].typ > BYTE#0 THEN POS := INC1(POS, max_OUT); ESR_OUT[POS] := ESR_3[CNT]; END_IF;
		IF ESR_4[CNT].typ > BYTE#0 THEN POS := INC1(POS, max_OUT); ESR_OUT[POS] := ESR_4[CNT]; END_IF;
		IF ESR_5[CNT].typ > BYTE#0 THEN POS := INC1(POS, max_OUT); ESR_OUT[POS] := ESR_5[CNT]; END_IF;
		IF ESR_6[CNT].typ > BYTE#0 THEN POS := INC1(POS, max_OUT); ESR_OUT[POS] := ESR_6[CNT]; END_IF;
		IF ESR_7[CNT].typ > BYTE#0 THEN POS := INC1(POS, max_OUT); ESR_OUT[POS] := ESR_7[CNT]; END_IF;
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

	func_block(POS   :=POS );
	POS := func_block.POS;
	ESR_OUT := func_block.ESR_OUT;

END_PROGRAM

