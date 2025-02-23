FUNCTION_BLOCK FT_MIN_MAX_Block

  VAR_INPUT
    IN :	REAL;
    RST :	BOOL;
  END_VAR


  VAR_OUTPUT
    mx :	REAL;
    mn :	REAL;
  END_VAR


  VAR
    init :	BOOL;
  END_VAR

  IF (RST = TRUE) OR (init = FALSE) THEN
    mn := IN;
    mx := IN;
    init := TRUE;
  ELSIF (IN < mn) THEN
    mn := IN;
  ELSIF (IN > mx) THEN
    mx := IN;
  END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    IN :	REAL;
    RST :	BOOL;

	  mx :	REAL;
    mn :	REAL;

  	func_block : FT_MIN_MAX_Block;
  END_VAR

	func_block.IN :=IN;
	func_block.RST := RST;
	func_block();
	mx := func_block.mx;
	mn := func_block.mn;

END_PROGRAM

