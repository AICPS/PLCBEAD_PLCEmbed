FUNCTION_BLOCK T_PLC_MS_Block
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

FUNCTION_BLOCK RTC_MS_Block

	VAR_INPUT
		SET :	BOOL;
		SDT :	UDINT;
		SMS :	INT;
	END_VAR


	VAR_OUTPUT
		XDT :	UDINT;
		XMS :	INT;
	END_VAR


	VAR
		init :	BOOL;
		last :	UDINT;
		tx :	UDINT;
		T_PLC_MS :	T_PLC_MS_Block;
	END_VAR

	T_PLC_MS();
	tx:= T_PLC_MS.T_PLC_MS;

	IF set OR NOT init THEN
		(* clock needs to be set when set is true or after power up *)
		init := TRUE;
		xdt := SDT;
		XMS := SMS;
	ELSE
		XMS := XMS + UDINT_TO_INT(tx - last);
		(* check if one second has expired *)
		IF XMS > 999 THEN
			XDT := XDT + UDINT#1; (* add one second *)
			XMS := XMS - 1000;
		END_IF;
	END_IF;
	last := tx;

END_FUNCTION_BLOCK


PROGRAM program0

	VAR
		SET :	BOOL;
		SDT :	UDINT;
		SMS :	INT;
		XDT :	UDINT;
		XMS :	INT;
		func_block : RTC_MS_Block;
  	END_VAR
	func_block.SET  :=	SET;
	func_block.SDT  :=	SDT;
	func_block.SMS  :=	SMS;
	func_block();
	XDT := func_block.XDT;
	XMS := func_block.XMS;

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