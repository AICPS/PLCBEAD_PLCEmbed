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

FUNCTION _WORD_TO_DINT:DINT
	VAR_INPUT
		IN :	WORD;
	END_VAR
	_WORD_TO_DINT := UINT_TO_DINT(WORD_TO_UINT(IN));
END_FUNCTION

FUNCTION TIME_TO_UDINT2:UDINT
	VAR_INPUT
		X :	TIME;
	END_VAR

	TIME_TO_UDINT2 := DINT_TO_UDINT(TIME_TO_DINT(X));
END_FUNCTION

FUNCTION_BLOCK _RMP_W

	VAR_INPUT
		DIR :	BOOL;
		E :	BOOL := TRUE;
		TR :	TIME;
	END_VAR


	VAR_IN_OUT
		RMP :	WORD;
	END_VAR


	VAR
		T_PLC_MS :	T_PLC_MS_block;
		TX :	UDINT;
		TL :	UDINT;
		PTesss :	DINT;
		init :	BOOL;
		last_DIR :	BOOL;
	END_VAR

	T_PLC_MS();
	TX := T_PLC_MS.T_PLC_MS;
	IF E AND init THEN
		(* we need to set TL = TX when DIRection CHAnges *)
		IF DIR XOR last_DIR THEN
			TL := TX;
			last_DIR := DIR;
		END_IF;
		(* check_elapsed time and calculate only if necessary *)
		IF TR > t#0s THEN
			PTesss := DWORD_TO_DINT(UDINT_TO_DWORD(DWORD_TO_UDINT(SHL(UDINT_TO_DWORD(TX- TL), 16)) / TIME_TO_UDINT2(TR)));
		ELSE
			PTesss := DINT#65535;
		END_IF;
		IF PTesss > DINT#0 THEN
			(* perform the PTesss on the ramp *)
			TL := TX;
			(* calculate the PTesss response *)
			IF NOT DIR THEN PTesss := - PTesss; END_IF;
			rmp := DINT_TO_WORD(LIMIT(DINT#0, _WORD_TO_DINT(rmp) + PTesss, DINT#65535));
		END_IF;
	ELSE
		TL := TX;
		init := TRUE;
	END_IF;
END_FUNCTION_BLOCK



FUNCTION_BLOCK RMP_W

	VAR_INPUT
		SET :	BOOL;
		PT :	TIME;
		E :	BOOL := TRUE;
		UP :	BOOL := TRUE;
		RST :	BOOL;
	END_VAR

	VAR_OUTPUT
		OUT :	WORD;
		BUSY :	BOOL;
		HIGH :	BOOL;
		LOW :	BOOL;
	END_VAR

	VAR
		rmp :	_RMP_W;
	END_VAR

	rmp(DIR := UP, E := E, TR := PT, rmp := OUT);
	OUT := rmp.RMP;

	IF RST THEN
		OUT := WORD#0;
	ELSIF SET THEN
		OUT := WORD#65535;
	END_IF;

	LOW := OUT = WORD#0;
	HIGH := OUT = WORD#65535;
	busy := NOT (low OR high) AND E;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
		SET :	BOOL;
		PT  :	TIME;
		E   :	BOOL;
		UP  :	BOOL ;
		RST :	BOOL;

		OUT  :	WORD;
		BUSY :	BOOL;
		HIGH :	BOOL;
		LOW  :	BOOL;

	func_block : RMP_W;
  END_VAR
	func_block.SET:=SET;
	func_block.PT :=PT ;
	func_block.E  :=E ;
	func_block.UP :=UP ;
	func_block.RST:=RST;
	func_block();
	OUT  := func_block.OUT ;
	BUSY := func_block.BUSY;
	HIGH := func_block.HIGH;
	LOW  := func_block.LOW ;
	 
END_PROGRAM

