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

PROGRAM program0
	VAR
		STATUS :	BYTE;
		ADRESS :	STRING;
		DT_IN  :	UDINT;
		TS     :	TIME;
		STATUS_TO_ESR :	oscat_esr_data;

		func_block : STATUS_TO_ESR_Block;
	END_VAR
	func_block.STATUS := STATUS;
	func_block.ADRESS := ADRESS;
	func_block.DT_IN := DT_IN ;
	func_block.TS    := TS    ;

	func_block();
	STATUS_TO_ESR  := func_block.STATUS_TO_ESR;
END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION