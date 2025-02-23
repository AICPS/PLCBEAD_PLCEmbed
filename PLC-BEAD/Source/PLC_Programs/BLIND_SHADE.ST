TYPE
  oscat_STRING5               : STRING;
  oscat_STRING30              : STRING;
END_TYPE

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
		NAME : oscat_string5;		(* name of time zone *)
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
		HOLY_NAME : oscat_string30;	(* name of holiday *)
		WORK_WEEK : INT;			(* current work week *)
	END_STRUCT;
END_TYPE

FUNCTION DT_TO_TOD2:UDINT
	VAR_INPUT
		IN :	UDINT;
	END_VAR

	DT_TO_TOD2 := (IN MOD UDINT#86400) * UDINT#1000;
END_FUNCTION

FUNCTION TIME_TO_UDINT2:UDINT
	VAR_INPUT
		X :	TIME;
	END_VAR

	TIME_TO_UDINT2 := DINT_TO_UDINT(TIME_TO_DINT(X));
END_FUNCTION

FUNCTION DEG : REAL
	VAR_INPUT
		RAD_IN : REAL;
	END_VAR

	DEG := MODR(57.29577951308232 * RAD_IN, 360.0);
END_FUNCTION

FUNCTION MODR : REAL
	VAR_INPUT
		IN : REAL;
		DIVI : REAL;
	END_VAR

	IF divi = 0.0 THEN
		MODR := 0.0;
	ELSE
		MODR := in - DINT_TO_REAL(FLOOR2(in / divi)) * divi;
	END_IF;
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

FUNCTION RAD:REAL

	VAR_INPUT
		DEG1 :	REAL;
	END_VAR

	RAD := MODR(0.0174532925199433 * DEG1 , 6.283185307179586476);

END_FUNCTION

FUNCTION TRUNC_UDINT2:UDINT
	VAR_INPUT
		IN :	REAL;
	END_VAR
	TRUNC_UDINT2 := DINT_TO_UDINT(TRUNC_DINT(IN));
END_FUNCTION

FUNCTION_BLOCK BLIND_SHADE_Block

	VAR_INPUT
		UP :	BOOL;
		DN :	BOOL;
		S_IN :	BYTE;
		PI :	BYTE;
		AI :	BYTE;
		ENABLE :	BOOL;
		SUN :	BOOL;
		SUNRISE_OFFSET :	TIME := T#1h;
		SUNSET_PRESET :	TIME := T#1h;
		DIRECTION :	REAL := 180.0;
		ANGLE_OFFSET :	REAL := 80.0;
		SLAT_WIDTH :	REAL := 80.0;
		SLAT_SPACING :	REAL := 60.0;
		SHADE_DELAY :	TIME := T#60s;
		SHADE_POS :	BYTE;
	END_VAR


	VAR_OUTPUT
		QU :	BOOL;
		QD :	BOOL;
		STATUS :	BYTE;
		PO :	BYTE;
		AO :	BYTE;
	END_VAR


	VAR_IN_OUT
		CX :	oscat_CALENDAR;
	END_VAR


	VAR
		angle :	REAL;
		sun_delay :	TOF;
	END_VAR

	sun_delay(IN := sun, PT := shade_delay);

	IF UP AND DN AND enable AND sun_delay.Q AND cx.SUN_HOR > direction - angle_offset AND cx.SUN_HOR < direction + angle_offset AND
		DT_TO_TOD2(cx.UTC) > cx.SUN_RISE + TIME_TO_UDINT2(sunrise_offset) AND DT_TO_TOD2(cx.UTC) < cx.SUN_SET - TIME_TO_UDINT2(sunset_preset) THEN
		status := BYTE#151;
		QU := UP;
		QD := DN;
		po := shade_pos;
		angle := DEG(ATAN(slat_spacing / slat_width));
		IF cx.SUN_VER > 0.0 AND cx.SUN_VER < angle THEN
			angle := cx.SUN_VER + DEG(ACOS(COS(RAD(cx.SUN_VER))*slat_spacing / Slat_width));
			ao := INT_TO_BYTE(LIMIT(0,UDINT_TO_INT(TRUNC_UDINT2(angle * 2.833333333)), 255));
		ELSE
			ao := BYTE#255;
		END_IF;
	ELSE
		QU := UP;
		QD := DN;
		po := pi;
		ao := ai;
		status := S_IN;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		UP :	BOOL;
		DN :	BOOL;
		S_IN :	BYTE;
		PI :	BYTE;
		AI :	BYTE;
		ENABLE :	BOOL;
		SUN :	BOOL;
		SUNRISE_OFFSET :	TIME := T#1h;
		SUNSET_PRESET :	TIME := T#1h;
		DIRECTION :	REAL := 180.0;
		ANGLE_OFFSET :	REAL := 80.0;
		SLAT_WIDTH :	REAL := 80.0;
		SLAT_SPACING :	REAL := 60.0;
		SHADE_DELAY :	TIME := T#60s;
		SHADE_POS :	BYTE;
		CX :	oscat_CALENDAR;

		func_block : BLIND_SHADE_Block;
	END_VAR
	func_block.UP := UP;
	func_block.DN := DN;
	func_block.S_IN := S_IN ;
	func_block.PI    := PI    ;
	func_block.AI    := AI    ;
	func_block.ENABLE := ENABLE;
	func_block.SUN := SUN;
	func_block.SUNRISE_OFFSET := SUNRISE_OFFSET;
	func_block.SUNSET_PRESET := SUNSET_PRESET ;
	func_block.DIRECTION := DIRECTION ;
	func_block.ANGLE_OFFSET    := ANGLE_OFFSET    ;
	func_block.SLAT_WIDTH := SLAT_WIDTH;
	func_block.SLAT_SPACING := SLAT_SPACING;
	func_block.SHADE_DELAY := SHADE_DELAY ;
	func_block.CX := CX ;

	func_block();
	CX  := func_block.CX;
END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION