FUNCTION_BLOCK CONTROL_SET2
	VAR_INPUT
		KS :	REAL;
		TU :	REAL;
		TG :	REAL;
		PI :	BOOL;
		PIDD :	BOOL;
		P_K :	REAL := 1.0;
		PI_K :	REAL := 0.9;
		PI_TN :	REAL := 3.33;
		PIDD_K :	REAL := 1.2;
		PIDD_TN :	REAL := 2.0;
		PIDD_TV :	REAL := 0.5;
	END_VAR

	VAR_OUTPUT
		KP :	REAL;
		TN :	REAL;
		TV :	REAL;
		KI :	REAL;
		KD :	REAL;
	END_VAR

	VAR
		TX :	REAL;
	END_VAR

	IF TU > 0.0 AND KS > 0.0 THEN TX := TG / TU / KS; END_IF;
	IF pi AND PIDD THEN
		KP := 0.0;
		TN := 0.0;
		TV := 0.0;
	ELSIF PIDD THEN
		KP := PIDD_K * TX;
		TN := PIDD_TN * TU;
		TV := PIDD_TV * TU;
	ELSIF PI THEN
		KP := PI_K * TX;
		TN := PI_TN * TU;
	ELSE
		KP := P_K * TX;
	END_IF;

	IF TN > 0.0 THEN KI := KP / TN; ELSE KI := 0.0; END_IF;
	KD := KP * TV;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	KS :REAL;
	TG :REAL;
	PI :BOOL;
	PIDD :BOOL;
	P_K :REAL ;
	PI_K :REAL ;
	PI_TN :REAL ;
	PIDD_K :REAL ;
	PIDD_TN :REAL ;
	PIDD_TV :REAL ;
	KP :REAL;
	TN :REAL;
	TV :REAL;
	KI :REAL;
	KD :REAL;
	func_block : CONTROL_SET2;
  END_VAR
	func_block.KS   := KS  ;
	func_block.TG   :=TG  ;
	func_block.PI   :=PI  ;
	func_block.PIDD   :=PIDD  ;
	func_block.P_K   :=P_K  ;
	func_block.PI_K   :=PI_K  ;
	func_block.PI_TN   :=PI_TN  ;
	func_block.PIDD_K   :=PIDD_K  ;
	func_block.PIDD_TN   :=PIDD_TN  ;
	func_block.PIDD_TV   :=PIDD_TV  ;
	func_block();
	KP := func_block.KP ;
	TN := func_block.TN ;
	TV := func_block.TV ;
	KI := func_block.KI ;
	KD := func_block.KD ;
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION
