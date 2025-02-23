FUNCTION BIT_LOAD_B:BYTE
	VAR_INPUT
		IN :	BYTE;
		VAL :	BOOL;
		POS :	INT;
	END_VAR

	IF VAL THEN
		BIT_LOAD_B := in OR SHL(BYTE#1,pos);
	ELSE
		BIT_LOAD_B := in AND (NOT SHL(BYTE#1,pos));
	END_IF;
END_FUNCTION

FUNCTION _BYTE_TO_INT:INT
	VAR_INPUT
		IN :	BYTE;
	END_VAR

	_BYTE_TO_INT := USINT_TO_INT(BYTE_TO_USINT(IN));
END_FUNCTION

FUNCTION_BLOCK DEC_8

	VAR_INPUT
		D :	BOOL;
		A0 :	BOOL;
		A1 :	BOOL;
		A2 :	BOOL;
	END_VAR


	VAR_OUTPUT
		Q0 :	BOOL;
		Q1 :	BOOL;
		Q2 :	BOOL;
		Q3 :	BOOL;
		Q4 :	BOOL;
		Q5 :	BOOL;
		Q6 :	BOOL;
		Q7 :	BOOL;
	END_VAR


	VAR
		X :	BYTE;
	END_VAR

	X:=BIT_LOAD_B(X,A0,0); (* X.0 := A0; *)
	X:=BIT_LOAD_B(X,A1,1); (* X.1 := A1; *)
	X:=BIT_LOAD_B(X,A2,2); (* X.2 := A2; *)

	Q0 := FALSE;
	Q1 := FALSE;
	Q2 := FALSE;
	Q3 := FALSE;
	Q4 := FALSE;
	Q5 := FALSE;
	Q6 := FALSE;
	Q7 := FALSE;

	CASE _BYTE_TO_INT(X) OF
		0 : Q0 := D;
		1 : Q1 := D;
		2 : Q2 := D;
		3 : Q3 := D;
		4 : Q4 := D;
		5 : Q5 := D;
		6 : Q6 := D;
		7 : Q7 := D;
	END_CASE;

	END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	D :	BOOL;
	A0 :	BOOL;
	A1 :	BOOL;
	A2 :	BOOL;

	Q0 :	BOOL;
	Q1 :	BOOL;
	Q2 :	BOOL;
	Q3 :	BOOL;
	Q4 :	BOOL;
	Q5 :	BOOL;
	Q6 :	BOOL;
	Q7 :	BOOL;

	func_block : DEC_8;
  END_VAR
	func_block.D   := D  ;
	func_block.A0  := A0  ;
	func_block.A1  := A1  ;
	func_block.A2  := A2  ;
	func_block();
	Q0:= func_block.Q0;
	Q1:= func_block.Q1;
	Q2:= func_block.Q2;
	Q3:= func_block.Q3;
	Q4:= func_block.Q4;
	Q5:= func_block.Q5;
	Q6:= func_block.Q6;
	Q7:= func_block.Q7;
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION