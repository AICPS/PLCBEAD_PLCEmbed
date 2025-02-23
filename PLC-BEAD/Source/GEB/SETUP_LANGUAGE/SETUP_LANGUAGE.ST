TYPE oscat_LANGUAGE:
	STRUCT
		DEFAULT 	: INT;
		LMAX    	: INT;    
	END_STRUCT;
END_TYPE

FUNCTION_BLOCK SETUP_LANGUAGE_Block

	VAR_IN_OUT
		LANGUAGE :	oscat_LANGUAGE;
	END_VAR

	VAR
		init :	BOOL;
	END_VAR

	IF init THEN RETURN; END_IF;
	init := TRUE;

	LANGUAGE.DEFAULT  := 1; (* 1=english, 2=german 3=french *)
	LANGUAGE.LMAX := 3;

END_FUNCTION_BLOCK

PROGRAM program0
	
	VAR
		LANGUAGE :	oscat_LANGUAGE;
		func_block : SETUP_LANGUAGE_Block;
	END_VAR
		func_block.LANGUAGE  := LANGUAGE;
		func_block();
		LANGUAGE := func_block.LANGUAGE;

END_PROGRAM

