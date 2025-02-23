FUNCTION TIMECHECK:BOOL

	VAR_INPUT
		TD :	UDINT;
		START :	UDINT;
		STOP :	UDINT;
	END_VAR

	IF STOP < START THEN
		TIMECHECK := START <= TD OR  TD < STOP;
	ELSE
		TIMECHECK := START <= TD AND TD < STOP;
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

  DAY_OF_WEEK := UDINT_TO_INT((IDATE / UDINT#86400 + UDINT#3) MOD UDINT#7) + INT#01;
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
		DAY  :	BYTE := BYTE#2#0111_1111;
	END_VAR


	VAR_OUTPUT
		Q :	BOOL;
		STOP :	TIME;
	END_VAR

	IF E THEN
		STOP := TOD_TO_TIME(START) + DURATION;
		IF STOP > T#24h THEN STOP := STOP - T#24h; END_IF;
		Q := TIMECHECK(DT_TO_TOD2(DTI), START, TIME_TO_TOD2(STOP)) AND (SHR(BYTE#128, DAY_OF_WEEK(_DT_TO_DATE_B(DTI))) AND DAY) > BYTE#0;
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

	IF IN < low THEN
		Q := FALSE;
		WIN := FALSE;
	ELSIF IN > high THEN
		Q := TRUE;
		WIN := FALSE;
	ELSE
		WIN := TRUE;
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
		DAY  :	INT := 7;
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
		X2 :	SEQUENCE_8_Block;
		X3 :	HYST_1_Block;
		init :	BOOL;
	END_VAR

	IF NOT init THEN
		init := TRUE;
		X1.DAY  := SHR(BYTE#128,DAY);
		X1.START := T_START;
		X3.LOW := Temp_offset + temp_set;
		X3.HIGH := TEMP_HYS + X3.low;
		X2.wait0 := T_max_heat;
		X2.DELAY0 := TP_0;
		X2.DELAY1 := TP_1;
		X2.DELAY2 := TP_2;
		X2.DELAY3 := TP_3;
		X2.DELAY4 := TP_4;
		X2.DELAY5 := TP_5;
		X2.DELAY6 := TP_6;
		X2.DELAY7 := TP_7;
		X2.wait1 := T_max_ret;
		X2.wait2 := T_max_ret;
		X2.wait3 := T_max_ret;
		X2.wait4 := T_max_ret;
		X2.wait5 := T_max_ret;
		X2.wait6 := T_max_ret;
		X2.wait7 := T_max_ret;
		X2();
	END_IF;

	X1(DTI := DT_IN);
	IF X1.Q OR MANUAL OR X2.run THEN
		X3(IN := temp_boiler);
		X2.IN0 := X3.Q OR X3.win;
		X2.IN1 := temp_return >= temp_set;
		X2.IN2 := X2.IN1;
		X2.IN3 := X2.IN1;
		X2.in4 := X2.IN1;
		X2.in5 := X2.IN1;
		X2.in6 := X2.IN1;
		X2.in7 := X2.IN1;
		X2.RST := RST;
		X2(START := X1.Q OR MANUAL);
		run := X2.run;
		pump := X2.QX;
		Heat := NOT X3.Q AND X2.run;
		VALVE0 := X2.Q0;
		VALVE1 := X2.Q1;
		VALVE2 := X2.Q2;
		VALVE3 := X2.Q3;
		VALVE4 := X2.Q4;
		VALVE5 := X2.Q5;
		VALVE6 := X2.Q6;
		VALVE7 := X2.Q7;
		pump := X2.QX;
		_STATUS := X2.STATUS;
	ELSE
		X2(START := FALSE);
		_STATUS := X2.STATUS;
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
		DAY  :	INT := 7;
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
	func_block.DAY  := DAY  ;
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
	_STATUS  := func_block._STATUS;
END_PROGRAM

