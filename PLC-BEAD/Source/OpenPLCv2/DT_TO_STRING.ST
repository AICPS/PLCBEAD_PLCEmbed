FUNCTION YEAR_OF_DATE:INT
	VAR_INPUT
		IDATE :	UDINT;
	END_VAR

	YEAR_OF_DATE := UDINT_TO_INT((idate+UDINT#43200) / UDINT#31557600 + UDINT#1970);
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

FUNCTION LEAP_OF_DATE:BOOL

	VAR_INPUT
		IDATE :	UDINT;
	END_VAR

	LEAP_OF_DATE := SHL(UDINT_TO_DWORD((idate + UDINT#43200) / UDINT#31557600), 30) = DWORD#16#80000000;
END_FUNCTION

FUNCTION MONTH_OF_DATE:INT

	VAR_INPUT
		IDATE :	UDINT;
	END_VAR

	MONTH_OF_DATE := DAY_OF_YEAR(idate);
	IF MONTH_OF_DATE < 32 THEN
		MONTH_OF_DATE := 1;
	ELSIF LEAP_OF_DATE(IDATE) THEN
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

FUNCTION SECOND_OF_DT:INT

	VAR_INPUT
		XDT :	UDINT;
	END_VAR

	SECOND_OF_DT := UDINT_TO_INT(XDT MOD UDINT#60);
END_FUNCTION

FUNCTION HOUR_OF_DT:INT
	VAR_INPUT
		XDT :	UDINT;
	END_VAR

	HOUR_OF_DT := UDINT_TO_INT((XDT MOD UDINT#86400) / UDINT#3600);
END_FUNCTION

FUNCTION MINUTE_OF_DT:INT
	VAR_INPUT
		XDT :	UDINT;
	END_VAR

	MINUTE_OF_DT := UDINT_TO_INT((XDT MOD UDINT#3600) / UDINT#60);
END_FUNCTION


FUNCTION_BLOCK DT_TO_STRING_Block

	VAR_INPUT
		IDT :	UDINT;
	END_VAR

	VAR_OUTPUT
		DT_STRING :	STRING;
	END_VAR

	VAR
		st_tmp1 :	STRING;
		st_tmp2 :	STRING;
	END_VAR

	st_tmp2 := CONCAT(INT_TO_STRING(YEAR_OF_DATE(IDT)),INT_TO_STRING(MONTH_OF_DATE(IDT)));
	st_tmp1 := CONCAT(INT_TO_STRING(day_of_month(IDT)),INT_TO_STRING(hour_of_DT(IDT)));
	st_tmp2 := CONCAT(st_tmp2,st_tmp1);
	st_tmp1 := CONCAT(INT_TO_STRING(minute_of_DT(IDT)),INT_TO_STRING(second_of_DT(IDT)));
	st_tmp2 := CONCAT(st_tmp2,st_tmp1);
	DT_STRING := st_tmp2;
END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		IDT : UDINT;
		OUT  : STRING;
		func_block : DT_TO_STRING_Block;
	END_VAR
	func_block.IDT := IDT;
	func_block();
	OUT := func_block.DT_STRING;
END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION