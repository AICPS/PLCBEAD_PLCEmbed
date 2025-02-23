FUNCTION_BLOCK ONTIME_Block

	VAR_INPUT
		IN :	BOOL;
		RST :	BOOL;
	END_VAR


	VAR_IN_OUT
		SECONDS :	UDINT;
		CYCLES :	UDINT;
	END_VAR


	VAR
		tx :	UDINT;
		last :	UDINT;
		edge :	BOOL;
		init :	BOOL;
		ms :	UDINT;
		T_PLC_MS :	T_PLC_MS_Block;
	END_VAR

	T_PLC_MS();
	tx:= T_PLC_MS.T_PLC_MS;

	IF NOT init THEN
		init := TRUE;
		last := tx;
		ms := UDINT#0;
	END_IF;
	IF RST THEN
		SECONDS := UDINT#0;
		CYCLES := UDINT#0;
		last := tx;
		ms := UDINT#0;
	ELSIF IN THEN
		(* add the current milliseconds *)
		ms := (tx - last) + ms;
		IF ms >= UDINT#1000 THEN
			seconds := seconds + UDINT#1;
			ms := ms - UDINT#1000;
		END_IF;
		cycles := cycles + BOOL_TO_UDINT(NOT edge);
	END_IF;
	last := tx;
	edge := in;

END_FUNCTION_BLOCK

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

