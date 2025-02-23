FUNCTION_BLOCK LENGTH_Block

	VAR_INPUT
		M :	REAL;
		P :	REAL;
		IN :	REAL;
		FT :	REAL;
		YD :	REAL;
		MILE :	REAL;
		SM :	REAL;
		FM :	REAL;
	END_VAR


	VAR_OUTPUT
		YM :	REAL;
		YP :	REAL;
		YIN :	REAL;
		YFT :	REAL;
		YYD :	REAL;
		YMILE :	REAL;
		YSM :	REAL;
		YFM :	REAL;
	END_VAR

	Ym :=	m
			+ p * 0.000376065
			+ in * 0.0254
			+ ft * 0.3048
			+ yd * 0.9144
			+ mile * 1609.344
			+ sm * 1852.0
			+ fm * 1.829;
	Yp := Ym * 2659.11478068951;
	Yin := Ym * 39.37007874016;
	Yft := Ym * 3.28083989501;
	Yyd := Ym * 1.09361329834;
	Ymile := Ym * 0.00062137119;
	Ysm := Ym * 0.00053995680;
	Yfm := Ym * 0.54674685621;

END_FUNCTION_BLOCK

PROGRAM program0

	VAR
		M :	REAL;
		P :	REAL;
		IN :	REAL;
		FT :	REAL;
		YD :	REAL;
		MILE :	REAL;
		SM :	REAL;
		FM :	REAL;

		YM :	REAL;
		YP :	REAL;
		YIN :	REAL;
		YFT :	REAL;
		YYD :	REAL;
		YMILE :	REAL;
		YSM :	REAL;
		YFM :	REAL;
		
		func_block : LENGTH_Block;
	END_VAR
	func_block.M := M;
	func_block.P := P;
	func_block.IN := IN;
	func_block.FT := FT;
	func_block.YD := YD;
	func_block.MILE := MILE;
	func_block.SM := SM;
	func_block.FM := FM;

	func_block();

	YM := func_block.YM;
	YP := func_block.YP;
	YIN := func_block.YIN;
	YFT := func_block.YFT;
	YYD := func_block.YYD;
	YMILE := func_block.YMILE;
	YSM := func_block.YSM;
	YFM := func_block.YFM;

END_PROGRAM

CONFIGURATION Config0

	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE

END_CONFIGURATION
