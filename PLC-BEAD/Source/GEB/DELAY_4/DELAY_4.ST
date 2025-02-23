FUNCTION_BLOCK DELAY_4

	VAR_INPUT
		IN :	REAL;
	END_VAR

	VAR_OUTPUT
		OUT1 :	REAL;
		OUT2 :	REAL;
		OUT3 :	REAL;
		OUT4 :	REAL;
	END_VAR

	VAR
		temp :	REAL;
	END_VAR

	OUT4 := OUT3;
	OUT3 := OUT2;
	OUT2 := OUT1;
	OUT1 := temp;
	temp := IN;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	IN :	REAL;

	OUT1 :	REAL;
	OUT2 :	REAL;
	OUT3 :	REAL;
	OUT4 :	REAL;
	func_block : DELAY_4;
  END_VAR
	func_block.IN  := IN;
	func_block();
	OUT1:= func_block.OUT1;
	OUT2:= func_block.OUT2;
	OUT3:= func_block.OUT3;
	OUT4:= func_block.OUT4;
END_PROGRAM

