FUNCTION_BLOCK FT_MIN_MAX_Block

  VAR_INPUT
    IN :	REAL;
    RST :	BOOL;
  END_VAR


  VAR_OUTPUT
    MX :	REAL;
    MN :	REAL;
  END_VAR


  VAR
    init :	BOOL;
  END_VAR

  IF (rst = TRUE) OR (init = FALSE) THEN
    mn := in;
    mx := in;
    init := TRUE;
  ELSIF (in < mn) THEN
    mn := in;
  ELSIF (in > mx) THEN
    mx := in;
  END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    IN :	REAL;
    RST :	BOOL;

	  MX :	REAL;
    MN :	REAL;

  	func_block : FT_MIN_MAX_Block;
  END_VAR

	func_block.IN :=IN;
	func_block.RST := RST;
	func_block();
	MX := func_block.MX;
	MN := func_block.MN;

END_PROGRAM

CONFIGURATION Config0
	
	VAR_GLOBAL
		PLC_TICKS_PER_SEC :	INT;
		PLC_SYS_TICK_CNT :	DINT;
	END_VAR

	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE

END_CONFIGURATION