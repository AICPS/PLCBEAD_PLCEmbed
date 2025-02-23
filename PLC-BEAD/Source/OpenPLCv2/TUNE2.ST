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

FUNCTION TIME_TO_UDINT2:UDINT
	VAR_INPUT
		X :	TIME;
	END_VAR

	TIME_TO_UDINT2 := DINT_TO_UDINT(TIME_TO_DINT(X));
END_FUNCTION

FUNCTION_BLOCK TUNE2_Block

	VAR_INPUT
		SET :	BOOL;
		SU :	BOOL;
		SD :	BOOL;
		FU :	BOOL;
		FD :	BOOL;
		RST :	BOOL;
		SS :	REAL := 0.1;
		FS :	REAL := 5.0;
		LIMIT_L :	REAL;
		LIMIT_H :	REAL := 100.0;
		RST_VAL :	REAL;
		SET_VAL :	REAL := 100.0;
		TR :	TIME := T#500ms;
		S1 :	REAL := 2.0;
		S2 :	REAL := 10.0;
	END_VAR

	VAR_OUTPUT
		Y :	REAL;
	END_VAR

	VAR
		tx :	UDINT;
		start :	UDINT;
		state :	INT;
		in :	BOOL;
		step2 :	REAL;
		speed :	REAL;
		Y_start :	REAL;
		T_PLC_MS :	T_PLC_MS_block;
	END_VAR

	T_PLC_MS();
	tx:= T_PLC_MS.T_PLC_MS;

	IF rst THEN
		Y := RST_val;
		state := 0;
	ELSIF set THEN
		Y := SET_val;
		state := 0;
	ELSIF state > 0 THEN
		CASE state OF
			1 :	
				in := su;
			2 :	
				in := sd;
			3 :	
				in := fu;
			4 :	
				in := fd;
		END_CASE;
		IF NOT in AND tx - start <= TIME_TO_UDINT2(TR) THEN
			Y := Y_start + step2;
			state := 0;
		ELSIF in AND tx - start >= TIME_TO_UDINT2(TR) THEN
			Y := Y_start + UDINT_TO_REAL(tx - start - TIME_TO_UDINT2(TR)) * speed;
		ELSIF NOT in THEN
			state := 0;
		END_IF;
	ELSIF su THEN
		state := 1;
		start := tx;
		step2 := ss;
		speed := s1 * 1.0E-3;
		Y_start := Y;
	ELSIF sd THEN
		state := 2;
		start := tx;
		step2 := -ss;
		speed := -s1 * 1.0E-3;
		Y_start := Y;
	ELSIF fu THEN
		state := 3;
		start := tx;
		step2 := fs;
		speed := s2 * 1.0E-3;
		y_start := Y;
	ELSIF fd THEN
		state := 4;
		start := tx;
		step2 := -fs;
		speed := -s2 * 1.0E-3;
		y_start := Y;
	END_IF;
END_FUNCTION_BLOCK

PROGRAM program0
  	VAR
		SET :	BOOL;
		SU :	BOOL;
		SD :	BOOL;
		FU :	BOOL;
		FD :	BOOL;
		RST :	BOOL;
		SS :	REAL;
		FS :	REAL;
		LIMIT_L :	REAL;
		LIMIT_H :	REAL;
		RST_VAL :	REAL;
		SET_VAL :	REAL;
		TR :	TIME ;
		S1 :	REAL;
		S2 :	REAL;
		Y :	REAL;
		func_block : TUNE2_Block;
  	END_VAR
	func_block.SET := SET;
	func_block.SU := SU;
	func_block.SD := SD;
	func_block.FU := FU;
	func_block.FD := FD;
	func_block.RST := RST;
	func_block.SS:= SS;
	func_block.FS := FS;
	func_block.LIMIT_L := LIMIT_L;
	func_block.LIMIT_H := LIMIT_H;
	func_block.RST_VAL := RST_VAL;
	func_block.SET_VAL := SET_VAL;
	func_block.TR := TR;
	func_block.S1 := S1;
	func_block.S2 := S2;
	func_block();
	Y := func_block.Y;
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