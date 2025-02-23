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

TYPE  
	oscat_ARRAY_X               : ARRAY [0..1]    OF REAL;
	oscat_XY                    : ARRAY [1..20]   OF oscat_ARRAY_X := [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
END_TYPE

FUNCTION_BLOCK LINEAR_INT_Block

	VAR_INPUT
		X :	REAL;
		XY :	oscat_XY;
		PTS :	INT;
	END_VAR


	VAR_OUTPUT
		LINEAR_INT :	REAL;
	END_VAR


	VAR
		i :	INT;
		i2 :	INT;
	END_VAR


	pts := MIN(pts,20);

	i := 2;

	WHILE (i < pts) AND (XY[i][0] < X) DO
		i := i + 1;
	END_WHILE;

	i2 := i-1;

	LINEAR_INT := ((XY[i][1] - XY[i2][1]) * X - XY[i][1] * XY[i2][0] + XY[i2][1] * XY[i][0]) / (XY[i][0] - XY[i2][0]);

END_FUNCTION_BLOCK

FUNCTION_BLOCK WATER_ENTHALPY_Block

    VAR_INPUT
        T :	REAL;
    END_VAR


    VAR_OUTPUT
        RESULT :	REAL;
    END_VAR


    VAR
        Pts :	INT;
        data :	oscat_XY;
        FB_LINEAR_INT :	LINEAR_INT_Block;
    END_VAR

    IF Pts = 0 THEN
        Pts := 11;
        data[01][0] := REAL#0.0;
        data[01][1] := REAL#0.06;
        data[02][0] := REAL#10.0;
        data[02][1] := REAL#42.1;
        data[03][0] := REAL#20.0;
        data[03][1] := REAL#83.9;
        data[04][0] := REAL#30.0;
        data[04][1] := REAL#125.8;
        data[05][0] := REAL#40.0;
        data[05][1] := REAL#167.58;
        data[06][0] := REAL#50.0;
        data[06][1] := REAL#209.4;
        data[07][0] := REAL#60.0;
        data[07][1] := REAL#251.2;
        data[08][0] := REAL#70.0;
        data[08][1] := REAL#293.1;
        data[09][0] := REAL#80.0;
        data[09][1] := REAL#335.0;
        data[10][0] := REAL#90.0;
        data[10][1] := REAL#377.0;
        data[11][0] := REAL#100.0;
        data[11][1] := REAL#419.1;
    END_IF;

    FB_LINEAR_INT(X:=T,XY:=Data,Pts:=Pts);
    Result :=FB_LINEAR_INT.LINEAR_INT;

END_FUNCTION_BLOCK

FUNCTION_BLOCK R2_SET_Block

	VAR_INPUT
		X :	REAL;
	END_VAR

	VAR_OUTPUT
		R2_SET :	REAL2;
	END_VAR

	R2_SET.RX := X;
	R2_SET.R1 := 0.0;

END_FUNCTION_BLOCK

FUNCTION_BLOCK R2_ADD_Block

	VAR_INPUT
		X :	REAL2;
		Y :	REAL;
	END_VAR

	VAR_OUTPUT
		R2_ADD :	REAL2;
	END_VAR

	VAR
		temp :	REAL;
	END_VAR


	temp := X.RX;
	R2_ADD.RX := Y + X.R1 + X.RX;
	R2_ADD.R1 := temp - R2_ADD.RX + Y + X.R1;

END_FUNCTION_BLOCK

TYPE REAL2:
	
	STRUCT
		R1 : REAL;
		RX : REAL;
	END_STRUCT;

END_TYPE

FUNCTION_BLOCK INTEGRATE

	VAR_INPUT
		E :	BOOL := TRUE;
		X :	REAL;
		K :	REAL := 1.0;
	END_VAR

	VAR_IN_OUT
		Y :	REAL;
	END_VAR

	VAR
		X_last :	REAL;
		init :	BOOL;
		T_PLC_MS :	T_PLC_MS_block;
		last :	UDINT;
		tx :	UDINT;
	END_VAR


	T_PLC_MS();
	tx:= T_PLC_MS.T_PLC_MS;

	IF NOT init THEN
		init := TRUE;
		X_last := X;
	ELSIF E THEN
		Y := (X + X_LAST) * 0.5E-3 * UDINT_TO_REAL(tx-last) * K + Y;
		X_last := X;
	END_IF;
	last := tx;

END_FUNCTION_BLOCK

FUNCTION_BLOCK FT_INT2_Block

	VAR_INPUT
		IN :	REAL;
		K :	REAL := 1.0;
		RUN :	BOOL := TRUE;
		RST :	BOOL;
		OUT_MIN :	REAL := REAL#-1.0E-37;
		OUT_MAX :	REAL := REAL#1.0E37;
	END_VAR

	VAR_OUTPUT
		OUT :	REAL;
		LIM :	BOOL;
	END_VAR

	VAR
		integ :	INTEGRATE;
		ix :	REAL;
		val :	REAL2;
		R2_ADD :	R2_ADD_Block;
		R2_SET :	R2_SET_Block;
	END_VAR

	IF RST THEN
		R2_SET(X:=0.0);
		val:=R2_SET.R2_SET;
		out := 0.0;
	ELSE
		integ(X := IN, E := RUN, K := K, Y := ix);
		ix := integ.Y;
		R2_ADD(X:=val,Y:=ix);
		val:=R2_ADD.R2_ADD;
		ix := 0.0;
		OUT := val.RX;
	END_IF;

	(* check output for limits *)
	IF out > OUT_MIN AND out < OUT_MAX THEN
		LIM := FALSE;
	ELSE
		OUT := LIMIT(OUT_MIN, OUT, OUT_MAX);
		R2_SET(X:=OUT);
		val:=R2_SET.R2_SET;
		LIM := TRUE;
	END_IF;

END_FUNCTION_BLOCK

FUNCTION WATER_DENSITY:REAL

    VAR_INPUT
        T :	REAL;
        SAT :	BOOL;
    END_VAR


    VAR
        T2 :	REAL;
        T4 :	REAL;
    END_VAR

    T2 := T * T;
    T4 := T2 * T2;
    WATER_DENSITY := (999.83952 + 16.952577*T + -7.9905127E-3*T2 + -4.6241757E-5*T2*T + 1.0584601E-7*T4 + -2.8103006E-10*T4*T) / (1.0 + 0.0168872*T);
    IF sat THEN WATER_DENSITY := WATER_DENSITY - 0.004612 + 0.000106 * T; END_IF;

END_FUNCTION

FUNCTION TIME_TO_UDINT2:UDINT
	VAR_INPUT
		X :	TIME;
	END_VAR

	TIME_TO_UDINT2 := DINT_TO_UDINT(TIME_TO_DINT(X));
END_FUNCTION

FUNCTION_BLOCK HEAT_METER_Block

	VAR_INPUT
		TF :	REAL;
		TR :	REAL;
		LPH :	REAL;
		E :	BOOL;
		RST :	BOOL;
		CP :	REAL;
		DENSITY :	REAL;
		CONTENT :	REAL;
		PULSE_MODE :	BOOL;
		RETURN_METER :	BOOL;
		AVG_TIME :	TIME := T#5s;
	END_VAR


	VAR_OUTPUT
		C :	REAL;
	END_VAR


	VAR_IN_OUT
		Y :	REAL;
	END_VAR


	VAR
		tx :	UDINT;
		last :	UDINT;
		int1 :	FT_INT2_Block;
		edge :	BOOL;
		x :	REAL;
		init :	BOOL;
		Y_last :	REAL;
		T_PLC_MS :	T_PLC_MS_Block;
		WATER_ENTHALPY :	WATER_ENTHALPY_Block;
		wa_TF :	REAL;
		wa_TR :	REAL;
	END_VAR

	IF rst THEN
		int1(rst := TRUE);
		int1.rst := FALSE;
		C := 0.0;
		Y := 0.0;
	ELSIF e THEN
		water_enthalpy(T:=TF);
		wa_TF:=water_enthalpy.Result;

		water_enthalpy(T:=TR);
		wa_TR:=water_enthalpy.Result;

		X := (WATER_DENSITY(SEL(return_meter, TF, TR), FALSE) * (wa_TF - wa_TR) * (1.0 - content) + CP * Density * content * (TF-TR));
	END_IF;

	int1(run := NOT pulse_mode AND e, in := X * LPH * 2.77777777777E-4);
	IF pulse_mode THEN
		IF NOT edge AND E THEN Y := Y + X * LPH; END_IF;
	ELSE
		Y := int1.Out;
	END_IF;

	edge := e;

	T_PLC_MS();
	tx:= T_PLC_MS.T_PLC_MS;

	IF NOT init THEN
		init := TRUE;
		last := tx;
	END_IF;

	IF (tx - last >= TIME_TO_UDINT2(AVG_TIME)) AND (avg_time > T#0s) THEN
		last := tx;
		C := (Y - Y_last) * 3.6E12 / TIME_TO_REAL(AVG_TIME);
		Y_last := Y;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
	    TF :	REAL;
		TR :	REAL;
		LPH :	REAL;
		E :	BOOL;
		RST :	BOOL;
		CP :	REAL;
		DENSITY :	REAL;
		CONTENT :	REAL;
		PULSE_MODE :	BOOL;
		RETURN_METER :	BOOL;
		AVG_TIME :	TIME := T#5s;
		Y :	REAL;
		C :	REAL;

		func_block : HEAT_METER_Block;
  	END_VAR
	func_block.TF := TF;
	func_block.TR := TR;
	func_block.LPH := LPH;
	func_block.E := E;
	func_block.RST := RST;
	func_block.CP := CP;
	func_block.DENSITY := DENSITY;
	func_block.CONTENT := CONTENT;
	func_block.PULSE_MODE := PULSE_MODE;
	func_block.RETURN_METER := RETURN_METER;
	func_block.AVG_TIME := AVG_TIME;
	func_block.Y := Y;

	func_block();
	Y := func_block.Y;
	C := func_block.C;
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