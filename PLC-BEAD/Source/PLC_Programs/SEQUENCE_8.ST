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
		debug :	BOOL;
		N :	INT;
		Offset :	UDINT;
		temp :	DWORD := DWORD#1;
		mode :	BOOL;
		faktor :	UDINT;
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

FUNCTION_BLOCK SEQUENCE_8_Block

	VAR_INPUT
		IN0 :	BOOL := TRUE;
		IN1 :	BOOL := TRUE;
		IN2 :	BOOL := TRUE;
		IN3 :	BOOL := TRUE;
		IN4 :	BOOL := TRUE;
		IN5 :	BOOL := TRUE;
		IN6 :	BOOL := TRUE;
		IN7 :	BOOL := TRUE;
		START :	BOOL;
		RST :	BOOL;
		WAIT0 :	TIME;
		DELAY0 :	TIME;
		WAIT1 :	TIME;
		DELAY1 :	TIME;
		WAIT2 :	TIME;
		DELAY2 :	TIME;
		WAIT3 :	TIME;
		DELAY3 :	TIME;
		WAIT4 :	TIME;
		DELAY4 :	TIME;
		WAIT5 :	TIME;
		DELAY5 :	TIME;
		WAIT6 :	TIME;
		DELAY6 :	TIME;
		WAIT7 :	TIME;
		DELAY7 :	TIME;
		STOP_ON_ERROR :	BOOL;
	END_VAR

	VAR_OUTPUT
		Q0 :	BOOL;
		Q1 :	BOOL;
		Q2 :	BOOL;
		Q3 :	BOOL;
		Q4 :	BOOL;
		Q5 :	BOOL;
		Q6 :	BOOL;
		Q7 :	BOOL;
		QX :	BOOL;
		RUN :	BOOL;
		_STEP :	INT := -1;
		STATUS :	BYTE;
	END_VAR

	VAR
		last :	TIME;
		edge :	BOOL;
		tx :	TIME;
		init :	BOOL;
		T_PLC_MS :	T_PLC_MS_Block;
	END_VAR	

	T_PLC_MS();
	tx:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

	IF NOT init THEN
		last := tx;
		init := TRUE;
		status := BYTE#110;
	END_IF;

	IF rst THEN
		_step := -1;
		Q0 := FALSE;
		Q1 := FALSE;
		Q2 := FALSE;
		Q3 := FALSE;
		Q4 := FALSE;
		Q5 := FALSE;
		Q6 := FALSE;
		Q7 := FALSE;
		status := BYTE#110;
		run := FALSE;

	ELSIF start AND NOT edge THEN
		_step := 0;
		last := tx;
		status := BYTE#111;
		Q0 := FALSE;
		Q1 := FALSE;
		Q2 := FALSE;
		Q3 := FALSE;
		Q4 := FALSE;
		Q5 := FALSE;
		Q6 := FALSE;
		Q7 := FALSE;
		run := TRUE;
	END_IF;
	edge := start;

	IF status > BYTE#0 AND status < BYTE#100 AND stop_on_error THEN RETURN; END_IF;

	IF run AND _step = 0 THEN
		IF NOT q0 AND in0 AND tx - last <= wait0 THEN
			Q0 := TRUE;
			last := tx;
		ELSIF NOT q0 AND tx - last > wait0 THEN
			status := BYTE#1;
			run := FALSE;
		ELSIF q0 AND tx - last >= delay0 THEN
			_step := 1;
			last := tx;
		END_IF;
	END_IF;
	IF run AND _step = 1 THEN
		IF NOT q1 AND in1 AND tx - last <= wait1 THEN
			Q0 := FALSE;
			Q1 := TRUE;
			last := tx;
		ELSIF NOT q1 AND Tx - last > wait1 THEN
			status := BYTE#2;
			q0 := FALSE;
			run := FALSE;
		ELSIF q1 AND tx - last >= delay1 THEN
			_step := 2;
			last := tx;
		END_IF;
	END_IF;
	IF run AND _step = 2 THEN
		IF NOT q2 AND in2 AND tx - last <= wait2 THEN
			Q1 := FALSE;
			Q2 := TRUE;
			last := tx;
		ELSIF NOT q2 AND Tx - last > wait2 THEN
			status := BYTE#3;
			q1 := FALSE;
			run := FALSE;
		ELSIF q2 AND tx - last >= delay2 THEN
			_step := 3;
			last := tx;
		END_IF;
	END_IF;
	IF run AND _step = 3 THEN
		IF NOT q3 AND in3 AND tx - last <= wait3 THEN
			Q2 := FALSE;
			Q3 := TRUE;
			last := tx;
		ELSIF NOT q3 AND Tx - last > wait3 THEN
			status := BYTE#4;
			q2 := FALSE;
			run := FALSE;
		ELSIF q3 AND tx - last >= delay3 THEN
			_step := 4;
			last := tx;
		END_IF;
	END_IF;
	IF run AND _step = 4 THEN
		IF NOT q4 AND in4 AND tx - last <= wait4 THEN
			Q3 := FALSE;
			Q4 := TRUE;
			last := tx;
		ELSIF NOT q4 AND Tx - last > wait4 THEN
			status := BYTE#5;
			q3 := FALSE;
			run := FALSE;
		ELSIF q4 AND tx - last >= delay4 THEN
			_step := 5;
			last := tx;
		END_IF;
	END_IF;
	IF run AND _step = 5 THEN
		IF NOT q5 AND in5 AND tx - last <= wait5 THEN
			Q4 := FALSE;
			Q5 := TRUE;
			last := tx;
		ELSIF NOT q5 AND Tx - last > wait5 THEN
			status := BYTE#6;
			q4 := FALSE;
			run := FALSE;
		ELSIF q5 AND tx - last >= delay5 THEN
			_step := 6;
			last := tx;
		END_IF;
	END_IF;
	IF run AND _step = 6 THEN
		IF NOT q6 AND in6 AND tx - last <= wait6 THEN
			Q5 := FALSE;
			Q6 := TRUE;
			last := tx;
		ELSIF NOT q6 AND Tx - last > wait6 THEN
			status := BYTE#7;
			q5 := FALSE;
			run := FALSE;
		ELSIF q6 AND tx - last >= delay6 THEN
			_step := 7;
			last := tx;
		END_IF;
	END_IF;
	IF run AND _step = 7 THEN
		IF NOT q7 AND in7 AND tx - last <= wait7 THEN
			Q6 := FALSE;
			Q7 := TRUE;
			last := tx;
		ELSIF NOT q7 AND Tx - last > wait7 THEN
			status := BYTE#8;
			q6 := FALSE;
			run := FALSE;
		ELSIF q7 AND tx - last >= delay7 THEN
			_step := -1;
			Q7 := FALSE;
			Run := FALSE;
			status := BYTE#110;
		END_IF;
	END_IF;
	QX := q0 OR q1 OR q2 OR q3 OR q4 OR q5 OR q6 OR q7;

