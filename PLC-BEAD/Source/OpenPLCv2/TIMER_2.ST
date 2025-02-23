FUNCTION UDINT_TO_TIME2:TIME

	VAR_INPUT
		IN :	UDINT;
	END_VAR


	UDINT_TO_TIME2 := DINT_TO_TIME(UDINT_TO_DINT(IN));

END_FUNCTION

FUNCTION_BLOCK T_PLC_MS_block
	VAR_OUTPUT
		T_PLC_MS :	UDINT;
	END_VAR

	VAR_EXTERNAL
		PLC_TICKS_PER_SEC :	INT;
		PLC_SYS_TICK_CNT :	DINT;
	END_VAR

	VAR
		debug :	BOOL;(*Debug-Mode ON / OFF*)
		N :	INT;(*Debug-Faktor*)
		Offset :	UDINT;(*Debug-Offset*)
		temp :	DWORD := DWORD#1;(*Debug-Offset*)
		mode :	BOOL;(*modus*)
		faktor :	UDINT;(*Systemtakt-Faktor*)
		init :	BOOL;
		v_plc_ticks_per_sec :	UDINT;
		base :	UDINT := UDINT#1000;
	END_VAR


	IF init = FALSE THEN
		v_plc_ticks_per_sec := INT_TO_UDINT(PLC_TICKS_PER_SEC);
		IF v_plc_ticks_per_sec = UDINT#1024 THEN
			faktor := UDINT#1;
			mode := FALSE;
		ELSIF v_plc_ticks_per_sec > UDINT#0 THEN
			IF v_plc_ticks_per_sec <= base THEN
				faktor := base / v_plc_ticks_per_sec;
				mode := FALSE;
			ELSE
				faktor := v_plc_ticks_per_sec / base;
				mode := TRUE;
			END_IF;
		ELSE
			faktor := UDINT#1;
		END_IF;
		init := TRUE;
	END_IF;

	IF mode THEN
		T_PLC_MS := DINT_TO_UDINT(PLC_SYS_TICK_CNT) / faktor;
	ELSE
		T_PLC_MS := DINT_TO_UDINT(PLC_SYS_TICK_CNT) * faktor;
	END_IF;

	IF debug THEN
		T_PLC_MS := (DWORD_TO_UDINT(SHL(UDINT_TO_DWORD(T_PLC_MS),N) OR SHL(temp,N)) - UDINT#1) + Offset;
	END_IF;
END_FUNCTION_BLOCK

FUNCTION DAY_OF_WEEK:INT
  VAR_INPUT
    IDATE :	UDINT;
  END_VAR

  DAY_OF_WEEK := UDINT_TO_INT((idate / UDINT#86400 + UDINT#3) MOD UDINT#7) + INT#01;
END_FUNCTION

FUNCTION _BYTE_TO_INT:INT
	VAR_INPUT
		IN :	BYTE;
	END_VAR

	_BYTE_TO_INT := USINT_TO_INT(BYTE_TO_USINT(IN));
END_FUNCTION

FUNCTION LEAP_OF_DATE:BOOL

	VAR_INPUT
		IDATE :	UDINT;
	END_VAR

	LEAP_OF_DATE := SHL(UDINT_TO_DWORD((idate + UDINT#43200) / UDINT#31557600), 30) = DWORD#16#80000000;

END_FUNCTION

FUNCTION DAY_OF_YEAR:INT
	VAR_INPUT
		IDATE :	DATE;
	END_VAR

	DAY_OF_YEAR := UDINT_TO_INT((DATE_TO_UDINT(idate) / UDINT#86400) MOD UDINT#1461);
	IF DAY_OF_YEAR > 729 THEN
		IF DAY_OF_YEAR > 1095 THEN DAY_OF_YEAR := DAY_OF_YEAR - 1095; ELSE DAY_OF_YEAR := DAY_OF_YEAR - 729; END_IF;
	ELSIF DAY_OF_YEAR > 364 THEN
		DAY_OF_YEAR := DAY_OF_YEAR - 364;
	ELSE
		DAY_OF_YEAR := DAY_OF_YEAR + 1;
	END_IF;
END_FUNCTION

FUNCTION DAY_OF_YEAR_UDINT:INT
	VAR_INPUT
		IDATE :	UDINT;
	END_VAR

	DAY_OF_YEAR_UDINT := UDINT_TO_INT((idate / UDINT#86400) MOD UDINT#1461);
	IF DAY_OF_YEAR_UDINT > 729 THEN
		IF DAY_OF_YEAR_UDINT > 1095 THEN DAY_OF_YEAR_UDINT := DAY_OF_YEAR_UDINT - 1095; ELSE DAY_OF_YEAR_UDINT := DAY_OF_YEAR_UDINT - 729; END_IF;
	ELSIF DAY_OF_YEAR_UDINT > 364 THEN
		DAY_OF_YEAR_UDINT := DAY_OF_YEAR_UDINT - 364;
	ELSE
		DAY_OF_YEAR_UDINT := DAY_OF_YEAR_UDINT + 1;
	END_IF;
END_FUNCTION

FUNCTION MONTH_OF_DATE_UDINT:INT

	VAR_INPUT
		IDATE :	UDINT;
	END_VAR

	MONTH_OF_DATE_UDINT := DAY_OF_YEAR_UDINT(idate);
	IF MONTH_OF_DATE_UDINT < 32 THEN
		MONTH_OF_DATE_UDINT := 1;
	ELSIF LEAP_OF_DATE(IDATE) THEN
		MONTH_OF_DATE_UDINT := (MONTH_OF_DATE_UDINT * 53 + 1668) / 1623;
	ELSE
		MONTH_OF_DATE_UDINT := (MONTH_OF_DATE_UDINT * 53 + 1700) / 1620;
	END_IF;

END_FUNCTION

FUNCTION DAY_OF_MONTH:INT
	VAR_INPUT
		IDATE :	UDINT;
	END_VAR

	day_of_month := day_of_year_UDINT(idate);

	IF leap_of_Date(idate) THEN
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

FUNCTION MONTH_OF_DATE:INT

	VAR_INPUT
		IDATE :	DATE;
	END_VAR

	MONTH_OF_DATE := DAY_OF_YEAR(idate);
	IF MONTH_OF_DATE < 32 THEN
		MONTH_OF_DATE := 1;
	ELSIF LEAP_OF_DATE(DATE_TO_UDINT(IDATE)) THEN
		MONTH_OF_DATE := (MONTH_OF_DATE * 53 + 1668) / 1623;
	ELSE
		MONTH_OF_DATE := (MONTH_OF_DATE * 53 + 1700) / 1620;
	END_IF;

END_FUNCTION

FUNCTION TIME_TO_UDINT2:UDINT
	VAR_INPUT
		X :	TIME;
	END_VAR

	TIME_TO_UDINT2 := DINT_TO_UDINT(TIME_TO_DINT(X));
END_FUNCTION

FUNCTION DT_TO_TOD2:UDINT
	VAR_INPUT
		IN :	UDINT;
	END_VAR

	DT_TO_TOD2 := (IN MOD UDINT#86400) * UDINT#1000;
END_FUNCTION

FUNCTION _DT_TO_DATE_B:UDINT

	VAR_INPUT
		_INN :	UDINT;
	END_VAR

	_DT_TO_DATE_B := (_INN / UDINT#86400) * UDINT#86400;
END_FUNCTION

FUNCTION_BLOCK TIMER_2_Block

	VAR_INPUT
		DT_IN :	UDINT;
		START :	UDINT;
		DURATION :	TIME;
		MODE :	BYTE;
		HOLIDAY :	BOOL;
	END_VAR


	VAR_OUTPUT
		Q :	BOOL;
	END_VAR


	VAR
		last_check :	TIME := T#0s;
		dat :	UDINT;
		daytime :	UDINT;
		activation :	TIME;
		tx :	TIME;
		enabled :	BOOL;
		wday :	INT;
		init :	BOOL;
	END_VAR


	VAR RETAIN 
		run_date :	UDINT;
	END_VAR


	VAR
		T_PLC_MS :	T_PLC_MS_Block;
	END_VAR

	T_PLC_MS();
	tx:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

	IF NOT init THEN
		init := TRUE;
		last_check := tx - t#100ms;
	END_IF;

	IF tx - last_check < T#100ms THEN RETURN; END_IF;

	dat := _DT_TO_DATE_B(dt_in);
	daytime := DT_TO_TOD2(dt_in);
	wday := DAY_OF_WEEK(dat);

	CASE _BYTE_TO_INT(mode) OF
	1..7:	
		enabled := wday = _BYTE_TO_INT(mode);
	11:	
		enabled := TRUE;
	12..16:	
		enabled := (dat / UDINT#86400) MOD (BYTE_TO_UDINT(mode) - UDINT#10) = UDINT#0;
	20:	
		enabled := wday <= 5;
	21:	
		enabled := wday > 5;
	22: 
		enabled := wday <= 5 AND NOT holiday;
	23:	
		enabled := wday > 5 OR holiday;
	24:	
		enabled := holiday;
	25:	
		enabled := DAY_OF_MONTH(dat) = 1;
	26:	
		enabled := day_of_month(dat + TIME_TO_UDINT2(t#1d)) = 1;
	27:	
		enabled := DAY_OF_MONTH(dat) = 31 AND MONTH_OF_DATE_UDINT(dat) = 12;
	28:	
		enabled := DAY_OF_YEAR_UDINT(dat) = 1;
	ELSE
		enabled := FALSE;
	END_CASE;

	IF enabled AND NOT Q AND daytime >= start AND run_date <> dat THEN
		Q := TRUE;
		activation := tx;
		run_date := dat;
	ELSIF Q AND tx - activation >= duration THEN
		Q := FALSE;
	END_IF;
	last_check := Tx;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		DT_IN :	UDINT;
		START :	UDINT;
		DURATION :	TIME;
		MODE :	BYTE;
		HOLIDAY :	BOOL;
		Q :	BOOL;

		func_block : TIMER_2_Block;
	END_VAR
	func_block.DT_IN := DT_IN;
	func_block.START := START;
	func_block.DURATION := DURATION ;
	func_block.MODE    := MODE    ;
	func_block.HOLIDAY := HOLIDAY;

	func_block();
	Q  := func_block.Q;
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