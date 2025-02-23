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

PROGRAM program0
  VAR
    LocalVar0 : oscat_DIRS;
	LocalOUT  : BOOL;
	func_block : SETUP_DIRS;
  END_VAR
	func_block.DIRS  := LocalVar0;
	func_block();
	LocalOUT := func_block.init;
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION