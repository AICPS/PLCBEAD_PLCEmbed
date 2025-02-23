FUNCTION_BLOCK T_PLC_US_Block
	VAR_OUTPUT
		T_PLC_US :	UDINT;
	END_VAR

	VAR_EXTERNAL
		PLC_TICKS_PER_SEC :	INT;
		PLC_SYS_TICK_CNT :	DINT;
	END_VAR

	VAR
		debug :	BOOL;
		N :	INT;
		Offset :	UDINT;
		temp :	DWORD := DWORD#1;
		mode :	BOOL;
		faktor :	UDINT;
		init :	BOOL;
		v_plc_ticks_per_sec :	UDINT;
		base :	UDINT := UDINT#1000000;
	END_VAR

	IF init = FALSE THEN
		v_plc_ticks_per_sec := INT_TO_UDINT(PLC_TICKS_PER_SEC);
		IF v_plc_ticks_per_sec = UDINT#1024 THEN
			faktor := UDINT#1000;
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
		T_PLC_US := DINT_TO_UDINT(PLC_SYS_TICK_CNT) / faktor;
	ELSE
		T_PLC_US := DINT_TO_UDINT(PLC_SYS_TICK_CNT) * faktor;
	END_IF;

	IF debug THEN
		T_PLC_US := (DWORD_TO_UDINT(SHL(UDINT_TO_DWORD(T_PLC_US),N) OR SHL(temp,N)) - UDINT#1) + Offset;
	END_IF;
END_FUNCTION_BLOCK

FUNCTION_BLOCK TC_S_Block

	VAR_OUTPUT
		TC :	REAL;
	END_VAR

	VAR
		init :	BOOL;
		tx :	UDINT;
		last :	UDINT;
		T_PLC_US :	T_PLC_US_Block;
	END_VAR

	T_PLC_US();
	tx:= T_PLC_US.T_PLC_US;

	IF NOT init THEN
		init := TRUE;
		TC := 0.0;
	ELSE
		tc := UDINT_TO_REAL(tx - last) * 1.0E-6;
	END_IF;
	last := tx;

END_FUNCTION_BLOCK

FUNCTION_BLOCK SRAMP_Block

	VAR_INPUT
		X :	REAL;
		A_UP :	REAL;
		A_DN :	REAL;
		VU_MAX :	REAL;
		VD_MAX :	REAL;
		LIMIT_HIGH :	REAL;
		LIMIT_LOW :	REAL;
		RST :	BOOL;
	END_VAR

	VAR_OUTPUT
		Y :	REAL;
		V :	REAL;
	END_VAR

	VAR
		cycle_time :	TC_S_Block;
		init :	BOOL;
	END_VAR

	cycle_time();

	A_up := MAX(0.0,A_UP);
	A_dn := MIN(0.0,A_dn);
	VU_max := MAX(0.0,VU_max);
	VD_max := MIN(0.0,VD_MAX);

	IF rst OR NOT init THEN
		init := TRUE;
		Y := 0.0;
		V := 0.0;
	ELSIF X = Y THEN
		v := 0.0;
	ELSIF X > Y THEN
		v := MIN(v + A_UP * cycle_time.TC, vu_max);
		v := MIN(SQRT((Y-X) * 2.0 * A_DN), v);
		y := LIMIT(limit_low, y + MIN(v * cycle_time.TC, X-Y), limit_high);
	ELSIF X < Y THEN
		v := MAX(v + A_DN * cycle_time.TC, vd_max);
		v := MAX(-SQRT((Y-X) * 2.0 * A_UP), v);
		y := LIMIT(limit_low, y + MAX(v * cycle_time.TC, X-Y), limit_high);
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		X :	REAL;
		A_UP :	REAL;
		A_DN :	REAL;
		VU_MAX :	REAL;
		VD_MAX :	REAL;
		LIMIT_HIGH :	REAL;
		LIMIT_LOW :	REAL;
		RST :	BOOL;
		Y :	REAL;
		V :	REAL;
		func_block : SRAMP_Block;
	END_VAR
		func_block.X  := X;
		func_block.A_UP  := A_UP;
		func_block.A_DN  := A_DN;
		func_block.VU_MAX  := VU_MAX;
		func_block.VD_MAX  := VD_MAX;
		func_block.LIMIT_HIGH  := LIMIT_HIGH;
		func_block.LIMIT_LOW  := LIMIT_LOW;
		func_block.RST  := RST;
		func_block();
		Y := func_block.Y;
		V := func_block.V;

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