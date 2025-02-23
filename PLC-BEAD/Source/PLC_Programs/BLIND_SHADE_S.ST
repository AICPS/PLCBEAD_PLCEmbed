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

FUNCTION_BLOCK BLIND_SHADE_S_Block

	VAR_INPUT
		UP :	BOOL;
		DN :	BOOL;
		S_IN :	BYTE;
		PI :	BYTE;
		ENABLE :	BOOL;
		SUN :	BOOL;
		HORZ1 :	REAL := 100.0;
		HORZ2 :	REAL := 260.0;
		VERT :	REAL := 90.0;
		ALERT :	BOOL;
		SUNRISE_OFFSET :	TIME := T#1h;
		SUNSET_PRESET :	TIME := T#1h;
		SHADE_DELAY :	TIME := T#60s;
		SHADE_POS :	BYTE;
		QU :	BOOL;
		QD :	BOOL;
		STATUS :	BYTE;
		PO :	BYTE;
	END_VAR


	VAR_IN_OUT
		CX :	oscat_CALENDAR;
	END_VAR

	
	VAR
		angle :	REAL;
		sun_delay :	TOF;
	END_VAR


	sun_delay(IN := sun, PT := shade_delay);

	IF ALERT THEN
	QU := TRUE;
	QD := FALSE;
	STATUS := BYTE#152;
	ELSIF UP AND DN AND ENABLE AND sun_delay.Q
	AND (CX.SUN_HOR > HORZ1) AND (CX.SUN_HOR < HORZ2)
	AND (CX.SUN_VER < VERT)
	AND (DT_TO_TOD2(CX.UTC) > CX.SUN_RISE + TIME_TO_UDINT2(sunrise_offset)) AND (DT_TO_TOD2(CX.UTC) < CX.SUN_SET - TIME_TO_UDINT2(sunset_preset)) THEN
	QU := UP;
	QD := DN;
	STATUS := BYTE#151;
	PO := MIN(PI, shade_pos);
	ELSE
	QU := UP;
	QD := DN;
	PO := PI;
	STATUS := S_IN;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		UP :	BOOL;
		DN :	BOOL;
		S_IN :	BYTE;
		PI :	BYTE;
		ENABLE :	BOOL;
		SUN :	BOOL;
		HORZ1 :	REAL := 100.0;
		HORZ2 :	REAL := 260.0;
		VERT :	REAL := 90.0;
		ALERT :	BOOL;
		SUNRISE_OFFSET :	TIME := T#1h;
		SUNSET_PRESET :	TIME := T#1h;
		SHADE_DELAY :	TIME := T#60s;
		SHADE_POS :	BYTE;
		QU :	BOOL;
		QD :	BOOL;
		STATUS :	BYTE;
		PO :	BYTE;
		CX :	oscat_CALENDAR;

		func_block : BLIND_SHADE_S_Block;
	END_VAR
	func_block.UP := UP;
	func_block.DN := DN;
	func_block.S_IN := S_IN ;
	func_block.PI    := PI    ;
	func_block.ENABLE := ENABLE;
	func_block.SUN := SUN;
	func_block.HORZ1 := HORZ1 ;
	func_block.HORZ2 := HORZ2 ;
	func_block.VERT    := VERT    ;
	func_block.ALERT := ALERT;
	func_block.SUNRISE_OFFSET := SUNRISE_OFFSET;
	func_block.SUNSET_PRESET := SUNSET_PRESET ;
	func_block.SHADE_DELAY := SHADE_DELAY ;
	func_block.SHADE_POS    := SHADE_POS    ;
	func_block.QU := QU;
	func_block.QD := QD;
	func_block.STATUS := STATUS ;
	func_block.PO := PO ;
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