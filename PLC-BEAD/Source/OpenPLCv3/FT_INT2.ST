FUNCTION_BLOCK R2_SET_Block

	VAR_INPUT
		X :	REAL;
	END_VAR

	VAR_OUTPUT
		R2_SET :	REAL2;
	END_VAR

	R2_SET.RX := X;
	R2_SET.R1 := 0.0;

END_FUNCTION_BLOCK

FUNCTION_BLOCK R2_ADD_Block

	VAR_INPUT
		X :	REAL2;
		Y :	REAL;
	END_VAR

	VAR_OUTPUT
		R2_ADD :	REAL2;
	END_VAR

	VAR
		temp :	REAL;
	END_VAR


	temp := X.RX;
	R2_ADD.RX := Y + X.R1 + X.RX;
	R2_ADD.R1 := temp - R2_ADD.RX + Y + X.R1;

END_FUNCTION_BLOCK

TYPE REAL2:
	
	STRUCT
		R1 : REAL;
		RX : REAL;
	END_STRUCT;

END_TYPE

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

FUNCTION_BLOCK FT_INT2_Block

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
		integ :	INTEGRATE;
		ix :	REAL;
		val :	REAL2;
		R2_ADD :	R2_ADD_Block;
		R2_SET :	R2_SET_Block;
	END_VAR

	IF RST THEN
		R2_SET(X:=0.0);
		val:=R2_SET.R2_SET;
		out := 0.0;
	ELSE
		integ(X := IN, E := RUN, K := K, Y := ix);
		ix := integ.Y;
		R2_ADD(X:=val,Y:=ix);
		val:=R2_ADD.R2_ADD;
		ix := 0.0;
		OUT := val.RX;
	END_IF;

	(* check output for limits *)
	IF out > OUT_MIN AND out < OUT_MAX THEN
		LIM := FALSE;
	ELSE
		OUT := LIMIT(OUT_MIN, OUT, OUT_MAX);
		R2_SET(X:=OUT);
		val:=R2_SET.R2_SET;
		LIM := TRUE;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	IN :	REAL;
	K :	REAL := 1.0;
	RUN :	BOOL := TRUE;
	RST :	BOOL;
	OUT_MIN :	REAL := REAL#-1.0E-37;
	OUT_MAX :	REAL := REAL#1.0E37;

	OUT :	REAL;
	LIM :	BOOL;

	func_block : FT_INT2_Block;
  END_VAR
	func_block.IN :=IN ;
	func_block.K :=K  ;
	func_block.RUN :=RUN  ;
	func_block.RST :=RST ;
	func_block.OUT_MIN :=OUT_MIN  ;
	func_block.OUT_MAX :=OUT_MAX  ;
	func_block();
	OUT := func_block.OUT;
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
