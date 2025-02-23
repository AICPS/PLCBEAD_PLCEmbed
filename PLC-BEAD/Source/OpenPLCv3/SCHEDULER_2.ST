FUNCTION_BLOCK SCHEDULER_2_Block

	VAR_INPUT
		E0 :	BOOL;
		E1 :	BOOL;
		E2 :	BOOL;
		E3 :	BOOL;
		C0 :	UINT;
		C1 :	UINT;
		C2 :	UINT;
		C3 :	UINT;
		O0 :	UINT;
		O1 :	UINT;
		O2 :	UINT;
		O3 :	UINT;
	END_VAR

	VAR_OUTPUT
		Q0 :	BOOL;
		Q1 :	BOOL;
		Q2 :	BOOL;
		Q3 :	BOOL;
	END_VAR

	VAR
		sx :	UINT;
	END_VAR

	Q0 := E0 AND (sx MOD C0 - O0 = UINT#0);
	Q1 := E1 AND (sx MOD C1 - O1 = UINT#0);
	Q2 := E2 AND (sx MOD C2 - O2 = UINT#0);
	Q3 := E3 AND (sx MOD C3 - O3 = UINT#0);

	sx := sx + UINT#1;

END_FUNCTION_BLOCK

PROGRAM program0

	VAR
		E0 :	BOOL;
		E1 :	BOOL;
		E2 :	BOOL;
		E3 :	BOOL;
		C0 :	UINT;
		C1 :	UINT;
		C2 :	UINT;
		C3 :	UINT;
		O0 :	UINT;
		O1 :	UINT;
		O2 :	UINT;
		O3 :	UINT;
		Q0 :	BOOL;
		Q1 :	BOOL;
		Q2 :	BOOL;
		Q3 :	BOOL;
		func_block : SCHEDULER_2_Block;
  	END_VAR
	func_block.E0  :=	E0;
	func_block.E1  :=	E1;
	func_block.E2  :=	E2;
	func_block.E3  :=	E3;
	func_block.C0  :=	C0;
	func_block.C1  :=	C1;
	func_block.C2  :=	C2;
	func_block.C3  :=	C3;
	func_block.O0  :=	O0;
	func_block.O1  :=	O1;
	func_block.O2  :=	O2;
	func_block.O3  :=	O3;
	func_block();
	Q0 := func_block.Q0;
	Q1 := func_block.Q1;
	Q2 := func_block.Q2;
	Q3 := func_block.Q3;

END_PROGRAM

CONFIGURATION Config0

	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE

END_CONFIGURATION