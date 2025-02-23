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

FUNCTION_BLOCK RMP_SOFT_Block

	VAR_INPUT
		IN :	BOOL;
		VAL :	BYTE;
		PT_ON :	TIME := T#100ms;
		PT_OFF :	TIME := T#100ms;
	END_VAR

	VAR_OUTPUT
		OUT :	BYTE := BYTE#00;
	END_VAR


	VAR
		rmp :	_RMP_B;
		tmp :	BYTE;
	END_VAR


	tmp := SEL(IN, BYTE#0, VAL);
	IF tmp > OUT THEN
		(* we need to ramp down *)
		rmp(DIR := TRUE, E := TRUE, TR := PT_ON, RMP := OUT);
		OUT := rmp.RMP; 
		(* make sure OUT does not surpass tmp *)
		OUT := MIN(OUT, tmp);
	ELSIF tmp < OUT THEN
		(* we need to ramp up *)
		rmp(DIR := FALSE, E := TRUE, TR := PT_OFF, RMP := OUT);
		OUT := rmp.RMP; 
		(* make sure OUT does not surpass tmp *)
		OUT := MAX(OUT, tmp);
	ELSE
		(* no ramp necessary *)
		rmp(E := FALSE, RMP := OUT);
		OUT := rmp.RMP; 
	END_IF;


END_FUNCTION_BLOCK


PROGRAM program0
	VAR
		IN :	BOOL;
		VAL :	BYTE;
		PT_ON :	TIME;
		PT_OFF : TIME;

		OUT  :	BYTE;

		func_block : RMP_SOFT_Block;
	END_VAR
		func_block.IN := IN;
		func_block.VAL := VAL;
		func_block.PT_ON := PT_ON;
		func_block.PT_OFF := PT_OFF;
		func_block();
		OUT  := func_block.OUT ;

END_PROGRAM

