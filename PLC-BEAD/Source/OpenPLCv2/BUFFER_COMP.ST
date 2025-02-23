TYPE
	oscat_arb_0_249 			  : ARRAY [0..249] 	OF BYTE;
END_TYPE

FUNCTION_BLOCK BUFFER_COMP_Block
	VAR_IN_OUT
		PT1 :	oscat_arb_0_249;
	END_VAR

	VAR_INPUT
		SIZE1 :	INT;
	END_VAR

	VAR_IN_OUT
		PT2 :	oscat_arb_0_249;
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
    LocalVar0 : oscat_arb_0_249;
    LocalVar1 : INT;
	LocalVar2 : oscat_arb_0_249;
	LocalVar3 : INT;
	LocalVar4 : INT;
	LocalOUT  : INT;
	func_block : BUFFER_COMP_Block;
  END_VAR
	func_block.PT1  := LocalVar0;
	func_block.SIZE1 := LocalVar1;
	func_block.PT2  := LocalVar2;
	func_block.SIZE2 := LocalVar3;
	func_block.START := LocalVar4;
	func_block();
	LocalOUT := func_block.BUFFER_COMP;
	LocalVar0 := func_block.PT1;
	LocalVar2 := func_block.PT1;

END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION