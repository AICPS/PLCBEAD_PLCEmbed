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

FUNCTION_BLOCK FT_PROFILE

	VAR_INPUT
		K :	REAL := 1.0;
		O :	REAL := 0.0;
		M :	REAL := 1.0;
		E :	BOOL;
		VALUE_0 :	REAL;
		TIME_1 :	TIME;
		VALUE_1 :	REAL;
		TIME_2 :	TIME;
		VALUE_2 :	REAL;
		TIME_3 :	TIME;
		VALUE_3 :	REAL;
		TIME_10 :	TIME;
		VALUE_10 :	REAL;
		TIME_11 :	TIME;
		VALUE_11 :	REAL;
		TIME_12 :	TIME;
		VALUE_12 :	REAL;
		TIME_13 :	TIME;
		VALUE_13 :	REAL;
	END_VAR


	VAR_OUTPUT
		Y :	REAL;
		RUN :	BOOL;
		ET :	TIME;
	END_VAR


	VAR
		TX :	TIME;
		edge :	BOOL;
		STATE :	INT;
		ta :	TIME;
		tb :	TIME;
		t0 :	TIME;
		temp :	REAL;
		va :	REAL;
		vb :	REAL;
		T_PLC_MS :	T_PLC_MS_block;
	END_VAR

	T_PLC_MS();
	TX:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

	(* determine START condition *)
	IF E AND NOT edge THEN
		RUN := TRUE;
		ET := t#0s;
		t0 := TX;
		ta := TX;
		tb := MULTIME(TIME_1, M);
		va := VALUE_0;
		vb := VALUE_1;
		temp := VALUE_0;
		STATE := 1;
	END_IF;
	edge := E;

	(* generate STARTup profile *)
	IF RUN THEN
		CASE STATE OF
			1:	IF SUB_TIME (TX, tb) >= tb THEN
					ta := ADD_TIME(ta, tb);
					tb := MULTIME(SUB_TIME(TIME_2,  TIME_1), M);
					va := VALUE_1;
					vb := VALUE_2;
					temp := VALUE_1;
					STATE := 2;
				ELSE
					temp := ((vb - va) * TIME_TO_REAL(SUB_TIME (TX, tb)) / TIME_TO_REAL(tb) + va);
				END_IF;
			2:	IF SUB_TIME (TX, tb) >= tb THEN
					ta := ADD_TIME(ta, tb);
					tb := MULTIME(SUB_TIME(TIME_3 , TIME_2), M);
					va := VALUE_2;
					vb := VALUE_3;
					temp := VALUE_2;
					STATE := 3;
				ELSE
					temp := ((vb - va) * TIME_TO_REAL(SUB_TIME (TX, tb)) / TIME_TO_REAL(tb) + va);
				END_IF;
			3:	IF SUB_TIME (TX, tb) >= tb THEN
					ta := ADD_TIME(ta, tb);
					tb := MULTIME(SUB_TIME(TIME_10 , TIME_3), M);
					va := VALUE_3;
					vb := VALUE_10;
					temp := VALUE_3;
					STATE := 4;
				ELSE
					temp := ((vb - va) * TIME_TO_REAL(SUB_TIME (TX, tb)) / TIME_TO_REAL(tb) + va);
				END_IF;
			4 :	IF SUB_TIME (TX, tb) >= tb THEN
					ta := ADD_TIME(ta, tb);
					tb := MULTIME(SUB_TIME(TIME_11 , TIME_10), M);
					va := VALUE_10;
					vb := VALUE_11;
					temp := VALUE_10;
					IF E THEN STATE := 5; ELSE STATE := 6; END_IF;
				ELSE
					temp := ((vb - va) * TIME_TO_REAL(SUB_TIME (TX, tb)) / TIME_TO_REAL(tb) + va);
				END_IF;
			5:	(* extend the SIGNal while E is true *)
				IF E THEN
					ta := TX;
				ELSE
					STATE := 6;
				END_IF;
			6:	IF SUB_TIME (TX, tb) >= tb THEN
					ta := ADD_TIME(ta, tb);
					tb := MULTIME(SUB_TIME(TIME_12 , TIME_11), M);
					va := VALUE_11;
					vb := VALUE_12;
					temp := VALUE_11;
					STATE := 7;
				ELSE
					temp := ((vb - va) * TIME_TO_REAL(SUB_TIME (TX, tb)) / TIME_TO_REAL(tb) + va);
				END_IF;
			7:	IF SUB_TIME (TX, tb) >= tb THEN
					ta := ADD_TIME(ta, tb);
					tb := MULTIME(SUB_TIME(TIME_13 , TIME_12), M);
					va := VALUE_12;
					vb := VALUE_13;
					temp := VALUE_12;
					STATE := 8;
				ELSE
					temp := ((vb - va) * TIME_TO_REAL(SUB_TIME (TX, tb)) / TIME_TO_REAL(tb) + va);
				END_IF;
			8:	IF SUB_TIME (TX, tb) >= tb THEN
					temp := VALUE_13;
					RUN := FALSE;
				ELSE
					temp := ((vb - va) * TIME_TO_REAL(SUB_TIME (TX, tb)) / TIME_TO_REAL(tb) + va);
				END_IF;
		END_CASE;
		Y := temp * K + O;
		ET := SUB_TIME(TX , t0);
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		K :	REAL := 1.0;
		O :	REAL := 0.0;
		M :	REAL := 1.0;
		E :	BOOL;
		VALUE_0 :	REAL;
		TIME_1 :	TIME;
		VALUE_1 :	REAL;
		TIME_2 :	TIME;
		VALUE_2 :	REAL;
		TIME_3 :	TIME;
		VALUE_3 :	REAL;
		TIME_10 :	TIME;
		VALUE_10 :	REAL;
		TIME_11 :	TIME;
		VALUE_11 :	REAL;
		TIME_12 :	TIME;
		VALUE_12 :	REAL;
		TIME_13 :	TIME;
		VALUE_13 :	REAL;

		Y :	REAL;
		RUN :	BOOL;
		ET :	TIME;

		func_block : FT_PROFILE;
	END_VAR
	func_block.K  := K ;
	func_block.O  := O ;
	func_block.M  := M ;
	func_block.E  := E ;
	func_block.VALUE_0  := VALUE_0 ;
	func_block.TIME_1  := TIME_1 ;
	func_block.VALUE_1  := VALUE_1 ;
	func_block.TIME_2  := TIME_2 ;
	func_block.VALUE_2  := VALUE_2 ;
	func_block.TIME_3  := TIME_3 ;
	func_block.VALUE_3  := VALUE_3 ;
	func_block.TIME_10  := TIME_10 ;
	func_block.VALUE_10  := VALUE_10 ;
	func_block.TIME_11  := TIME_11 ;
	func_block.VALUE_11  := VALUE_11 ;
	func_block.TIME_12  := TIME_12 ;
	func_block.VALUE_12  := VALUE_12 ;
	func_block.TIME_13  := TIME_13 ;
	func_block.VALUE_13  := VALUE_13 ;
	func_block();
	Y := func_block.Y;
	RUN := func_block.RUN;
	ET := func_block.ET;
END_PROGRAM

