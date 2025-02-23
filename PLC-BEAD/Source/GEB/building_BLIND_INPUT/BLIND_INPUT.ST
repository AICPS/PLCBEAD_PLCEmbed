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

FUNCTION _BYTE_TO_INT:INT
	VAR_INPUT
		IN :	BYTE;
	END_VAR

	_BYTE_TO_INT := USINT_TO_INT(BYTE_TO_USINT(IN));
END_FUNCTION

FUNCTION_BLOCK BLIND_INPUT_Block

	VAR_INPUT
		POS :	BYTE;
		ANG :	BYTE;
		S1 :	BOOL;
		S2 :	BOOL;
		IN :	BOOL;
		PI :	BYTE;
		AI :	BYTE;
		SINGLE_SWITCH :	BOOL;
		CLICK_EN :	BOOL := TRUE;
		CLICK_TIME :	TIME := T#500ms;
		MAX_RUNTIME :	TIME := T#60s;
		MANUAL_TIMEOUT :	TIME := T#1h;
		DEBOUNCE_TIME :	TIME := T#20ms;
		DBL_CLK1 :	BOOL := FALSE;
		DBL_POS1 :	BYTE;
		DBL_ANG1 :	BYTE;
		DBL_CLK2 :	BOOL := FALSE;
		DBL_POS2 :	BYTE := BYTE#255;
		DBL_ANG2 :	BYTE := BYTE#255;
		D1_TOGGLE :	BOOL := TRUE;
		D2_TOGGLE :	BOOL := TRUE;
		MASTER_MODE :	BOOL;
	END_VAR


	VAR_OUTPUT
		QU :	BOOL := TRUE;
		QD :	BOOL := TRUE;
		STATUS :	BYTE;
		PO :	BYTE := BYTE#255;
		AO :	BYTE := BYTE#255;
		D1 :	BOOL;
		D2 :	BOOL;
	END_VAR


	VAR
		S1e :	TOF;
		S2e :	TOF;
		S1d :	CLICK_MODE_Block;
		S2d :	CLICK_MODE_Block;
		DIR :	BOOL;
		TX :	TIME;
		last :	TIME;
		T_PLC_MS :	T_PLC_MS_block;
	END_VAR

	T_PLC_MS();
	TX:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

	S1e(IN := S1, PT := DEBOUNCE_TIME);
	S2e(IN := S2, PT := DEBOUNCE_TIME);
	S1d(IN := (S1e.Q AND NOT SINGLE_SWITCH) OR (S1e.Q AND SINGLE_SWITCH AND DIR), t_long := CLICK_TIME);
	S2d(IN := (S2e.Q AND NOT SINGLE_SWITCH) OR (S1e.Q AND SINGLE_SWITCH AND NOT DIR), t_long := CLICK_TIME);

	IF NOT D1_toggle THEN D1 := FALSE; END_IF;
	IF NOT D2_toggle THEN D2 := FALSE; END_IF;

	IF (S1d.LONG AND S2d.LONG) OR (STATUS = BYTE#139) THEN
	STATUS := BYTE#139;
	IF NOT (S1d.LONG OR S2d.LONG)  THEN STATUS := BYTE#130; END_IF;
	ELSIF S1d.tp_LONG THEN
		STATUS := BYTE#132;
	ELSIF S2d.tp_LONG THEN
		STATUS := BYTE#133;
	ELSIF  S1d.SINGLE THEN
		IF click_en THEN
			IF QU XOR QD THEN
				STATUS := BYTE#131;
			ELSE
				STATUS := BYTE#134;
				last := TX;
				DIR := NOT DIR;
			END_IF;
		END_IF;
	ELSIF  S2d.SINGLE THEN
		IF click_en THEN
			IF QU XOR QD THEN
				STATUS := BYTE#131;
			ELSE
				STATUS := BYTE#135;
				last := TX;
				DIR := NOT DIR;
			END_IF;
		END_IF;
	ELSIF IN THEN
		STATUS := BYTE#136;
		last := TX;
	ELSIF S1d.DOUBLE THEN
		IF dbl_CLK1 THEN
			STATUS := BYTE#137;
			last := TX;
		ELSE
			D1 := NOT D1;
		END_IF;
	ELSIF S2d.DOUBLE THEN
		IF dbl_CLK2 THEN
			STATUS := BYTE#138;
			last := TX;
		ELSE
			IF single_switch THEN D1 := NOT D1; ELSE D2 := NOT D2; END_IF;
		END_IF;
	END_IF;

	CASE _BYTE_TO_INT(STATUS) OF
		0:		
				STATUS := BYTE#130;

		130:	
				IF NOT master_MODE THEN
					PO := POS;
					AO := ANG;
				END_IF;
				QU := TRUE;
				QD := TRUE;

		131:	
				QU := FALSE;
				QD := FALSE;
				PO := POS;
				AO := ANG;
				IF SUB_TIME(TX, last) >= MANUAL_TIMEOUT THEN
					STATUS := BYTE#130;
				END_IF;

		132:	
				QU := TRUE;
				QD := FALSE;
				PO := POS; AO := ANG;
				last := TX;
				IF NOT S1d.LONG THEN STATUS := BYTE#131; DIR := NOT DIR; END_IF;

		133:	
				QU := FALSE;
				QD := TRUE;
				PO := POS; AO := ANG;
				last := TX;
				IF NOT S2d.LONG THEN	STATUS := BYTE#131; DIR := NOT DIR; END_IF;

		134:
				QU := TRUE;
				QD := FALSE;
				PO := POS; AO := ANG;
				IF SUB_TIME(TX, last) >= max_runtime THEN STATUS := BYTE#131; END_IF;

		135:	
				QU := FALSE;
				QD := TRUE;
				PO := POS; AO := ANG;
				IF SUB_TIME(TX, last) >= max_runtime THEN STATUS := BYTE#131;	END_IF;

		136:	
				QU := TRUE;
				QD := TRUE;
				PO := PI; AO := AI;
				IF TX-last >= max_runtime THEN STATUS := BYTE#130; END_IF;

		137:
				QU := TRUE;
				QD := TRUE;
				PO := DBL_POS1;
				AO := DBL_ANG1;
				IF SUB_TIME(TX, last) >= max_runtime THEN STATUS := BYTE#131; END_IF;

		138:	
				QU := TRUE;
				QD := TRUE;
				PO := DBL_POS2;
				AO := DBL_ANG2;
				IF SUB_TIME(TX, last) >= max_runtime THEN STATUS := BYTE#131; END_IF;

		139:
				QU := FALSE;
				QD := FALSE;
				PO := POS;
				AO := ANG;

	END_CASE;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		POS :	BYTE;
		ANG :	BYTE;
		S1 :	BOOL;
		S2 :	BOOL;
		IN :	BOOL;
		PI :	BYTE;
		AI :	BYTE;
		SINGLE_SWITCH :	BOOL;
		CLICK_EN :	BOOL := TRUE;
		CLICK_TIME :	TIME := T#500ms;
		MAX_RUNTIME :	TIME := T#60s;
		MANUAL_TIMEOUT :	TIME := T#1h;
		DEBOUNCE_TIME :	TIME := T#20ms;
		DBL_CLK1 :	BOOL := FALSE;
		DBL_POS1 :	BYTE;
		DBL_ANG1 :	BYTE;
		DBL_CLK2 :	BOOL := FALSE;
		DBL_POS2 :	BYTE := BYTE#255;
		DBL_ANG2 :	BYTE := BYTE#255;
		D1_TOGGLE :	BOOL := TRUE;
		D2_TOGGLE :	BOOL := TRUE;
		MASTER_MODE :	BOOL;
		QU :	BOOL := TRUE;
		QD :	BOOL := TRUE;
		STATUS :	BYTE;
		PO :	BYTE := BYTE#255;
		AO :	BYTE := BYTE#255;
		D1 :	BOOL;
		D2 :	BOOL;
		func_block : BLIND_INPUT_Block;
	END_VAR
	func_block.POS := POS;
	func_block.ANG := ANG;
	func_block.S1 := S1 ;
	func_block.S2 := S2;
	func_block.IN := IN;
	func_block.PI := PI;
	func_block.AI := AI;
	func_block.SINGLE_SWITCH := SINGLE_SWITCH;
	func_block.CLICK_EN := CLICK_EN ;
	func_block.CLICK_TIME := CLICK_TIME;
	func_block.MAX_RUNTIME := MAX_RUNTIME;
	func_block.MANUAL_TIMEOUT := MANUAL_TIMEOUT;
	func_block.DEBOUNCE_TIME := DEBOUNCE_TIME;
	func_block.DBL_CLK1 := DBL_CLK1;
	func_block.DBL_POS1 := DBL_POS1 ;
	func_block.DBL_ANG1 := DBL_ANG1;
	func_block.DBL_CLK2 := DBL_CLK2;
	func_block.DBL_POS2 := DBL_POS2;
	func_block.DBL_ANG2 := DBL_ANG2;
	func_block.D1_TOGGLE := D1_TOGGLE ;
	func_block.D2_TOGGLE := D2_TOGGLE;
	func_block.MASTER_MODE := MASTER_MODE;
	func_block();
	QU  := func_block.QU;
	QD  := func_block.QD;
	STATUS  := func_block.STATUS;
	PO  := func_block.PO;
	AO  := func_block.AO;
	D1  := func_block.D1;
	D2  := func_block.D2;
END_PROGRAM

