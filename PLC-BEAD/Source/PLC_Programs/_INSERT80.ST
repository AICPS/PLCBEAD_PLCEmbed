FUNCTION_BLOCK _INSERT80

    VAR_INPUT
        IN1 :	STRING;
        IN2 :	STRING;
        P :	INT;
    END_VAR

    VAR_OUTPUT
        _INSERT :	STRING;
    END_VAR

    VAR
        size :	INT;
    END_VAR

    size := LEN(IN1);
    IF size + LEN(IN2) <= 80 THEN
        P := LIMIT(0,P,size);
        IF P = 0 THEN
            _INSERT := CONCAT(IN2,IN1);
        ELSE
            _INSERT := INSERT(IN1, IN2, P);
        END_IF;
    END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
	    LocalVar1 : STRING;
        LocalVar2 : STRING;
        LocalVar3 : INT;
		LocalOUT  : STRING;
		func_block : _INSERT80;
  	END_VAR
	func_block.IN1 := LocalVar1;
    func_block.IN2 := LocalVar2;
    func_block.P := LocalVar3;
	func_block();
	LocalOUT := func_block._INSERT;
END_PROGRAM

CONFIGURATION Config0
  	RESOURCE Res0 ON PLC
    	TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    	PROGRAM instance0 WITH task0 : program0;
  	END_RESOURCE
END_CONFIGURATION