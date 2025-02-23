FUNCTION _REAL_TO_UDINT:UDINT
  VAR_INPUT
    X :	REAL;
  END_VAR

  IF REAL_TO_UDINT(0.5) = UDINT#1 THEN
    _REAL_TO_UDINT := REAL_TO_UDINT(x);
  ELSIF X > 0.0 THEN
    _REAL_TO_UDINT := REAL_TO_UDINT(x+0.5); 
  ELSIF X < 0.0 THEN 
    _REAL_TO_UDINT := REAL_TO_UDINT(x-0.5); 
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
		tx :	UDINT;
		last :	UDINT;
		init :	BOOL;
		tc :	REAL;
		T_PLC_US :	T_PLC_US_Block;
	END_VAR

	T_PLC_US();
	tx:= T_PLC_US.T_PLC_US;
	tc := UDINT_TO_REAL(tx - last);

	IF NOT init THEN
		init := TRUE;
		old := in;
	ELSIF run AND tc > 0.0 THEN
		out := (in - old) / tc * 1000000.0 * K;
		old := in;
	ELSE
		out := 0.0;
	END_IF;

	last := tx;

	T_PLC_US();
	tx:= T_PLC_US.T_PLC_US;

	IF NOT init THEN
		init := TRUE;
	ELSIF run AND tx - last > UDINT#0 THEN
		out := (in - old) / UDINT_TO_REAL(tx - last) * 1000000.0 * K;
	ELSE
		out := 0.0;
	END_IF;
	old := in;
	last := tx;
END_FUNCTION_BLOCK

FUNCTION_BLOCK FT_PT1

	VAR_INPUT
		IN :	REAL;
		T :	TIME;
		K :	REAL := 1.0;
	END_VAR

	VAR_OUTPUT
		OUT :	REAL;
	END_VAR

	VAR
		last :	UDINT;
		tx :	UDINT;
		init :	BOOL;
		T_PLC_US :	T_PLC_US_Block;
	END_VAR

	T_PLC_US();
	tx:= T_PLC_US.T_PLC_US;

	IF NOT init OR T = t#0s THEN
		init := TRUE;
		out := K * in;
	ELSE
		out := out + (in * K - out) * UDINT_TO_REAL(Tx - last) / TIME_TO_REAL(T) * 1.0E-3;
		IF ABS(out) < 1.0E-20 THEN out := 0.0; END_IF;
	END_IF;
	last := tx;
END_FUNCTION_BLOCK

FUNCTION_BLOCK FT_PDT1_Block

	VAR_INPUT
		IN :	REAL;
		KP :	REAL := 1.0;
		TV :	REAL := 1.0;
		T1 :	REAL := 1.0;
	END_VAR

	VAR_OUTPUT
		Y :	REAL;
	END_VAR

	VAR
		diff :	FT_DERIV;
		_TP :	FT_PT1;
	END_VAR

	diff(IN := IN, K := TV);

	_tp(in := diff.out, T := REAL_TO_TIME2(T1));

	Y := KP * (_tp.out + IN);

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		IN :	REAL;
		KP :	REAL := 1.0;
		TV :	REAL := 1.0;
		T1 :	REAL := 1.0;

		Y :	REAL;
		func_block : FT_PDT1_Block;
	END_VAR
	func_block.IN :=IN;
	func_block.KP :=KP;
	func_block.TV :=TV;
	func_block.T1 :=T1;
	func_block();
	Y := func_block.Y;
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