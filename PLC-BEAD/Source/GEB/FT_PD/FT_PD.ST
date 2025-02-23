FUNCTION_BLOCK T_PLC_US_Block
	VAR_OUTPUT
		T_PLC_US :	UDINT;
	END_VAR

	VAR
		PLC_TICKS_PER_SEC :	INT;
		PLC_SYS_TICK_CNT :	DINT;
	END_VAR

	VAR
		debug :	BOOL;
		N :	INT;
		Offset :	UDINT;
		temp :	DWORD := DWORD#1;
		MODE :	BOOL;
		faktor :	UDINT;
		init :	BOOL;
		v_plc_ticks_per_sec :	UDINT;
		base :	UDINT := UDINT#1000000;
	END_VAR

	IF init = FALSE THEN
		v_plc_ticks_per_sec := INT_TO_UDINT(PLC_TICKS_PER_SEC);
		IF v_plc_ticks_per_sec = UDINT#1024 THEN
			faktor := UDINT#1000;
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
		T_PLC_US := DINT_TO_UDINT(PLC_SYS_TICK_CNT) / faktor;
	ELSE
		T_PLC_US := DINT_TO_UDINT(PLC_SYS_TICK_CNT) * faktor;
	END_IF;

	IF debug THEN
		T_PLC_US := (DWORD_TO_UDINT(SHL(UDINT_TO_DWORD(T_PLC_US),N) OR SHL(temp,N)) - UDINT#1) + Offset;
	END_IF;
END_FUNCTION_BLOCK

FUNCTION_BLOCK FT_DERIV
	VAR_INPUT
		IN :	REAL;
		K :	REAL := 1.0;
		RUN :	BOOL := TRUE;
	END_VAR

	VAR_OUTPUT
		OUT :	REAL;
	END_VAR

	VAR
		old :	REAL;
		TX :	UDINT;
		last :	UDINT;
		init :	BOOL;
		tc :	REAL;
		T_PLC_US :	T_PLC_US_Block;
	END_VAR

	T_PLC_US();
	TX:= T_PLC_US.T_PLC_US;
	tc := UDINT_TO_REAL(TX - last);

	IF NOT init THEN
		init := TRUE;
		old := IN;
	ELSIF RUN AND tc > 0.0 THEN
		OUT := (IN - old) / tc * 1000000.0 * K;
		old := IN;
	ELSE
		OUT := 0.0;
	END_IF;

	last := TX;

	T_PLC_US();
	TX:= T_PLC_US.T_PLC_US;

	IF NOT init THEN
		init := TRUE;
	ELSIF RUN AND TX - last > UDINT#0 THEN
		OUT := (IN - old) / UDINT_TO_REAL(TX - last) * 1000000.0 * K;
	ELSE
		OUT := 0.0;
	END_IF;
	old := IN;
	last := TX;
END_FUNCTION_BLOCK

FUNCTION_BLOCK FT_PD_Block

	VAR_INPUT
		IN :	REAL;
		KP :	REAL := 1.0;
		TV :	REAL := 1.0;
	END_VAR

	VAR_OUTPUT
		Y :	REAL;
	END_VAR

	VAR
		diff :	FT_DERIV;
	END_VAR

	diff(IN := IN, K := TV);

	Y := KP * (diff.OUT + IN);

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		IN :	REAL;
		KP :	REAL := 1.0;
		TV :	REAL := 1.0;
		Y :	REAL;
		func_block : FT_PD_Block;
	END_VAR
	func_block.IN :=IN;
	func_block.KP :=KP;
	func_block.TV :=TV;
	func_block();
	Y := func_block.Y;
END_PROGRAM

