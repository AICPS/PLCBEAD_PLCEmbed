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

FUNCTION _REAL_TO_DWORD: DWORD

  VAR_INPUT
    X :	REAL;
  END_VAR

  IF REAL_TO_DWORD(0.5) = DWORD#1 THEN
    _REAL_TO_DWORD := REAL_TO_DWORD(x);
  ELSIF X > 0.0 THEN
    _REAL_TO_DWORD := REAL_TO_DWORD(x+0.5); 
  ELSIF X < 0.0 THEN 
    _REAL_TO_DWORD := REAL_TO_DWORD(x-0.5); 
  ELSE 
    _REAL_TO_DWORD := DWORD#0;
  END_IF;
END_FUNCTION

FUNCTION _DWORD_TO_REAL:REAL
	VAR_INPUT
		IN :	DWORD;
	END_VAR

	_DWORD_TO_REAL := UDINT_TO_REAL(DWORD_TO_UDINT(IN));
END_FUNCTION

FUNCTION MULTIME:TIME
	VAR_INPUT
		T :	TIME;
		M :	REAL;
	END_VAR

	multime := DWORD_TO_TIME(_REAL_TO_DWORD(_DWORD_TO_REAL(TIME_TO_DWORD(t))*M));
END_FUNCTION

FUNCTION_BLOCK DEAD_BAND_A
	VAR_INPUT
		X :	REAL;
		T :	TIME;
		KL :	REAL := 1.0;
		LM :	REAL;
	END_VAR

	VAR_OUTPUT
		Y :	REAL;
		L :	REAL;
	END_VAR

	VAR
		tp1 :	FT_PT1;
		tp2 :	FT_PT1;
	END_VAR

	tp1(in := X, T:= T);
	tp2(in := ABS(tp1.out - X), T := MULTIME(T, 4.0));
	L := MIN(KL * tp2.out, LM);

	IF X > L THEN
		Y := X - L;
	ELSIF X < -L THEN
		Y := X + L;
	ELSE
		Y := 0.0;
	END_IF;
END_FUNCTION_BLOCK

PROGRAM program0
  VAR

		X  :	REAL;
		T  :	TIME;
		KL :	REAL;
		LM :	REAL;

		Y :	REAL;
		L :	REAL;

	func_block : DEAD_BAND_A;
  END_VAR
	func_block.X   :=X ;
	func_block.T   :=T ;
	func_block.KL  :=KL;
	func_block.LM  :=LM;
	func_block();
	Y := func_block.Y;
	L := func_block.L;
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