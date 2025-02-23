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

FUNCTION_BLOCK FILTER_W
	VAR_INPUT
		X :	WORD;
		T :	TIME;
	END_VAR

	VAR_OUTPUT
		Y :	WORD;
	END_VAR

	VAR
		last :	UDINT;
		TX :	UDINT;
		init :	BOOL;
		tmp :	DINT;
		T_PLC_MS :	T_PLC_MS_block;
	END_VAR

	T_PLC_MS();
	TX:= T_PLC_MS.T_PLC_MS;

	IF NOT init OR T = T#0s THEN
		init := TRUE;
		last := TX;
		Y := X;
	ELSIF Y = X THEN
		last := TX;
	ELSE
		tmp := UINT_TO_DINT(WORD_TO_UINT(X) - WORD_TO_UINT(Y)) * UDINT_TO_DINT(TX - last) / TIME_TO_DINT(T);
		IF tmp <> DINT#0 THEN
			Y := DINT_TO_WORD(WORD_TO_DINT(Y) + tmp);
			last := TX;
		END_IF;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	X :	WORD;
	T :	TIME;

	Y :	WORD;

	func_block : FILTER_W;
  END_VAR
	func_block.X  := X;
	func_block.T  := T;
	func_block();
	Y := func_block.Y;
END_PROGRAM

