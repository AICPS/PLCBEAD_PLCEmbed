TYPE
	oscat_STRING250             : STRING;
END_TYPE


FUNCTION_BLOCK ELEMENT_GET_Block

	VAR_INPUT
		SEP :	BYTE;
		POS :	INT;
	END_VAR


	VAR_IN_OUT
		ELEMENT :	oscat_STRING250;
	END_VAR


	VAR_OUTPUT
		ELEMENT_GET :	oscat_STRING250;
	END_VAR


	VAR
		i :	INT;
		i2 :	INT;
		cnt :	INT;
		size :	INT;
	END_VAR

	cnt := 0;
	size := LEN(ELEMENT);

	FOR i := 1 TO size DO
		IF cnt = POS THEN EXIT; END_IF;
		IF INT_TO_BYTE(GET_CHAR(ELEMENT,i)) = SEP THEN cnt := cnt + 1; END_IF;
	END_FOR;

	FOR i2 := i TO size DO
		IF INT_TO_BYTE(GET_CHAR(ELEMENT,i2)) = SEP THEN EXIT; END_IF; 
	END_FOR;

	IF i2 > i THEN
		ELEMENT_GET := MID(ELEMENT,i2-i,i);
	ELSE
		ELEMENT_GET := '';
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		SEP :	BYTE;
		POS :	INT;
		ELEMENT :	oscat_STRING250;
		ELEMENT_GET :	oscat_STRING250;

		func_block : ELEMENT_GET_Block;
	END_VAR
	func_block.SEP    :=SEP    ;
	func_block.POS:=POS;
	func_block.ELEMENT     :=ELEMENT     ;
	func_block();
	ELEMENT    := func_block.ELEMENT    ;
	ELEMENT_GET:= func_block.ELEMENT_GET;

END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION