FUNCTION_BLOCK _INSERT80

    VAR_INPUT
        IN1 :	STRING;
        IN2 :	STRING;
        P :	INT;
    END_VAR

    VAR_OUTPUT
        INSERT80 :	STRING;
    END_VAR

    VAR
        SIZE :	INT;
        p_p : INT;
    END_VAR

    SIZE := LEN(IN1);
    IF SIZE + LEN(IN2) <= 80 THEN
        p_p := LIMIT_INT(0,P,SIZE);
        IF p_p = 0 THEN
            INSERT80 := CONCAT(IN2,IN1);
        ELSE
            INSERT80 := INSERT(IN1, IN2, p_p);
        END_IF;
    END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
	    LocalVaR1  : STRING;
        LocalVaR2 : STRING;
        LocalVar3 : INT;
		LocalOUT  : STRING;
		func_block : _INSERT80;
  	END_VAR
	func_block(IN1 := LocalVaR1 ,IN2 := LocalVaR2, P := LocalVar3);
	LocalOUT := func_block.INSERT80;
END_PROGRAM

