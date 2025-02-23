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

	YM :=	M
			+ P * 0.000376065
			+ IN * 0.0254
			+ FT * 0.3048
			+ YD * 0.9144
			+ MILE * 1609.344
			+ SM * 1852.0
			+ FM * 1.829;
	YP := YM * 2659.11478068951;
	YIN := YM * 39.37007874016;
	YFT := YM * 3.28083989501;
	YYD := YM * 1.09361329834;
	YMILE := YM * 0.00062137119;
	YSM := YM * 0.00053995680;
	YFM := YM * 0.54674685621;

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

