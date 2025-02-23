
TYPE oscat_LANGUAGE:
  STRUCT
    DEFAULT 	: INT;
	LMAX    	: INT;    
  END_STRUCT;
END_TYPE


TYPE
	oscat_LOCATION_ELEMENTS	: ARRAY [1..5] OF INT;
END_TYPE

TYPE
  oscat_ELEMENT_WEEKDAYS	: ARRAY [1..7] OF STRING;
  oscat_WEEKDAYS			: ARRAY [1..3]  OF oscat_ELEMENT_WEEKDAYS := [0, 0, 0];
END_TYPE

TYPE oscat_LOCATION:
  STRUCT
    DEFAULT 	: INT;
	LMAX    	: INT;    
	LANGUAGE	: oscat_LOCATION_ELEMENTS;
  END_STRUCT;
END_TYPE

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

FUNCTION_BLOCK SETUP_LOCATION
	VAR_IN_OUT
		LOCATION :	oscat_LOCATION;
	END_VAR

	VAR
		init :	BOOL;
	END_VAR


	IF init THEN RETURN; END_IF;
	init := TRUE;

	LOCATION.DEFAULT  := 1;  
	LOCATION.LMAX := 5;

	LOCATION.LANGUAGE[1] := 2;
	LOCATION.LANGUAGE[2] := 2;
	LOCATION.LANGUAGE[3] := 3;
	LOCATION.LANGUAGE[4] := 2;
	LOCATION.LANGUAGE[5] := 2;
END_FUNCTION_BLOCK

FUNCTION_BLOCK SETUP_WEEKDAYS

	VAR_IN_OUT
		WEEKDAYS :	oscat_WEEKDAYS;
	END_VAR

	VAR
		init :	BOOL;
	END_VAR

	IF init THEN RETURN; END_IF;
	init := TRUE;

	WEEKDAYS[1][01] := 'Monday';
	WEEKDAYS[1][02] := 'Tuesday';
	WEEKDAYS[1][03] := 'Wednesday';
	WEEKDAYS[1][04] := 'Thursday';
	WEEKDAYS[1][05] := 'Friday';
	WEEKDAYS[1][06] := 'Saturday';
	WEEKDAYS[1][07] := 'Sunday';

	WEEKDAYS[2][01] := 'Montag';
	WEEKDAYS[2][02] := 'Dienstag';
	WEEKDAYS[2][03] := 'Mittwoch';
	WEEKDAYS[2][04] := 'Donnerstag';
	WEEKDAYS[2][05] := 'Freitag';
	WEEKDAYS[2][06] := 'Samstag';
	WEEKDAYS[2][07] := 'Sonntag';

	WEEKDAYS[3][01] := 'Lundi';
	WEEKDAYS[3][02] := 'Mardi';
	WEEKDAYS[3][03] := 'Mercredi';
	WEEKDAYS[3][04] := 'Jeudi';
	WEEKDAYS[3][05] := 'Vendredi';
	WEEKDAYS[3][06] := 'Samedi';
	WEEKDAYS[3][07] := 'Dimanche';
END_FUNCTION_BLOCK

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

