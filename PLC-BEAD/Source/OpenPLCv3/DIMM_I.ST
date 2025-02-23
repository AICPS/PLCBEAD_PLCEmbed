FUNCTION_BLOCK SW_RECONFIG_Block

	VAR_INPUT
		IN :	BOOL;
		TD :	TIME;
		TR :	TIME;
	END_VAR


	VAR_OUTPUT
		Q :	BOOL;
	END_VAR


	VAR
		T1 :	TON;
		T2 :	TON;
		INV :	BOOL;
	END_VAR

	t1(in := IN, PT := TD);

	IF tr > t#0s THEN
		Q := t1.Q XOR inv;
		T2(in := Q, pt := TR);
		IF T2.Q THEN INV := NOT INV; END_IF;
	ELSE
		Q := t1.Q;
	END_IF;

END_FUNCTION_BLOCK

FUNCTION_BLOCK CLICK_MODE_Block

	VAR_INPUT
		IN :	BOOL;
		T_LONG :	TIME := T#500ms;
	END_VAR


	VAR_OUTPUT
		SINGLE :	BOOL;
		DOUBLE :	BOOL;
		LONG :	BOOL;
		TP_LONG :	BOOL;
	END_VAR


	VAR
		Timer :	TP;
		cnt :	INT;
		last :	BOOL;
	END_VAR

	timer(in := IN, PT := T_LONG);
	single := FALSE;
	double := FALSE;

	IF timer.Q THEN
		IF NOT in AND last THEN	cnt := cnt + 1; END_IF;
	ELSE
		CASE cnt OF
			1 : single := TRUE;
			2 : double := TRUE;
		END_CASE;
		cnt := 0;
	END_IF;
	last := in;
	TP_LONG := NOT timer.Q AND (NOT LONG) AND IN;
	LONG := NOT timer.Q AND in;

END_FUNCTION_BLOCK

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

FUNCTION TIME_TO_UDINT2:UDINT
	VAR_INPUT
		X :	TIME;
	END_VAR

	TIME_TO_UDINT2 := DINT_TO_UDINT(TIME_TO_DINT(X));
END_FUNCTION

