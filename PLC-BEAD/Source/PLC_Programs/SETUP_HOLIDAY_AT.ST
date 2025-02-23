TYPE oscat_HOLIDAY_DATA :
	STRUCT
		NAME : STRING;
		DAY : SINT;
		MONTH : SINT;
		USE : SINT;
		PAD_BYTE : BYTE;
	END_STRUCT;
END_TYPE

TYPE
	oscat_HOLIDAY_DATA_0_29 	: ARRAY [0..29] OF oscat_HOLIDAY_DATA;
END_TYPE

FUNCTION_BLOCK SETUP_HOLIDAY_AT_Block

	VAR_IN_OUT
		HD :	oscat_HOLIDAY_DATA_0_29;
	END_VAR

	VAR
		init :	BOOL;
	END_VAR

	IF init THEN RETURN; END_IF;

	init := TRUE;

	HD[00].NAME := 'Neujahr';
	HD[00].DAY  := SINT#01;
	HD[00].MONTH := SINT#01;
	HD[00].USE := SINT#01;

	HD[01].NAME := 'Heilige Drei Koenige';
	HD[01].DAY  := SINT#06;
	HD[01].MONTH := SINT#01;
	HD[01].USE := SINT#01;

	HD[02].NAME := 'Karfreitag';
	HD[02].DAY  := SINT#-2;
	HD[02].MONTH := SINT#00;
	HD[02].USE := SINT#01;

	HD[03].NAME := 'Ostersonntag';
	HD[03].DAY  := SINT#00;
	HD[03].MONTH := SINT#00;
	HD[03].USE := SINT#01;

	HD[04].NAME := 'Ostermontag';
	HD[04].DAY  := SINT#01;
	HD[04].MONTH := SINT#00;
	HD[04].USE := SINT#01;

	HD[05].NAME := '';
	HD[05].DAY  := SINT#01;
	HD[05].MONTH := SINT#05;
	HD[05].USE := SINT#00;

	HD[06].NAME := 'Christi Himmelfahrt';
	HD[06].DAY  := SINT#39;
	HD[06].MONTH := SINT#00;
	HD[06].USE := SINT#01;

	HD[07].NAME := 'Pfingstsonntag';
	HD[07].DAY  := SINT#49;
	HD[07].MONTH := SINT#00;
	HD[07].USE := SINT#01;

	HD[08].NAME := 'Pfingstmontag';
	HD[08].DAY  := SINT#50;
	HD[08].MONTH := SINT#00;
	HD[08].USE := SINT#01;

	HD[09].NAME := 'Fronleichnam';
	HD[09].DAY  := SINT#60;
	HD[09].MONTH := SINT#00;
	HD[09].USE := SINT#01;

	HD[10].NAME := '';
	HD[10].DAY  := SINT#08;
	HD[10].MONTH := SINT#08;
	HD[10].USE := SINT#00;

	HD[11].NAME := 'Maria Himmelfahrt';
	HD[11].DAY  := SINT#15;
	HD[11].MONTH := SINT#08;
	HD[11].USE := SINT#01;

	HD[12].NAME := '';
	HD[12].DAY  := SINT#03;
	HD[12].MONTH := SINT#10;
	HD[12].USE := SINT#00;

	HD[13].NAME := '';
	HD[13].DAY  := SINT#31;
	HD[13].MONTH := SINT#10;
	HD[13].USE := SINT#00;

	HD[14].NAME := 'Allerheiligen';
	HD[14].DAY  := SINT#01;
	HD[14].MONTH := SINT#11;
	HD[14].USE := SINT#01;

	HD[15].NAME := 'Maria Empfngnis';
	HD[15].DAY  := SINT#8;
	HD[15].MONTH := SINT#12;
	HD[15].USE := SINT#01;

	HD[16].NAME := '1. Weihnachtsfeiertag';
	HD[16].DAY  := SINT#25;
	HD[16].MONTH := SINT#12;
	HD[16].USE := SINT#01;

	HD[17].NAME := '2. Weihnachtsfeiertag';
	HD[17].DAY  := SINT#26;
	HD[17].MONTH := SINT#12;
	HD[17].USE := SINT#01;

END_FUNCTION_BLOCK

PROGRAM program0
	
	VAR
		LocalVar0 : oscat_HOLIDAY_DATA_0_29;
		func_block : SETUP_HOLIDAY_AT_Block;
	END_VAR
		func_block.HD  := LocalVar0;
		func_block();
		LocalVar0 := func_block.HD;

END_PROGRAM

CONFIGURATION Config0

	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE

END_CONFIGURATION