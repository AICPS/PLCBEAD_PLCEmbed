TYPE
	oscat_STRING250             : STRING;
END_TYPE

FUNCTION_BLOCK INSERTT250
    VAR_INPUT
        IN1 :	oscat_STRING250;
        IN2 :	oscat_STRING250;
        P :	INT;
    END_VAR
    VAR_OUTPUT
        INSERTT :	oscat_STRING250;
    END_VAR
    VAR
        SIZE :	INT;
        PP :	INT;
    END_VAR
	PP := P;
    SIZE := LEN(IN1);
    IF SIZE + LEN(IN2) <= 250 THEN
        PP := LIMIT(0,PP,SIZE);
        IF PP = 0 THEN
            INSERTT := CONCAT(IN2,IN1);
        ELSE
            INSERTT := INSERT(IN1, IN2, PP);
        END_IF;
    END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
	    LocalVaR1  : oscat_STRING250;
        LocalVaR2 : oscat_STRING250;
        LocalVar3 : INT;
		LocalOUT  : oscat_STRING250;
		func_block : INSERTT250;
  	END_VAR
	func_block.IN1 := LocalVaR1 ;
    func_block.IN2 := LocalVaR2;
    func_block.P := LocalVar3;
	func_block();
	LocalOUT := func_block.INSERTT;
END_PROGRAM

