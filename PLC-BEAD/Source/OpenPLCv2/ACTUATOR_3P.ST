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


FUNCTION_BLOCK TREND_DW
	VAR_INPUT
		X :	DWORD;
	END_VAR
	VAR_OUTPUT
		Q :	BOOL;
		TU :	BOOL;
		TD :	BOOL;
		D :	DWORD;
	END_VAR

	VAR
		LAST_X :	DWORD;
	END_VAR

	IF X > last_X THEN
		TU := TRUE;
		TD := FALSE;
		D := UDINT_TO_DWORD(DWORD_TO_UDINT(X) - DWORD_TO_UDINT(last_X));
		Q := TRUE;
	ELSIF X < last_X THEN
		TD := TRUE;
		TU := FALSE;
		D := UDINT_TO_DWORD(DWORD_TO_UDINT(last_X) - DWORD_TO_UDINT(X));
		Q := FALSE;
	ELSE
		TU := FALSE;
		TD := FALSE;
		D := DWORD#0;
	END_IF;
	last_X := X;
END_FUNCTION_BLOCK

FUNCTION_BLOCK _RMP_NEXT_Block
	VAR_INPUT
		E :	BOOL := TRUE;
		IN :	BYTE;
		TR :	TIME;
		TF :	TIME;
		TL :	TIME;
	END_VAR

	VAR_OUTPUT
		DIR :	BOOL;
		UP :	BOOL;
		DN :	BOOL;
	END_VAR

	VAR_IN_OUT
		OUT :	BYTE;
	END_VAR
	VAR
		rmx :	_RMP_B;
		dirx :	TREND_DW;
		t_lock :	TP;
		xen :	BOOL;
		xdir :	BOOL;
	END_VAR

	dirx(X := BYTE_TO_DWORD(in));

	t_lock(in := FALSE, pt := TL);

	IF dirx.TU AND (OUT < IN) THEN
		IF NOT xdir AND xen THEN t_lock(in := TRUE); END_IF;
		xen := TRUE;
		xdir := TRUE;
	ELSIF dirx.TD AND (OUT > IN) THEN
		IF xdir AND xen THEN t_lock(in := TRUE); END_IF;
		xen := TRUE;
		xdir := FALSE;
	ELSIF xen THEN
		IF (xdir AND (out >= in)) OR (NOT xdir AND (out <= in)) THEN
			xen := FALSE;
			IF tl > t#0s THEN t_lock(IN := TRUE); END_IF;
		END_IF;
	END_IF;

	IF NOT t_lock.Q AND xen THEN
		UP := XDIR;
		DIR := XDIR;
		DN := NOT XDIR;
	ELSE
		UP := FALSE;
		DN := FALSE;
	END_IF;

	rmx(rmp := OUT, E := E AND (UP OR DN) , dir := DIR, tr := SEL(dir, TF, TR));
	OUT := rmx.RMP;
END_FUNCTION_BLOCK

FUNCTION _BYTE_TO_INT:INT
	VAR_INPUT
		IN :	BYTE;
	END_VAR

	_BYTE_TO_INT := USINT_TO_INT(BYTE_TO_USINT(IN));
END_FUNCTION

