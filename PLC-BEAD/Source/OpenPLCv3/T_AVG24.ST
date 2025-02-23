TYPE
  oscat_T_AVG24         	  : ARRAY [0..47]   OF INT;
END_TYPE

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

FUNCTION_BLOCK FILTER_I_Block
	VAR_INPUT
		X :	INT;
		T :	TIME;
	END_VAR

	VAR_OUTPUT
		Y :	INT;
	END_VAR

	VAR
		Yi :	DINT;
		last :	UDINT;
		tx :	UDINT;
		init :	BOOL;
		T_PLC_MS :	T_PLC_MS_block;
	END_VAR

	T_PLC_MS();
	tx:= T_PLC_MS.T_PLC_MS;

	IF NOT init OR T = t#0s THEN
		init := TRUE;
		Yi := INT_TO_DINT(X) * DINT#1000;
	ELSE
		Yi := Yi + INT_TO_DINT(X - Y) * UDINT_TO_DINT(tx - last) * DINT#1000 / TIME_TO_DINT(T);
	END_IF;
	last := tx;
	Y := DINT_TO_INT(yi / DINT#1000);

END_FUNCTION_BLOCK

FUNCTION TIME_TO_UDINT2:UDINT
	VAR_INPUT
		X :	TIME;
	END_VAR

	TIME_TO_UDINT2 := DINT_TO_UDINT(TIME_TO_DINT(X));
END_FUNCTION

FUNCTION INC1:INT

	VAR_INPUT
		X :	INT;
		N :	INT;
	END_VAR

	IF X >= N - 1 THEN
		INC1 := 0;
	ELSE
		INC1 := X + 1;
	END_IF;
END_FUNCTION

FUNCTION_BLOCK T_AVG24_Block

	VAR_INPUT
		TS :	INT;
		DTI :	UDINT;
		RST :	BOOL;
		T_FILTER :	TIME := T#10m;
		SCALE :	REAL := 1.0;
		OFS :	REAL;
	END_VAR


	VAR_OUTPUT
		TA :	REAL;
		_TP :	BOOL;
	END_VAR


	VAR_IN_OUT
		T24 :	REAL;
		T24_MAX :	REAL;
		T24_MIN :	REAL;
	END_VAR


	VAR
		samples :	oscat_T_AVG24;
		pos :	INT;
		init :	BOOL;	
		sum :	DINT;
		last :	UDINT;
		tmp_maxxx :	INT;
		tmp_min :	INT;
		i :	INT;
		ft1 :	FILTER_I_Block;
	END_VAR

	ft1(X := TS, T := T_FILTER);

	IF rst OR NOT init THEN
		init := TRUE;
		IF T24 = -1000.0 THEN t24 := INT_TO_REAL(ft1.Y) * 0.1; END_IF;
		FOR pos := 0 TO 47 DO
			samples[pos] := REAL_TO_INT(T24 * 10.0);
		END_FOR;
		pos := 0;
		sum := INT_TO_DINT(samples[0]) * DINT#48;
		TA := (INT_TO_REAL(ft1.Y) * 0.1 + OFS) * SCALE;
		T24 := (DINT_TO_REAL(sum) * 0.00208333333333 + OFS) * SCALE;
		_TP := TRUE;
	ELSIF (dti / UDINT#60 MOD UDINT#30) = UDINT#0 AND DTI > last THEN
		last := DTI + TIME_TO_UDINT2(T#1m);
		sum := sum - INT_TO_DINT(samples[pos]);
		samples[pos] := ft1.Y;
		sum := sum + INT_TO_DINT(samples[pos]);
		pos := INC1(pos, 48);
		TA := (INT_TO_REAL(ft1.Y) * 0.1 + OFS) * SCALE;
		T24 := (DINT_TO_REAL(sum) * 0.00208333333333 + OFS) * SCALE;
		tmp_maxxx := -32000;
		tmp_min := 32000;
		FOR i := 0 TO 47 DO
			tmp_maxxx := MAX(tmp_maxxx, samples[i]);
			tmp_min := MIN(tmp_min, samples[i]);
		END_FOR;
		T24_MAX := (INT_TO_REAL(tmp_maxxx) * 0.1 + OFS) * SCALE;
		T24_MIN := (INT_TO_REAL(tmp_min) * 0.1 + OFS) * SCALE;
		_TP := TRUE;
	ELSE
		_TP := FALSE;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		TS :	INT;
		DTI :	UDINT;
		RST :	BOOL;
		T_FILTER :	TIME := T#10m;
		SCALE :	REAL := 1.0;
		OFS :	REAL;
		TA :	REAL;
		_TP :	BOOL;

		func_block : T_AVG24_Block;
	END_VAR
	func_block.TS := TS;
	func_block.DTI := DTI;
	func_block.RST := RST ;
	func_block.T_FILTER := T_FILTER;
	func_block.SCALE := SCALE;
	func_block.OFS := OFS ;

	func_block();
	TA  := func_block.TA;
	_TP  := func_block._TP;

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