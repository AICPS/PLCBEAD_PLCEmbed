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


FUNCTION_BLOCK CYCLE_TIME
	VAR_INPUT
		RST :	BOOL;
	END_VAR

	VAR_OUTPUT
		CT_MIN :	TIME := t#0s;
		CT_MAX :	TIME := t#0s;
		CT_LAST :	TIME;
		SYSTIME :	TIME;
		SYSDAYS :	INT;
		CYCLES :	DWORD;
	END_VAR

	VAR
		last_cycle :	TIME;
		tx :	TIME;
		init :	BOOL;
		T_PLC_MS :	T_PLC_MS_block;
	END_VAR

	T_PLC_MS();
	tx:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS) - last_cycle;

	IF rst THEN
		ct_min := t#10h;
		ct_max := t#0ms;
		cycles := DWORD#0;
	ELSIF last_cycle > t#0s THEN
		IF tx < ct_min THEN ct_min := tx;
		ELSIF tx > ct_max THEN ct_max := tx;
		END_IF;
		ct_last := tx;
	ELSIF ct_min = t#0s THEN
		ct_min := t#0s - t#1ms;
	END_IF;
	IF init THEN
		systime := systime + tx;
			IF systime >= t#1d THEN
				systime := systime - t#1d;
				sysdays := sysdays + 1;
			END_IF;
	END_IF;
	init := TRUE;
	last_cycle := last_cycle + tx;
	cycles := UDINT_TO_DWORD(DWORD_TO_UDINT(cycles) + UDINT#1);

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	RST :	BOOL;

	CT_MIN  :	TIME;
	CT_MAX  :	TIME;
	CT_LAST :	TIME;
	SYSTIME :	TIME;
	SYSDAYS :	INT;
	CYCLES  :	DWORD;

	func_block : CYCLE_TIME;
  END_VAR
	func_block.RST   :=RST ;
	func_block();
	CT_MIN := func_block.CT_MIN ;
	CT_MAX := func_block.CT_MAX ;
	CT_LAST:= func_block.CT_LAST;
	SYSTIME:= func_block.SYSTIME;
	SYSDAYS:= func_block.SYSDAYS;
	CYCLES := func_block.CYCLES ;
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