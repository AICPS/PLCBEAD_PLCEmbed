FUNCTION F_LIN:REAL
	VAR_INPUT
		X :	REAL;
		A :	REAL;
		B :	REAL;
	END_VAR

	F_LIN := A * X + B;
END_FUNCTION

PROGRAM program0
  VAR
    LocalVar0 : REAL;
	LocalVaR1  : REAL;
	LocalVaR2 : REAL;
	  LocalOUT  : REAL;
  END_VAR
  	LocalOUT := F_LIN(LocalVar0, LocalVaR1 , LocalVaR2);
END_PROGRAM

