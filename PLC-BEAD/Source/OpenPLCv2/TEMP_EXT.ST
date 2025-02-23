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

FUNCTION MID3:REAL

	VAR_INPUT
		IN1 :	REAL;
		IN2 :	REAL;
		IN3 :	REAL;
	END_VAR

	VAR
		_IN1 :	REAL;
		_IN2 :	REAL;
		_IN3 :	REAL;
	END_VAR

	_IN1 := IN1;
	_IN2 := IN2;
	_IN3 := IN3;

	IF _IN1 > _IN2 THEN MID3 := _IN1; _IN1 := _IN2; _IN2 := MID3; END_IF;
	IF _IN2 > _IN3 THEN _IN2 := _IN3; END_IF;
	MID3 := SEL(_IN1 > _IN2, _IN2, _IN1);

END_FUNCTION

FUNCTION _BYTE_TO_INT:INT
	VAR_INPUT
		IN :	BYTE;
	END_VAR

	_BYTE_TO_INT := USINT_TO_INT(BYTE_TO_USINT(IN));
END_FUNCTION

FUNCTION MULTI_IN:REAL

	VAR_INPUT
		IN_1 :	REAL;
		IN_2 :	REAL;
		IN_3 :	REAL;
		DEFAULT :	REAL;
		IN_MIN :	REAL;
		IN_MAX :	REAL;
		MODE :	BYTE;
	END_VAR

	VAR
		count :	INT;
		F1 :	BOOL;
		F2 :	BOOL;
		F3 :	BOOL;
	END_VAR

	F1 :=  in_1 > in_min AND in_1 < in_max;
	F2 :=  in_2 > in_min AND in_2 < in_max;
	F3 :=  in_3 > in_min AND in_3 < in_max;

	CASE _BYTE_TO_INT(mode) OF
	0:	count := 0;
		IF F1 THEN
			count := count + 1;
			MULTI_IN := in_1;
		ELSE
			MULTI_IN := 0.0;
		END_IF;
		IF F2 THEN
			count := count + 1;
			MULTI_IN := MULTI_IN + in_2;
		END_IF;
		IF F3 THEN
			count := count + 1;
			MULTI_IN := MULTI_IN + in_3;
		END_IF;
		MULTI_IN := SEL_REAL(count = 0, MULTI_IN / INT_TO_REAL(count), default);

	1:	MULTI_IN := SEL_REAL(F1, default, IN_1);

	2:	MULTI_IN := SEL_REAL(F2, default, IN_2);

	3:	MULTI_IN := SEL_REAL(F3, default, IN_3);

	4:	MULTI_IN := default;

	5:	MULTI_IN := SEL_REAL(F1, in_max, IN_1);
		IF F2 AND in_2 < MULTI_IN THEN MULTI_IN := in_2; END_IF;
		IF F3 AND in_3 < MULTI_IN THEN MULTI_IN := in_3; END_IF;
		IF MULTI_IN = in_max THEN MULTI_IN := default; END_IF;

	6:	MULTI_IN := SEL_REAL(F1, in_min, IN_1);
		IF F2 AND in_2 > MULTI_IN THEN MULTI_IN := in_2; END_IF;
		IF F3 AND in_3 > MULTI_IN THEN MULTI_IN := in_3; END_IF;
		IF MULTI_IN = in_min THEN MULTI_IN := default; END_IF;

	7:	IF F1 AND F2 AND F3 THEN MULTI_IN := MID3(in_1, in_2, in_3);
		ELSIF F1 AND F2 THEN MULTI_IN := MIN(in_1, in_2);
		ELSIF F1 AND F3 THEN MULTI_IN := MIN(in_1, in_3);
		ELSIF F2 AND F3 THEN MULTI_IN := MIN(in_2, in_3);
		ELSIF F1 THEN MULTI_IN := in_1;
		ELSIF F2 THEN MULTI_IN := in_2;
		ELSIF F3 THEN MULTI_IN := in_3;
		ELSE MULTI_IN := default;
		END_IF;

	END_CASE;

END_FUNCTION

