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
		IF LOG_SCALE THEN
			temp := EXP(LN(TRIGGER_HIGH / TRIGGER_LOW) * 0.166666666666666666666);
			T1 := TRIGGER_LOW * temp;
			T2 := T1 * temp;
			T3 := T2 * temp;
			T4 := T3 * temp;
			T5 := T4 * temp;
		ELSE
			temp := (TRIGGER_HIGH - TRIGGER_LOW) * 0.142857142;
			T1 := TRIGGER_LOW + temp;
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
	STATUS := BYTE#110;

	IF NOT ALARM_LOW THEN LOW := FALSE; END_IF;
	IF NOT ALARM_HIGH THEN HIGH := FALSE; END_IF;
	IF RST THEN
		ALARM := FALSE;
		LOW := FALSE;
		HIGH := FALSE;
	END_IF;

	IF X < TRIGGER_LOW THEN
		LOW := TRUE;
		STATUS := BYTE#111;
		IF ALARM_LOW THEN
			ALARM := TRUE;
			STATUS := BYTE#1;
		END_IF;
	ELSIF X < T1 THEN
		Q1 := TRUE;
	ELSIF X < T2 THEN
		Q2 := TRUE;
	ELSIF X < T3 THEN
		Q3 := TRUE;
	ELSIF X < T4 THEN
		Q4 := TRUE;
	ELSIF X < T5 THEN
		Q5 := TRUE;
	ELSIF X < TRIGGER_HIGH THEN
		Q6 := TRUE;
	ELSE
		HIGH := TRUE;
		STATUS := BYTE#112;
		IF ALARM_HIGH THEN
			ALARM := TRUE;
			STATUS := BYTE#2;
		END_IF;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : REAL;
    LocalVaR1  : BOOL;
	LocalVaR2 : REAL;
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
	func_block.RST := LocalVaR1 ;
	func_block.TRIGGER_LOW := LocalVaR2;
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

