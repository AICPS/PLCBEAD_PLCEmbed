(* a simple ST program that call a USEr defined function, and executes a FOR loop *)
PROGRAM prog1
	VAR
		X1 : INT := 10;	
		Y1 : INT := 20;
		I, Z : INT ; 
		R1  : REAL := 3.0;
		A : BOOL := TRUE;
		
	END_VAR
		
	VAR_GLOBAL (* currenTLy we allow GLOBAL blocks inside PROGRAMS *)
		G1: BOOL;
	END_VAR
		
	Z := func1(X1, Y1); // USEr defined function
		
	A := A AND G1;
	
	G1 := NOT G1; // CHAnges IN each run
	
	Y1 := Z + 5;
				
	FOR I := 1 TO 3 DO
		R1  := SQRT(R1 );
		X1 := I;
	END_FOR;
	
	Y1 := Z + 1;

END_PROGRAM
