FUNCTION INC:INT
	VAR_INPUT
		X :	INT;
		D :	INT;
		M :	INT;
	END_VAR

	INC := (X + D + M + 1) MOD (M + 1);
END_FUNCTION

PROGRAM program0
  VAR
    LocalVar0 : INT;
	LocalVaR1  : INT;
	LocalVaR2 : INT;
	LocalOUT  : INT;
  END_VAR
  	LocalOUT := INC(LocalVar0, LocalVaR1 ,LocalVaR2);
END_PROGRAM

