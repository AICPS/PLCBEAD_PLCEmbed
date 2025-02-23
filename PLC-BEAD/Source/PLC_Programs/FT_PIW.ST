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
		X_last :	REAL;
		init :	BOOL;
		T_PLC_MS :	T_PLC_MS_block;
		last :	UDINT;
		tx :	UDINT;
	END_VAR


	T_PLC_MS();
	tx:= T_PLC_MS.T_PLC_MS;

	IF NOT init THEN
		init := TRUE;
		X_last := X;
	ELSIF E THEN
		Y := (X + X_LAST) * 0.5E-3 * UDINT_TO_REAL(tx-last) * K + Y;
		X_last := X;
	END_IF;
	last := tx;

END_FUNCTION_BLOCK

FUNCTION_BLOCK FT_INT_Block

	VAR_INPUT
		IN :	REAL;
		K :	REAL := 1.0;
		RUN :	BOOL := TRUE;
		RST :	BOOL;
		OUT_MIN :	REAL := REAL#-1.0E-37;
		OUT_MAX :	REAL := REAL#1.0E37;
	END_VAR

	VAR_OUTPUT
		OUT :	REAL;
		LIM :	BOOL;
	END_VAR

	VAR
		INTEG :	INTEGRATE;
	END_VAR


	IF rst THEN
		out := 0.0;
	ELSE
		integ(X := IN, E := RUN, K := K, Y := out);
		out := integ.Y;
	END_IF;

	(* limit the outputs *)
	IF out >= OUT_MAX THEN
		out := out_max;
		LIM := TRUE;
	ELSIF out <= out_min THEN
		out := out_min;
		lim := TRUE;
	ELSE
		lim := FALSE;
	END_IF;

END_FUNCTION_BLOCK

FUNCTION_BLOCK FT_PIW

	VAR_INPUT
		IN :	REAL;
		KP :	REAL := 1.0;
		KI :	REAL := 1.0;
		LIM_L :	REAL := -1.0E38;
		LIM_H :	REAL := 1.0E38;
		RST :	BOOL := FALSE;
	END_VAR

	VAR_OUTPUT
		Y :	REAL;
		LIM :	BOOL;
	END_VAR

	VAR
		integ :	FT_INT_Block;
	END_VAR

	integ(IN := IN, K := KI, RUN := NOT LIM, RST := RST);

	(* set output value *)
	Y := KP * IN + integ.Out;

	(* check for limits *)
	IF Y < LIM_L THEN
		Y := LIM_L;
		LIM := TRUE;
	ELSIF Y > LIM_H THEN
		Y := LIM_H;
		LIM := TRUE;
	ELSE
		LIM := FALSE;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		IN :	REAL;
		KP :	REAL := 1.0;
		KI :	REAL := 1.0;
		LIM_L :	REAL := -1.0E38;
		LIM_H :	REAL := 1.0E38;
		RST :	BOOL := FALSE;

		Y :	REAL;
		LIM :	BOOL;

		func_block : FT_PIW;
	END_VAR
	func_block.IN := IN;
	func_block.KP := KP;
	func_block.KI := KI;
	func_block.LIM_L := LIM_L;
	func_block.LIM_H := LIM_H;
	func_block.RST := RST;
	func_block();
	Y := func_block.Y;
	LIM := func_block.LIM;
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