FUNCTION DAY_OF_WEEK:INT
	VAR_INPUT
		IDATE :	UDINT;
	END_VAR

	DAY_OF_WEEK := UDINT_TO_INT((idate / UDINT#86400 + UDINT#3) MOD UDINT#7) + INT#01;
END_FUNCTION

FUNCTION EASTER:UDINT
	VAR_INPUT
		YEAR :	INT;
	END_VAR

	VAR
		b :	INT;
		c :	INT;
		oday :	INT;
	END_VAR

	b := (204 - 11 * (year MOD 19)) MOD 30;
	IF b > 27 THEN b := b - 1; END_IF;
	c := (year + WORD_TO_INT(SHR(INT_TO_WORD(year),2)) + b - 13) MOD 7;
	oday := 28 + b - c;
	IF oday > 33 THEN
		easter := set_Date(year, 4, oday - 31);
	ELSE
		easter := set_Date(year, 3, oday);
	END_IF;
END_FUNCTION

FUNCTION LEAP_OF_DATE:BOOL

	VAR_INPUT
		IDATE :	UDINT;
	END_VAR

	LEAP_OF_DATE := SHL(UDINT_TO_DWORD((idate + UDINT#43200) / UDINT#31557600), 30) = DWORD#16#80000000;
END_FUNCTION

FUNCTION DAY_OF_YEAR:INT
	VAR_INPUT
		IDATE :	UDINT;
	END_VAR

	DAY_OF_YEAR := UDINT_TO_INT(((idate) / UDINT#86400) MOD UDINT#1461);
	IF DAY_OF_YEAR > 729 THEN
		IF DAY_OF_YEAR > 1095 THEN DAY_OF_YEAR := DAY_OF_YEAR - 1095; ELSE DAY_OF_YEAR := DAY_OF_YEAR - 729; END_IF;
	ELSIF DAY_OF_YEAR > 364 THEN
		DAY_OF_YEAR := DAY_OF_YEAR - 364;
	ELSE
		DAY_OF_YEAR := DAY_OF_YEAR + 1;
	END_IF;
END_FUNCTION

FUNCTION MONTH_OF_DATE:INT

	VAR_INPUT
		IDATE :	UDINT;
	END_VAR

	MONTH_OF_DATE := DAY_OF_YEAR(idate);
	IF MONTH_OF_DATE < 32 THEN
		MONTH_OF_DATE := 1;
	ELSIF LEAP_OF_DATE((IDATE)) THEN
		MONTH_OF_DATE := (MONTH_OF_DATE * 53 + 1668) / 1623;
	ELSE
		MONTH_OF_DATE := (MONTH_OF_DATE * 53 + 1700) / 1620;
	END_IF;
END_FUNCTION

FUNCTION DAY_OF_MONTH:INT
	VAR_INPUT
		IDATE :	UDINT;
	END_VAR

	day_of_month := day_of_year(idate);

	IF leap_of_Date((idate)) THEN
		CASE day_of_month OF
			32..60	:	day_of_month := day_of_month - 31;
			61..91	:	day_of_month := day_of_month - 60;
			92..121 :	day_of_month := day_of_month - 91;
			122..152:	day_of_month := day_of_month - 121;
			153..182:	day_of_month := day_of_month - 152;
			183..213:	day_of_month := day_of_month - 182;
			214..244:	day_of_month := day_of_month - 213;
			245..274:	day_of_month := day_of_month - 244;
			275..305:	day_of_month := day_of_month - 274;
			306..335:	day_of_month := day_of_month - 305;
			336..366:	day_of_month := day_of_month - 335;
		END_CASE;
	ELSE
		CASE day_of_month OF
			32..59	:	day_of_month := day_of_month - 31;
			60..90	:	day_of_month := day_of_month - 59;
			91..120 :	day_of_month := day_of_month - 90;
			121..151:	day_of_month := day_of_month - 120;
			152..181:	day_of_month := day_of_month - 151;
			182..212:	day_of_month := day_of_month - 181;
			213..243:	day_of_month := day_of_month - 212;
			244..273:	day_of_month := day_of_month - 243;
			274..304:	day_of_month := day_of_month - 273;
			305..334:	day_of_month := day_of_month - 304;
			335..365:	day_of_month := day_of_month - 334;
		END_CASE;
	END_IF;
END_FUNCTION


FUNCTION DATE_ADD:UDINT
	VAR_INPUT
		IDATE :	UDINT;
		D :	INT;
		W :	INT; 
		M :	INT;
		Y :	INT;
	END_VAR

	VAR
		mo :	INT;
		yr :	INT;
		dm :	INT;
	END_VAR

	DATE_ADD := IDATE + INT_TO_UDINT(D + W * 7) * UDINT#86400;
	yr := Y + YEAR_OF_DATE(DATE_ADD);
	mo := M + MONTH_OF_DATE(DATE_ADD);
	dm := DAY_OF_MONTH(DATE_ADD);
	WHILE mo > 12 DO
		mo := mo - 12;
		yr := yr + 1;
	END_WHILE;
	WHILE mo < 1 DO
		mo := mo + 12;
		yr := yr - 1;
	END_WHILE;
	DATE_ADD := SET_DATE(yr, mo, dm);
END_FUNCTION

FUNCTION_BLOCK HOLIDAY_Block
	VAR_INPUT
		DATE_IN :	UDINT;
		LANGU :	INT;
		FRIDAY :	BOOL;
		SATURDAY :	BOOL;
		SUNDAY :	BOOL;
	END_VAR

	VAR_IN_OUT
		HOLIDAYS :	oscat_HOLIDAY_DATA_0_29;
	END_VAR

	VAR_OUTPUT
		Y :	BOOL;
		NAME :	STRING;
	END_VAR


	

	VAR
		size :	INT := INT#29;
		last_active :	UDINT;
		ostern :	UDINT;
		i :	INT;
		jahr :	INT;
		x_date :	UDINT;
		lx :	INT;
		wdx :	INT;
		SETUP_LOCATIONS :	SETUP_LOCATION;
		SETUP_WEEKDAYSS :	SETUP_WEEKDAYS;
		SETUP_LANGUAGES :	SETUP_LANGUAGE_Block;
		LOCATION :	oscat_LOCATION;
		WEEKDAYS :	oscat_WEEKDAYS;
		LANGUAGE :	oscat_LANGUAGE;
		wd :	INT;
	END_VAR


	IF last_active = date_in THEN RETURN; END_IF;
	last_active := DATE_IN;

	SETUP_LOCATIONS(LOCATION:=LOCATION);
	LOCATION:=SETUP_LOCATIONS.LOCATION;

	SETUP_WEEKDAYSS(WEEKDAYS:=WEEKDAYS);
	WEEKDAYS:=SETUP_WEEKDAYSS.WEEKDAYS;

	SETUP_LANGUAGES(LANGUAGE:=LANGUAGE);
	LANGUAGE:=SETUP_LANGUAGES.LANGUAGE;


	IF LANGU = 0 THEN
		lx := language.DEFAULT;
	ELSE
		lx := MIN(language.LMAX, LANGU);
	END_IF;

	jahr := YEAR_OF_DATE(date_in);
	ostern := EASTER(jahr);
	wdx := DAY_OF_WEEK(DATE_IN);
	Y := FALSE;

	FOR i := 0 TO size DO
		x_date := SET_DATE(jahr, SINT_TO_INT(HOLIDAYS[i].MONTH) , SINT_TO_INT(HOLIDAYS[i].DAY));
		IF HOLIDAYS[i].USE = SINT#1 AND HOLIDAYS[i].MONTH > SINT#0 THEN
			(* check for fixed date holiday *)
			IF x_date = date_in THEN
				Y := TRUE;
				NAME := HOLIDAYS[i].NAME;
				RETURN;
			END_IF;
		ELSIF HOLIDAYS[i].USE = SINT#1 AND HOLIDAYS[i].MONTH = SINT#0 THEN
			(* check for holiday in reference to easter *)
			IF DATE_ADD(ostern, SINT_TO_INT(HOLIDAYS[i].DAY),0,0,0) = date_in THEN
				Y := TRUE;
				NAME := HOLIDAYS[i].NAME;
				RETURN;
			END_IF;
		ELSIF HOLIDAYS[i].USE < SINT#0 THEN
			(* check for holiday on a weekday before date *)
			IF DAY_OF_WEEK(date_in) = SINT_TO_INT(ABS(HOLIDAYS[i].USE)) AND date_in < x_date AND date_in >= DATE_ADD(x_date,-7,0,0,0) THEN
				Y := TRUE;
				NAME := HOLIDAYS[i].NAME;
				RETURN;
			END_IF;
		END_IF;
	END_FOR;

	IF NOT Y AND (wdx = 5 AND FRIDAY OR wdx = 6 AND SATURDAY OR wdx = 7 AND SUNDAY) THEN
		Y := TRUE;
		wd := LOCATION.LANGUAGE[lx];
		NAME := WEEKDAYS[wd][wdx];
	ELSE
		NAME := '';
	END_IF;
END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	DATE_IN  :	UDINT;
	LANGU    :	INT;
	FRIDAY   :	BOOL;
	SATURDAY :	BOOL;
	SUNDAY   :	BOOL;

	Y :	BOOL;
	NAME :	STRING;

	HOLIDAYS :	oscat_HOLIDAY_DATA_0_29;

	func_block : HOLIDAY_Block;
  END_VAR
	func_block.DATE_IN :=DATE_IN ;
	func_block.LANGU   :=LANGU   ;
	func_block.FRIDAY  :=FRIDAY  ;
	func_block.SATURDAY:=SATURDAY;
	func_block.SUNDAY  :=SUNDAY  ;
	func_block.HOLIDAYS  :=HOLIDAYS ;

	func_block();
	Y := func_block.Y;
	NAME := func_block.NAME;
	HOLIDAYS := func_block.HOLIDAYS;

END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION