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
		tx :	TIME;
		edge :	BOOL;
		state :	INT;
		ta :	TIME;
		tb :	TIME;
		t0 :	TIME;
		temp :	REAL;
		va :	REAL;
		vb :	REAL;
		T_PLC_MS :	T_PLC_MS_block;
	END_VAR

	T_PLC_MS();
	tx:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

	(* determine start condition *)
	IF E AND NOT edge THEN
		RUN := TRUE;
		ET := t#0s;
		t0 := tx;
		ta := tx;
		tb := multime(time_1, M);
		va := value_0;
		vb := value_1;
		temp := value_0;
		state := 1;
	END_IF;
	edge := E;

	(* generate startup profile *)
	IF run THEN
		CASE state OF
			1:	IF tx - ta >= tb THEN
					ta := ta + tb;
					tb := multime(time_2 - time_1, M);
					va := value_1;
					vb := value_2;
					temp := value_1;
					state := 2;
				ELSE
					temp := ((vb - va) * TIME_TO_REAL(tx - ta) / TIME_TO_REAL(tb) + va);
				END_IF;
			2:	IF tx - ta >= tb THEN
					ta := ta + tb;
					tb := multime(time_3 - time_2, M);
					va := value_2;
					vb := value_3;
					temp := value_2;
					state := 3;
				ELSE
					temp := ((vb - va) * TIME_TO_REAL(tx - ta) / TIME_TO_REAL(tb) + va);
				END_IF;
			3:	IF tx - ta >= tb THEN
					ta := ta + tb;
					tb := multime(time_10 - time_3, M);
					va := value_3;
					vb := value_10;
					temp := value_3;
					state := 4;
				ELSE
					temp := ((vb - va) * TIME_TO_REAL(tx - ta) / TIME_TO_REAL(tb) + va);
				END_IF;
			4 :	IF tx - ta >= tb THEN
					ta := ta + tb;
					tb := multime(time_11 - time_10, M);
					va := value_10;
					vb := value_11;
					temp := value_10;
					IF E THEN state := 5; ELSE state := 6; END_IF;
				ELSE
					temp := ((vb - va) * TIME_TO_REAL(tx - ta) / TIME_TO_REAL(tb) + va);
				END_IF;
			5:	(* extend the signal while E is true *)
				IF E THEN
					ta := tx;
				ELSE
					state := 6;
				END_IF;
			6:	IF tx - ta >= tb THEN
					ta := ta + tb;
					tb := multime(time_12 - time_11, M);
					va := value_11;
					vb := value_12;
					temp := value_11;
					state := 7;
				ELSE
					temp := ((vb - va) * TIME_TO_REAL(tx - ta) / TIME_TO_REAL(tb) + va);
				END_IF;
			7:	IF tx - ta >= tb THEN
					ta := ta + tb;
					tb := multime(time_13 - time_12, M);
					va := value_12;
					vb := value_13;
					temp := value_12;
					state := 8;
				ELSE
					temp := ((vb - va) * TIME_TO_REAL(tx - ta) / TIME_TO_REAL(tb) + va);
				END_IF;
			8:	IF tx - ta >= tb THEN
					temp := value_13;
					run := FALSE;
				ELSE
					temp := ((vb - va) * TIME_TO_REAL(tx - ta) / TIME_TO_REAL(tb) + va);
				END_IF;
		END_CASE;
		Y := temp * K + O;
		ET := tx - t0;
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