FUNCTION _DT_TO_DATE_B:UDINT

	VAR_INPUT
		_INN :	UDINT;
	END_VAR

	_DT_TO_DATE_B := (_INN / UDINT#86400) * UDINT#86400;
END_FUNCTION

FUNCTION DT_TO_TOD2:UDINT
	VAR_INPUT
		IN :	UDINT;
	END_VAR

	DT_TO_TOD2 := (IN MOD UDINT#86400) * UDINT#1000;
END_FUNCTION

FUNCTION_BLOCK TEMP_EXT_Block

	VAR_INPUT
		T_EXT1 :	REAL;
		T_EXT2 :	REAL;
		T_EXT3 :	REAL;
		T_EXT_CONFIG :	BYTE := 0;
		DT_IN :	UDINT;
		T_EXT_MIN :	REAL := REAL#-40.0;
		T_EXT_MAX :	REAL := REAL#60.0;
		T_EXT_DEFAULT :	REAL := REAL#-10.0;
		HEAT_PERIOD_START :	UDINT := UDINT#20995200;
		HEAT_PERIOD_STOP :	UDINT := UDINT#10281600;
		COOL_PERIOD_START :	UDINT := UDINT#07776000;
		COOL_PERIOD_STOP :	UDINT := UDINT#23500800;
		HEAT_START_TEMP_DAY :	REAL := REAL#15.0;
		HEAT_START_TEMP_NIGHT :	REAL := REAL#10.0;
		HEAT_STOP_TEMP :	REAL := REAL#18.0;
		COOL_START_TEMP_DAY :	REAL := REAL#26.0;
		COOL_START_TEMP_NIGHT :	REAL := REAL#26.0;
		COOL_STOP_TEMP :	REAL := REAL#24.0;
		START_DAY :	UDINT := UDINT#32400000;
		START_NIGHT :	UDINT := UDINT#75600000;
		CYCLE_TIME :	TIME := t#10m;
	END_VAR


	VAR_OUTPUT
		T_EXT :	REAL;
		HEAT :	BOOL;
		COOL :	BOOL;
	END_VAR


	VAR
		tx :	TIME;
		last_run :	TIME;
		init :	BOOL;
		cool_start :	UDINT;
		cool_stop :	UDINT;
		heat_start :	UDINT;
		heat_stop :	UDINT;
		xdate :	UDINT;
		day :	BOOL;
		T_PLC_MS :	T_PLC_MS_Block;
	END_VAR

	IF NOT init THEN
		init := TRUE;
		heat_start := SET_DATE(1972,MONTH_OF_DATE_UDINT(heat_period_start),DAY_OF_MONTH(heat_period_start));
		heat_stop := SET_DATE(1972,MONTH_OF_DATE_UDINT(heat_period_stop),DAY_OF_MONTH(heat_period_stop));
		cool_start := SET_DATE(1972,MONTH_OF_DATE_UDINT(cool_period_start),DAY_OF_MONTH(cool_period_start));
		cool_stop := SET_DATE(1972,MONTH_OF_DATE_UDINT(cool_period_stop),DAY_OF_MONTH(cool_period_stop));
	END_IF;

	T_PLC_MS();
	tx:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

	IF tx - last_run < cycle_time THEN RETURN; END_IF;

	xdate := SET_DATE(1972,MONTH_OF_DATE_UDINT(_DT_TO_DATE_B(dt_in)),DAY_OF_MONTH(_DT_TO_DATE_B(dt_in)));
	day := DT_TO_TOD2(dt_in) >= start_day AND  DT_TO_TOD2(dt_in) < start_night;

	t_ext := MULTI_IN(t_ext1, t_ext2, t_ext3, t_ext_default, t_ext_min, t_ext_max, t_ext_config);

	IF (heat_start <= heat_stop AND xdate >= heat_start AND xdate <= heat_stop) OR (heat_start > heat_stop AND (xdate >= heat_start OR xdate <= heat_stop)) THEN
		IF day AND t_ext <= heat_start_temp_day THEN
			heat := TRUE;
		ELSIF NOT day AND t_ext <= heat_start_temp_night THEN
			heat := TRUE;
		ELSIF t_ext >= heat_stop_temp THEN
			heat := FALSE;
		END_IF;
	ELSE
		heat := FALSE;
	END_IF;

	IF (cool_start <= cool_stop AND xdate >= cool_start AND xdate <= cool_stop) OR (cool_start > cool_stop AND (xdate >= cool_start OR xdate <= cool_stop)) THEN
		IF day AND t_ext >= cool_start_temp_day THEN
			cool := TRUE;
		ELSIF NOT day AND t_ext >= cool_start_temp_night THEN
			cool := TRUE;
		ELSIF t_ext <= cool_stop_temp THEN
			cool := FALSE;
		END_IF;
	ELSE
		cool := FALSE;
	END_IF;

	last_run := tx;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		T_EXT1 :	REAL;
		T_EXT2 :	REAL;
		T_EXT3 :	REAL;
		T_EXT_CONFIG :	BYTE := 0;
		DT_IN :	UDINT;
		T_EXT_MIN :	REAL := REAL#-40.0;
		T_EXT_MAX :	REAL := REAL#60.0;
		T_EXT_DEFAULT :	REAL := REAL#-10.0;
		HEAT_PERIOD_START :	UDINT := UDINT#20995200;
		HEAT_PERIOD_STOP :	UDINT := UDINT#10281600;
		COOL_PERIOD_START :	UDINT := UDINT#07776000;
		COOL_PERIOD_STOP :	UDINT := UDINT#23500800;
		HEAT_START_TEMP_DAY :	REAL := REAL#15.0;
		HEAT_START_TEMP_NIGHT :	REAL := REAL#10.0;
		HEAT_STOP_TEMP :	REAL := REAL#18.0;
		COOL_START_TEMP_DAY :	REAL := REAL#26.0;
		COOL_START_TEMP_NIGHT :	REAL := REAL#26.0;
		COOL_STOP_TEMP :	REAL := REAL#24.0;
		START_DAY :	UDINT := UDINT#32400000;
		START_NIGHT :	UDINT := UDINT#75600000;
		CYCLE_TIME :	TIME := t#10m;
		T_EXT :	REAL;
		HEAT :	BOOL;
		COOL :	BOOL;

		func_block : TEMP_EXT_Block;
	END_VAR

	func_block.T_EXT1 := T_EXT1;
	func_block.T_EXT2 := T_EXT2;
	func_block.T_EXT3 := T_EXT3 ;
	func_block.T_EXT_CONFIG := T_EXT_CONFIG;
	func_block.DT_IN := DT_IN;
	func_block.T_EXT_MIN := T_EXT_MIN ;
	func_block.T_EXT_MAX := T_EXT_MAX;
	func_block.T_EXT_DEFAULT := T_EXT_DEFAULT;
	func_block.HEAT_PERIOD_START := HEAT_PERIOD_START ;
	func_block.HEAT_PERIOD_STOP := HEAT_PERIOD_STOP;
	func_block.COOL_PERIOD_START := COOL_PERIOD_START;
	func_block.COOL_PERIOD_STOP := COOL_PERIOD_STOP ;
	func_block.HEAT_START_TEMP_DAY := HEAT_START_TEMP_DAY;
	func_block.HEAT_START_TEMP_NIGHT := HEAT_START_TEMP_NIGHT;
	func_block.HEAT_STOP_TEMP := HEAT_STOP_TEMP ;
	func_block.COOL_START_TEMP_DAY := COOL_START_TEMP_DAY;
	func_block.COOL_START_TEMP_NIGHT := COOL_START_TEMP_NIGHT;
	func_block.COOL_STOP_TEMP:= COOL_STOP_TEMP ;
	func_block.START_DAY := START_DAY;
	func_block.START_NIGHT := START_NIGHT;
	func_block.CYCLE_TIME:= CYCLE_TIME ;

	func_block();
	T_EXT  := func_block.T_EXT;
	HEAT  := func_block.HEAT;
	COOL  := func_block.COOL;

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