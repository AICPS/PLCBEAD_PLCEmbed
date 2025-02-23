FUNCTION_BLOCK INTERLOCK_Block

	VAR_INPUT
		I1 :	BOOL;
		I2 :	BOOL;
		TL :	TIME;
	END_VAR


	VAR_OUTPUT
		Q1 :	BOOL;
		Q2 :	BOOL;
	END_VAR


	VAR
		T1 :	TOF;
		T2 :	TOF;
	END_VAR

	T1(IN := I1, PT := TL);
	T2(IN := I2, PT := TL);

	Q1 := I1 AND NOT t2.Q;
	Q2 := I2 AND NOT t1.Q;

END_FUNCTION_BLOCK


FUNCTION TIME_TO_UDINT2:UDINT
	VAR_INPUT
		X :	TIME;
	END_VAR

	TIME_TO_UDINT2 := DINT_TO_UDINT(TIME_TO_DINT(X));
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

FUNCTION_BLOCK RMP_B_Block

	VAR_INPUT
		SET :	BOOL;
		PT :	TIME;
		E :	BOOL := TRUE;
		UP :	BOOL := TRUE;
		RST :	BOOL;
	END_VAR


	VAR_OUTPUT
		OUT :	BYTE;
		BUSY :	BOOL;
		HIGH :	BOOL;
		LOW :	BOOL;
	END_VAR


	VAR
		rmp :	_RMP_B;
	END_VAR

	rmp(dir := UP, E := E, TR := PT, RMP := out);
	out := rmp.RMP;

	IF RST THEN
		out := BYTE#0;
	ELSIF SET THEN
		out := BYTE#255;
	END_IF;

low := out = BYTE#0;
high := out = BYTE#255;
busy := NOT (low OR high) AND E;

END_FUNCTION_BLOCK

FUNCTION_BLOCK BLIND_ACTUATOR_Block

	VAR_INPUT
		UP :	BOOL;
		DN :	BOOL;
		S_IN :	BYTE;
		T_UD :	TIME := T#10s;
		T_ANGLE :	TIME := T#3s;
		T_LOCKOUT :	TIME := t#100ms;
	END_VAR


	VAR_OUTPUT
		POS :	BYTE;
		ANG :	BYTE;
		QU :	BOOL;
		QD :	BOOL;
		STATUS :	BYTE;
	END_VAR


	VAR
		position :	RMP_B_Block;
		angle :	RMP_B_Block;
		lock :	INTERLOCK_Block;
	END_VAR

	lock(i1 := UP, I2 := DN, TL := T_lockout);

	angle(e := lock.Q1 OR lock.Q2, UP := lock.Q1, PT := T_Angle);
	position(e := lock.Q1 AND angle.high OR lock.Q2 AND angle.low, up := lock.Q1, PT := T_UD);

	pos := position.Out;
	ang := angle.Out;

	QU := lock.Q1;
	QD := lock.Q2;

	IF UP AND DN THEN
		status := BYTE#1;		
	ELSIF UP THEN
		status := BYTE#121;
	ELSIF DN THEN
		status := BYTE#122;
	ELSE
		status := S_IN;
	END_IF;

END_FUNCTION_BLOCK

FUNCTION _BYTE_TO_INT:INT
	VAR_INPUT
		IN :	BYTE;
	END_VAR

	_BYTE_TO_INT := USINT_TO_INT(BYTE_TO_USINT(IN));
END_FUNCTION

FUNCTION_BLOCK BLIND_CONTROL_Block

	VAR_INPUT
		UP :	BOOL;
		DN :	BOOL;
		S_IN :	BYTE;
		PI :	BYTE;
		AI :	BYTE;
		T_UD :	TIME;
		T_ANGLE :	TIME;
		SENS :	BYTE := 5;
		T_LOCKOUT :	TIME := T#100ms;
	END_VAR


	VAR_OUTPUT
		POS :	BYTE;
		ANG :	BYTE;
		MU :	BOOL;
		MD :	BOOL;
		STATUS :	BYTE;
	END_VAR


	VAR
		act :	BLIND_ACTUATOR_Block;
		delta :	BYTE;
		bTimeTest :	BOOL;
		iPos :	BYTE;
		iAngel :	BYTE;
	END_VAR

	IF bTimeTest THEN
		PI:=iPos;
		AI:=iAngel;
		UP:=TRUE;
		DN:=TRUE;
	END_IF;

	act(T_UD:=T_UD, T_ANGLE:=T_ANGLE, T_lockout := T_Lockout);

	IF UP AND DN THEN
		IF _BYTE_TO_INT(act.pos) < _BYTE_TO_INT(pi) - _BYTE_TO_INT(delta) THEN
			act.UP := TRUE;
			act.DN := FALSE;
			delta := BYTE#0;
			STATUS := BYTE#121;
		ELSIF _BYTE_TO_INT(act.pos) > _BYTE_TO_INT(pi) + _BYTE_TO_INT(delta) THEN
			act.UP := FALSE;
			act.DN := TRUE;
			delta := BYTE#0;
			STATUS := BYTE#122;
		ELSIF _BYTE_TO_INT(act.ang) < _BYTE_TO_INT(ai) - _BYTE_TO_INT(delta) AND T_angle > T#100ms THEN
			act.UP := TRUE;
			act.DN := FALSE;
			delta := SHR(sens,2);
			STATUS := BYTE#123;
		ELSIF _BYTE_TO_INT(act.ang) > _BYTE_TO_INT(ai) + _BYTE_TO_INT(delta) AND T_angle > T#100ms THEN
			act.UP := FALSE;
			act.DN := TRUE;
			delta := SHR(sens,2);
			STATUS := BYTE#124;
		ELSE
			act.UP := FALSE;
			act.DN := FALSE;
			delta := sens;
			STATUS := S_IN;
		END_IF;
	ELSE
		act.UP := UP;
		act.DN := DN;
		STATUS := S_IN;
	END_IF;

	act(T_UD:=T_UD, T_ANGLE:=T_ANGLE, T_lockout := T_Lockout);
	pos := act.pos;
	ang := act.ang;
	MU := act.QU;
	md := act.QD;
	status := act.status;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		UP :	BOOL;
		DN :	BOOL;
		S_IN :	BYTE;
		PI :	BYTE;
		AI :	BYTE;
		T_UD :	TIME;
		T_ANGLE :	TIME;
		SENS :	BYTE := 5;
		T_LOCKOUT :	TIME := T#100ms;
		POS :	BYTE;
		ANG :	BYTE;
		MU :	BOOL;
		MD :	BOOL;
		STATUS :	BYTE;
		func_block : BLIND_CONTROL_Block;
	END_VAR
	func_block.UP := UP;
	func_block.DN := DN;
	func_block.S_IN := S_IN ;
	func_block.PI    := PI    ;
	func_block.AI := AI;
	func_block.T_UD := T_UD ;
	func_block.T_ANGLE    := T_ANGLE    ;
	func_block.SENS := SENS;
	func_block.T_LOCKOUT := T_LOCKOUT;
	func_block();
	POS  := func_block.POS;
	ANG  := func_block.ANG;
	MU  := func_block.MU;
	MD  := func_block.MD;
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