FUNCTION FRMP_B:BYTE
	VAR_INPUT
		START :	BYTE;
		DIR :	BOOL;
		TD :	TIME;
		TR :	TIME;
	END_VAR

	IF TD < TR THEN
		FRMP_B := MIN(UDINT_TO_BYTE(DWORD_TO_UDINT(SHL(TIME_TO_DWORD(TD), 8)) / TIME_TO_UDINT2(TR)), SEL(DIR, START, USINT_TO_BYTE(USINT#255 - BYTE_TO_USINT(START))));
		IF DIR THEN
			FRMP_B := USINT_TO_BYTE(BYTE_TO_USINT(START) + BYTE_TO_USINT(FRMP_B));
		ELSE
			FRMP_B := USINT_TO_BYTE(BYTE_TO_USINT(START) - BYTE_TO_USINT(FRMP_B));
		END_IF;
	ELSE
		FRMP_B := SEL(DIR, BYTE#0, BYTE#255);
	END_IF;
END_FUNCTION

FUNCTION_BLOCK _RMP_B
	VAR_INPUT
		DIR :	BOOL;
		E :	BOOL := TRUE;
		TR :	TIME;
	END_VAR


	VAR_IN_OUT
		RMP :	BYTE;
	END_VAR


	VAR
		T_PLC_MS :	T_PLC_MS_block;
		tx :	TIME;
		tl :	TIME;
		tn :	TIME;
		init :	BOOL;
		last_dir :	BOOL;
		start :	BYTE;
	END_VAR


	T_PLC_MS();
	tx := UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

	IF E AND init AND (dir = last_dir) AND (RMP <> SEL(DIR, BYTE#0, BYTE#255)) AND TR = tn THEN
		RMP := FRMP_B(start, DIR, tx - tl, TR);
	ELSE
		init := TRUE;
		tl := tx;
		tn := tr;
		start := RMP;
	END_IF;
	last_dir := dir;
END_FUNCTION_BLOCK

FUNCTION _BYTE_TO_INT:INT
	VAR_INPUT
		IN :	BYTE;
	END_VAR

	_BYTE_TO_INT := USINT_TO_INT(BYTE_TO_USINT(IN));
END_FUNCTION

FUNCTION_BLOCK DIMM_I_Block

	VAR_INPUT
		SET :	BOOL;
		VAL :	BYTE := BYTE#255;
		IN :	BOOL;
		RST :	BOOL;
		T_DEBOUNCE :	TIME := T#10ms;
		T_RECONFIG :	TIME := T#10s;
		T_ON_MAX :	TIME := T#0h;
		T_DIMM_START :	TIME := T#1s;
		T_DIMM :	TIME := T#3s;
		MIN_ON :	BYTE := BYTE#50;
		MAX_ON :	BYTE := BYTE#255;
		SOFT_DIMM :	BOOL := TRUE;
		DBL_TOGGLE :	BOOL;
		RST_OUT :	BOOL;
	END_VAR


	VAR_OUTPUT
		Q :	BOOL;
		DBL :	BOOL;
	END_VAR


	VAR_IN_OUT
		OUT :	BYTE;
	END_VAR


	VAR
		config :	SW_RECONFIG_Block;
		decode :	CLICK_MODE_Block;
		t3 :	TON;
		dim :	_RMP_B;
		dir :	BOOL;
	END_VAR

	config(IN := IN, TD := T_DEBOUNCE, TR := T_RECONFIG);
	decode(in := config.Q, T_LONG := T_DIMM_START);

	IF RST THEN
		IF rst_out THEN out := BYTE#0; END_IF;
		Q := FALSE;
		dir := out > BYTE#127;
	ELSIF set THEN
		out := val;
		Q := TRUE;
		dir := out > BYTE#127;
	ELSIF decode.SINGLE THEN
		Q := NOT Q;
		IF Q THEN OUT := INT_TO_BYTE(LIMIT_INT(MAX(_BYTE_TO_INT(MIN_ON),1), _BYTE_TO_INT(out), _BYTE_TO_INT(MAX_ON)));	END_IF;
		dir := OUT > BYTE#127;
	ELSIF decode.TP_LONG THEN
		IF NOT Q THEN
			IF SOFT_DIMM THEN
				OUT := BYTE#1;
				dir := TRUE;
			ELSE
				out := INT_TO_BYTE(LIMIT_INT(MAX(_BYTE_TO_INT(MIN_ON),1), _BYTE_TO_INT(out), _BYTE_TO_INT(MAX_ON)));
				DIR := out < BYTE#127;
			END_IF;
			Q := TRUE;
		ELSE
			dir := NOT dir;
		END_IF;
	END_IF;

	IF NOT dbl_toggle THEN dbl := FALSE; END_IF;
	IF decode.DOUBLE THEN dbl := NOT dbl; END_IF;

	dim(DIR := dir, e := decode.LONG AND Q, TR := T_DIMM, rmp := out);
	OUT := dim.RMP;
	IF out = BYTE#0 THEN
		dir := TRUE;
	ELSIF out = BYTE#255 THEN
		dir := FALSE;
	END_IF;

	IF t_ON_MAX > t#0s THEN
		t3(in := q, pt := T_ON_MAX);
		Q := Q XOR t3.Q;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
	    SET :	BOOL;
		VAL :	BYTE := BYTE#255;
		IN :	BOOL;
		RST :	BOOL;
		T_DEBOUNCE :	TIME := T#10ms;
		T_RECONFIG :	TIME := T#10s;
		T_ON_MAX :	TIME := T#0h;
		T_DIMM_START :	TIME := T#1s;
		T_DIMM :	TIME := T#3s;
		MIN_ON :	BYTE := BYTE#50;
		MAX_ON :	BYTE := BYTE#255;
		SOFT_DIMM :	BOOL := TRUE;
		DBL_TOGGLE :	BOOL;
		RST_OUT :	BOOL;
		OUT :	BYTE;
		Q :	BOOL;
		DBL :	BOOL;

		func_block : DIMM_I_Block;
  	END_VAR
	func_block.SET := SET;
	func_block.VAL := VAL;
	func_block.IN := IN;
	func_block.RST := RST;
	func_block.T_DEBOUNCE := T_DEBOUNCE;
	func_block.T_RECONFIG := T_RECONFIG;
	func_block.T_ON_MAX := T_ON_MAX;
	func_block.T_DIMM_START := T_DIMM_START;
	func_block.T_DIMM := T_DIMM;
	func_block.MIN_ON := MIN_ON;
	func_block.MAX_ON := MAX_ON;
	func_block.SOFT_DIMM := SOFT_DIMM;
	func_block.DBL_TOGGLE := DBL_TOGGLE;
	func_block.RST_OUT := RST_OUT;
	func_block.OUT := OUT;

	func_block();
	OUT := func_block.OUT;
	Q := func_block.Q;
	DBL := func_block.DBL;
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