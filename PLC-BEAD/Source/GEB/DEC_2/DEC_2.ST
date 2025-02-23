FUNCTION_BLOCK DEC_2
	VAR_INPUT
		D :	BOOL;
		A :	BOOL;
	END_VAR
	VAR_OUTPUT
		Q0 :	BOOL;
		Q1 :	BOOL;
	END_VAR
	Q0 := D AND NOT A;
	Q1 := D AND A;
END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : BOOL;
	LocalVaR1  : BOOL;
	LocalOUT  : BOOL;
	LocalOUT1  : BOOL;
	func_block : DEC_2;
  END_VAR
	func_block.D  := LocalVar0;
	func_block.A  := LocalVaR1 ;
	func_block();
	LocalOUT := func_block.Q0;
	LocalOUT1 := func_block.Q1;
END_PROGRAM

