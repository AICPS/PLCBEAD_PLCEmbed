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

FUNCTION_BLOCK ACTUATOR_PUMP_Block

	VAR_INPUT
		IN :	BOOL;
		MANUAL :	BOOL;
		RST :	BOOL := FALSE;
		MIN_ONTIME :	TIME := T#10s;
		MIN_OFFTIME :	TIME := T#10s;
		RUN_EVERY :	TIME := T#10000m;
	END_VAR


	VAR_OUTPUT
		PUMP :	BOOL;
		RUNTIME :	UDINT;
		CYCLES :	UDINT;
	END_VAR


	VAR
		TX :	TIME;
		last_CHAnge :	TIME;
		meter :	ONTIME_Block;
		old_man :	BOOL;
		init :	BOOL;
		T_PLC_MS :	T_PLC_MS_block;
	END_VAR

	T_PLC_MS();
	TX:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

	IF NOT init THEN
		init := TRUE;
		last_CHAnge := TX;
	ELSIF RST THEN
		RST := FALSE;
		runtime := UDINT#0;
		CYCLES := UDINT#0;
	ELSIF MANUAL AND NOT pump AND NOT old_man THEN
		last_CHAnge := TX;
		pump := TRUE;
	ELSIF NOT MANUAL AND old_man AND pump AND NOT IN THEN
		last_CHAnge := TX;
		pump := FALSE;
	ELSIF IN AND NOT pump AND SUB_TIME(TX, last)_CHAnge >= min_offtime THEN
		last_CHAnge := TX;
		pump := TRUE;
	ELSIF pump AND NOT IN AND NOT MANUAL AND SUB_TIME(TX, last)_CHAnge >= min_ontime THEN
		last_CHAnge := TX;
		pump := FALSE;
	ELSIF NOT pump AND (SUB_TIME(TX, last)_CHAnge >= run_every) AND (run_every > T#0s) THEN
		last_CHAnge := TX;
		pump := TRUE;
	END_IF;

	meter(IN := pump, SECONDS := runtime, CYCLES := CYCLES);
	CYCLES := meter.CYCLES;
	runtime := meter.SECONDS;

	old_man := MANUAL;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		IN :	BOOL;
		MANUAL :	BOOL;
		RST :	BOOL := FALSE;
		MIN_ONTIME :	TIME := T#10s;
		MIN_OFFTIME :	TIME := T#10s;
		RUN_EVERY :	TIME := T#10000m;
		PUMP :	BOOL;
		RUNTIME :	UDINT;
		CYCLES :	UDINT;
		func_block : ACTUATOR_PUMP_Block;
	END_VAR
	func_block.IN := IN;
	func_block.MANUAL := MANUAL;
	func_block.RST := RST ;
	func_block.MIN_ONTIME := MIN_ONTIME;
	func_block.MIN_OFFTIME := MIN_OFFTIME;
	func_block.RUN_EVERY := RUN_EVERY ;
	func_block();
	PUMP  := func_block.PUMP;
	RUNTIME  := func_block.RUNTIME;
	CYCLES  := func_block.CYCLES;
END_PROGRAM

