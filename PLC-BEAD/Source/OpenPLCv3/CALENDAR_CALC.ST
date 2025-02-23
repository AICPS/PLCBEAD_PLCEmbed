TYPE oscat_CALENDAR :
	STRUCT
		UTC : UDINT;				(* world time UTC *)
		LDT : UDINT;				(* local time *)
		LDATE : UDINT;				(* local date *)
		LTOD : UDINT;				(* local time of day *)
		YEAR : INT;					(* year of LDATE *)
		MONTH : INT;				(* month of LDATE *)
		DAY : INT;					(* day of LDATE *)
		WEEKDAY : INT;				(* weekday of LDATE *)
		OFFSET : INT;				(* Time Zone Offset for Local time in minutes *)
		DST_EN : BOOL;				(* daylight savings time enable *)
		DST_ON : BOOL;				(* true when daylight savings time os on *)
		NAME : STRING;		(* name of time zone *)
		LANGUAGE : INT;			    (* language number pls see language setup *)
		LONGITUDE : REAL;			(* longitude of current location *)
		LATITUDE : REAL;			(* latitude of current location *)
		SUN_RISE : UDINT;			(* sun_rise for current location *)
		SUN_SET : UDINT;			(* sun_set for current location *)
		SUN_MIDDAY : UDINT;			(* worldtime when sun stands at south position *)
		SUN_HEIGTH : REAL;			(* suns heigth at midday, south position *)
		SUN_HOR : REAL;				(* sun angle horizontal 0 = north in degrees *)
		SUN_VER : REAL;				(* sun angle vertical above horizon in degrees *)
		NIGHT : BOOL;				(* true between sun_set and sun_rise *)
		HOLIDAY : BOOL;				(* true when holiday *)
		HOLY_NAME : STRING;	(* name of holiday *)
		WORK_WEEK : INT;			(* current work week *)
	END_STRUCT;
END_TYPE

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

FUNCTION _REAL_TO_UDINT:UDINT
	
	VAR_INPUT
		X :	REAL;
	END_VAR

	IF REAL_TO_UDINT(0.5) = UDINT#1 THEN
		_REAL_TO_UDINT := REAL_TO_UDINT(x);
	ELSIF X > 0.0 THEN
		_REAL_TO_UDINT := REAL_TO_UDINT(x+0.5); 
	ELSIF X < 0.0 THEN 
		_REAL_TO_UDINT := REAL_TO_UDINT(x-0.5); 
	ELSE 
		_REAL_TO_UDINT := UDINT#0;
  	END_IF;
END_FUNCTION

FUNCTION HOUR_TO_TIME:TIME

	VAR_INPUT
		IN :	REAL;
	END_VAR

	hour_to_time := UDINT_TO_TIME(_REAL_TO_UDINT(IN * 3600000.0));
END_FUNCTION

FUNCTION TIME_TO_UDINT2:UDINT
	VAR_INPUT
		X :	TIME;
	END_VAR

	TIME_TO_UDINT2 := DINT_TO_UDINT(TIME_TO_DINT(X));
END_FUNCTION

FUNCTION FLOOR2 : DINT
	VAR_INPUT
		x : REAL;
	END_VAR

	FLOOR2 := REAL_TO_DINT(X);
	IF DINT_TO_REAL(FLOOR2) > X THEN
		FLOOR2 := FLOOR2 - DINT#1;
	END_IF;
	
END_FUNCTION

FUNCTION MODR:REAL

	VAR_INPUT
		IN :	REAL;
		DIVI :	REAL;
	END_VAR


	IF divi = 0.0 THEN
		MODR := 0.0;
	ELSE
		MODR := in - DINT_TO_REAL(FLOOR2(in / divi)) * divi;
	END_IF;

END_FUNCTION

FUNCTION RAD:REAL

	VAR_INPUT
		DEGG :	REAL;
	END_VAR

	RAD := MODR(0.0174532925199433 * DEGG , 6.283185307179586476);

END_FUNCTION

FUNCTION REFRACTION:REAL

	VAR_INPUT
		ELEV :	REAL;
	END_VAR

	VAR
		tmp :	REAL;
	END_VAR


	tmp := LIMIT(-1.9, elev, 80.0);
	REFRACTION := 0.0174532925199433 / TAN(0.0174532925199433 * (tmp + 10.3 / (tmp + 5.11)));

