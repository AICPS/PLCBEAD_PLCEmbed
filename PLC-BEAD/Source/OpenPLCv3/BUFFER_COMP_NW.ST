TYPE
  oscat_NW_BUF_LONG  : ARRAY [0..4095] OF BYTE;
END_TYPE

FUNCTION_BLOCK BUFFER_COMP_NW
	VAR_IN_OUT
		PT1 :	oscat_NW_BUF_LONG;
	END_VAR

	VAR_INPUT
		SIZE1 :	INT;
	END_VAR

	VAR_IN_OUT
		PT2 :	oscat_NW_BUF_LONG;
	END_VAR

	VAR_INPUT
		SIZE2 :	INT;
		START :	INT;
	END_VAR

	VAR_OUTPUT
		BUFFER_COMP :	INT;
	END_VAR

	VAR
		i :	INT;
		j :	INT;
		end :	INT;
		j2 :	INT;
	END_VAR

	IF SIZE2 <= SIZE1 AND SIZE1 > 0 AND SIZE2 > 0 AND START >= 0 THEN
		end := SIZE1 - SIZE2;
		FOR i := START TO end DO
			IF PT1[i] = PT2[0] THEN
				(* first character matches, now compare rest of array *)
				j := 1;
				j2 := j + i;
				WHILE j < SIZE2 DO
					IF PT2[j] <> PT1[j2] THEN EXIT; END_IF;
					j := j + 1;
					j2 := j2 + 1;
				END_WHILE;
				(* when J > size2 a match was found return the position i in buffer1 *)
				IF j = SIZE2 THEN
					BUFFER_COMP := i;
					RETURN;
				END_IF;
			END_IF;
		END_FOR;
	END_IF;
	BUFFER_COMP := -1;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	PT1   :	oscat_NW_BUF_LONG;

	SIZE1 :	INT;

	PT2   : 	oscat_NW_BUF_LONG;


	SIZE2 :	INT;
	START :	INT;

	BUFFER_COMP :	INT;

	func_block : BUFFER_COMP_NW;
  END_VAR
	func_block.PT1  :=PT1  ;
	func_block.SIZE1:=SIZE1;
	func_block.PT2  :=PT2  ;
	func_block.SIZE2:=SIZE2;
	func_block.START:=START;
	func_block();
	BUFFER_COMP := func_block.BUFFER_COMP;
	PT1 := func_block.PT1;
	PT2 := func_block.PT2;

END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION