FUNCTION INC:INT
	VAR_INPUT
		X :	INT;
		D :	INT;
		M :	INT;
	END_VAR

	inc := (X + D + M + 1) MOD (M + 1);
END_FUNCTION

FUNCTION_BLOCK MANUAL_4_Block

	VAR_INPUT
		I0 :	BOOL;
		I1 :	BOOL;
		I2 :	BOOL;
		I3 :	BOOL;
		MAN :	BOOL;
		STP :	BOOL;
		M0 :	BOOL;
		M1 :	BOOL;
		M2 :	BOOL;
		M3 :	BOOL;
	END_VAR


	VAR_OUTPUT
		Q0 :	BOOL;
		Q1 :	BOOL;
		Q2 :	BOOL;
		Q3 :	BOOL;
		STATUS :	BYTE;
	END_VAR


	VAR
		edge :	BOOL;
		pos :	INT;
		tog :	BOOL;
	END_VAR

	IF man THEN
		IF NOT TOG THEN
			Q0 := M0;
			Q1 := M1;
			Q2 := M2;
			Q3 := M3;
			STATUS := BYTE#101;
		END_IF;
		IF STP AND NOT edge THEN
			tog := TRUE;
			CASE pos OF
				0:	Q0 := TRUE;
					Q1 := FALSE;
					Q2 := FALSE;
					Q3 := FALSE;
					STATUS := BYTE#110;
				1:	Q0 := FALSE;
					Q1 := TRUE;
					Q2 := FALSE;
					Q3 := FALSE;
					STATUS := BYTE#111;
				2:	Q0 := FALSE;
					Q1 := FALSE;
					Q2 := TRUE;
					Q3 := FALSE;
					STATUS := BYTE#112;
				3:	Q0 := FALSE;
					Q1 := FALSE;
					Q2 := FALSE;
					Q3 := TRUE;
					STATUS := BYTE#113;
			END_CASE;
			pos := INC(pos,1,3);
		END_IF;
	ELSE
		Q0 := I0;
		Q1 := I1;
		Q2 := I2;
		Q3 := I3;
		STATUS := BYTE#100;
		tog := FALSE;
		pos := 0;
	END_IF;

	edge := STP;

END_FUNCTION_BLOCK

PROGRAM program0

	VAR
		I0 :	BOOL;
		I1 :	BOOL;
		I2 :	BOOL;
		I3 :	BOOL;
		MAN :	BOOL;
		STP :	BOOL;
		M0 :	BOOL;
		M1 :	BOOL;
		M2 :	BOOL;
		M3 :	BOOL;

		Q0 :	BOOL;
		Q1 :	BOOL;
		Q2 :	BOOL;
		Q3 :	BOOL;
		STATUS :	BYTE;
	
		func_block : MANUAL_4_Block;
	END_VAR
	func_block.I0 := I0;
	func_block.I1 := I1;
	func_block.I2 := I2;
	func_block.I3 := I3;
	func_block.MAN := MAN;
	func_block.STP := STP;
	func_block.M0 := M0;
	func_block.M1 := M1;
	func_block.M2 := M2;
	func_block.M3 := M3;
	func_block();
	Q0 := func_block.Q0;
	Q1 := func_block.Q1;
	Q2 := func_block.Q2;
	Q3 := func_block.Q3;
	STATUS := func_block.STATUS;

END_PROGRAM

CONFIGURATION Config0

	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE

END_CONFIGURATION