END_FUNCTION

FUNCTION TOD_TO_REAL2:REAL
	VAR_INPUT
		IN :	UDINT;
	END_VAR
	TOD_TO_REAL2 := UDINT_TO_REAL(IN);
END_FUNCTION

FUNCTION DEG:REAL

	VAR_INPUT
		X :	REAL;
	END_VAR

	DEG := MODR(57.29577951308232 * X, 360.0);
END_FUNCTION

FUNCTION DT_TO_TOD2:UDINT
	VAR_INPUT
		IN :	UDINT;
	END_VAR

	DT_TO_TOD2 := (IN MOD UDINT#86400) * UDINT#1000;
END_FUNCTION

FUNCTION_BLOCK SUN_POS

	VAR_INPUT
		LATITUDE :	REAL;
		LONGITUDE :	REAL;
		UTC :	UDINT;
	END_VAR

	VAR_OUTPUT
		B :	REAL;
		HR :	REAL;
	END_VAR

	VAR
		g :	REAL;
		a :	REAL;
		d :	REAL;
		h :	REAL;
		t1 :	REAL;
		n :	REAL;
		e :	REAL;
		c :	REAL;
		tau :	REAL;
		sin_d :	REAL;
		rlat :	REAL;
		sin_lat :	REAL;
		cos_lat :	REAL;
		cos_tau :	REAL;
		cos_d :	REAL;
		MATH_PI :	REAL := 3.14159265358979323846264338327950288;
		MATH_PI2 :	REAL := 6.28318530717958647692528676655900576;
	END_VAR


	n := UDINT_TO_REAL(UTC - UDINT#946728000) * 0.000011574074074074;
	g :=MODR(6.240040768 + 0.01720197 * n, MATH_PI2);
	d := MODR(4.89495042 + 0.017202792 * n, MATH_PI2) + 0.033423055 * SIN(g) + 0.000349066 * SIN(2.0*g);
	e := 0.409087723 - 0.000000006981317008 * n;
	cos_d := COS(d);
	sin_d := SIN(d);
	a := ATAN(COS(e) * sin_d / cos_d);
	IF cos_d < 0.0 THEN a := a + MATH_PI; END_IF;
	c := ASIN(SIN(e) * sin_d);

	(* also here we must be very careful utc is from 1.1.1970 for step7 the formula must change *)
	tau := RAD(MODR(6.697376 + (n - 0.25) * 0.0657098245037645 + TOD_TO_REAL2(DT_TO_TOD2(utc)) * 0.0000002785383333, 24.0) * 15.0 + longitude) - a;
	rlat := RAD(latitude);
	sin_lat := SIN(rlat);
	cos_lat := COS(rlat);
	cos_tau := COS(tau);
	t1 := cos_tau * sin_lat - TAN(c) * cos_lat;
	B := ATAN(SIN(tau) / t1);
	IF t1 < 0.0 THEN B := B + MATH_PI2; ELSE B := B + MATH_PI; END_IF;
	B := DEG(MODR(B, MATH_PI2));
	h := DEG(ASIN(COS(C) * cos_tau * cos_lat +SIN(c) * sin_lat));
	IF h > 180.0 THEN h := h - 360.0; END_IF;
	(* consider refraction *)
	HR := h + REFRACTION(h);
END_FUNCTION_BLOCK

FUNCTION HOUR_TO_TOD:UDINT
	VAR_INPUT
		IN :	REAL;
	END_VAR

	hour_to_tod := _REAL_TO_UDINT(IN * 3600000.00);
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

FUNCTION SUN_MIDDAY:UDINT
	VAR_INPUT
		LON :	REAL;
		UTC :	DATE;
	END_VAR

	VAR
		T :	REAL;
		OFFSET :	REAL;
	END_VAR

	T := INT_TO_REAL(DAY_OF_YEAR(utc));
	OFFSET := -0.1752 * SIN(0.033430 * T + 0.5474) - 0.1340 * SIN(0.018234 * T - 0.1939);
	SUN_MIDDAY := HOUR_TO_TOD(12.0 - OFFSET - lon * 0.0666666666666);
END_FUNCTION

FUNCTION SUN_MIDDAY_UDINT:UDINT
	VAR_INPUT
		LON :	REAL;
		UTC :	UDINT;
	END_VAR

	VAR
		T :	REAL;
		OFFSET :	REAL;
	END_VAR

	T := INT_TO_REAL(DAY_OF_YEAR_UDINT(utc));
	OFFSET := -0.1752 * SIN(0.033430 * T + 0.5474) - 0.1340 * SIN(0.018234 * T - 0.1939);
	SUN_MIDDAY_UDINT := HOUR_TO_TOD(12.0 - OFFSET - lon * 0.0666666666666);
END_FUNCTION


FUNCTION_BLOCK SUN_TIME_Block

	VAR_INPUT
		LATITUDE :	REAL;
		LONGITUDE :	REAL;
		UTC :	UDINT;
		H :	REAL := -0.83333333333;
	END_VAR

	VAR_OUTPUT
		MIDDAY :	UDINT;
		SUN_RISE :	UDINT;
		SUN_SET :	UDINT;
		SUN_DECLINATION :	REAL;
	END_VAR

	VAR
		DK :	REAL;
		delta :	UDINT;
		B :	REAL;
	END_VAR

	B := latitude * 0.0174532925199433;
	MIDDAY := SUN_MIDDAY_UDINT(longitude, utc);
	DK := 0.40954 * SIN(0.0172 * (INT_TO_REAL(DAY_OF_YEAR_UDINT(utc)) - 79.35));
	sun_declination := DEG(DK);
	IF sun_declination > 180.0 THEN sun_declination := sun_declination - 360.0; END_IF;
	sun_declination := 90.0 - LATITUDE + sun_declination;
	delta := TIME_TO_UDINT2(HOUR_TO_TIME(ACOS((SIN(RAD(H)) - SIN(B) * SIN(DK)) / (COS(B) * COS(DK))) * 3.819718632));
	sun_rise := MIDDAY - delta;
	sun_set := MIDDAY + delta;
END_FUNCTION_BLOCK

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


FUNCTION MONTH_OF_DATE:INT

	VAR_INPUT
		IDATE :	UDINT;
	END_VAR

	MONTH_OF_DATE := DAY_OF_YEAR_UDINT(idate);
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

	day_of_month := DAY_OF_YEAR_UDINT(idate);

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

FUNCTION DT_TO_DATE2:UDINT
	VAR_INPUT
		IN :	UDINT;
	END_VAR

	DT_TO_DATE2 := (IN / UDINT#86400) * UDINT#86400;
END_FUNCTION

FUNCTION DAY_OF_DATE:DINT
	VAR_INPUT
		IDATE :	UDINT;
	END_VAR

	day_of_date := UDINT_TO_DINT(idate / UDINT#86400);
END_FUNCTION

FUNCTION LEAP_YEAR:BOOL

  VAR_INPUT
    YEAR :	INT;
  END_VAR


  IF (year MOD INT#400) = INT#00 THEN
    leap_year := TRUE;
  ELSIF (year MOD INT#100) = INT#00 THEN
    leap_year := FALSE;
  ELSIF (year MOD INT#04) = INT#00 THEN
    leap_year := TRUE;
  ELSE
    leap_year := FALSE;
  END_IF;

END_FUNCTION

FUNCTION HOUR:INT
	VAR_INPUT
		ITOD :	UDINT;
	END_VAR
	hour := UDINT_TO_INT(itod / UDINT#3600000);
END_FUNCTION

FUNCTION SET_DT:UDINT

	VAR_INPUT
		YEAR : INT;
		MONTH :	INT;
		DAY : INT;
		HOURR : INT;
		MINUTE : INT;
		SECOND : INT;
	END_VAR

	SET_DT := SET_DATE(YEAR, MONTH, DAY) + _INT_TO_UDINT(SECOND) + _INT_TO_UDINT(MINUTE) * UDINT#60 + _INT_TO_UDINT(HOURR) * UDINT#3600;

END_FUNCTION


FUNCTION DST:BOOL
	VAR_INPUT
		UTC :	UDINT;
	END_VAR

	VAR
		yr :	INT;
		yr4 :	UDINT;
		ltc :	UDINT;
		idate :	UDINT;
	END_VAR

	yr := YEAR_OF_DATE(DT_TO_DATE2(UTC));
	ltc := UTC;
	idate := SET_DT(yr, 3, 31, 1, 0, 0);
	yr4 := DWORD_TO_UDINT(SHR(INT_TO_DWORD(5 * yr), 2)) + UDINT#1;
	DST := (idate - ((yr4 + UDINT#3) MOD UDINT#7) * UDINT#86400 <= ltc) AND (idate + (UDINT#214 - (yr4) MOD UDINT#7) * UDINT#86400 > ltc);

END_FUNCTION


FUNCTION UTC_TO_LTIME:UDINT

	VAR_INPUT
		UTC :	UDINT;
		DST_ENABLE :	BOOL;
		TIME_ZONE_OFFSET :	INT;
	END_VAR

	VAR
		tmp :	INT;
	END_VAR

	UTC_TO_LTIME := UTC + _INT_TO_UDINT(TIME_ZONE_OFFSET) * UDINT#60 + BOOL_TO_UDINT(DST_ENABLE AND DST(UTC)) * UDINT#3600;

	tmp := TIME_ZONE_OFFSET * 60 + BOOL_TO_INT(DST_ENABLE AND DST(UTC)) * 3600;
	IF tmp < 0 THEN
		UTC_TO_LTIME := UTC - _INT_TO_UDINT(ABS(tmp));
	ELSE
		UTC_TO_LTIME := UTC + _INT_TO_UDINT(tmp);
	END_IF;

END_FUNCTION

FUNCTION YEAR_BEGIN:UDINT
	VAR_INPUT
		Y :	INT;
	END_VAR
	year_begin := DWORD_TO_UDINT(SHR(UDINT_TO_DWORD(_INT_TO_UDINT(y) * UDINT#1461 - UDINT#2878169),2))*UDINT#86400;

END_FUNCTION

FUNCTION WORK_WEEK:INT

	VAR_INPUT
		IDATE :	UDINT;
	END_VAR

	VAR
		d1 :	UDINT;
		w1 :	INT;
		ds :	UDINT;
		yr :	INT;
		w31 :	INT;
		w01 :	INT;
		wm :	INT;
	END_VAR

	yr := YEAR_OF_DATE(idate);
	d1 := year_begin(yr);
	w1 := DAY_OF_WEEK(d1);
	IF w1 < 5 THEN
		ds := d1 - _INT_TO_UDINT(w1+6) * UDINT#86400;
	ELSE
		ds := d1 + _INT_TO_UDINT(1-w1) * UDINT#86400;
	END_IF;

	work_week := UDINT_TO_INT((idate - ds) / UDINT#604800);

	IF work_week = 0 THEN
		IF w1 > 1 THEN w31 := w1 - 1; ELSE W31 := 7; END_IF;
		IF leap_year(yr - 1) THEN IF w31 > 1 THEN w01 := W31 - 1; ELSE w1 := 7; END_IF; END_IF;
		WORK_WEEK := 52 + BOOL_TO_INT(w31 = 4 OR w01 = 4);
	ELSE
		IF leap_year(yr) THEN
			IF w1 < 7 THEN w31 := w1 + 1; ELSE w31 := 1; END_IF;
		ELSE
			w31 := w1;
		END_IF;
		wm := 52 + BOOL_TO_INT(w31 = 4 OR w1 = 4);
		IF work_week > wm THEN work_week := 1; END_IF;
	END_IF;

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

FUNCTION_BLOCK CALENDAR_CALC
	VAR_INPUT
		SPE :	BOOL;
		H :	REAL := REAL#-0.83333333333;
	END_VAR

	VAR_IN_OUT
		XCAL :	oscat_CALENDAR;
		HOLIDAYS :	oscat_HOLIDAY_DATA_0_29;
	END_VAR

	VAR
		last :	UDINT;
		last_day :	DINT;
		holy :	HOLIDAY_Block;
		sun :	SUN_TIME_Block;
		last_hour :	INT;
		utod :	UDINT;
		pos :	SUN_POS;
		plast :	UDINT;
		dtemp :	DINT;
		tmp :	INT;
		SETUP_LOCATIONS :	SETUP_LOCATION;
		LOCATION :	oscat_LOCATION;
	END_VAR

	IF xcal.UTC <> last THEN
		last := XCAL.UTC;
		utod := DT_TO_TOD2(xcal.UTC);

		XCAL.LDT := UTC_TO_LTIME(XCAL.UTC, XCAL.DST_EN, XCAL.OFFSET);
		XCAL.LDATE := DT_TO_DATE2(XCAL.LDT);
		XCAL.LTOD := DT_TO_TOD2(XCAL.LDT);
		dtemp := DAY_OF_DATE(XCAL.LDATE);
		xcal.night := XCAL.LTOD < XCAL.SUN_RISE OR XCAL.LTOD > XCAL.SUN_SET;

		tmp := HOUR(xcal.LTOD);
		IF  tmp <> last_hour THEN
			XCAL.DST_ON := DST(XCAL.UTC) AND xcal.DST_EN;
			last_hour := tmp;
		END_IF;

		IF dtemp <> last_day THEN
			SETUP_LOCATIONS(LOCATION:=LOCATION);
			LOCATION:=SETUP_LOCATIONS.LOCATION;

			last_day := dtemp;
			XCAL.YEAR := YEAR_OF_DATE(XCAL.LDATE);
			XCAL.MONTH := MONTH_OF_DATE(XCAL.LDATE);
			XCAL.DAY := DAY_OF_MONTH(XCAL.LDATE);
			XCAL.WEEKDAY := DAY_OF_WEEK(XCAL.LDATE);
			HOLY(date_in := XCAL.LDATE, LANGU := xcal.LANGUAGE, HOLIDAYS := HOLIDAYS);
			HOLIDAYS := HOLY.HOLIDAYS;
			XCAL.HOLIDAY := HOLY.Y;
			XCAL.HOLY_NAME := HOLY.NAME;
			sun(latitude := XCAL.LATITUDE, longitude := xcal.LONGITUDE, utc := DT_TO_DATE2(xcal.UTC), H := H);
			XCAL.SUN_RISE := DINT_TO_UDINT(UDINT_TO_DINT(sun.sun_rise) + INT_TO_DINT(XCAL.OFFSET) * DINT#60000 + SEL_DINT(XCAL.DST_ON,DINT#0,DINT#3600000));
			XCAL.SUN_SET := DINT_TO_UDINT(UDINT_TO_DINT(sun.sun_set) + INT_TO_DINT(XCAL.OFFSET) * DINT#60000 + SEL_DINT(XCAL.DST_ON,DINT#0,DINT#3600000));
			XCAL.SUN_MIDDAY := DINT_TO_UDINT(UDINT_TO_DINT(sun.midday) + INT_TO_DINT(XCAL.OFFSET) * DINT#60000 + SEL_DINT(XCAL.DST_ON,DINT#0,DINT#3600000));
			XCAL.SUN_HEIGTH := sun.sun_declination;
			XCAL.WORK_WEEK := WORK_WEEK(XCAL.LDATE);
		END_IF;

		IF SPE AND xcal.UTC -  plast >= TIME_TO_UDINT2(t#25s) THEN
			plast := last;
			pos(latitude := xcal.LATITUDE, longitude := xcal.LONGITUDE, utc := xcal.UTC);
			xcal.SUN_HOR := pos.B;
			xcal.SUN_VER := pos.HR;
		END_IF;
	END_IF;
END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : BOOL;
    LocalVar1 : REAL;
	LocalVar2 : oscat_CALENDAR;
	LocalVar3 : oscat_HOLIDAY_DATA_0_29;
	func_block : CALENDAR_CALC;
  END_VAR
	func_block.SPE  := LocalVar0;
	func_block.H := LocalVar1;
	func_block.XCAL  := LocalVar2;
	func_block.HOLIDAYS := LocalVar3;
	func_block();
	LocalVar2 := func_block.XCAL;
	LocalVar3 := func_block.HOLIDAYS;

END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION