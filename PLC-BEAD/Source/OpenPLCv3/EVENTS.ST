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
  oscat_HOLIDAY_DATA_0_49 	: ARRAY [0..49] OF oscat_HOLIDAY_DATA;
END_TYPE

FUNCTION DAY_OF_DATE:DINT
	VAR_INPUT
		IDATE :	UDINT;
	END_VAR

	day_of_date := UDINT_TO_DINT(idate / UDINT#86400);
END_FUNCTION

FUNCTION YEAR_OF_DATE:INT
	VAR_INPUT
		IDATE :	UDINT;
	END_VAR

	YEAR_OF_DATE := UDINT_TO_INT((idate+UDINT#43200) / UDINT#31557600 + UDINT#1970);
END_FUNCTION

FUNCTION _INT_TO_UDINT:UDINT
	VAR_INPUT
		IN :	INT;
	END_VAR

	_INT_TO_UDINT := DINT_TO_UDINT(INT_TO_DINT(IN));
END_FUNCTION

FUNCTION SET_DATE:UDINT

	VAR_INPUT
		YEAR :	INT;
		MONTH :	INT;
		DAY :	INT;
	END_VAR


	VAR
		count :	INT;
	END_VAR


	IF month > 2 THEN
		count := (month - 1) * 30;
		IF month > 7 THEN
			count := count + DWORD_TO_INT(SHR(DINT_TO_DWORD(INT_TO_DINT(month) - INT_TO_DINT(3)),1));
		ELSE
			count := count + DWORD_TO_INT(SHR(DINT_TO_DWORD(INT_TO_DINT(month) - INT_TO_DINT(4)),1));
		END_IF;
		IF SHL(INT_TO_WORD(year),14) = WORD#0 THEN
			count := count + 1;
		END_IF;
	ELSE
		count := (month - 1) * 31;
	END_IF;
	SET_DATE := (_INT_TO_UDINT(count + day - 1) + DWORD_TO_UDINT(SHR(UDINT_TO_DWORD(_INT_TO_UDINT(year) * UDINT#1461 - UDINT#2878169), 2))) * UDINT#86400;
END_FUNCTION

FUNCTION_BLOCK EVENTS
	VAR_INPUT
		DATE_IN :	UDINT;
		ENA :	BOOL;
	END_VAR

	VAR_OUTPUT
		Y :	BOOL;
		NAME :	STRING;
	END_VAR

	VAR_IN_OUT
		ELIST :	oscat_HOLIDAY_DATA_0_49;
	END_VAR

	VAR
		i :	INT;
		last_active :	UDINT;
		size :	INT := 49;
		day_in :	DINT;
		cyr :	INT;
		lday :	DINT;
		check :	oscat_HOLIDAY_DATA;
		y_int :	BOOL;
		name_int :	STRING;
	END_VAR


	IF last_active <> date_in THEN
		last_active := DATE_IN;
		Y_int := FALSE;
		name_int := '';
		day_in := DAY_OF_DATE(DATE_IN);
		cyr := YEAR_OF_DATE(DATE_IN);

		(* search list for events *)
		FOR i := 0 TO size DO
			check := elist[i];
			lday := DAY_OF_DATE(SET_DATE(cyr,SINT_TO_INT(check.month), SINT_TO_INT(check.day)));
			IF day_in >= lday AND day_in <= lday + SINT_TO_DINT(check.use) - DINT#1 THEN
				y_int := TRUE;
				name_int := check.name;
				EXIT;
			END_IF;
		END_FOR;
	END_IF;

	IF ENA THEN
		Y := y_int;
		NAME := name_int;
	ELSE
		Y := FALSE;
		NAME := '';
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		DATE_IN :	UDINT;
		ENA :	BOOL;

		Y :	BOOL;
		NAME :	STRING;

		ELIST :	oscat_HOLIDAY_DATA_0_49;

		func_block : EVENTS;
	END_VAR
	func_block.DATE_IN := DATE_IN;
	func_block.ENA := ENA;
	func_block.ELIST := ELIST ;

	func_block();
	Y  := func_block.Y;
	NAME  := func_block.NAME;
	ELIST  := func_block.ELIST;
END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION
