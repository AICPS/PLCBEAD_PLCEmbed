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
		debug :	BOOL;
		N :	INT;
		Offset :	UDINT;
		temp :	DWORD := DWORD#1;
		MODE :	BOOL;
		faktor :	UDINT;
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
		TX :	TIME;
		init :	BOOL;
		T_PLC_MS :	T_PLC_MS_block;
	END_VAR	

	T_PLC_MS();
	TX:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

	IF NOT init THEN
		last := TX;
		init := TRUE;
		STATUS := BYTE#110;
	END_IF;

	IF RST THEN
		_STEP := -1;
		Q0 := FALSE;
		Q1 := FALSE;
		Q2 := FALSE;
		Q3 := FALSE;
		Q4 := FALSE;
		Q5 := FALSE;
		Q6 := FALSE;
		Q7 := FALSE;
		STATUS := BYTE#110;
		run := FALSE;

	ELSIF START AND NOT edge THEN
		_STEP := 0;
		last := TX;
		STATUS := BYTE#111;
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
	edge := START;

	IF STATUS > BYTE#0 AND STATUS < BYTE#100 AND STOP_on_ERROR THEN RETURN; END_IF;

	IF run AND _STEP = 0 THEN
		IF NOT q0 AND IN0 AND SUB_TIME(TX, last) <= wait0 THEN
			Q0 := TRUE;
			last := TX;
		ELSIF NOT q0 AND SUB_TIME(TX, last) > wait0 THEN
			STATUS := BYTE#1;
			run := FALSE;
		ELSIF q0 AND SUB_TIME(TX, last) >= DELAY0 THEN
			_STEP := 1;
			last := TX;
		END_IF;
	END_IF;
	IF run AND _STEP = 1 THEN
		IF NOT Q1 AND IN1 AND SUB_TIME(TX, last) <= wait1 THEN
			Q0 := FALSE;
			Q1 := TRUE;
			last := TX;
		ELSIF NOT Q1 AND SUB_TIME(TX, last) > wait1 THEN
			STATUS := BYTE#2;
			q0 := FALSE;
			run := FALSE;
		ELSIF Q1 AND SUB_TIME(TX, last) >= DELAY1 THEN
			_STEP := 2;
			last := TX;
		END_IF;
	END_IF;
	IF run AND _STEP = 2 THEN
		IF NOT Q2 AND IN2 AND SUB_TIME(TX, last) <= wait2 THEN
			Q1 := FALSE;
			Q2 := TRUE;
			last := TX;
		ELSIF NOT Q2 AND SUB_TIME(TX, last) > wait2 THEN
			STATUS := BYTE#3;
			Q1 := FALSE;
			run := FALSE;
		ELSIF Q2 AND SUB_TIME(TX, last) >= DELAY2 THEN
			_STEP := 3;
			last := TX;
		END_IF;
	END_IF;
	IF run AND _STEP = 3 THEN
		IF NOT q3 AND IN3 AND SUB_TIME(TX, last) <= wait3 THEN
			Q2 := FALSE;
			Q3 := TRUE;
			last := TX;
		ELSIF NOT q3 AND SUB_TIME(TX, last) > wait3 THEN
			STATUS := BYTE#4;
			Q2 := FALSE;
			run := FALSE;
		ELSIF q3 AND SUB_TIME(TX, last) >= DELAY3 THEN
			_STEP := 4;
			last := TX;
		END_IF;
	END_IF;
	IF run AND _STEP = 4 THEN
		IF NOT q4 AND in4 AND SUB_TIME(TX, last) <= wait4 THEN
			Q3 := FALSE;
			Q4 := TRUE;
			last := TX;
		ELSIF NOT q4 AND SUB_TIME(TX, last) > wait4 THEN
			STATUS := BYTE#5;
			q3 := FALSE;
			run := FALSE;
		ELSIF q4 AND SUB_TIME(TX, last) >= DELAY4 THEN
			_STEP := 5;
			last := TX;
		END_IF;
	END_IF;
	IF run AND _STEP = 5 THEN
		IF NOT q5 AND in5 AND SUB_TIME(TX, last) <= wait5 THEN
			Q4 := FALSE;
			Q5 := TRUE;
			last := TX;
		ELSIF NOT q5 AND SUB_TIME(TX, last) > wait5 THEN
			STATUS := BYTE#6;
			q4 := FALSE;
			run := FALSE;
		ELSIF q5 AND SUB_TIME(TX, last) >= DELAY5 THEN
			_STEP := 6;
			last := TX;
		END_IF;
	END_IF;
	IF run AND _STEP = 6 THEN
		IF NOT q6 AND in6 AND SUB_TIME(TX, last) <= wait6 THEN
			Q5 := FALSE;
			Q6 := TRUE;
			last := TX;
		ELSIF NOT q6 AND SUB_TIME(TX, last) > wait6 THEN
			STATUS := BYTE#7;
			q5 := FALSE;
			run := FALSE;
		ELSIF q6 AND SUB_TIME(TX, last) >= DELAY6 THEN
			_STEP := 7;
			last := TX;
		END_IF;
	END_IF;
	IF run AND _STEP = 7 THEN
		IF NOT q7 AND in7 AND SUB_TIME(TX, last) <= wait7 THEN
			Q6 := FALSE;
			Q7 := TRUE;
			last := TX;
		ELSIF NOT q7 AND SUB_TIME(TX, last) > wait7 THEN
			STATUS := BYTE#8;
			q6 := FALSE;
			run := FALSE;
		ELSIF q7 AND SUB_TIME(TX, last) >= DELAY7 THEN
			_STEP := -1;
			Q7 := FALSE;
			Run := FALSE;
			STATUS := BYTE#110;
		END_IF;
	END_IF;
	QX := q0 OR Q1 OR Q2 OR q3 OR q4 OR q5 OR q6 OR q7;

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

