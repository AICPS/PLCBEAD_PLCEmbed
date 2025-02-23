FUNCTION_BLOCK BAR_GRAPH
	VAR_INPUT
		X :	REAL;
		RST :	BOOL;
		TRIGGER_LOW :	REAL;
		TRIGGER_HIGH :	REAL;
		ALARM_LOW :	BOOL;
		ALARM_HIGH :	BOOL;
		LOG_SCALE :	BOOL;
	END_VAR


	VAR_OUTPUT
		LOW :	BOOL;
		Q1 :	BOOL;
		Q2 :	BOOL;
		Q3 :	BOOL;
		Q4 :	BOOL;
		Q5 :	BOOL;
		Q6 :	BOOL;
		HIGH :	BOOL;
		ALARM :	BOOL;
		STATUS :	BYTE;
	END_VAR


	VAR
		init :	BOOL;
		T1 :	REAL;
		T2 :	REAL;
		T3 :	REAL;
		T4 :	REAL;
		T5 :	REAL;
		temp :	REAL;
	END_VAR

	IF NOT init THEN
		init := TRUE;
		IF log_scale THEN
			temp := EXP(LN(Trigger_high / Trigger_low) * 0.166666666666666666666);
			T1 := trigger_low * temp;
			T2 := T1 * temp;
			T3 := T2 * temp;
			T4 := T3 * temp;
			T5 := T4 * temp;
		ELSE
			temp := (trigger_high - trigger_low) * 0.142857142;
			T1 := trigger_low + temp;
			T2 := T1 + temp;
			T3 := T2 + temp;
			T4 := T3 + temp;
			T5 := T4 + temp;
		END_IF;
	END_IF;

	Q1 := FALSE;
	Q2 := FALSE;
	Q3 := FALSE;
	Q4 := FALSE;
	Q5 := FALSE;
	Q6 := FALSE;
	status := BYTE#110;

	IF NOT alarm_low THEN low := FALSE; END_IF;
	IF NOT alarm_high THEN high := FALSE; END_IF;
	IF rst THEN
		alarm := FALSE;
		low := FALSE;
		high := FALSE;
	END_IF;

	IF X < trigger_low THEN
		Low := TRUE;
		status := BYTE#111;
		IF alarm_low THEN
			alarm := TRUE;
			status := BYTE#1;
		END_IF;
	ELSIF X < T1 THEN
		Q1 := TRUE;
	ELSIF x < t2 THEN
		Q2 := TRUE;
	ELSIF x < t3 THEN
		Q3 := TRUE;
	ELSIF x < T4 THEN
		Q4 := TRUE;
	ELSIF x < T5 THEN
		q5 := TRUE;
	ELSIF x < trigger_high THEN
		q6 := TRUE;
	ELSE
		high := TRUE;
		status := BYTE#112;
		IF alarm_high THEN
			alarm := TRUE;
			status := BYTE#2;
		END_IF;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : REAL;
    LocalVar1 : BOOL;
	LocalVar2 : REAL;
	LocalVar3 : REAL;
	LocalVar4 : BOOL;
	LocalVar5 : BOOL;
	LocalVar6 : BOOL;

	LOW   :	BOOL;
	Q1    :	BOOL;
	Q2    :	BOOL;
	Q3    :	BOOL;
	Q4    :	BOOL;
	Q5    :	BOOL;
	Q6    :	BOOL;
	HIGH  :	BOOL;
	ALARM :	BOOL;
	STATUS:	BYTE;

	func_block : BAR_GRAPH;
  END_VAR
	func_block.X := LocalVar0;
	func_block.RST := LocalVar1;
	func_block.TRIGGER_LOW := LocalVar2;
	func_block.TRIGGER_HIGH := LocalVar3;
	func_block.ALARM_LOW := LocalVar4;
	func_block.ALARM_HIGH := LocalVar5;
	func_block.LOG_SCALE := LocalVar6;

	func_block();
	LOW   := func_block.LOW   ;
	Q1    := func_block.Q1    ;
	Q2    := func_block.Q2    ;
	Q3    := func_block.Q3    ;
	Q4    := func_block.Q4    ;
	Q5    := func_block.Q5    ;
	Q6    := func_block.Q6    ;
	HIGH  := func_block.HIGH  ;
	ALARM := func_block.ALARM ;
	STATUS:= func_block.STATUS;
	 

END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION