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
		TX :	TIME;
		TL :	TIME;
		tn :	TIME;
		init :	BOOL;
		last_DIR :	BOOL;
		START :	BYTE;
	END_VAR


	T_PLC_MS();
	TX := UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

	IF E AND init AND (DIR = last_DIR) AND (RMP <> SEL(DIR, BYTE#0, BYTE#255)) AND TR = tn THEN
		RMP := FRMP_B(START, DIR, SUB_TIME(TX, TL), TR);
	ELSE
		init := TRUE;
		TL := TX;
		tn := tr;
		START := RMP;
	END_IF;
	last_DIR := DIR;
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
		CNT :	INT;
		last :	BOOL;
	END_VAR

	timer(IN := IN, PT := T_LONG);
	single := FALSE;
	double := FALSE;

	IF timer.Q THEN
		IF NOT IN AND last THEN	CNT := CNT + 1; END_IF;
	ELSE
		CASE CNT OF
			1 : single := TRUE;
			2 : double := TRUE;
		END_CASE;
		CNT := 0;
	END_IF;
	last := IN;
	TP_LONG := NOT timer.Q AND (NOT LONG) AND IN;
	LONG := NOT timer.Q AND IN;

END_FUNCTION_BLOCK

FUNCTION_BLOCK DIMM_2_Block

	VAR_INPUT
		SET :	BOOL;
		VAL :	BYTE := BYTE#255;
		I1 :	BOOL;
		I2 :	BOOL;
		RST :	BOOL;
		T_DEBOUNCE :	TIME := T#10ms;
		T_ON_MAX :	TIME := T#0h;
		T_DIMM_START :	TIME := T#1s;
		T_DIMM :	TIME := T#3s;
		MIN_ON :	BYTE := BYTE#50;
		MAX_ON :	BYTE := BYTE#255;
		RST_OUT :	BOOL;
		SOFT_DIMM :	BOOL := TRUE;
		DBL1_TOG :	BOOL;
		DBL2_TOG :	BOOL;
		DBL1_SET :	BOOL;
		DBL2_SET :	BOOL;
		DBL1_POS :	BYTE;
		DBL2_POS :	BYTE;
	END_VAR


	VAR_OUTPUT
		Q :	BOOL;
		D1 :	BOOL;
		D2 :	BOOL;
	END_VAR


	VAR_IN_OUT
		_OUT :	BYTE;
	END_VAR


	VAR
		t1 :	TOF;
		t2 :	TOF;
		DC1 :	CLICK_MODE_Block;
		DC2 :	CLICK_MODE_Block;
		t3 :	TON;
		dim :	_RMP_B;
	END_VAR

	t1(IN := I1, PT := T_DEBOUNCE);
	t2(IN := I2, PT := T_DEBOUNCE);
	DC1(IN := t1.Q, T_LONG := T_DIMM_START);
	DC2(IN := t2.Q, T_LONG := T_DIMM_START);

	IF RST THEN
		IF RST_OUT THEN _OUT := BYTE#0; END_IF;
		Q := FALSE;
		D1 := FALSE;
		D2 := FALSE;
	ELSIF SET THEN
		_OUT := VAL;
		Q := TRUE;
	ELSIF DC1.SINGLE THEN
		_OUT := LIMIT(MAX(MIN_ON,BYTE#1), _OUT, MAX_ON);
		Q := TRUE;
	ELSIF DC2.SINGLE THEN
		Q := FALSE;
	ELSIF DC1.TP_LONG THEN
		IF NOT Q THEN
			_OUT := SEL(SOFT_DIMM, LIMIT(MAX(MIN_ON,BYTE#1), _OUT, MAX_ON), BYTE#1);
		END_IF;
		Q := TRUE;
		dim.DIR := TRUE;
	ELSIF DC2.TP_LONG THEN
		dim.DIR := FALSE;
	END_IF;

	IF NOT DBL1_TOG THEN D1 := FALSE; END_IF;
	IF DC1.DOUBLE THEN
		IF DBL1_SET THEN
			_OUT := DBL1_POS;
			Q := TRUE;
		ELSE
			D1 := NOT D1;
		END_IF;
	END_IF;
	IF NOT DBL2_TOG THEN D2 := FALSE; END_IF;
	IF DC2.DOUBLE THEN
		IF DBL2_SET THEN
			_OUT := DBL2_POS;
			Q := TRUE;
		ELSE
			D2 := NOT D2;
		END_IF;
	END_IF;


	dim(DIR := DC2.LONG, e := DC1.LONG OR DC2.LONG , TR := T_DIMM, rmp := _OUT);
	_OUT := dim.RMP;

	IF _OUT = BYTE#0 THEN Q := FALSE; END_IF;

	IF t_ON_MAX > t#0s THEN
		t3(IN := q, PT := T_ON_MAX);
		Q := Q XOR t3.Q;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
	    SET :	BOOL;
		VAL :	BYTE := BYTE#255;
		I1 :	BOOL;
		I2 :	BOOL;
		RST :	BOOL;
		T_DEBOUNCE :	TIME := T#10ms;
		T_ON_MAX :	TIME := T#0h;
		T_DIMM_START :	TIME := T#1s;
		T_DIMM :	TIME := T#3s;
		MIN_ON :	BYTE := BYTE#50;
		MAX_ON :	BYTE := BYTE#255;
		RST_OUT :	BOOL;
		SOFT_DIMM :	BOOL := TRUE;
		DBL1_TOG :	BOOL;
		DBL2_TOG :	BOOL;
		DBL1_SET :	BOOL;
		DBL2_SET :	BOOL;
		DBL1_POS :	BYTE;
		DBL2_POS :	BYTE;
		_OUT :	BYTE := BYTE#0;
		Q :	BOOL;
		D1 :	BOOL;
		D2 :	BOOL;

		func_block : DIMM_2_Block;
  	END_VAR
	func_block.SET := SET;
	func_block.VAL := VAL;
	func_block.I1 := I1;
	func_block.I2 := I2;
	func_block.RST := RST;
	func_block.T_DEBOUNCE := T_DEBOUNCE;
	func_block.T_ON_MAX := T_ON_MAX;
	func_block.T_DIMM_START := T_DIMM_START;
	func_block.T_DIMM := T_DIMM;
	func_block.MIN_ON := MIN_ON;
	func_block.MAX_ON := MAX_ON;
	func_block.RST_OUT := RST_OUT;
	func_block.SOFT_DIMM := SOFT_DIMM;
	func_block.DBL1_TOG := DBL1_TOG;
	func_block.DBL2_TOG := DBL2_TOG;
	func_block.DBL1_SET := DBL1_SET;
	func_block.DBL2_SET := DBL2_SET;
	func_block.DBL1_POS := DBL1_POS;
	func_block.DBL2_POS := DBL2_POS;
	func_block._OUT := _OUT;

	func_block();
	_OUT := func_block._OUT;
	Q := func_block.Q;
	D1 := func_block.D1;
	D2 := func_block.D2;
END_PROGRAM

