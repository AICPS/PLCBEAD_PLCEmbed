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

FUNCTION_BLOCK STATUS_TO_ESR_Block

	VAR_INPUT
		STATUS :	BYTE;
		ADRESS :	STRING;
		DT_IN :	UDINT;
		TS :	TIME;
	END_VAR

	VAR_OUTPUT
		STATUS_TO_ESR :	oscat_ESR_data;
	END_VAR


	IF STATUS < BYTE#100 THEN
		STATUS_TO_ESR.typ := BYTE#1;
	ELSIF STATUS < BYTE#200 THEN
		STATUS_TO_ESR.typ := BYTE#2;
	ELSE
		STATUS_TO_ESR.typ := BYTE#3;
	END_IF;
	STATUS_TO_ESR.ADRESS:= ADRESS;
	STATUS_TO_ESR.DS := DT_IN;
	STATUS_TO_ESR.TS := TS;
	STATUS_TO_ESR.data[0] := STATUS;
END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		STATUS :	BYTE;
		ADRESS :	STRING;
		DT_IN  :	UDINT;
		TS     :	TIME;
		STATUS_TO_ESR :	oscat_ESR_data;

		func_block : STATUS_TO_ESR_Block;
	END_VAR
	func_block.STATUS := STATUS;
	func_block.ADRESS := ADRESS;
	func_block.DT_IN := DT_IN ;
	func_block.TS    := TS    ;

	func_block();
	STATUS_TO_ESR  := func_block.STATUS_TO_ESR;
END_PROGRAM

