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

	VAR		PLC_TICKS_PER_SEC :	INT;
		PLC_SYS_TICK_CNT :	DINT;
	END_VAR

	VAR
		debug :	BOOL;(*Debug-Mode ON / OFF*)
		N :	INT;(*Debug-Faktor*)
		Offset :	UDINT;(*Debug-Offset*)
		temp :	DWORD := DWORD#1;(*Debug-Offset*)
		MODE :	BOOL;(*modus*)
		faktor :	UDINT;(*Systemtakt-Faktor*)
		INit :	BOOL;
		v_plc_ticks_per_sec :	UDINT;
		base :	UDINT := UDINT#1000;
	END_VAR


	IF INit = FALSE THEN
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
		INit := TRUE;
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
		INit :	BOOL;
		last_DIR :	BOOL;
		START :	BYTE;
	END_VAR


	T_PLC_MS();
	TX := UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

	IF E AND INit AND (DIR = last_DIR) AND (RMP <> SEL(DIR, BYTE#0, BYTE#255)) AND TR = tn THEN
		RMP := FRMP_B(START, DIR, SUB_TIME(TX, TL), TR);
	ELSE
		INit := TRUE;
		TL := TX;
		tn := TR;
		START := RMP;
	END_IF;
	last_DIR := DIR;
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
		last_X :	DWORD;
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

FUNCTION_BLOCK _RMP_NEXT
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
		rmX :	_RMP_B;
		DIRX :	TREND_DW;
		t_lock :	TP;
		Xen :	BOOL;
		XDIR :	BOOL;
	END_VAR

	DIRX(X := BYTE_TO_DWORD(IN));

	t_lock(IN := FALSE, PT := TL);

	IF DIRX.TU AND (OUT < IN) THEN
		IF NOT XDIR AND Xen THEN t_lock(IN := TRUE); END_IF;
		Xen := TRUE;
		XDIR := TRUE;
	ELSIF DIRX.TD AND (OUT > IN) THEN
		IF XDIR AND Xen THEN t_lock(IN := TRUE); END_IF;
		Xen := TRUE;
		XDIR := FALSE;
	ELSIF Xen THEN
		IF (XDIR AND (OUT >= IN)) OR (NOT XDIR AND (OUT <= IN)) THEN
			Xen := FALSE;
			IF TL > t#0s THEN t_lock(IN := TRUE); END_IF;
		END_IF;
	END_IF;

	IF NOT t_lock.Q AND Xen THEN
		UP := XDIR;
		DIR := XDIR;
		DN := NOT XDIR;
	ELSE
		UP := FALSE;
		DN := FALSE;
	END_IF;

	rmX(RMP := OUT, E := E AND (UP OR DN) , DIR := DIR, TR := SEL(DIR, TF, TR));
	OUT := rmX.RMP;
END_FUNCTION_BLOCK

PROGRAM program0
	VAR
	    LocalVaR1  : BOOL;
		LocalVaR2 : BYTE;
		LocalVar3 : TIME;
		LocalVar4 : TIME;
		LocalVar5 : TIME;
		LocalVar6 : BOOL;
		LocalVar7 : BOOL;
		LocalVar8 : BOOL;
		LocalINOUT : BYTE;
		func_block : _RMP_NEXT;
  	END_VAR
	func_block(E  := LocalVaR1 ,IN := LocalVaR2, TR := LocalVar3, TF := LocalVar4, TL := LocalVar5, OUT := LocalINOUT);
	LocalINOUT := func_block.OUT;
	LocalVar6 := func_block.DIR;
	LocalVar7 := func_block.UP;
	LocalVar8 := func_block.DN;
END_PROGRAM

