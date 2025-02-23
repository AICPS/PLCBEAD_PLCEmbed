TYPE
  oscat_STRING5               : STRING;
  oscat_STRING30              : STRING;
END_TYPE

TYPE oscat_CALENDAR :
	STRUCT
		UTC : UDINT;				(* world time UTC *)
		LDT : UDINT;				(* local time *)
		LDATE : UDINT;				(* local date *)
		LTOD : UDINT;				(* local time of DAY  *)
		YEAR  : INT;					(* YEAR  of LDATE *)
		MONTH : INT;				(* MONTH of LDATE *)
		DAY  : INT;					(* DAY  of LDATE *)
		WEEKDAY  : INT;				(* weekDAY  of LDATE *)
		OFFSET : INT;				(* Time Zone Offset for Local time IN minutes *)
		DST_EN : BOOL;				(* DAYlight savings time enable *)
		DST_ON : BOOL;				(* true when DAYlight savings time os on *)
		NAME : oscat_string5;		(* NAME of time zone *)
		LANGUAGE : INT;			    (* LANGUAGE number pls see LANGUAGE setup *)
		LONGITUDE : REAL;			(* LONGITUDE of current location *)
		LATITUDE : REAL;			(* LATITUDE of current location *)
		SUN_RISE : UDINT;			(* SUN_RISE for current location *)
		SUN_SET : UDINT;			(* SUN_SET for current location *)
		SUN_MIDDAY  : UDINT;			(* worlDTIME when sun stands at sOUTh POSition *)
		SUN_HEIGTH : REAL;			(* suns heigth at MIDDAY, sOUTh POSition *)
		SUN_HOR : REAL;				(* sun angle horizontal 0 = north IN degrees *)
		SUN_VER : REAL;				(* sun angle vertical above horizon IN degrees *)
		NIGHT : BOOL;				(* true between SUN_SET and SUN_RISE *)
		HOLIDAY  : BOOL;				(* true when holiDAY  *)
		HOLY_NAME : oscat_string30;	(* NAME of holiDAY  *)
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
		sun_DELAY :	TOF;
	END_VAR


	sun_DELAY(IN := sun, PT := shade_DELAY);

	IF ALERT THEN
	QU := TRUE;
	QD := FALSE;
	STATUS := BYTE#152;
	ELSIF UP AND DN AND ENABLE AND sun_DELAY.Q
	AND (CX.SUN_HOR > HORZ1) AND (CX.SUN_HOR < HORZ2)
	AND (CX.SUN_VER < VERT)
	AND (DT_TO_TOD2(CX.UTC) > CX.SUN_RISE + TIME_TO_UDINT2(sunrise_offset)) AND (DT_TO_TOD2(CX.UTC) < CX.SUN_SET - TIME_TO_UDINT2(sunset_preset)) THEN
	QU := UP;
	QD := DN;
	STATUS := BYTE#151;
	PO := MIN(PI, shade_POS);
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

