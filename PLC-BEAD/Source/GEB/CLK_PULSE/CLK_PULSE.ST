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

FUNCTION TIME_TO_UDINT2:UDINT
	VAR_INPUT
		X :	TIME;
	END_VAR

	TIME_TO_UDINT2 := DINT_TO_UDINT(TIME_TO_DINT(X));
END_FUNCTION

FUNCTION_BLOCK CLK_PULSE
	VAR_INPUT
		PT :	TIME;
		N :	INT;
		RST :	BOOL;
	END_VAR

	VAR_OUTPUT
		Q :	BOOL;
		CNT :	INT;
		RUN :	BOOL;
	END_VAR

	VAR
		TX :	UDINT;
		tn :	UDINT;
		init :	BOOL;
		T_PLC_MS :	T_PLC_MS_block;
	END_VAR

	T_PLC_MS();
	TX:= T_PLC_MS.T_PLC_MS;
	Q := FALSE;				(* reset Q we generate pulses only for one cycle *)
	RUN := CNT < N;

	IF NOT init OR RST THEN
		init := TRUE;
		CNT := 0;
		tn := TX - TIME_TO_UDINT2(PT);
		RUN := FALSE;
	ELSIF (CNT < N OR N = 0) AND TX - tn >= TIME_TO_UDINT2(PT) THEN		(* generate a pulse *)
		CNT := CNT + 1;
		Q := TRUE;
		tn := tn + TIME_TO_UDINT2(PT);
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : TIME;
	LocalVaR1  : INT;
	LocalVaR2 : BOOL;

	Q :	BOOL;
	CNT :	INT;
	RUN :	BOOL;
	func_block : CLK_PULSE;
  END_VAR
	func_block.PT  := LocalVar0;
	func_block.N  := LocalVaR1 ;
	func_block.RST  := LocalVaR2;
	func_block();
	Q:= func_block.Q;
	CNT := func_block.CNT;
	RUN := func_block.RUN;

END_PROGRAM

