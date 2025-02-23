FUNCTION F_QUAD:REAL

	VAR_INPUT
		X :	REAL;
		A :	REAL;
		B :	REAL;
		C :	REAL;
	END_VAR

	F_QUAD :=  (A * X + B) * X + C;

END_FUNCTION

PROGRAM program0
  VAR
    LocalVar0 : REAL;
	LocalVaR1  : REAL;
	LocalVaR2 : REAL;
	LocalVar3 : REAL;
	LocalOUT  : REAL;
  END_VAR
  	LocalOUT := F_QUAD(LocalVar0, LocalVaR1 , LocalVaR2, LocalVar3);
END_PROGRAM

