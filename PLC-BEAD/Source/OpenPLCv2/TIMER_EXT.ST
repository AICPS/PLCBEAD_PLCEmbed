FUNCTION_BLOCK MANUAL_2_Block

	VAR_INPUT
		_IN :	BOOL;
		ENA :	BOOL;
		_ON :	BOOL;
		OFF :	BOOL;
		MAN :	BOOL;
	END_VAR


	VAR_OUTPUT
		Q :	BOOL;
		STATUS :	BYTE;
	END_VAR

	IF ena THEN
		IF NOT _ON AND NOT OFF THEN
			Q := _IN;
			STATUS := BYTE#100;
		ELSIF _on AND NOT off THEN
			Q := TRUE;
			STATUS := BYTE#101;
		ELSIF NOT _on AND off THEN
			q := FALSE;
			STATUS := BYTE#102;
		ELSE
			Q := MAN;
			STATUS := BYTE#103;
		END_IF;
	ELSE
		Q := FALSE;
		STATUS := BYTE#104;
	END_IF;

END_FUNCTION_BLOCK

FUNCTION_BLOCK DEBOUNCE_Block

	VAR_INPUT
		IN :	BOOL;
		TD :	TIME;
		PM :	BOOL;
	END_VAR


	VAR_OUTPUT
		Q :	BOOL;
	END_VAR


	VAR
		deb :	TOF;
	END_VAR

	IF NOT deb.Q AND IN THEN
		Q := TRUE;
	ELSIF NOT PM THEN
		Q := deb.Q;
	ELSE
		Q := FALSE;
	END_IF;

END_FUNCTION_BLOCK

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

