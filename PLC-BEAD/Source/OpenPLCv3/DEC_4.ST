FUNCTION_BLOCK DEC_4
	VAR_INPUT
		D :	BOOL;
		A0 :	BOOL;
		A1 :	BOOL;
	END_VAR

	VAR_OUTPUT
		Q0 :	BOOL;
		Q1 :	BOOL;
		Q2 :	BOOL;
		Q3 :	BOOL;
	END_VAR

	Q0 := D AND NOT A0 AND NOT A1;
	Q1 := D AND A0 AND NOT A1;
	Q2 := D AND NOT A0 AND A1;
	Q3 := D AND A0 AND A1;
END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	D :	BOOL;
	A0 :	BOOL;
	A1 :	BOOL;

	Q0 :	BOOL;
	Q1 :	BOOL;
	Q2 :	BOOL;
	Q3 :	BOOL;

	func_block : DEC_4;
  END_VAR
	func_block.D   := D  ;
	func_block.A0  := A0  ;
	func_block.A1  := A1  ;
	func_block();
	Q0:= func_block.Q0;
	Q1:= func_block.Q1;
	Q2:= func_block.Q2;
	Q3:= func_block.Q3;
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION