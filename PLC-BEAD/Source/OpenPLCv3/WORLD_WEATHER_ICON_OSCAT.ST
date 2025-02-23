TYPE
  oscat_STRING3               : STRING;
  oscat_STRING8               : STRING;
  oscat_STRING10              : STRING;
  oscat_STRING60              : STRING;

END_TYPE
TYPE
	oscat_WORLD_WEATHER_CUR :
	STRUCT
		OBSERVATION_TIME : oscat_STRING8;
		TEMP_C           : INT;
		WEATHER_CODE     : INT;
		WEATHER_DESC 	 : oscat_STRING60;
		WEATHER_ICON     : INT;
		WIND_SPEED_MILES : INT;
		WIND_SPEED_KMPH  : INT;
		WIND_DIR_DEGREE  : INT;
		WIND_DIR16POINT  : oscat_STRING3;
		PRECIPMM         : REAL;
		HUMIDITY         : INT;
		VISIBILITY       : INT;
		PRESSURE         : INT;
		CLOUDOVER        : INT;
	END_STRUCT;

	oscat_WORLD_WEATHER_DAY :
	STRUCT
		DATE_OF_DAY      : oscat_STRING10;
		TEMP_MAX_C       : INT;
		TEMP_MAX_F       : INT;
		TEMP_MIN_C       : INT;
		TEMP_MIN_F       : INT;
		WIND_SPEED_MILES : INT;
		WIND_SPEED_KMPH  : INT;
		WIND_DIR_DEGREE  : INT;
		WIND_DIR16POINT  : oscat_STRING3;
		WEATHER_CODE     : INT;
		WEATHER_DESC     : oscat_STRING60;
		WEATHER_ICON     : INT;
		PRECIPMM         : REAL;
	END_STRUCT;

	oscat_WORLD_WEATHER_DAY_ARR : ARRAY [0..4] OF oscat_WORLD_WEATHER_DAY;

	oscat_WORLD_WEATHER_DATA :
	STRUCT
		CUR : oscat_WORLD_WEATHER_CUR;
		DAY : oscat_WORLD_WEATHER_DAY_ARR;
	END_STRUCT;

	oscat_WORLD_WEATHER_aI0_41 : ARRAY[0..41] OF INT;
END_TYPE

FUNCTION_BLOCK WORLD_WEATHER_ICON_OSCAT_Block

	VAR_INPUT
		ACTIVATE :	BOOL;
	END_VAR


	VAR_IN_OUT
		WW :	oscat_WORLD_WEATHER_DATA;
	END_VAR


	VAR
		act_last :	BOOL;
		x :	INT;
		i :	INT;
		init :	BOOL;
		dat :	oscat_WORLD_WEATHER_aI0_41;
	END_VAR

	IF not init THEN
		init := TRUE;

		dat[00] := 0;
		dat[01] := 14;
		dat[02] := 12;
		dat[03] := 9;
		dat[04] := 9;
		dat[05] := 0;
		dat[06] := 7;
		dat[07] := 7;
		dat[08] := 0;
		dat[09] := 2;
		dat[10] := 2;
		dat[11] := 3;
		dat[12] := 3;
		dat[13] := 1;
		dat[14] := 0;
		dat[15] := 0;
		dat[16] := 17;
		dat[17] := 4;
		dat[18] := 4;
		dat[19] := 3;
		dat[20] := 3;
		dat[21] := 1;
		dat[22] := 0;
		dat[23] := 0;
		dat[24] := 17;
		dat[25] := 2;
		dat[26] := 2;
		dat[27] := 3;
		dat[28] := 3;
		dat[29] := 1;
		dat[30] := 0;
		dat[31] := 0;
		dat[32] := 17;
		dat[33] := 2;
		dat[34] := 4;
		dat[35] := 3;
		dat[36] := 3;
		dat[37] := 1;
		dat[38] := 0;
		dat[39] := 0;
		dat[40] := 17;
		dat[41] := 0;
	END_IF;

	IF ACTIVATE AND act_last = FALSE THEN
		x := LIMIT(0,WW.CUR.WEATHER_ICON,41);
		WW.CUR.WEATHER_ICON := dat[x];
		FOR i := 0 TO 4 DO
			x := LIMIT(0,WW.DAY[i].WEATHER_ICON,41);
			WW.DAY[i].WEATHER_ICON := dat[x];
		END_FOR;
	END_IF;
	act_last := ACTIVATE;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		ACTIVATE :	BOOL;
		WW :	oscat_WORLD_WEATHER_DATA;

		func_block : WORLD_WEATHER_ICON_OSCAT_Block;
	END_VAR
	func_block.ACTIVATE := ACTIVATE;
	func_block.WW := WW;

	func_block();
	WW  := func_block.WW;
END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION