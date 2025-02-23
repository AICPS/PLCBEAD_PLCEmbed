FUNCTION_BLOCK R2_SET_Block

	VAR_INPUT
		X :	REAL;
	END_VAR

	VAR_OUTPUT
		R2_SET :	REAL2;
	END_VAR

	R2_SET.RX := X;
	R2_SET.R1  := 0.0;

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
	R2_ADD.RX := Y + X.R1  + X.RX;
	R2_ADD.R1  := temp - R2_ADD.RX + Y + X.R1 ;

END_FUNCTION_BLOCK

TYPE REAL2:
	
	STRUCT
		R1  : REAL;
		RX : REAL;
	END_STRUCT;

END_TYPE

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
		INTEG :	INTEGRATE;
		ix :	REAL;
		VAL :	REAL2;
		R2_ADD :	R2_ADD_Block;
		R2_SET :	R2_SET_Block;
	END_VAR

	IF RST THEN
		R2_SET(X:=0.0);
		VAL:=R2_SET.R2_SET;
		OUT := 0.0;
	ELSE
		INTEG(X := IN, E := RUN, K := K, Y := ix);
		ix := INTEG.Y;
		R2_ADD(X:=VAL,Y:=ix);
		VAL:=R2_ADD.R2_ADD;
		ix := 0.0;
		OUT := VAL.RX;
	END_IF;

	(* check OUTput for limits *)
	IF OUT > OUT_MIN AND OUT < OUT_MAX THEN
		LIM := FALSE;
	ELSE
		OUT := LIMIT(OUT_MIN, OUT, OUT_MAX);
		R2_SET(X:=OUT);
		VAL:=R2_SET.R2_SET;
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

