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

FUNCTION YEAR_OF_DATE:INT
	VAR_INPUT
		IDATE :	UDINT;
	END_VAR

	YEAR_OF_DATE := UDINT_TO_INT((idate+UDINT#43200) / UDINT#31557600 + UDINT#1970);
END_FUNCTION


FUNCTION_BLOCK METER_STAT_Block

	VAR_INPUT
		IN :	REAL;
		DI :	UDINT;
		RST :	BOOL;
	END_VAR


	VAR_IN_OUT
		LAST_DAY :	REAL;
		CURRENT_DAY :	REAL;
		LAST_WEEK :	REAL;
		CURRENT_WEEK :	REAL;
		LAST_MONTH :	REAL;
		CURRENT_MONTH :	REAL;
		LAST_YEAR :	REAL;
		CURRENT_YEAR :	REAL;
	END_VAR


	VAR RETAIN 
		year_start :	REAL;
		month_start :	REAL;
		week_start :	REAL;
		day_start :	REAL;
		last_run :	UDINT;
	END_VAR

	IF rst THEN
		Last_Day := 0.0;
		Current_Day := 0.0;
		Day_start := IN;
		Last_week := 0.0;
		Current_week := 0.0;
		Week_start := in;
		Last_month := 0.0;
		Current_month := 0.0;
		month_start := in;
		last_year := 0.0;
		current_year := 0.0;
		year_start := in;
	ELSE
		Current_Day := IN - Day_Start;
		Current_Week := In - Week_Start;
		Current_Month := IN - Month_Start;
		Current_Year := IN - Year_Start;
	END_IF;

	IF YEAR_OF_DATE(DI) > YEAR_OF_DATE(last_run) THEN
		(* a new year has started *)
		last_year := current_year;
		current_year := 0.0;
		year_start := in;
		last_month := current_month;
		current_month := 0.0;
		month_start := in;
		last_day := current_day;
		current_day := 0.0;
		day_start := in;
	ELSIF MONTH_OF_DATE(DI) > MONTH_OF_DATE(last_run) THEN
		(* a new month has started, january is alrerady done by year change *)
		last_month := current_month;
		current_month := 0.0;
		month_start := in;
		last_day := current_day;
		current_day := 0.0;
		day_start := in;
	ELSIF DAY_OF_YEAR(di) > DAY_OF_YEAR(last_run) THEN
		(* day has chaged, first day of year and first day of month has already been taken care of *)
		last_day := current_day;
		current_day := 0.0;
		day_start := in;
	END_IF;
	IF DAY_OF_WEEK(DI) < DAY_OF_WEEK(last_run) THEN
		(* a new week has started *)
		last_week := current_week;
		current_week := 0.0;
		week_start := in;
	END_IF;
	last_run := di;

END_FUNCTION_BLOCK


PROGRAM program0

	VAR
		IN :	REAL;
		DI :	UDINT;
		RST :	BOOL;

		LAST_DAY :	REAL;
		CURRENT_DAY :	REAL;
		LAST_WEEK :	REAL;
		CURRENT_WEEK :	REAL;
		LAST_MONTH :	REAL;
		CURRENT_MONTH :	REAL;
		LAST_YEAR :	REAL;
		CURRENT_YEAR :	REAL;

		func_block : METER_STAT_Block;
	END_VAR

	func_block.IN := IN;
	func_block.DI := DI;
	func_block.RST := RST;
	func_block.LAST_DAY := LAST_DAY;
	func_block.CURRENT_DAY := CURRENT_DAY;
	func_block.LAST_WEEK := LAST_WEEK;
	func_block.CURRENT_WEEK := CURRENT_WEEK;
	func_block.LAST_MONTH := LAST_MONTH;
	func_block.CURRENT_MONTH := CURRENT_MONTH;
	func_block.LAST_YEAR := LAST_YEAR;
	func_block.CURRENT_YEAR := CURRENT_YEAR;

	func_block();

	LAST_DAY  := func_block.LAST_DAY;
	CURRENT_DAY  := func_block.CURRENT_DAY;
	LAST_WEEK  := func_block.LAST_WEEK;
	CURRENT_WEEK  := func_block.CURRENT_WEEK;
	LAST_MONTH  := func_block.LAST_MONTH;
	CURRENT_MONTH  := func_block.CURRENT_MONTH;
	LAST_YEAR  := func_block.LAST_YEAR;
	CURRENT_YEAR  := func_block.CURRENT_YEAR;

END_PROGRAM

CONFIGURATION Config0

	VAR_GLOBAL
		PLC_TICKS_PER_SEC :	INT;
		PLC_SYS_TICK_CNT :	DINT;
	END_VAR
	
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE

END_CONFIGURATION

