FUNCTION_BLOCK ENERGY
	VAR_INPUT
		J :	REAL;
		C :	REAL;
		WH :	REAL;
	END_VAR

	VAR_OUTPUT
		YJ :	REAL;
		YC :	REAL;
		YWH :	REAL;
	END_VAR

	YJ := J + Wh * 3600.0 + C * 4.1868;
	YC := YJ * 0.238845896627496;
	YWh := YJ * 2.7777777778E-004;
END_FUNCTION_BLOCK

PROGRAM program0
  VAR
		J  :	REAL;
		C  :	REAL;
		WH :	REAL;

		YJ  :	REAL;
		YC  :	REAL;
		YWH :	REAL;
	func_block : ENERGY;
  END_VAR
	func_block.J  :=J ;
	func_block.C  :=C ;
	func_block.WH :=WH;
	func_block();
	YJ  := func_block.YJ ;
	YC  := func_block.YC ;
	YWH := func_block.YWH;

END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION