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
		TX :	TIME;
		START :	TIME;
		ix :	BOOL;
		T_PLC_MS :	T_PLC_MS_block;
		RSTT :	BOOL;
	END_VAR

	T_PLC_MS();
	TX := UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

	RSTT := RST;
	
	IF RSTT THEN
		Q := FALSE;
		RSTT := FALSE;
		W := FALSE;
	ELSIF W THEN
		IF SUB_TIME(TX , START) >= PTD THEN
			W := FALSE;
		END_IF;
	ELSIF IN AND NOT ix THEN
		Q := TRUE;
		START := TX;
		IN := FALSE;
	ELSIF TX - START >= PT1 THEN
		Q := FALSE;
		W := TRUE;
		START := TX;
	END_IF;

	ix := IN;

END_FUNCTION_BLOCK


PROGRAM program0
  VAR
	IN :	BOOL;
	PT1 :	TIME;
	PTD :	TIME;
	RST :	BOOL;
	Q :	BOOL;
	W :	BOOL;
	func_block : TP_1D;
  END_VAR
	func_block.IN  :=IN;
	func_block.PT1  :=PT1;
	func_block.PTD  :=PTD;
	func_block.RST  :=RST;
	func_block();
	Q := func_block.Q;
	W := func_block.W;
END_PROGRAM

