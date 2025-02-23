FUNCTION _BYTE_TO_INT:INT
	VAR_INPUT
		IN :	BYTE;
	END_VAR

	_BYTE_TO_INT := USINT_TO_INT(BYTE_TO_USINT(IN));
END_FUNCTION

FUNCTION_BLOCK TO_UML_Block

	VAR_INPUT
		IN :	BYTE;
	END_VAR


	VAR_OUTPUT
		TO_UML :	STRING;
	END_VAR

	CASE _BYTE_TO_INT(in) OF
		196:
			TO_UML := 'Ae';
		214:
			TO_UML := 'Oe';
		220:
			TO_UML := 'Ue';
		223:
			TO_UML := 'ss';
		228:
			TO_UML := 'ae';
		246:
			TO_UML := 'oe';
		252:
			TO_UML := 'ue';
	ELSE
		TO_UML := BYTE_TO_STRING(IN);
	END_CASE;

END_FUNCTION_BLOCK

FUNCTION_BLOCK REPLACE_UML_Block

    VAR_INPUT
        STR :	STRING;
    END_VAR


    VAR_OUTPUT
        REPLACE_UML :	STRING;
    END_VAR

    VAR
        pos1 :	INT;
        pos2 :	INT;
        l :	INT;
        pto :	BYTE;
        temp :	STRING;
        TO_UML :	TO_UML_Block;
    END_VAR

    L := LEN(str);
    REPLACE_UML := str;
    pos1 := 1;
    pos2 := 1;
    WHILE pos1 <= L AND pos2 <= 80 DO
        pto := INT_TO_BYTE(GET_CHAR(str,pos1));
        IF pto > BYTE#127 THEN
            TO_UML(IN:=pto);
            IF LEN(TO_UML.TO_UML) = 2 THEN
                temp := REPLACE_UML;
                IF pos2 >= 80 THEN
                    TO_UML.TO_UML := LEFT(TO_UML.TO_UML,1);
                    REPLACE_UML:=REPLACE(temp,TO_UML.TO_UML,1,pos2);
                ELSE
                    REPLACE_UML:=REPLACE(temp,TO_UML.TO_UML,1,pos2);
                    POS2 := POS2 +1;
                END_IF;
            END_IF;
        END_IF;
        pos1 := POS1 +1;
        pos2 := POS2 +1;
    END_WHILE;

END_FUNCTION_BLOCK

PROGRAM program0

	VAR
		STR :	STRING;
		
        REPLACE_UML :	STRING;
		func_block : REPLACE_UML_Block;
	END_VAR
		func_block.STR := STR;
		func_block();
		REPLACE_UML := func_block.REPLACE_UML;

	END_PROGRAM

CONFIGURATION Config0
	
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE

END_CONFIGURATION
