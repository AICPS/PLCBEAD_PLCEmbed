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

FUNCTION_BLOCK F_LAMP_Block

	VAR_INPUT
		SWITCH :	BOOL;
		DIMM :	BYTE := BYTE#255;
		RST :	BOOL;
		T_NO_DIMM :	UINT := UINT#100;
		T_MAINTENANCE :	UINT := UINT#15000;
	END_VAR


	VAR_OUTPUT
		LAMP :	BYTE;
		STATUS :	BYTE;
	END_VAR


	VAR_IN_OUT
		ONTIME :	UDINT;
		CYCLES :	UDINT;
	END_VAR


	VAR
		runtime :	ONTIME_Block;
	END_VAR

	runtime(in := switch, SECONDS := ONTIME , CYCLES := CYCLES);
	CYCLES := runtime.CYCLES;
	ONTIME := runtime.SECONDS;

	IF RST THEN
		ONTIME := UDINT#0;
		CYCLES := UDINT#0;
	END_IF;
	IF SWITCH THEN
		IF ontime < UINT_TO_UDINT(T_NO_DIMM) * UDINT#3600 THEN
			LAMP := BYTE#255;
			STATUS := BYTE#111;
		ELSE
			LAMP := DIMM;
			STATUS := BYTE#112;
		END_IF;
	ELSE
		LAMP := BYTE#0;
		STATUS := BYTE#110;
	END_IF;

	IF ontime >= UINT_TO_UDINT(T_maintenance) * UDINT#3600 AND T_Maintenance > UINT#0 THEN
		STATUS := BYTE#120;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
	    SWITCH :	BOOL;
		DIMM :	BYTE := BYTE#255;
		RST :	BOOL;
		T_NO_DIMM :	UINT := UINT#100;
		T_MAINTENANCE :	UINT := UINT#15000;
		ONTIME :	UDINT;
		CYCLES :	UDINT;
		LAMP :	BYTE;
		STATUS :	BYTE;

		func_block : F_LAMP_Block;
  	END_VAR
	func_block.SWITCH := SWITCH;
	func_block.DIMM := DIMM;
	func_block.RST := RST;
	func_block.T_NO_DIMM := T_NO_DIMM;
	func_block.T_MAINTENANCE := T_MAINTENANCE;
	func_block.ONTIME := ONTIME;
	func_block.CYCLES := CYCLES;

	func_block();
	ONTIME := func_block.ONTIME;
	CYCLES := func_block.CYCLES;
	LAMP := func_block.LAMP;
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