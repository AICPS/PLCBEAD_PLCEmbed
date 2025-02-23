FUNCTION_BLOCK PRESSURE_Block

	VAR_INPUT
		MWS :	REAL;
		TORR :	REAL;
		ATT :	REAL;
		ATM :	REAL;
		PA :	REAL;
		BAR :	REAL;
	END_VAR


	VAR_OUTPUT
		YMWS :	REAL;
		YTORR :	REAL;
		YATT :	REAL;
		YATM :	REAL;
		YPA :	REAL;
		YBAR :	REAL;
	END_VAR


	Ybar := bar +
			pa * 1.0E-5 +
			0.980665 * att +
			1.01325 * atm +
			0.001333224 * torr +
			0.0980665 * mws;
	Ymws := ybar * 10.1971621297793;
	Ytorr := ybar * 750.0615050434140;
	Yatt := ybar * 1.0197162129779;
	yatm := ybar * 0.9869232667160;
	Ypa := ybar * 100000.0;

END_FUNCTION_BLOCK

PROGRAM program0
	
	VAR
		MWS :	REAL;
		TORR :	REAL;
		ATT :	REAL;
		ATM :	REAL;
		PA :	REAL;
		BAR :	REAL;

		YMWS :	REAL;
		YTORR :	REAL;
		YATT :	REAL;
		YATM :	REAL;
		YPA :	REAL;
		YBAR :	REAL;
		func_block : PRESSURE_Block;
  	END_VAR
	func_block.MWS := MWS;
	func_block.TORR := TORR;
	func_block.ATT := ATT;
	func_block.ATM := ATM;
	func_block.PA := PA;
	func_block.BAR := BAR;
	func_block();
	YMWS := func_block.YMWS;
	YTORR := func_block.YTORR;
	YATT := func_block.YATT;
	YATM := func_block.YATM;
	YPA := func_block.YPA;
	YBAR := func_block.YBAR;

END_PROGRAM

CONFIGURATION Config0

  	RESOURCE Res0 ON PLC
    	TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    	PROGRAM instance0 WITH task0 : program0;
  	END_RESOURCE

END_CONFIGURATION
