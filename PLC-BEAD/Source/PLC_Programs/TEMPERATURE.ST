FUNCTION_BLOCK TEMPERATURE

	VAR_INPUT
		K :	REAL;
		C :	REAL := -273.15;
		F :	REAL := -459.67;
		RE :	REAL := -218.52;
		RA :	REAL := 0.0;
	END_VAR


	VAR_OUTPUT
		YK :	REAL;
		YC :	REAL;
		YF :	REAL;
		YRE :	REAL;
		YRA :	REAL;
	END_VAR

	YK := K + (C + 273.15) + (F + 459.67) * 0.555555555555 + (Re * 1.25 + 273.15) + (Ra * 0.555555555555);
	YC := YK -273.15;
	YF := YK * 1.8 - 459.67;
	YRe := (YK - 273.15) * 0.8;
	YRa := YK * 1.8;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	K :	REAL;
	C :	REAL := -273.15;
	F :	REAL := -459.67;
	RE :	REAL := -218.52;
	RA :	REAL := 0.0;
	YK :	REAL;
	YC :	REAL;
	YF :	REAL;
	YRE :	REAL;
	YRA :	REAL;
	func_block : TEMPERATURE;
  END_VAR
	func_block.K  :=K;
	func_block.C  :=C;
	func_block.F  :=F;
	func_block.RE  :=RE;
	func_block.RA  :=RA;
	func_block();
	YK := func_block.YK;
	YC := func_block.YC;
	YF := func_block.YF;
	YRE := func_block.YRE;
	YRA := func_block.YRA;

END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION