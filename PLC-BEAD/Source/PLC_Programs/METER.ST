TYPE REAL2:
	
	STRUCT
		R1 : REAL;
		RX : REAL;
	END_STRUCT;

END_TYPE

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

FUNCTION_BLOCK METER_Block

	VAR_INPUT
		M1 :	REAL;
		M2 :	REAL;
		I1 :	BOOL;
		I2 :	BOOL;
		D :	REAL := 1.0;
		RST :	BOOL;
	END_VAR

	VAR_IN_OUT
		MX :	REAL;
	END_VAR


	VAR RETAIN 
		MR :	REAL2;
	END_VAR


	VAR
		MX1 :	REAL;(*current consumption value on M1 and M2*)
		MX2 :	REAL;(*current consumption value on M1 and M2*)
		tx :	UDINT;
		last :	UDINT;
		tc :	REAL;
		init :	BOOL;
		T_PLC_MS :	T_PLC_MS_Block;
		R2_ADD :	R2_ADD_Block;
	END_VAR


	T_PLC_MS();
	tx:= T_PLC_MS.T_PLC_MS;
	IF NOT init THEN
		init := TRUE;
		last := tx;
		mr.RX := mx;
		mr.R1 := 0.0;
	ELSIF tx = last THEN
		RETURN;
	ELSE
		tc := UDINT_TO_REAL(tx - last) * 0.001;
	END_IF;
	last := tx;

	(* reset *)
	IF rst THEN
		mr.R1 := 0.0;
		mr.RX := 0.0;
	ELSE
		MX1 := SEL(I1,0.0,M1);
		MX2 := SEL(I2,0.0,M2);
		R2_ADD(X:=MR,Y:=(SEL(I1,0.0,mx1) + SEL(I2, 0.0, mx2)) / D * TC);
		MR:=R2_ADD.R2_ADD;
		MX := mr.RX;
	END_IF;

END_FUNCTION_BLOCK


PROGRAM program0

	VAR
		M1 :	REAL;
		M2 :	REAL;
		I1 :	BOOL;
		I2 :	BOOL;
		D :	REAL := 1.0;
		RST :	BOOL;

		MX :	REAL;

		func_block : METER_Block;
	END_VAR

	func_block.M1 := M1;
	func_block.M2 := M2;
	func_block.I1 := I1;
	func_block.I2 := I2;
	func_block.D := D;
	func_block.RST := RST;
	func_block.MX := MX;

	func_block();

	MX  := func_block.MX;

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
