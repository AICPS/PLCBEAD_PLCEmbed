FUNCTION _BYTE_TO_INT:INT
	VAR_INPUT
		IN :	BYTE;
	END_VAR

	_BYTE_TO_INT := USINT_TO_INT(BYTE_TO_USINT(IN));
END_FUNCTION

FUNCTION TIME_TO_UDINT2:UDINT
	VAR_INPUT
		X :	TIME;
	END_VAR

	TIME_TO_UDINT2 := DINT_TO_UDINT(TIME_TO_DINT(X));
END_FUNCTION

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

FUNCTION_BLOCK SIGNAL_Block

	VAR_INPUT
		IN :	BOOL;
		SIG :	BYTE;
		TS :	TIME;
	END_VAR

	VAR_OUTPUT
		Q :	BOOL;
	END_VAR

	VAR
		tx :	DWORD;
		_step :	BYTE;
		T_PLC_MS :	T_PLC_MS_Block;
	END_VAR

	IF in THEN
		T_PLC_MS();
		tx:= UDINT_TO_DWORD(T_PLC_MS.T_PLC_MS);

		IF ts > t#0s THEN
			_step := DWORD_TO_BYTE(UDINT_TO_DWORD(DWORD_TO_UDINT(tx) / TIME_TO_UDINT2(ts)) AND DWORD#16#0000_0007);
		ELSE
			_step := DWORD_TO_BYTE(SHR(tx,7) AND DWORD#16#0000_0007);
		END_IF;
		_step := SHL(BYTE#1,_BYTE_TO_INT(_step));
		Q := (_step AND sig) > BYTE#0;
	ELSE
		Q := FALSE;
	END_IF;

END_FUNCTION_BLOCK

FUNCTION_BLOCK SIGNAL_4_Block

	VAR_INPUT
		IN1 :	BOOL;
		IN2 :	BOOL;
		IN3 :	BOOL;
		IN4 :	BOOL;
		TS :	TIME;
		S1 :	BYTE := 2#1111_1111;
		S2 :	BYTE := 2#1111_0000;
		S3 :	BYTE := 2#1010_1010;
		S4 :	BYTE := 2#1010_0000;
	END_VAR

	VAR_OUTPUT
		Q :	BOOL;
	END_VAR

	VAR
		sig :	SIGNAL_Block;
	END_VAR

	IF in1 THEN
		sig(in := TRUE, sig := s1, TS := TS);
	ELSIF in2 THEN
		sig(in := TRUE, sig := s2, TS := TS);
	ELSIF in3 THEN
		sig(in := TRUE, sig := s3, TS := TS);
	ELSIF in4 THEN
		sig(in := TRUE, sig := s4, TS := TS);
	ELSE
		sig(in := FALSE);
	END_IF;

	Q := sig.Q;

END_FUNCTION_BLOCK

PROGRAM program0

	VAR
		IN1 :	BOOL;
		IN2 :	BOOL;
		IN3 :	BOOL;
		IN4 :	BOOL;
		TS :	TIME;
		S1 :	BYTE := 2#1111_1111;
		S2 :	BYTE := 2#1111_0000;
		S3 :	BYTE := 2#1010_1010;
		S4 :	BYTE := 2#1010_0000;
		Q :	BOOL;
		func_block : SIGNAL_4_Block;
	END_VAR

	func_block.IN1  :=IN1;
	func_block.IN2  :=IN2;
	func_block.IN3  :=IN3;
	func_block.IN4  :=IN4;
	func_block.TS  :=TS;
	func_block.S1  :=S1;
	func_block.S2  :=S2;
	func_block.S3  :=S3;
	func_block.S4  :=S4;
	func_block();
	Q := func_block.Q;

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