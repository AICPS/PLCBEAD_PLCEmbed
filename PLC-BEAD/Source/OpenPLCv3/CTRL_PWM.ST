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

FUNCTION_BLOCK CLK_PRG
	VAR_INPUT
		PT :	TIME := T#10ms;
	END_VAR

	VAR_OUTPUT
		Q :	BOOL;
	END_VAR

	VAR
		init :	BOOL := FALSE;
		last :	TIME;
		tx :	TIME;
		T_PLC_MS :	T_PLC_MS_block;
	END_VAR


	T_PLC_MS();
	tx:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

	IF NOT init THEN
		init := TRUE;
		last := tx - pt;
	END_IF;

	Q := tx - last >= pt;
	IF Q THEN last := tx; END_IF;
END_FUNCTION_BLOCK

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

FUNCTION_BLOCK TP_X
	VAR_INPUT
		IN :	BOOL;
		PT :	TIME;
	END_VAR


	VAR_OUTPUT
		Q :	BOOL;
		ET :	TIME;
	END_VAR


	VAR
		edge :	BOOL;
		start :	TIME;
		tx :	TIME;
		T_PLC_MS :	T_PLC_MS_block;
	END_VAR


	T_PLC_MS();
	tx := UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

	IF IN AND NOT edge THEN
		start := tx;
		Q := PT > t#0ms;
	ELSIF Q THEN
		ET := tx - start;
		IF ET >= PT THEN
			Q := FALSE;
			ET := t#0ms;
		END_IF;
	END_IF;
	edge := IN;

END_FUNCTION_BLOCK

FUNCTION_BLOCK PWM_DC
	VAR_INPUT
		F :	REAL;
		DC :	REAL;
	END_VAR

	VAR_OUTPUT
		Q :	BOOL;
	END_VAR

	VAR
		clk :	CLK_Prg;
		pulse :	TP_X;
		tmp :	REAL;
	END_VAR

	IF F > 0.0 THEN
		tmp := 1000.0/F;
		CLK(PT := REAL_TO_TIME2(tmp));
		Pulse(in := clk.Q, pt := REAL_TO_TIME2(tmp*DC));
		Q := pulse.Q;
	END_IF;
END_FUNCTION_BLOCK


FUNCTION_BLOCK CTRL_PWM
	VAR_INPUT
		CI :	REAL;
		MAN_IN :	REAL;
		MANUAL :	BOOL;
		F :	REAL;
	END_VAR

	VAR_OUTPUT
		Q :	BOOL;
	END_VAR

	VAR
		PW :	PWM_DC;
	END_VAR

	PW(F := F, DC := SEL(MANUAL,CI,MAN_IN));
	Q := PW.Q;
END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	CI     :	REAL;
	MAN_IN :	REAL;
	MANUAL :	BOOL;
	F      :	REAL;

	Q :	BOOL;

	func_block : CTRL_PWM;
  END_VAR
	func_block.CI    :=CI    ;
	func_block.MAN_IN:=MAN_IN;
	func_block.MANUAL:=MANUAL;
	func_block.F     :=F     ;
	func_block();
	Q := func_block.Q;
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
