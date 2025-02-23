FUNCTION BIT_OF_DWORD : BOOL
  VAR_INPUT
    IN : DWORD;
    N : INT;
  END_VAR

  BIT_OF_DWORD := (SHR(IN,N) AND 16#00000001) > 0;
  (* from OSCAT library; www.oscat.de  *)
END_FUNCTION

FUNCTION_BLOCK CLK_DIV
	VAR_INPUT
		CLK :	BOOL;
		RST :	BOOL;
	END_VAR

	VAR_OUTPUT
		Q0 :	BOOL := FALSE;
		Q1 :	BOOL := FALSE;
		Q2 :	BOOL := FALSE;
		Q3 :	BOOL := FALSE;
		Q4 :	BOOL := FALSE;
		Q5 :	BOOL := FALSE;
		Q6 :	BOOL := FALSE;
		Q7 :	BOOL := FALSE;
	END_VAR

	VAR
		CNT :	BYTE := 0;
	END_VAR

	IF RST THEN
		CNT:= BYTE#0;
		Q0 := FALSE;
		Q1 := FALSE;
		Q2 := FALSE;
		Q3 := FALSE;
		Q4 := FALSE;
		Q5 := FALSE;
		Q6 := FALSE;
		Q7 := FALSE;
	ELSIF CLK THEN
		CNT:= USINT_TO_BYTE(BYTE_TO_USINT(CNT) + USINT#1);

		Q0 := BIT_OF_DWORD(BYTE_TO_DWORD(CNT),0); (* Q0 := CNT.X0; *)
		Q1 := BIT_OF_DWORD(BYTE_TO_DWORD(CNT),1); (* Q1 := CNT.X1; *)
		Q2 := BIT_OF_DWORD(BYTE_TO_DWORD(CNT),2); (* Q2 := CNT.X2; *)
		Q3 := BIT_OF_DWORD(BYTE_TO_DWORD(CNT),3); (* Q3 := CNT.X3; *)
		Q4 := BIT_OF_DWORD(BYTE_TO_DWORD(CNT),4); (* Q4 := CNT.X4; *)
		Q5 := BIT_OF_DWORD(BYTE_TO_DWORD(CNT),5); (* Q5 := CNT.X5; *)
		Q6 := BIT_OF_DWORD(BYTE_TO_DWORD(CNT),6); (* Q6 := CNT.X6; *)
		Q7 := BIT_OF_DWORD(BYTE_TO_DWORD(CNT),7); (* Q7 := CNT.X7; *)

	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : BOOL;
    LocalVaR1  : BOOL;
	Q0 :	BOOL;
	Q1 :	BOOL;
	Q2 :	BOOL;
	Q3 :	BOOL;
	Q4 :	BOOL;
	Q5 :	BOOL;
	Q6 :	BOOL;
	Q7 :	BOOL;
	func_block : CLK_DIV;
  END_VAR
	func_block.CLK  := LocalVar0;
	func_block.RST := LocalVaR1 ;
	func_block();
	Q0 := func_block.Q0;
	Q1 := func_block.Q1;
	Q2 := func_block.Q2;
	Q3 := func_block.Q3;
	Q4 := func_block.Q4;
	Q5 := func_block.Q5;
	Q6 := func_block.Q6;
	Q7 := func_block.Q7;
END_PROGRAM

