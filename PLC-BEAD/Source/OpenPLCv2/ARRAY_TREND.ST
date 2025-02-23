TYPE
	oscat_pt_ARRAY: ARRAY [1..100] OF REAL;
END_TYPE

FUNCTION BIT_OF_DWORD:BOOL
	VAR_INPUT
		IN :	DWORD;
		N :	INT;
	END_VAR
	BIT_OF_DWORD := (SHR(in,n) AND DWORD#1) > DWORD#0;
END_FUNCTION

FUNCTION EVEN:BOOL
	VAR_INPUT
		IN :	DINT;
	END_VAR
	even := NOT BIT_OF_DWORD(DINT_TO_DWORD(in),0);
END_FUNCTION

FUNCTION_BLOCK ARRAY_TREND_Block
	VAR_IN_OUT
		PT :	oscat_pt_ARRAY;
	END_VAR

	VAR_INPUT
		SIZE :	UINT;
	END_VAR

	VAR_OUTPUT
		ARRAY_TREND :	REAL;
	END_VAR

	VAR
		d :	INT;
		i :	INT;
		stop :	INT;
		stop2 :	INT;
		x :	REAL;
	END_VAR

	x := 0.0;
	stop :=LIMIT_INT(1,UINT_TO_INT(size),1000);
	stop2 := WORD_TO_INT(SHR(INT_TO_WORD(stop),1)); 
	IF even(INT_TO_DINT(stop)) THEN d:=0; ELSE d:=1;END_IF;

	FOR i := 1 TO stop2+d DO
		x := x - pt[i];
	END_FOR; 
	FOR i := stop2+1 TO stop DO
		x := x + pt[i];
	END_FOR; 
	array_trend := x / INT_TO_REAL(stop2+d);

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : oscat_pt_ARRAY;
    LocalVar1 : UINT;
	LocalOUT  : REAL;
	func_block : ARRAY_TREND_Block;
  END_VAR
	func_block.pt := LocalVar0;
	func_block.size := LocalVar1;
	func_block();
	LocalOUT := func_block.ARRAY_TREND;

END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION