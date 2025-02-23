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
		TX :	UDINT;
		last :	UDINT;
		edge :	BOOL;
		init :	BOOL;
		ms :	UDINT;
		T_PLC_MS :	T_PLC_MS_block;
	END_VAR

	T_PLC_MS();
	TX:= T_PLC_MS.T_PLC_MS;

	IF NOT init THEN
		init := TRUE;
		last := TX;
		ms := UDINT#0;
	END_IF;
	IF RST THEN
		SECONDS := UDINT#0;
		CYCLES := UDINT#0;
		last := TX;
		ms := UDINT#0;
	ELSIF IN THEN
		(* add the current milliseconds *)
		ms := (SUB_TIME(TX, last)) + ms;
		IF ms >= UDINT#1000 THEN
			seconds := seconds + UDINT#1;
			ms := ms - UDINT#1000;
		END_IF;
		CYCLES := CYCLES + BOOL_TO_UDINT(NOT edge);
	END_IF;
	last := TX;
	edge := IN;

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

	VAR
		PLC_TICKS_PER_SEC :	INT;
		PLC_SYS_TICK_CNT :	DINT;
	END_VAR

	VAR
		debug :	BOOL;(*Debug-Mode ON / OFF*)
		N :	INT;(*Debug-Faktor*)
		Offset :	UDINT;(*Debug-Offset*)
		temp :	DWORD := DWORD#1;(*Debug-Offset*)
		MODE :	BOOL;(*modus*)
		faktor :	UDINT;(*Systemtakt-Faktor*)
		init :	BOOL;
		v_plc_ticks_per_sec :	UDINT;
		base :	UDINT := UDINT#1000;
	END_VAR


	IF init = FALSE THEN
		v_plc_ticks_per_sec := INT_TO_UDINT(PLC_TICKS_PER_SEC);
		IF v_plc_ticks_per_sec = UDINT#1024 THEN
			faktor := UDINT#1;
			MODE := FALSE;
		ELSIF v_plc_ticks_per_sec > UDINT#0 THEN
			IF v_plc_ticks_per_sec <= base THEN
				faktor := base / v_plc_ticks_per_sec;
				MODE := FALSE;
			ELSE
				faktor := v_plc_ticks_per_sec / base;
				MODE := TRUE;
			END_IF;
		ELSE
			faktor := UDINT#1;
		END_IF;
		init := TRUE;
	END_IF;

	IF MODE THEN
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
		STATE :	INT;
		last :	TIME;
		TX :	TIME;
		last_CHAnge :	TIME;
		timeR1  :	ONTIME_Block;
		timeR2 :	ONTIME_Block;
		oil_temp_last :	BOOL;
		CYCLES2 :	UDINT;
		T_PLC_MS :	T_PLC_MS_block;
	END_VAR

	T_PLC_MS();
	TX:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

	IF RST OR over_temp OR STATE = 0 THEN
		IF STATUS > BYTE#0 AND SUB_TIME(TX, last)_CHAnge >= lockOUT_time AND RST THEN
			STATUS := BYTE#110;
			fail := FALSE;
			STATE := 1;
		ELSE
			motor := FALSE;
			coil1 := FALSE;
			coil2 := FALSE;
			ignite := FALSE;
			pre_heat := FALSE;
			IF over_temp THEN
				STATUS := BYTE#9;
				fail := TRUE;
			END_IF;
			last_CHAnge := TX;
			last := TX;
			STATE := 1;
		END_IF;
	END_IF;

	IF RST_timer THEN
		runtime1 := UDINT#0;
		runtime2 := UDINT#0;
		CYCLES := UDINT#0;
		CYCLES2 := UDINT#0;
	END_IF;

	IF (STATUS > BYTE#0 AND STATUS < BYTE#100) OR RST THEN RETURN; END_IF;

	CASE STATE OF

	1:	
		IF IN AND flame THEN
			STATE := 7;
			pre_heat := FALSE;
			STATUS := BYTE#2;
			last_CHAnge := TX;
		ELSIF IN THEN
			pre_heat := TRUE;
			STATE := 2;
			last_CHAnge := TX;
		END_IF;

	2:	
		IF (TX- last_CHAnge >= pre_heat_time AND oil_temp) OR (oil_temp AND NOT oil_temp_last) THEN
			motor := TRUE;
			STATE := 3;
			last_CHAnge := TX;
		ELSIF SUB_TIME(TX, last)_CHAnge >= pre_heat_time AND NOT oil_temp THEN
			STATE := 7;
			pre_heat := FALSE;
			STATUS := BYTE#1;
			last_CHAnge := TX;
		ELSIF flame THEN
			STATE := 7;
			pre_heat := FALSE;
			STATUS := BYTE#2;
			last_CHAnge := TX;
		END_IF;

	3:	
		IF SUB_TIME(TX, last)_CHAnge >= pre_vent_time - pre_ignite_time THEN
			ignite := TRUE;
			STATE := 4;
			last_CHAnge := TX;
		ELSIF flame THEN
			STATE := 7;
			pre_heat := FALSE;
			motor := FALSE;
			STATUS := BYTE#3;
			last_CHAnge := TX;
		END_IF;

	4:	
		IF SUB_TIME(TX, last)_CHAnge >= pre_ignite_time THEN
			coil1 := TRUE;
			STATE := 5;
			last_CHAnge := TX;
		END_IF;

	5:	
		IF SUB_TIME(TX, last)_CHAnge >= safety_time OR flame THEN
			IF NOT flame THEN
				STATE := 7;
				motor := FALSE;
				coil1 := FALSE;
				pre_heat := FALSE;
				ignite := FALSE;
				STATUS := BYTE#4;
				last_CHAnge := TX;
			ELSE
				STATE := 6;
				last_CHAnge := TX;
			END_IF;
		END_IF;

	6:	
		IF NOT flame AND NOT multiple_ignition THEN
			STATE := 7;
			motor := FALSE;
			coil1 := FALSE;
			coil2 := FALSE;
			pre_heat := FALSE;
			ignite := FALSE;
			STATUS := BYTE#5;
			last_CHAnge := TX;
		ELSIF NOT flame AND multiple_ignition THEN
			ignite := TRUE;
			STATE := 5;
			coil2 := FALSE;
			last_CHAnge := TX;
		ELSE
			IF SUB_TIME(TX, last)_CHAnge >= POSt_ignite_time THEN
				ignite := FALSE;
			END_IF;
			IF SUB_TIME(TX, last)_CHAnge >= stage2_DELAY AND stage2 THEN
				coil2 := TRUE;
			ELSE
				coil2 := FALSE;
			END_IF;
		END_IF;
	END_CASE;

	IF NOT IN THEN
		STATE := 1;
		motor := FALSE;
		coil1 := FALSE;
		coil2 := FALSE;
		ignite := FALSE;
		pre_heat := FALSE;
		last_CHAnge := TX;
	END_IF;

	timeR1 (IN := flame AND IN AND motor AND coil1 AND NOT coil2, SECONDS := runtime1, CYCLES := CYCLES);
	CYCLES := timeR1 .CYCLES;
	runtime1 := timeR1 .SECONDS;

	timeR2(IN := flame AND IN AND motor AND coil1 AND coil2, SECONDS := runtime2, CYCLES := CYCLES2);
	CYCLES2 := timeR2.CYCLES;
	runtime2 := timeR2.SECONDS;

	KWH := UDINT_TO_REAL(runtime1) * KW1 / 3600.0 + UDINT_TO_REAL(runtime2) * KW2 / 3600.0;

	last := TX;


	IF STATUS > BYTE#0 AND STATUS < BYTE#100 THEN
		fail := TRUE;
	ELSE
		fail := FALSE;
		IF NOT IN THEN
			STATUS := BYTE#110;
		ELSIF flame AND IN AND motor AND coil2 AND coil1 THEN
			STATUS := BYTE#113;
		ELSIF flame AND IN AND motor AND coil1 THEN
			STATUS := BYTE#112;
		ELSE
			STATUS := BYTE#111;
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

