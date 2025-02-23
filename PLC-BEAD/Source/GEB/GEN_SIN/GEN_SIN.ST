FUNCTION _REAL_TO_DWORD: DWORD

  VAR_INPUT
    X :	REAL;
  END_VAR

  IF REAL_TO_DWORD(0.5) = DWORD#1 THEN
    _REAL_TO_DWORD := REAL_TO_DWORD(X);
  ELSIF X > 0.0 THEN
    _REAL_TO_DWORD := REAL_TO_DWORD(X+0.5); 
  ELSIF X < 0.0 THEN 
    _REAL_TO_DWORD := REAL_TO_DWORD(X-0.5); 
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

FUNCTION MULTIME_B:TIME
	VAR_INPUT
		T :	TIME;
		M :	REAL;
	END_VAR

	MULTIME_B := DWORD_TO_TIME(_REAL_TO_DWORD(_DWORD_TO_REAL(TIME_TO_DWORD(T))*M));
END_FUNCTION

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

FUNCTION TIME_TO_REAL1:REAL

	VAR_INPUT
		X :	TIME;
	END_VAR

	TIME_TO_REAL1 := UDINT_TO_REAL(DINT_TO_UDINT(TIME_TO_DINT(X)));
END_FUNCTION

FUNCTION MODR : REAL
  VAR_INPUT
    IN : REAL;
    DIVI : REAL;
  END_VAR

  IF DIVI = 0.0 THEN
  	MODR := 0.0;
  ELSE
  	MODR := IN - DINT_TO_REAL(FLOOR2(IN / DIVI)) * DIVI;
  END_IF;
END_FUNCTION

FUNCTION FLOOR2 : DINT
  VAR_INPUT
    X : REAL;
  END_VAR

  FLOOR2 := REAL_TO_DINT(X);
  IF DINT_TO_REAL(FLOOR2) > X THEN
  	FLOOR2 := FLOOR2 - DINT#1;
  END_IF;
END_FUNCTION

FUNCTION SIGN_R : BOOL
  VAR_INPUT
    IN : REAL;
  END_VAR

  SIGN_R := IN < 0.0;
END_FUNCTION


FUNCTION_BLOCK GEN_SIN_Block

	VAR_INPUT
		PT :	TIME;
		AM :	REAL := REAL#1.0;
		OS :	REAL;
		DL :	REAL;
	END_VAR


	VAR_OUTPUT
		Q :	BOOL;
		Out :	REAL;
	END_VAR


	VAR
		TX :	TIME;
		last :	TIME;
		init :	BOOL;
		temp :	REAL;
		DLL : REAL;
		T_PLC_MS :	T_PLC_MS_block;
	END_VAR

	T_PLC_MS();
	TX:= SUB_TIME(UDINT_TO_TIME(T_PLC_MS.T_PLC_MS), last);

	DLL := MODR(DL,1.0);
	IF DLL < 0.0 THEN DLL := 1.0 - DLL; END_IF;

	IF NOT init THEN
		init := TRUE;
		last := TX;
		TX := t#0s;
	END_IF;

	IF TX >= PT THEN
		last := ADD_TIME(last ,PT);
		TX := SUB_TIME(TX, PT);
	END_IF;

	IF PT > t#0s THEN temp := SIN(6.283185307179586476 * TIME_TO_REAL1(ADD_TIME(TX ,MULTIME_B(PT, DL))) / TIME_TO_REAL(PT)); END_IF;
	Out := AM * 0.5 *  temp + OS;

	Q := NOT SIGN_R(temp);

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	PT :	TIME := T#1s;
	AM :	REAL := REAL#1.0;
	OS :	REAL;
	DL :	REAL;
	Q :	BOOL;
	OUT :	REAL;
	func_block : GEN_SIN_Block;
  END_VAR
	func_block.PT  :=PT;
	func_block.AM  :=AM;
	func_block.OS  :=OS;
	func_block.DL  :=DL;
	func_block();
	Q := func_block.Q;
	OUT := func_block.Out;
END_PROGRAM

