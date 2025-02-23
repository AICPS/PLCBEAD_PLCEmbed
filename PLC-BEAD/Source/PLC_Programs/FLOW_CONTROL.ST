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

FUNCTION_BLOCK TP_1D
	VAR_INPUT
		IN :	BOOL;
		PT1 :	TIME;
		PTD :	TIME;
		RST :	BOOL;
	END_VAR


	VAR_OUTPUT
		Q :	BOOL;
		W :	BOOL;
	END_VAR

	VAR
		tx :	TIME;
		start :	TIME;
		ix :	BOOL;
		T_PLC_MS :	T_PLC_MS_block;
	END_VAR

	T_PLC_MS();
	tx := UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

	IF RST THEN
		Q := FALSE;
		rst := FALSE;
		W := FALSE;
	ELSIF W THEN
		IF tx - start >= PTD THEN
			W := FALSE;
		END_IF;
	ELSIF IN AND NOT ix THEN
		Q := TRUE;
		start := tx;
		in := FALSE;
	ELSIF tx - start >= PT1 THEN
		Q := FALSE;
		W := TRUE;
		start := tx;
	END_IF;

	ix := IN;

END_FUNCTION_BLOCK

FUNCTION_BLOCK FLOW_CONTROL
	VAR_INPUT
		IN :	BOOL;
		REQ :	BOOL;
		ENQ :	BOOL;
		RST :	BOOL := FALSE;
		T_AUTO :	TIME := T#1h;
		T_DELAY :	TIME := T#23h;
	END_VAR

	VAR_OUTPUT
		Q :	BOOL;
		STATUS :	BYTE;
	END_VAR

	VAR
		timer :	TP_1D;
	END_VAR

	STATUS := BYTE#100;
	IF RST THEN
		Q := FALSE;
		timer(rst := TRUE);
		timer.RST := FALSE;
		STATUS := BYTE#103;
	ELSIF ENQ THEN
		IF IN THEN
			status := BYTE#101;
		END_IF;
		IF REQ THEN
			(* timer will generate a timed pulse after TP goes high *)
			timer.PT1 := T_AUTO;
			timer.PTD := T_DELAY;
			timer.IN := TRUE;
			STATUS := BYTE#102;
		END_IF;
	END_IF;

	timer();
	timer.IN := FALSE;
	Q := (IN AND ENQ) OR timer.Q;
END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	IN      :	BOOL;
	REQ     :	BOOL;
	ENQ     :	BOOL;
	RST     :	BOOL ;
	T_AUTO  :	TIME ;
	T_DELAY :	TIME ;

	Q      :	BOOL;
	STATUS :	BYTE;

	func_block : FLOW_CONTROL;
  END_VAR
	func_block.IN     :=IN     ;
	func_block.REQ    :=REQ    ;
	func_block.ENQ    :=ENQ    ;
	func_block.RST    :=RST    ;
	func_block.T_AUTO :=T_AUTO ;
	func_block.T_DELAY:=T_DELAY;
	func_block();
	Q     := func_block.Q     ;
	STATUS:= func_block.STATUS;
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