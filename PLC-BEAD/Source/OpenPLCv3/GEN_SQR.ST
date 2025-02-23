FUNCTION UDINT_TO_TIME2:TIME

	VAR_INPUT
		IN :	UDINT;
	END_VAR


	UDINT_TO_TIME2 := DINT_TO_TIME(UDINT_TO_DINT(IN));

END_FUNCTION

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

FUNCTION MODR : REAL
  VAR_INPUT
    IN : REAL;
    DIVI : REAL;
  END_VAR

  IF divi = 0.0 THEN
  	MODR := 0.0;
  ELSE
  	MODR := in - DINT_TO_REAL(FLOOR2(in / divi)) * divi;
  END_IF;
END_FUNCTION

FUNCTION FLOOR2 : DINT
  VAR_INPUT
    x : REAL;
  END_VAR

  FLOOR2 := REAL_TO_DINT(X);
  IF DINT_TO_REAL(FLOOR2) > X THEN
  	FLOOR2 := FLOOR2 - DINT#1;
  END_IF;
END_FUNCTION

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

FUNCTION_BLOCK GEN_SQR_Block

	VAR_INPUT
		PT :	TIME;
		AM :	REAL := REAL#1.0;
		OS :	REAL;
		DC :	REAL := REAL#0.5;
		DL :	REAL;
	END_VAR


	VAR_OUTPUT
		Q :	BOOL;
		Out :	REAL;
	END_VAR


	VAR
		tx :	TIME;
		last :	TIME;
		init :	BOOL;
		T_PLC_MS :	T_PLC_MS_Block;
	END_VAR

	IF dc = 0.0 THEN
		out := -am * 0.5 + os;
		Q := FALSE;
		RETURN;
	ELSIF dc = 1.0 THEN
		out := am * 0.5 + os;
		Q := TRUE;
		RETURN;
	END_IF;

	T_PLC_MS();
	tx:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS) - last;
	DL := modR(dl,1.0);
	IF dl < 0.0 THEN dl := 1.0 - dl; END_IF;
	dc := modR(dc,1.0);
	IF dc < 0.0 THEN dc := 1.0 - dc; END_IF;

	IF NOT init THEN
		init := TRUE;
		last := tx;
		tx := t#0s;
	END_IF;

	IF tx >= pt THEN
		last := last + pt;
		tx := tx - pt;
	END_IF;

	IF multime(pt, dl + dc) >= pt THEN
		IF tx >= multime(pt, dl + dc - 1.0) THEN
			out := -am * 0.5 + os;
			Q := FALSE;
		END_IF;
		IF tx >= multime(pt, dl) THEN
			out := am * 0.5 + os;
			Q := TRUE;
		END_IF;
	ELSE
		IF tx >= multime(pt, dl) THEN
			out := am * 0.5 + os;
			Q := TRUE;
		END_IF;
		IF tx >= multime(pt, dl + dc) THEN
			out := -am * 0.5 +os;
			Q := FALSE;
		END_IF;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	PT :	TIME;
	AM :	REAL := REAL#1.0;
	OS :	REAL;
	DC :	REAL := REAL#0.5;
	DL :	REAL;
	Q :	BOOL;
	Out :	REAL;
	func_block : GEN_SQR_Block;
  END_VAR
	func_block.PT  :=PT;
	func_block.AM  :=AM;
	func_block.OS  :=OS;
	func_block.DC  :=DC;
	func_block.DL  :=DL;
	func_block();
	Q := func_block.Q;
	OUT := func_block.OUT;
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