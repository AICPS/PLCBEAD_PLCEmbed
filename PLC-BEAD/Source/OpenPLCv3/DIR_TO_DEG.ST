TYPE oscat_LANGUAGE:
  STRUCT
    DEFAULT 	: INT;
	LMAX    	: INT;    
  END_STRUCT;
END_TYPE

TYPE
  oscat_ELEMENT_DIRS 		: ARRAY [0..15] OF STRING;
  oscat_DIRS				: ARRAY [1..3]  OF oscat_ELEMENT_DIRS := [0,0 , 0];
END_TYPE

FUNCTION_BLOCK SETUP_DIRS
	VAR_IN_OUT
		DIRS :	oscat_DIRS;
	END_VAR

	VAR
		init :	BOOL;
	END_VAR

	IF init THEN RETURN; END_IF;
	init := TRUE;

	(* ---- english --- *)
	DIRS[1][00] := 'N';
	DIRS[1][01] := 'NNE';
	DIRS[1][02] := 'NE';
	DIRS[1][03] := 'ENE';
	DIRS[1][04] := 'E';
	DIRS[1][05] := 'ESE';
	DIRS[1][06] := 'SE';
	DIRS[1][07] := 'SSE';
	DIRS[1][08] := 'S';
	DIRS[1][09] := 'SSW';
	DIRS[1][10] := 'SW';
	DIRS[1][11] := 'WSW';
	DIRS[1][12] := 'W';
	DIRS[1][13] := 'WNW';
	DIRS[1][14] := 'NW';
	DIRS[1][15] := 'NNW';

	(* ---- german --- *)
	DIRS[2][00] := 'N';
	DIRS[2][01] := 'NNO';
	DIRS[2][02] := 'NO';
	DIRS[2][03] := 'ONO';
	DIRS[2][04] := 'O';
	DIRS[2][05] := 'OSO';
	DIRS[2][06] := 'SO';
	DIRS[2][07] := 'SSO';
	DIRS[2][08] := 'S';
	DIRS[2][09] := 'SSW';
	DIRS[2][10] := 'SW';
	DIRS[2][11] := 'WSW';
	DIRS[2][12] := 'W';
	DIRS[2][13] := 'WNW';
	DIRS[2][14] := 'NW';
	DIRS[2][15] := 'NNW';

	(* ---- french --- *)
	DIRS[3][00] := 'N';
	DIRS[3][01] := 'NNO';
	DIRS[3][02] := 'NO';
	DIRS[3][03] := 'ONO';
	DIRS[3][04] := 'O';
	DIRS[3][05] := 'OSO';
	DIRS[3][06] := 'SO';
	DIRS[3][07] := 'SSO';
	DIRS[3][08] := 'S';
	DIRS[3][09] := 'SSW';
	DIRS[3][10] := 'SW';
	DIRS[3][11] := 'WSW';
	DIRS[3][12] := 'W';
	DIRS[3][13] := 'WNW';
	DIRS[3][14] := 'NW';
	DIRS[3][15] := 'NNW';
END_FUNCTION_BLOCK

FUNCTION_BLOCK SETUP_LANGUAGE_Block

	VAR_IN_OUT
		LANGUAGE :	oscat_LANGUAGE;
	END_VAR

	VAR
		init :	BOOL;
	END_VAR

	IF init THEN RETURN; END_IF;
	init := TRUE;

	LANGUAGE.DEFAULT  := 1; (* 1=english, 2=german 3=french *)
	LANGUAGE.LMAX := 3;

END_FUNCTION_BLOCK

FUNCTION_BLOCK DIR_TO_DEG_Block
	VAR_INPUT
		DIR :	STRING;
		L :	INT;
	END_VAR

	VAR_OUTPUT
		DIR_TO_DEG :	INT;
	END_VAR

	VAR
		ly :	INT;
		i :	INT;
		SETUP_DIRSS :	SETUP_DIRS;
		DIRS :	oscat_DIRS;
		SETUP_LANGUAGE :	SETUP_LANGUAGE_Block;
		LANGUAGE :	oscat_LANGUAGE;
	END_VAR

	SETUP_DIRSS(DIRS:=DIRS);
	DIRS:=SETUP_DIRSS.DIRS;
	SETUP_LANGUAGE(LANGUAGE:=LANGUAGE);
	LANGUAGE:=SETUP_LANGUAGE.LANGUAGE;

	IF L = 0 THEN ly := LANGUAGE.DEFAULT; ELSE ly := MIN(L, LANGUAGE.LMAX); END_IF;
	FOR i := 0 TO 15 DO
		IF EQ_STRING(DIRS[ly][i],DIR) THEN EXIT; END_IF;
	END_FOR;
	DIR_TO_DEG := WORD_TO_INT(SHR(INT_TO_WORD(i * 45 + 1), 1));

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : STRING;
	LocalVar1 : INT;
	
	LocalOUT  : INT;
	func_block : DIR_TO_DEG_Block;
  END_VAR
	func_block.DIR  := LocalVar0;
	func_block.L  := LocalVar1;
	func_block();
	LocalOUT := func_block.DIR_TO_DEG;
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION