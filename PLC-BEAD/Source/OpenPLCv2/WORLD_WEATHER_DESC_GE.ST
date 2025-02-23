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

FUNCTION_BLOCK WORLD_WEATHER_DESC_GE_Block

	VAR_INPUT
		ACTIVATE :	BOOL;
	END_VAR


	VAR_IN_OUT
		WW :	oscat_WORLD_WEATHER_DATA;
	END_VAR


	VAR
		act_last :	BOOL;
		x :	INT;
		y :	INT;
		str :	oscat_STRING60;
		i :	INT;
	END_VAR

	IF ACTIVATE AND act_last = FALSE THEN
		i := 0;
		FOR y := 1 TO 12 DO
			CASE y OF
			1,3,5,7,9:	x :=  WW.DAY[i].WEATHER_CODE;
			2,4,6,8,10:	WW.DAY[i].WEATHER_DESC := str;
						i := i + 1;
			11:			x :=  WW.CUR.WEATHER_CODE;
			12:			WW.CUR.WEATHER_DESC := str;
			END_CASE;

			CASE x OF
				113	:	str := 'heiter/sonnig';
				116	:	str := 'stellenweise wolkig';
				119	:	str := 'wolkig';
				122	:	str := 'awret';
				143	:	str := 'Nebel';
				176	:	str := 'stellenweise nahegelegener Regen';
				179	:	str := 'stellenweise nahegelegener Schneefall';
				182	:	str := 'stellenweise nahegelegener Eisregen';
				185	:	str := 'stellenweise gefrierender Niesel';
				200	:	str := 'nahegelegene Sturm';
				227	:	str := 'Schneetreiben';
				230	:	str := 'Schneesturm';
				248	:	str := 'Nebel';
				260	:	str := 'gefrierender Nebel';
				263	:	str := 'stellenweise leichter Nieselregen';
				266	:	str := 'leichter Niesel';
				281	:	str := 'gefrierender Nieselregen';
				284	:	str := 'stark gefrierender Nieselregen';
				293	:	str := 'stellenweise leichter Regen';
				296	:	str := 'leichter Regen';
				299	:	str := 'zeitweise etwas Regen';
				302	:	str := 'awerg Regen';
				305	:	str := 'zeitweise etwas starker Regen';
				308	:	str := 'starker Regen';
				311	:	str := 'leichter gefrierender Regen';
				314	:	str := 'awerawer oder starker Eisregen';
				317	:	str := 'leichter Eisregen';
				320	:	str := 'awewea oder starker Eisregen';
				323	:	str := 'stellenweise leichter Schneefall';
				326	:	str := 'leichter Scheefall';
				329	:	str := 'stellenweise moderater Schneefall';
				332	:	str := 'awertwy Schnee';
				335	:	str := 'stellenweise starker Scheefall';
				338	:	str := 'starker Schneefall';
				350	:	str := 'Hagel';
				353	:	str := 'leichte ewruerh';
				356	:	str := 'awerwaer oder starker Regenfall';
				359	:	str := 'sintflutartige aweheawh';
				362	:	str := 'leichter Eisregen';
				365	:	str := 'aweraweb oder starker Eisregen';
				368	:	str := 'leichte Schneeschauer';
				371	:	str := 'awerawb oder starker Schneefall';
				374	:	str := 'leichter Hagel';
				377	:	str := 'awerawer oder starker Hagel';
				386	:	str := 'stellenweise leichter Regen in Gewittergebiet';
				389	:	str := 'awer oder starker Regen in Gewittergebiet';
				392	:	str := 'stellenweise leichter Schneefall in Gewittergebiet';
				395	:	str := 'awerh oder starker Schnee in Gewittergebiet';
			ELSE
				str := 	'nicht aweh';
			END_CASE;
		END_FOR;
	END_IF;
	act_last := ACTIVATE;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		ACTIVATE :	BOOL;
		WW :	oscat_WORLD_WEATHER_DATA;

		func_block : WORLD_WEATHER_DESC_GE_Block;
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