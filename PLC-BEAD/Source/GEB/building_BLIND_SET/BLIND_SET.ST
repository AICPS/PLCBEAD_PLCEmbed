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

FUNCTION_BLOCK BLIND_SET_Block

	VAR_INPUT
		UP :	BOOL;
		DN :	BOOL;
		S_IN :	INT;
		PI :	BYTE;
		AI :	BYTE;
		IN :	BOOL;
		PX :	BYTE;
		AX :	BYTE;
		OVERRIDE_MANUAL :	BOOL;
		RESTORE_POSITION :	BOOL;
		RESTORE_TIME :	TIME := T#60s;
	END_VAR


	VAR_OUTPUT
		QU :	BOOL;
		QD :	BOOL;
		STATUS :	INT;
		PO :	BYTE;
		AO :	BYTE;
	END_VAR


	VAR
		T_PLC_MS :	T_PLC_MS_block;
		TX :	TIME;
		ps :	BYTE;
		as :	BYTE;
		last :	TIME;
	END_VAR

	T_PLC_MS();
	TX:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

	IF IN THEN
		IF override_MANUAL OR (UP AND DN) THEN
			STATUS := 178;
		END_IF;
	END_IF;

	CASE STATUS OF
		0: 
			STATUS := S_IN;

		178: 
			PO := PX;
			AO := AX;
			QU := TRUE;
			QD := TRUE;
			IF NOT IN THEN
				STATUS := SEL(RESTORE_POSITION, S_IN, 179);
				last := TX;
			END_IF;

		179:
			PO := ps;
			AO := as;
			IF ((PO = PI) AND (AO = AI))  OR SUB_TIME(TX, last) >= RESTORE_TIME THEN
				STATUS := S_IN;
			END_IF;

	ELSE
		PO := PI;
		ps := PI;
		AO := AI;
		as := AI;
		STATUS := S_IN;
		QU := UP;
		QD := DN;
	END_CASE;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		UP :	BOOL;
		DN :	BOOL;
		S_IN :	INT;
		PI :	BYTE;
		AI :	BYTE;
		IN :	BOOL;
		PX :	BYTE;
		AX :	BYTE;
		OVERRIDE_MANUAL :	BOOL;
		RESTORE_POSITION :	BOOL;
		RESTORE_TIME :	TIME := T#60s;
		QU :	BOOL;
		QD :	BOOL;
		STATUS :	INT;
		PO :	BYTE;
		AO :	BYTE;

		func_block : BLIND_SET_Block;
	END_VAR
	func_block.UP := UP;
	func_block.DN := DN;
	func_block.S_IN := S_IN ;
	func_block.PI    := PI    ;
	func_block.AI := AI;
	func_block.IN := IN;
	func_block.PX := PX ;
	func_block.AX := AX ;
	func_block.OVERRIDE_MANUAL    := OVERRIDE_MANUAL    ;
	func_block.RESTORE_POSITION := RESTORE_POSITION;
	func_block.RESTORE_TIME := RESTORE_TIME;

	func_block();
	QU  := func_block.QU;
	QD  := func_block.QD;
	STATUS  := func_block.STATUS;
	PO  := func_block.PO;
	AO  := func_block.AO;
END_PROGRAM

