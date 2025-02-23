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
		TX :	TIME;
		init :	BOOL;
		T_PLC_MS :	T_PLC_MS_block;
	END_VAR

	T_PLC_MS();
	TX:= SUB_TIME(UDINT_TO_TIME(T_PLC_MS.T_PLC_MS) , last_cycle);

	IF RST THEN
		CT_MIN := t#10h;
		CT_MAX := t#0ms;
		CYCLES := DWORD#0;
	ELSIF last_cycle > t#0s THEN
		IF TX < CT_MIN THEN CT_MIN := TX;
		ELSIF TX > CT_MAX THEN CT_MAX := TX;
		END_IF;
		CT_LAST := TX;
	ELSIF CT_MIN = t#0s THEN
		CT_MIN := SUB_TIME(t#0s, t#1ms);
	END_IF;
	IF init THEN
		SYSTIME := ADD_TIME(SYSTIME, TX);
			IF SYSTIME >= t#1d THEN
				SYSTIME := SUB_TIME(SYSTIME , t#1d);
				SYSDAYS := SYSDAYS + 1;
			END_IF;
	END_IF;
	init := TRUE;
	last_cycle := ADD_TIME(last_cycle , TX);
	CYCLES := UDINT_TO_DWORD(DWORD_TO_UDINT(CYCLES) + UDINT#1);

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

