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
		tx :	UDINT;
		tl :	UDINT;
		ptesss :	DINT;
		init :	BOOL;
		last_dir :	BOOL;
	END_VAR

	T_PLC_MS();
	tx := T_PLC_MS.T_PLC_MS;
	IF E AND init THEN
		(* we need to set tl = tx when direction changes *)
		IF dir XOR last_dir THEN
			tl := tx;
			last_dir := dir;
		END_IF;
		(* check_elapsed time and calculate only if necessary *)
		IF tr > t#0s THEN
			ptesss := DWORD_TO_DINT(UDINT_TO_DWORD(DWORD_TO_UDINT(SHL(UDINT_TO_DWORD(tx-tl), 16)) / TIME_TO_UDINT2(TR)));
		ELSE
			ptesss := DINT#65535;
		END_IF;
		IF ptesss > DINT#0 THEN
			(* perform the ptesss on the ramp *)
			tl := tx;
			(* calculate the ptesss response *)
			IF NOT dir THEN ptesss := - ptesss; END_IF;
			rmp := DINT_TO_WORD(LIMIT(DINT#0, _WORD_TO_DINT(rmp) + ptesss, DINT#65535));
		END_IF;
	ELSE
		tl := tx;
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

	rmp(dir := UP, E := E, TR := PT, rmp := out);
	out := rmp.RMP;

	IF RST THEN
		out := WORD#0;
	ELSIF SET THEN
		out := WORD#65535;
	END_IF;

	low := out = WORD#0;
	high := out = WORD#65535;
	busy := NOT (low OR high) AND E;

END_FUNCTION_BLOCK

FUNCTION _WORD_TO_REAL:REAL
	VAR_INPUT
		IN :	WORD;
	END_VAR
	_WORD_TO_REAL := UINT_TO_REAL(WORD_TO_UINT(IN));
END_FUNCTION

FUNCTION_BLOCK FADE
	VAR_INPUT
		IN1 :	REAL;
		IN2 :	REAL;
		F :	BOOL;
		TF :	TIME;
		RST :	BOOL;
	END_VAR

	VAR_OUTPUT
		Y :	REAL;
	END_VAR

	VAR
		rmx :	RMP_W;
	END_VAR
	rmx(rst := rst AND NOT F, set := rst AND F, pt := TF, up := F);
	Y := (in2 - In1) / 65535.0 * _WORD_TO_REAL(rmx.out) + in1;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR

	IN1 :	REAL;
	IN2 :	REAL;
	F   :	BOOL;
	TF  :	TIME;
	RST :	BOOL;

	Y :	REAL;

	func_block : FADE;
  END_VAR
	func_block.IN1 :=IN1;
	func_block.IN2 :=IN2;
	func_block.F   :=F  ;
	func_block.TF  :=TF ;
	func_block.RST :=RST;
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