FUNCTION_BLOCK SPEED_Block

	VAR_INPUT
		MS :	REAL;
		KMH :	REAL;
		KN :	REAL;
		MH :	REAL;
	END_VAR

	VAR_OUTPUT
		YMS :	REAL;
		YKMH :	REAL;
		YKN :	REAL;
		YMH :	REAL;
	END_VAR

	Yms := ms +
			kmh * 0.27777777777778 +
			kn * 0.5144444 +
			mh * 0.44704;
	Ykmh := Yms * 3.6;
	Ykn := Yms * 1.94384466037535;
	Ymh := Yms * 2.23693629205440;

END_FUNCTION_BLOCK

PROGRAM program0

	VAR
		MS :	REAL;
		KMH :	REAL;
		KN :	REAL;
		MH :	REAL;
		YMS :	REAL;
		YKMH :	REAL;
		YKN :	REAL;
		YMH :	REAL;
		func_block : SPEED_Block;
	END_VAR
		func_block.MS  :=MS;
		func_block.KMH  :=KMH;
		func_block.KN  :=KN;
		func_block.MH  :=MH;
		func_block();
		YMS := func_block.YMS;
		YKMH := func_block.YKMH;
		YKN := func_block.YKN;
		YMH := func_block.YMH;

	END_PROGRAM

CONFIGURATION Config0
	
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE

END_CONFIGURATION