FUNCTION_BLOCK BURNER_Block

	VAR_INPUT
		IN :	BOOL;
		STAGE2 :	BOOL;
		OVER_TEMP :	BOOL;
		OIL_TEMP :	BOOL := TRUE;
		FLAME :	BOOL;
		RST :	BOOL;
		RST_TIMER :	BOOL;
		PRE_HEAT_TIME :	TIME := t#5s;
		PRE_VENT_TIME :	TIME := t#15s;
		PRE_IGNITE_TIME :	TIME := t#5s;
		POST_IGNITE_TIME :	TIME := t#25s;
		STAGE2_DELAY :	TIME := t#10s;
		SAFETY_TIME :	TIME := t#5s;
		LOCKOUT_TIME :	TIME := t#10s;
		MULTIPLE_IGNITION :	BOOL := TRUE;
		KW1 :	REAL;
		KW2 :	REAL;
	END_VAR


	VAR_OUTPUT
		MOTOR :	BOOL;
		COIL1 :	BOOL;
		COIL2 :	BOOL;
		PRE_HEAT :	BOOL;
		IGNITE :	BOOL;
		KWH :	REAL;
		STATUS :	BYTE;
		FAIL :	BOOL;
	END_VAR


	VAR_IN_OUT
		RUNTIME1 :	UDINT;
		RUNTIME2 :	UDINT;
		CYCLES :	UDINT;
	END_VAR


	VAR
		state :	INT;
		last :	TIME;
		tx :	TIME;
		last_change :	TIME;
		timer1 :	ONTIME_Block;
		timer2 :	ONTIME_Block;
		oil_temp_last :	BOOL;
		cycles2 :	UDINT;
		T_PLC_MS :	T_PLC_MS_Block;
	END_VAR

	T_PLC_MS();
	tx:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

	IF rst OR over_temp OR state = 0 THEN
		IF status > BYTE#0 AND tx - last_change >= lockout_time AND rst THEN
			status := BYTE#110;
			fail := FALSE;
			state := 1;
		ELSE
			motor := FALSE;
			coil1 := FALSE;
			coil2 := FALSE;
			ignite := FALSE;
			pre_heat := FALSE;
			IF over_temp THEN
				status := BYTE#9;
				fail := TRUE;
			END_IF;
			last_change := tx;
			last := tx;
			state := 1;
		END_IF;
	END_IF;

	IF rst_timer THEN
		runtime1 := UDINT#0;
		runtime2 := UDINT#0;
		cycles := UDINT#0;
		cycles2 := UDINT#0;
	END_IF;

	IF (status > BYTE#0 AND status < BYTE#100) OR rst THEN RETURN; END_IF;

	CASE state OF

	1:	
		IF in AND flame THEN
			state := 7;
			pre_heat := FALSE;
			status := BYTE#2;
			last_change := tx;
		ELSIF in THEN
			pre_heat := TRUE;
			state := 2;
			last_change := tx;
		END_IF;

	2:	
		IF (tx- last_change >= pre_heat_time AND oil_temp) OR (oil_temp AND NOT oil_temp_last) THEN
			motor := TRUE;
			state := 3;
			last_change := tx;
		ELSIF tx - last_change >= pre_heat_time AND NOT oil_temp THEN
			state := 7;
			pre_heat := FALSE;
			status := BYTE#1;
			last_change := tx;
		ELSIF flame THEN
			state := 7;
			pre_heat := FALSE;
			status := BYTE#2;
			last_change := tx;
		END_IF;

	3:	
		IF tx - last_change >= pre_vent_time - pre_ignite_time THEN
			ignite := TRUE;
			state := 4;
			last_change := tx;
		ELSIF flame THEN
			state := 7;
			pre_heat := FALSE;
			motor := FALSE;
			status := BYTE#3;
			last_change := tx;
		END_IF;

	4:	
		IF tx - last_change >= pre_ignite_time THEN
			coil1 := TRUE;
			state := 5;
			last_change := tx;
		END_IF;

	5:	
		IF tx - last_change >= safety_time OR flame THEN
			IF NOT flame THEN
				state := 7;
				motor := FALSE;
				coil1 := FALSE;
				pre_heat := FALSE;
				ignite := FALSE;
				status := BYTE#4;
				last_change := tx;
			ELSE
				state := 6;
				last_change := tx;
			END_IF;
		END_IF;

	6:	
		IF NOT flame AND NOT multiple_ignition THEN
			state := 7;
			motor := FALSE;
			coil1 := FALSE;
			coil2 := FALSE;
			pre_heat := FALSE;
			ignite := FALSE;
			status := BYTE#5;
			last_change := tx;
		ELSIF NOT flame AND multiple_ignition THEN
			ignite := TRUE;
			state := 5;
			coil2 := FALSE;
			last_change := tx;
		ELSE
			IF tx - last_change >= post_ignite_time THEN
				ignite := FALSE;
			END_IF;
			IF tx - last_change >= stage2_delay AND stage2 THEN
				coil2 := TRUE;
			ELSE
				coil2 := FALSE;
			END_IF;
		END_IF;
	END_CASE;

	IF NOT in THEN
		state := 1;
		motor := FALSE;
		coil1 := FALSE;
		coil2 := FALSE;
		ignite := FALSE;
		pre_heat := FALSE;
		last_change := tx;
	END_IF;

	timer1(in := flame AND in AND motor AND coil1 AND NOT coil2, SECONDS := runtime1, CYCLES := cycles);
	cycles := timer1.CYCLES;
	runtime1 := timer1.SECONDS;

	timer2(in := flame AND in AND motor AND coil1 AND coil2, SECONDS := runtime2, CYCLES := cycles2);
	cycles2 := timer2.CYCLES;
	runtime2 := timer2.SECONDS;

	KWH := UDINT_TO_REAL(runtime1) * KW1 / 3600.0 + UDINT_TO_REAL(runtime2) * KW2 / 3600.0;

	last := tx;


	IF status > BYTE#0 AND status < BYTE#100 THEN
		fail := TRUE;
	ELSE
		fail := FALSE;
		IF NOT in THEN
			status := BYTE#110;
		ELSIF flame AND in AND motor AND coil2 AND coil1 THEN
			status := BYTE#113;
		ELSIF flame AND in AND motor AND coil1 THEN
			status := BYTE#112;
		ELSE
			status := BYTE#111;
		END_IF;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		IN :	BOOL;
		STAGE2 :	BOOL;
		OVER_TEMP :	BOOL;
		OIL_TEMP :	BOOL := TRUE;
		FLAME :	BOOL;
		RST :	BOOL;
		RST_TIMER :	BOOL;
		PRE_HEAT_TIME :	TIME := t#5s;
		PRE_VENT_TIME :	TIME := t#15s;
		PRE_IGNITE_TIME :	TIME := t#5s;
		POST_IGNITE_TIME :	TIME := t#25s;
		STAGE2_DELAY :	TIME := t#10s;
		SAFETY_TIME :	TIME := t#5s;
		LOCKOUT_TIME :	TIME := t#10s;
		MULTIPLE_IGNITION :	BOOL := TRUE;
		KW1 :	REAL;
		KW2 :	REAL;
		RUNTIME1 :	UDINT;
		RUNTIME2 :	UDINT;
		CYCLES :	UDINT;
		MOTOR :	BOOL;
		COIL1 :	BOOL;
		COIL2 :	BOOL;
		PRE_HEAT :	BOOL;
		IGNITE :	BOOL;
		KWH :	REAL;
		STATUS :	BYTE;
		FAIL :	BOOL;

		func_block : BURNER_Block;
	END_VAR
	func_block.IN := IN;
	func_block.STAGE2 := STAGE2;
	func_block.OVER_TEMP := OVER_TEMP ;
	func_block.OIL_TEMP    := OIL_TEMP    ;
	func_block.FLAME := FLAME;
	func_block.RST := RST;
	func_block.RST_TIMER := RST_TIMER ;
	func_block.PRE_HEAT_TIME := PRE_HEAT_TIME ;
	func_block.PRE_VENT_TIME    := PRE_VENT_TIME    ;
	func_block.PRE_IGNITE_TIME := PRE_IGNITE_TIME;
	func_block.POST_IGNITE_TIME := POST_IGNITE_TIME;
	func_block.STAGE2_DELAY := STAGE2_DELAY ;
	func_block.SAFETY_TIME := SAFETY_TIME ;
	func_block.LOCKOUT_TIME    := LOCKOUT_TIME    ;
	func_block.MULTIPLE_IGNITION := MULTIPLE_IGNITION;
	func_block.KW1 := KW1;
	func_block.KW2 := KW2;
	func_block.RUNTIME1 := RUNTIME1;
	func_block.RUNTIME2 := RUNTIME2;
	func_block.CYCLES := CYCLES;
	
	func_block();
	MOTOR  := func_block.MOTOR;
	COIL1  := func_block.COIL1;
	COIL2  := func_block.COIL2;
	PRE_HEAT  := func_block.PRE_HEAT;
	IGNITE  := func_block.IGNITE;
	KWH  := func_block.KWH;
	STATUS  := func_block.STATUS;
	FAIL  := func_block.FAIL;
	RUNTIME1  := func_block.RUNTIME1;
	RUNTIME2  := func_block.RUNTIME2;
	CYCLES  := func_block.CYCLES;
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