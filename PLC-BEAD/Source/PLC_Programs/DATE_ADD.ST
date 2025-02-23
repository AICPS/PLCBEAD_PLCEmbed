FUNCTION YEAR_OF_DATE:INT
	VAR_INPUT
		IDATE :	UDINT;
	END_VAR

	YEAR_OF_DATE := UDINT_TO_INT((idate+UDINT#43200) / UDINT#31557600 + UDINT#1970);
END_FUNCTION

FUNCTION DAY_OF_WEEK:INT

	VAR_INPUT
		IDATE :	UDINT;
	END_VAR


	DAY_OF_WEEK := UDINT_TO_INT((idate / UDINT#86400 + UDINT#3) MOD UDINT#7) + INT#01;
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

PROGRAM program0
  VAR
    LocalVar0 : UDINT;
	LocalVar1 : INT;
	LocalVar2 : INT;
	LocalVar3 : INT;
	LocalVar4 : INT;
	LocalOUT  : UDINT;
  END_VAR
  	LocalOUT := DATE_ADD(LocalVar0, LocalVar1, LocalVar2, LocalVar3, LocalVar4);
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION