FUNCTION_BLOCK ALARM_2
	VAR_INPUT
		X :	REAL;
		LO_1 :	REAL;
		HI_1 :	REAL;
		LO_2 :	REAL;
		HI_2 :	REAL;
		HYS :	REAL;
	END_VAR

	VAR_OUTPUT
		Q1_LO :	BOOL;
		Q1_HI :	BOOL;
		Q2_LO :	BOOL;
		Q2_HI :	BOOL;
	END_VAR

	VAR
		tmp :	REAL;
	END_VAR

	tmp := X - Hys * 0.5;
	IF tmp > LO_1 THEN Q1_LO := FALSE; END_IF;
	IF tmp > LO_2 THEN Q2_LO := FALSE; END_IF;
	IF tmp > HI_1 THEN Q1_HI := TRUE; END_IF;
	IF tmp > HI_2 THEN Q2_HI := TRUE; END_IF;
	tmp := tmp + hys;
	IF tmp < LO_1 THEN Q1_LO := TRUE; END_IF;
	IF tmp < LO_2 THEN Q2_LO := TRUE; END_IF;
	IF tmp < HI_1 THEN Q1_HI := FALSE; END_IF;
	IF tmp < HI_2 THEN Q2_HI := FALSE; END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
	    LocalVar0 : REAL;
		LocalVar1 : REAL;
		LocalVar2 : REAL;
		LocalVar3 : REAL;
		LocalVar4 : REAL;
		LocalVar5 : REAL;
		LocalOUT1  : BOOL;
		LocalOUT2  : BOOL;
		LocalOUT3  : BOOL;
		LocalOUT4  : BOOL;
		func_block : ALARM_2;
  	END_VAR
	func_block.X := LocalVar0;
	func_block.LO_1 := LocalVar1;
	func_block.HI_1 := LocalVar2;
	func_block.LO_2 := LocalVar3;
	func_block.HI_2 := LocalVar4;
	func_block.HYS := LocalVar5;
	func_block();
	LocalOUT1 := func_block.Q1_LO;
	LocalOUT2 := func_block.Q1_HI;
	LocalOUT3 := func_block.Q2_LO;
	LocalOUT4 := func_block.Q2_HI;
END_PROGRAM

CONFIGURATION Config0
  	RESOURCE Res0 ON PLC
    	TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    	PROGRAM instance0 WITH task0 : program0;
  	END_RESOURCE
END_CONFIGURATION