FUNCTION_BLOCK ACTUATOR_3P_Block

	VAR_INPUT
		IN :	BYTE;
		TEST :	BOOL;
		ARE :	BOOL := TRUE;
		END_POS :	BOOL;
		T_RUN :	TIME := T#60s;
		T_EXT :	TIME := T#10s;
		T_CAL :	TIME := T#600s;
		T_DIAG :	TIME := T#10d;
		SWITCH_AVAIL :	BOOL;
	END_VAR


	VAR_OUTPUT
		OUT1 :	BOOL;
		OUT2 :	BOOL;
		POS :	BYTE;
		ERROR :	BOOL;
		STATUS :	BYTE;
	END_VAR


	VAR_IN_OUT
		ARX :	BOOL;
	END_VAR

	VAR
		tx :	TIME;
		_ramp :	_RMP_NEXT_Block;
		next_cal :	TIME;
		next_diag :	TIME;
		last :	TIME;
		start :	TIME;
		T_PLC_MS :	T_PLC_MS_Block;
	END_VAR

	T_PLC_MS();
	tx := UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

	IF TEST THEN
		status := BYTE#103;
		start := tx;
		ARX := TRUE;
	END_IF;

	CASE _BYTE_TO_INT(status) OF
		0:	
			IF ARE AND NOT ARX THEN
				status := BYTE#103;
				start := tx;
				ARX := TRUE;
			END_IF;

		100:
			IF T_DIAG > T#0s AND tx > next_diag AND ARE AND NOT ARX THEN
					status := BYTE#103;
					start := tx;
					ARX := TRUE;

			ELSIF T_CAL > T#0s AND tx > next_cal AND ARE AND NOT ARX THEN
				IF pos > BYTE#127 THEN
					OUT1 := TRUE;
					OUT2 := FALSE;
					_ramp.IN := BYTE#255;
					ARX := TRUE;
				ELSE
					OUT1 := FALSE;
					OUT2 := TRUE;
					_ramp.IN := BYTE#0;
					ARX := TRUE;
				END_IF;
				status := BYTE#101;
				start := tx;
			ELSE
				IF NOT(OUT1 OR OUT2) THEN next_cal := next_cal + (tx-last); END_IF;
				_ramp.IN := IN;
			END_IF;

		101:
			IF tx - start < T_EXT THEN
				next_cal := tx + T_CAL;
			ELSIF SWITCH_AVAIL AND END_POS THEN
				STATUS := BYTE#100;
				ARX := FALSE;
			ELSIF tx - start > T_EXT + T_RUN THEN
				ERROR := SWITCH_AVAIL;
				ARX := FALSE;
			END_IF;

		103:	
			IF tx - start < T_EXT THEN
				ERROR := FALSE;
				_ramp.TR := T_RUN;
				_ramp.TF := T_RUN;
				OUT1 := TRUE;
				OUT2 := FALSE;
				_ramp.IN := BYTE#255;
			ELSIF SWITCH_AVAIL AND END_POS THEN
				_ramp.TR := tx - start;
				STATUS := BYTE#104;
			ELSIF tx - start > T_EXT + T_RUN THEN
				ERROR := SWITCH_AVAIL;
				STATUS := BYTE#104;
				start := tx;
			END_IF;

		104:	
			IF tx - start < T_ext THEN
				OUT1 := FALSE;
				OUT2 := TRUE;
				_ramp.IN := BYTE#0;
				next_diag := tx + T_DIAG;
			ELSIF SWITCH_AVAIL AND END_POS THEN
				_ramp.TR := tx - start;
				IF DINT_TO_TIME(ABS(TIME_TO_DINT(_ramp.TR) - TIME_TO_DINT(_ramp.TF)) * DINT#10) > T_RUN THEN error := TRUE; END_IF;
				STATUS := BYTE#100;
				ARX := FALSE;
				next_cal := tx + T_CAL;
			ELSIF tx - start > T_EXT + T_RUN THEN
				IF SWITCH_AVAIL THEN ERROR := TRUE; END_IF;
				STATUS := BYTE#100;
				ARX := FALSE;
				next_CAL := tx + T_CAL;
			END_IF;
	END_CASE;

	_ramp(OUT := POS);
	POS := _ramp.OUT;
	IF STATUS = BYTE#100 THEN
		OUT1 := _ramp.UP;
		OUT2 := _ramp.DN;
	END_IF;

	IF SWITCH_AVAIL AND END_POS THEN
		POS := SEL_BYTE(POS > BYTE#127, BYTE#0, BYTE#255);
		next_cal := tx + T_CAL;
	END_IF;

	last := tx;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		IN :	BYTE;
		TEST :	BOOL;
		ARE :	BOOL := TRUE;
		END_POS :	BOOL;
		T_RUN :	TIME := T#60s;
		T_EXT :	TIME := T#10s;
		T_CAL :	TIME := T#600s;
		T_DIAG :	TIME := T#10d;
		SWITCH_AVAIL :	BOOL;
		OUT1 :	BOOL;
		OUT2 :	BOOL;
		POS :	BYTE;
		ERROR :	BOOL;
		STATUS :	BYTE;
		func_block : ACTUATOR_3P_Block;
	END_VAR
	func_block.IN := IN;
	func_block.TEST := TEST;
	func_block.ARE := ARE ;
	func_block.END_POS := END_POS;
	func_block.T_RUN := T_RUN;
	func_block.T_EXT := T_EXT;
	func_block.T_CAL := T_CAL ;
	func_block.T_DIAG := T_DIAG;
	func_block.SWITCH_AVAIL := SWITCH_AVAIL;
	func_block();
	OUT1  := func_block.OUT1;
	OUT2  := func_block.OUT2;
	POS  := func_block.POS;
	ERROR  := func_block.ERROR;
	STATUS  := func_block.STATUS;
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