FUNCTION DAY_OF_WEEK:INT
  VAR_INPUT
    IDATE :	UDINT;
  END_VAR

  DAY_OF_WEEK := UDINT_TO_INT((idate / UDINT#86400 + UDINT#3) MOD UDINT#7) + INT#01;
END_FUNCTION

FUNCTION TIME_TO_UDINT2:UDINT
	VAR_INPUT
		X :	TIME;
	END_VAR

	TIME_TO_UDINT2 := DINT_TO_UDINT(TIME_TO_DINT(X));
END_FUNCTION

FUNCTION_BLOCK TIMER_EXT_Block

	VAR_INPUT
		ENA :	BOOL;
		_ON :	BOOL;
		OFF :	BOOL;
		MAN :	BOOL;
		SWITCH :	BOOL;
		DT_IN :	UDINT;
		SUN_SET :	UDINT;
		SUN_RISE :	UDINT;
		HOLIDAY :	BOOL;
		T_DEBOUNCE :	TIME := T#100ms;
		T_RISE_START :	TIME;
		T_RISE_STOP :	TIME;
		T_SET_START :	TIME;
		T_SET_STOP :	TIME;
		T_DAY_START :	UDINT;
		T_DAY_STOP :	UDINT;
		ENABLE_SATURDAY :	BOOL;
		ENABLE_SUNDAY :	BOOL;
		ENABLE_HOLIDAY :	BOOL;
	END_VAR


	VAR_OUTPUT
		Q :	BOOL;
		STATUS :	BYTE;
	END_VAR


	VAR
		mx :	MANUAL_2_Block;
		deb :	DEBOUNCE_Block;
		tdx :	UDINT;
		wdx :	INT;
		tc :	TIME;
		tx :	UDINT;
		tl :	UDINT;
		qx :	BOOL;
		T_PLC_MS :	T_PLC_MS_Block;
		init :	BOOL;
	END_VAR

	SUN_RISE := SUN_RISE / UDINT#1000 * UDINT#1000;
	SUN_SET := SUN_SET / UDINT#1000 * UDINT#1000;

	T_PLC_MS();
	tx:= T_PLC_MS.T_PLC_MS;
	IF NOT init THEN
		init := TRUE;
		tl := tx;
	END_IF;
	tc := UDINT_TO_TIME(tx - tl);
	IF tc < t#200ms THEN RETURN; END_IF;
	tl := tx;

	deb(in := SWITCH, TD := T_DEBOUNCE, PM := TRUE);

	tdx := DT_TO_TOD2(dt_in);
	wdx := DAY_OF_WEEK(_DT_TO_DATE_B(dt_in));

	IF deb.Q THEN
		qx := NOT qx;
		status := BYTE#110;
	ELSIF holiday AND NOT enable_holiday THEN
		qx := FALSE;
	ELSIF wdx = 6 AND NOT enable_saturday THEN
		qx := FALSE;
	ELSIF wdx = 7 AND NOT enable_sunday THEN
		qx := FALSE;
	ELSIF T_day_start > UDINT#00 AND tdx - T_DAY_START <= TIME_TO_UDINT2(tc) THEN
		qx := TRUE;
		status := BYTE#111;
	ELSIF T_DAY_STOP > UDINT#00 AND tdx - T_DAY_STOP <= TIME_TO_UDINT2(tc) THEN
		qx := FALSE;
		status := BYTE#112;
	ELSIF T_RISE_START > T#0s AND tdx - SUN_RISE + TIME_TO_UDINT2(T_RISE_START) <= TIME_TO_UDINT2(tc) THEN
		qx := TRUE;
		status := BYTE#113;
	ELSIF T_RISE_STOP > T#0s AND tdx - SUN_RISE - TIME_TO_UDINT2(T_RISE_STOP) <= TIME_TO_UDINT2(tc) THEN
		qx := FALSE;
		status := BYTE#114;
	ELSIF T_SET_start > T#0s AND tdx - SUN_SET + TIME_TO_UDINT2(T_SET_START) <= TIME_TO_UDINT2(tc) THEN
		qx := TRUE;
		status := BYTE#115;
	ELSIF T_SET_STOP > T#0s AND tdx - SUN_SET - TIME_TO_UDINT2(T_SET_STOP) <= TIME_TO_UDINT2(tc) THEN
		qx := FALSE;
		status := BYTE#116;
	END_IF;

	mx(_IN := qx, ena := ENA, _ON := _ON, off := OFF, man := MAN);
	Q := mx.Q;

	IF mx.STATUS > BYTE#100 THEN status := mx.STATUS; END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		ENA :	BOOL;
		_ON :	BOOL;
		OFF :	BOOL;
		MAN :	BOOL;
		SWITCH :	BOOL;
		DT_IN :	UDINT;
		SUN_SET :	UDINT;
		SUN_RISE :	UDINT;
		HOLIDAY :	BOOL;
		T_DEBOUNCE :	TIME := T#100ms;
		T_RISE_START :	TIME;
		T_RISE_STOP :	TIME;
		T_SET_START :	TIME;
		T_SET_STOP :	TIME;
		T_DAY_START :	UDINT;
		T_DAY_STOP :	UDINT;
		ENABLE_SATURDAY :	BOOL;
		ENABLE_SUNDAY :	BOOL;
		ENABLE_HOLIDAY :	BOOL;
		Q :	BOOL;
		STATUS :	BYTE;

		func_block : TIMER_EXT_Block;
	END_VAR
	func_block.ENA := ENA;
	func_block._ON := _ON;
	func_block.OFF := OFF ;
	func_block.MAN    := MAN    ;
	func_block.SWITCH := SWITCH;
	func_block.DT_IN := DT_IN;
	func_block.SUN_SET := SUN_SET;
	func_block.SUN_RISE := SUN_RISE ;
	func_block.HOLIDAY    := HOLIDAY    ;
	func_block.T_DEBOUNCE := T_DEBOUNCE;
	func_block.T_RISE_START := T_RISE_START;
	func_block.T_RISE_STOP := T_RISE_STOP;
	func_block.T_SET_START := T_SET_START ;
	func_block.T_SET_STOP    := T_SET_STOP    ;
	func_block.T_DAY_START := T_DAY_START;
	func_block.T_DAY_STOP := T_DAY_STOP;
	func_block.ENABLE_SATURDAY := ENABLE_SATURDAY;
	func_block.ENABLE_SUNDAY := ENABLE_SUNDAY ;
	func_block.ENABLE_HOLIDAY    := ENABLE_HOLIDAY    ;

	func_block();
	Q  := func_block.Q;
	STATUS := func_block.STATUS;
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