END_FUNCTION_BLOCK

PROGRAM program0

	VAR
		IN0 :	BOOL := TRUE;
		IN1 :	BOOL := TRUE;
		IN2 :	BOOL := TRUE;
		IN3 :	BOOL := TRUE;
		IN4 :	BOOL := TRUE;
		IN5 :	BOOL := TRUE;
		IN6 :	BOOL := TRUE;
		IN7 :	BOOL := TRUE;
		START :	BOOL;
		RST :	BOOL;
		WAIT0 :	TIME;
		DELAY0 :	TIME;
		WAIT1 :	TIME;
		DELAY1 :	TIME;
		WAIT2 :	TIME;
		DELAY2 :	TIME;
		WAIT3 :	TIME;
		DELAY3 :	TIME;
		WAIT4 :	TIME;
		DELAY4 :	TIME;
		WAIT5 :	TIME;
		DELAY5 :	TIME;
		WAIT6 :	TIME;
		DELAY6 :	TIME;
		WAIT7 :	TIME;
		DELAY7 :	TIME;
		STOP_ON_ERROR :	BOOL;
		Q0 :	BOOL;
		Q1 :	BOOL;
		Q2 :	BOOL;
		Q3 :	BOOL;
		Q4 :	BOOL;
		Q5 :	BOOL;
		Q6 :	BOOL;
		Q7 :	BOOL;
		QX :	BOOL;
		RUN :	BOOL;
		_STEP :	INT := -1;
		STATUS :	BYTE;
		func_block : SEQUENCE_8_Block;
  	END_VAR
	func_block.IN0  :=IN0;
	func_block.IN1  :=IN1;
	func_block.IN2  :=IN2;
	func_block.IN3  :=IN3;
	func_block.IN4  :=IN4;
	func_block.IN5  :=IN5;
	func_block.IN6  :=IN6;
	func_block.IN7  :=IN7;
	func_block.START  :=START;
	func_block.RST  :=RST;
	func_block.WAIT0  :=WAIT0;
	func_block.DELAY0  :=DELAY0;
	func_block.WAIT1:=WAIT1;
	func_block.DELAY1:=DELAY1;
	func_block.WAIT2  :=WAIT2;
	func_block.DELAY2  :=DELAY2;
	func_block.WAIT3  :=WAIT3;
	func_block.DELAY3  :=DELAY3;
	func_block.DELAY1:=DELAY1;
	func_block.WAIT2  :=WAIT2;
	func_block.DELAY2  :=DELAY2;
	func_block.WAIT3  :=WAIT3;
	func_block.DELAY3  :=DELAY3;
	func_block.WAIT4:=WAIT4;
	func_block.DELAY4  :=DELAY4;
	func_block.WAIT5  :=WAIT5;
	func_block.DELAY5  :=DELAY5;
	func_block.WAIT6  :=WAIT6;
	func_block.DELAY6  :=DELAY6;
	func_block.WAIT7  :=WAIT7;
	func_block.DELAY7  :=DELAY7;
	func_block.STOP_ON_ERROR  :=STOP_ON_ERROR;
	func_block();
	Q0 := func_block.Q0;
	Q1 := func_block.Q1;
	Q2 := func_block.Q2;
	Q3 := func_block.Q3;
	Q4 := func_block.Q4;
	Q5 := func_block.Q5;
	Q6 := func_block.Q6;
	Q7 := func_block.Q7;
	QX := func_block.QX;
	RUN := func_block.RUN;
	_STEP := func_block._STEP;
	STATUS := func_block.STATUS;
	
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