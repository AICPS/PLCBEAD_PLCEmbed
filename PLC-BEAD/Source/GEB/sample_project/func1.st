(* just a trivial function that sums two INTEGers *) 
FUNCTION func1 : INT
	VAR_INPUT
		X: INT;
		Y: INT;
	END_VAR
	VAR 
	   Z: INT;
	END_VAR
	
	Z := Y + 1;	(* this is silly, only for demonstration purporses *)

	func1 := Z + X - 1;
	
END_FUNCTION

