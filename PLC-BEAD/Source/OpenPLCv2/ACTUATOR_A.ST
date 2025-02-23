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

FUNCTION_BLOCK CYCLE_4

	VAR_INPUT
		E :	BOOL := TRUE;
		T0 :	TIME;
		T1 :	TIME;
		T2 :	TIME;
		T3 :	TIME;
		S0 :	BOOL;
		SX :	INT;
		SL :	BOOL;
	END_VAR


	VAR_OUTPUT
		STATE :	INT;
	END_VAR

	VAR
		tx :	TIME;
		last :	TIME;
		init :	BOOL;
		T_PLC_MS :	T_PLC_MS_block;
	END_VAR

	T_PLC_MS();
	tx:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

	(* init on first cycle *)
	IF NOT init THEN
		init := TRUE;
		last := tx;
	END_IF;

	IF E THEN
		IF SL THEN
			(* when sx > 0 then the state sx is forced to start *)
			state:= LIMIT(0,SX,3);
			last := tx;
			(* this is to avoid to reset sx from the calling programm it does work fine on codesys but i am not sure about other systems, because we are writing to an input *)
			SL := FALSE;
		ELSE
			CASE state OF
				0 :	(* wait for T0 and switch to next cycle *)
					IF tx - last >= T0 THEN
						state := 1;
						last := tx;
					END_IF;
				1 : (* wait for T1 over 1st cycle *)
					IF tx - last >= T1 THEN
						state := 2;
						last := tx;
					END_IF;
				2 : (* wait for T1 over 1st cycle *)
					IF tx - last >= T2 THEN
						state := 3;
						last := tx;
					END_IF;
				3 : (* wait for T2 over 2nd cycle *)
					IF tx - last >= T3 THEN
						IF S0 THEN State := 0; END_IF; (* if S0 is false, the sequence stops at state 3 *)
						last := tx;
					END_IF;
			END_CASE;
		END_IF;
	ELSE
		state := 0;
		last := tx;
	END_IF;

END_FUNCTION_BLOCK

FUNCTION_BLOCK ACTUATOR_A_Block

	VAR_INPUT
		I1 :	BYTE;
		IS :	BOOL;
		I2 :	BYTE;
		RV :	BOOL;
		DX :	BOOL;
		RUNTIME :	TIME;
		SELF_ACT_TIME :	TIME;
		OUT_MIN :	DWORD;
		OUT_MAX :	DWORD;
	END_VAR


	VAR_OUTPUT
		Y :	DWORD;
	END_VAR


	VAR
		timer :	CYCLE_4;
		dx_edge :	BOOL;
	END_VAR

	timer(T0 := RUNTIME, T1 := RUNTIME, T3 := SELF_ACT_TIME, sl := DX AND NOT dx_edge, sx := 0, S0 := SELF_ACT_TIME > t#0s);
	dx_edge := dx;

	CASE timer.STATE OF
		0: 	
			Y := OUT_MIN;
		1:
			Y := OUT_MAX;
		3:	
			IF rv THEN
				Y := UDINT_TO_DWORD(DWORD_TO_UDINT(OUT_MAX) - (DWORD_TO_UDINT(OUT_MAX) - DWORD_TO_UDINT(OUT_MIN)) * BYTE_TO_UDINT(SEL(IS, I1, I2)) / UDINT#255);
			ELSE
				Y := UDINT_TO_DWORD((DWORD_TO_UDINT(OUT_MAX) - DWORD_TO_UDINT(OUT_MIN)) * BYTE_TO_UDINT(SEL(IS, I1, I2)) / UDINT#255 + DWORD_TO_UDINT(OUT_MIN));
			END_IF;
	END_CASE;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		I1 :	BYTE;
		IS :	BOOL;
		I2 :	BYTE;
		RV :	BOOL;
		DX :	BOOL;
		RUNTIME :	TIME;
		SELF_ACT_TIME :	TIME;
		OUT_MIN :	DWORD;
		OUT_MAX :	DWORD;
		Y :	DWORD;
		func_block : ACTUATOR_A_Block;
	END_VAR
	func_block.I1 := I1;
	func_block.IS := IS;
	func_block.I2 := I2 ;
	func_block.RV := RV;
	func_block.DX := DX;
	func_block.RUNTIME := RUNTIME;
	func_block.SELF_ACT_TIME := SELF_ACT_TIME ;
	func_block.OUT_MIN := OUT_MIN;
	func_block.OUT_MAX := OUT_MAX;
	func_block();
	Y  := func_block.Y;
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