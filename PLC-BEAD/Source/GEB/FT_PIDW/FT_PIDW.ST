FUNCTION _REAL_TO_UDINT:UDINT
  VAR_INPUT
    X :	REAL;
  END_VAR

  IF REAL_TO_UDINT(0.5) = UDINT#1 THEN
    _REAL_TO_UDINT := REAL_TO_UDINT(X);
  ELSIF X > 0.0 THEN
    _REAL_TO_UDINT := REAL_TO_UDINT(X+0.5); 
  ELSIF X < 0.0 THEN 
    _REAL_TO_UDINT := REAL_TO_UDINT(X-0.5); 
  ELSE 
    _REAL_TO_UDINT := UDINT#0;
  END_IF;
END_FUNCTION

FUNCTION REAL_TO_TIME2:TIME
	VAR_INPUT
		IN :	REAL;
	END_VAR

	REAL_TO_TIME2 := DINT_TO_TIME(UDINT_TO_DINT(_REAL_TO_UDINT(IN)));
END_FUNCTION

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
	ELSIF RUN AND (TX - last) > UDINT#0 THEN
		OUT := (IN - old) / UDINT_TO_REAL(TX - last) * 1000000.0 * K;
	ELSE
		OUT := 0.0;
	END_IF;
	old := IN;
	last := TX;
END_FUNCTION_BLOCK
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

FUNCTION_BLOCK INTEGRATE

	VAR_INPUT
		E :	BOOL := TRUE;
		X :	REAL;
		K :	REAL := 1.0;
	END_VAR

	VAR_IN_OUT
		Y :	REAL;
	END_VAR

	VAR
		X_LAST :	REAL;
		init :	BOOL;
		T_PLC_MS :	T_PLC_MS_block;
		last :	UDINT;
		TX :	UDINT;
	END_VAR


	T_PLC_MS();
	TX:= T_PLC_MS.T_PLC_MS;

	IF NOT init THEN
		init := TRUE;
		X_LAST := X;
	ELSIF E THEN
		Y := (X + X_LAST) * 0.5E-3 * UDINT_TO_REAL(TX-last) * K + Y;
		X_LAST := X;
	END_IF;
	last := TX;

END_FUNCTION_BLOCK

FUNCTION_BLOCK FT_PIDW

	VAR_INPUT
		IN :	REAL;
		KP :	REAL := 1.0;
		TN :	REAL := 1.0;
		TV :	REAL := 1.0;
		LIM_L :	REAL := -1.0E38;
		LIM_H :	REAL := 1.0E38;
		RST :	BOOL := FALSE;
	END_VAR


	VAR_OUTPUT
		Y :	REAL;
		LIM :	BOOL;
	END_VAR


	VAR
		INTEG :	INTEGRATE;
		diff :	FT_DERIV;
		YI :	REAL;
	END_VAR


	IF TN = 0.0 OR RST THEN
		INTEG(E := FALSE, Y := YI);
		YI := INTEG.Y;
		YI := 0.0;
	ELSE
		INTEG(X := IN, K := 1.0 / TN, E := NOT LIM, Y := YI);
		YI := INTEG.Y;
	END_IF;

	(* add up INTEGrator and linear part *)
	Y := KP * (IN + YI);

	(* run differentiator *)
	diff(IN := IN, K := TV);

	(* set lim before differentiator is added to STOP INTEGrator if necessary *)
	IF Y > LIM_L AND Y < LIM_H THEN
		LIM := FALSE;
	ELSE
		LIM := TRUE;
	END_IF;

	Y := LIMIT(LIM_L, Y + KP * diff.OUT, LIM_H);

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		IN :	REAL;
		KP :	REAL := 1.0;
		TN :	REAL := 1.0;
		TV :	REAL := 1.0;
		LIM_L :	REAL := -1.0E38;
		LIM_H :	REAL := 1.0E38;
		RST :	BOOL := FALSE;

		Y :	REAL;
		LIM :	BOOL;

		func_block : FT_PIDW;
	END_VAR
	func_block.IN := IN;
	func_block.KP := KP;
	func_block.TN := TN;
	func_block.TV := TV;
	func_block.LIM_L := LIM_L;
	func_block.LIM_H := LIM_H;
	func_block.RST := RST;

	func_block();
	Y := func_block.Y;
	LIM := func_block.LIM;
END_PROGRAM

