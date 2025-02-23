FUNCTION F_POWER:REAL
	VAR_INPUT
		A :	REAL;
		X :	REAL;
		N :	REAL;
	END_VAR

	F_POWER := A * EXPT(X,N);
END_FUNCTION

PROGRAM program0
  VAR
    LocalVar0 : REAL;
	LocalVaR1  : REAL;
	LocalVaR2 : REAL;
	  LocalOUT  : REAL;
  END_VAR
  	LocalOUT := F_POWER(LocalVar0, LocalVaR1 , LocalVaR2);
END_PROGRAM

