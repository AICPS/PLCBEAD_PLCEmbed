FUNCTION _REAL_TO_UDINT:UDINT
  VAR_INPUT
    X :	REAL;
  END_VAR

  IF REAL_TO_UDINT(0.5) = UDINT#1 THEN
    _REAL_TO_UDINT := REAL_TO_UDINT(x);
  ELSIF X > 0.0 THEN
    _REAL_TO_UDINT := REAL_TO_UDINT(x+0.5); 
  ELSIF X < 0.0 THEN 
    _REAL_TO_UDINT := REAL_TO_UDINT(x-0.5); 
  ELSE 
    _REAL_TO_UDINT := UDINT#0;
  END_IF;
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

FUNCTION_BLOCK DT_SIMU
	VAR_INPUT
		START :	UDINT;
		SPEED :	REAL := 1.0;
	END_VAR

	VAR_OUTPUT
		DTS :	UDINT;
	END_VAR

	VAR
		tc :	UDINT;
		init :	BOOL;
		last :	UDINT;
		tx :	UDINT;
		td :	UDINT;
		T_PLC_MS :	T_PLC_MS_block;
	END_VAR


	T_PLC_MS();
	tx:= T_PLC_MS.T_PLC_MS;
	tc := _REAL_TO_UDINT(UDINT_TO_REAL(tx - last) * speed);

	IF NOT init THEN
		init := TRUE;
		DTS := Start;
		tc := UDINT#0;
		last := tx;
	ELSIF SPEED = 0.0 THEN
		DTS := DTS + UDINT#1;
	ELSIF tc >= UDINT#1000 THEN
		td := (tc / UDINT#1000) * UDINT#1000;
		DTS := DTS + td;
		last := last + _REAL_TO_UDINT(UDINT_TO_REAL(td) / speed);
	END_IF;
END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : UDINT;
	LocalVar1 : REAL;
	LocalOUT  : UDINT;
	func_block : DT_SIMU;
  END_VAR
	func_block.START  := LocalVar0;
	func_block.SPEED  := LocalVar1;
	func_block();
	LocalOUT := func_block.DTS;
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