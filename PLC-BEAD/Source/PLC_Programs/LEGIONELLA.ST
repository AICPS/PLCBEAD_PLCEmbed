FUNCTION TIMECHECK:BOOL

	VAR_INPUT
		TD :	UDINT;
		START :	UDINT;
		STOP :	UDINT;
	END_VAR

	IF stop < start THEN
		TIMECHECK := start <= TD OR  TD < stop;
	ELSE
		TIMECHECK := start <= TD AND TD < stop;
	END_IF;

END_FUNCTION

FUNCTION TIME_TO_TOD:UDINT



	VAR_INPUT
		IN :	TIME;
	END_VAR

	TIME_TO_TOD := DWORD_TO_UDINT(TIME_TO_DWORD(IN));
END_FUNCTION

FUNCTION TOD_TO_TIME:TIME
	VAR_INPUT
		IN :	UDINT;
	END_VAR

	TOD_TO_TIME := DWORD_TO_TIME(UDINT_TO_DWORD(IN));
END_FUNCTION

FUNCTION DAY_OF_WEEK:INT
  VAR_INPUT
    IDATE :	UDINT;
  END_VAR

  DAY_OF_WEEK := UDINT_TO_INT((idate / UDINT#86400 + UDINT#3) MOD UDINT#7) + INT#01;
END_FUNCTION

FUNCTION _DT_TO_DATE_B:UDINT

	VAR_INPUT
		_INN :	UDINT;
	END_VAR

	_DT_TO_DATE_B := (_INN / UDINT#86400) * UDINT#86400;
END_FUNCTION

FUNCTION DT_TO_TOD2:UDINT
	VAR_INPUT
		IN :	UDINT;
	END_VAR

	DT_TO_TOD2 := (IN MOD UDINT#86400) * UDINT#1000;
END_FUNCTION

FUNCTION TIME_TO_TOD2:UDINT

	VAR_INPUT
		IN :	TIME;
	END_VAR

	TIME_TO_TOD2 := DWORD_TO_UDINT(TIME_TO_DWORD(IN));
END_FUNCTION

FUNCTION_BLOCK TIMER_1_Block

	VAR_INPUT
		E :	BOOL := TRUE;
		DTI :	UDINT;
		START :	UDINT;
		DURATION :	TIME;
		DAY :	BYTE := BYTE#2#0111_1111;
	END_VAR


	VAR_OUTPUT
		Q :	BOOL;
		STOP :	TIME;
	END_VAR

	IF E THEN
		stop := TOD_TO_TIME(START) + DURATION;
		IF stop > T#24h THEN stop := stop - T#24h; END_IF;
		Q := TIMECHECK(DT_TO_TOD2(DTI), START, TIME_TO_TOD2(stop)) AND (SHR(BYTE#128, DAY_OF_WEEK(_DT_TO_DATE_B(DTI))) AND DAY) > BYTE#0;
	ELSE
		Q := FALSE; 
	END_IF;

END_FUNCTION_BLOCK

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

FUNCTION_BLOCK HYST_1_Block

	VAR_INPUT
		IN :	REAL;
		HIGH :	REAL;
		LOW :	REAL;
	END_VAR


	VAR_OUTPUT
		Q :	BOOL;
		WIN :	BOOL;
	END_VAR

	IF in < low THEN
		Q := FALSE;
		win := FALSE;
	ELSIF in > high THEN
		Q := TRUE;
		win := FALSE;
	ELSE
		win := TRUE;
	END_IF;

END_FUNCTION_BLOCK

FUNCTION_BLOCK LEGIONELLA_Block

	VAR_INPUT
		MANUAL :	BOOL;
		TEMP_BOILER :	REAL;
		TEMP_RETURN :	REAL := 100.0;
		DT_IN :	UDINT;
		RST :	BOOL;
		T_START :	UDINT := UDINT#10800000;(*tod#03:00:00*)
		DAY :	INT := 7;
		TEMP_SET :	REAL := 70.0;
		TEMP_OFFSET :	REAL := 10.0;
		TEMP_HYS :	REAL := 5.0;
		T_MAX_HEAT :	TIME := t#10m;
		T_MAX_RET :	TIME := t#10m;
		TP_0 :	TIME := t#5m;
		TP_1 :	TIME := t#5m;
		TP_2 :	TIME := t#5m;
		TP_3 :	TIME := t#5m;
		TP_4 :	TIME := t#5m;
		TP_5 :	TIME := t#5m;
		TP_6 :	TIME := t#5m;
		TP_7 :	TIME := t#5m;
	END_VAR


	VAR_OUTPUT
		HEAT :	BOOL;
		PUMP :	BOOL;
		VALVE0 :	BOOL;
		VALVE1 :	BOOL;
		VALVE2 :	BOOL;
		VALVE3 :	BOOL;
		VALVE4 :	BOOL;
		VALVE5 :	BOOL;
		VALVE6 :	BOOL;
		VALVE7 :	BOOL;
		RUN :	BOOL;
		_STATUS :	BYTE;
	END_VAR


	VAR
		X1 :	TIMER_1_Block;
		x2 :	SEQUENCE_8_Block;
		x3 :	HYST_1_Block;
		init :	BOOL;
	END_VAR

	IF NOT init THEN
		init := TRUE;
		X1.day := SHR(BYTE#128,day);
		X1.start := T_start;
		X3.low := Temp_offset + temp_set;
		X3.high := Temp_hys + X3.low;
		X2.wait0 := T_max_heat;
		X2.delay0 := TP_0;
		X2.delay1 := TP_1;
		X2.delay2 := TP_2;
		X2.delay3 := TP_3;
		X2.delay4 := TP_4;
		X2.delay5 := TP_5;
		X2.delay6 := TP_6;
		X2.delay7 := TP_7;
		X2.wait1 := T_max_ret;
		X2.wait2 := T_max_ret;
		X2.wait3 := T_max_ret;
		X2.wait4 := T_max_ret;
		X2.wait5 := T_max_ret;
		X2.wait6 := T_max_ret;
		X2.wait7 := T_max_ret;
		X2();
	END_IF;

	X1(DTi := DT_in);
	IF X1.Q OR MANUAL OR x2.run THEN
		X3(in := temp_boiler);
		X2.in0 := X3.Q OR x3.win;
		X2.in1 := temp_return >= temp_set;
		X2.in2 := x2.in1;
		X2.in3 := x2.in1;
		X2.in4 := x2.in1;
		X2.in5 := x2.in1;
		X2.in6 := x2.in1;
		X2.in7 := x2.in1;
		X2.rst := rst;
		X2(start := X1.Q OR MANUAL);
		run := x2.run;
		pump := x2.QX;
		Heat := NOT X3.Q AND x2.run;
		valve0 := X2.Q0;
		valve1 := X2.Q1;
		valve2 := X2.Q2;
		valve3 := X2.Q3;
		valve4 := X2.Q4;
		valve5 := X2.Q5;
		valve6 := X2.Q6;
		valve7 := X2.Q7;
		pump := X2.QX;
		_STATUS := X2.status;
	ELSE
		X2(start := FALSE);
		_STATUS := x2.status;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		MANUAL :	BOOL;
		TEMP_BOILER :	REAL;
		TEMP_RETURN :	REAL := 100.0;
		DT_IN :	UDINT;
		RST :	BOOL;
		T_START :	UDINT := UDINT#10800000;(*tod#03:00:00*)
		DAY :	INT := 7;
		TEMP_SET :	REAL := 70.0;
		TEMP_OFFSET :	REAL := 10.0;
		TEMP_HYS :	REAL := 5.0;
		T_MAX_HEAT :	TIME := t#10m;
		T_MAX_RET :	TIME := t#10m;
		TP_0 :	TIME := t#5m;
		TP_1 :	TIME := t#5m;
		TP_2 :	TIME := t#5m;
		TP_3 :	TIME := t#5m;
		TP_4 :	TIME := t#5m;
		TP_5 :	TIME := t#5m;
		TP_6 :	TIME := t#5m;
		TP_7 :	TIME := t#5m;
		HEAT :	BOOL;
		PUMP :	BOOL;
		VALVE0 :	BOOL;
		VALVE1 :	BOOL;
		VALVE2 :	BOOL;
		VALVE3 :	BOOL;
		VALVE4 :	BOOL;
		VALVE5 :	BOOL;
		VALVE6 :	BOOL;
		VALVE7 :	BOOL;
		RUN :	BOOL;
		_STATUS :	BYTE;

		func_block : LEGIONELLA_Block;
	END_VAR
	func_block.MANUAL := MANUAL;
	func_block.TEMP_BOILER := TEMP_BOILER;
	func_block.TEMP_RETURN := TEMP_RETURN ;
	func_block.DT_IN    := DT_IN    ;
	func_block.RST := RST;
	func_block.T_START := T_START;
	func_block.DAY := DAY ;
	func_block.TEMP_SET := TEMP_SET ;
	func_block.TEMP_OFFSET    := TEMP_OFFSET    ;
	func_block.TEMP_HYS    := TEMP_HYS    ;
	func_block.T_MAX_HEAT := T_MAX_HEAT;
	func_block.T_MAX_RET := T_MAX_RET;
	func_block.TP_0 := TP_0;
	func_block.TP_1 := TP_1 ;
	func_block.TP_2 := TP_2 ;
	func_block.TP_3    := TP_3    ;
	func_block.TP_4    := TP_4    ;
	func_block.TP_5 := TP_5;
	func_block.TP_6 := TP_6;
	func_block.TP_7 := TP_7;

	func_block();
	HEAT  := func_block.HEAT;
	PUMP  := func_block.PUMP;
	VALVE0  := func_block.VALVE0;
	VALVE1  := func_block.VALVE1;
	VALVE2  := func_block.VALVE2;
	VALVE3  := func_block.HEAT;
	VALVE4  := func_block.VALVE4;
	VALVE5  := func_block.VALVE5;
	VALVE6  := func_block.VALVE6;
	VALVE7  := func_block.VALVE7;
	RUN  := func_block.RUN;
	_status  := func_block._status;
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