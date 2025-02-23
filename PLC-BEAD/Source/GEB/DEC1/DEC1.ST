FUNCTION DEC1:INT

	VAR_INPUT
		X :	INT;
		N :	INT;
	END_VAR

	IF X = 0 THEN
		DEC1 := N - 1;
	ELSE
		DEC1 := X - 1;
	END_IF;

END_FUNCTION

PROGRAM program0
  VAR
    LocalVar0 : INT;
	LocalVaR1  : INT;
	LocalOUT  : INT;
  END_VAR
  	LocalOUT := DEC1(LocalVar0, LocalVaR1 );
END_PROGRAM

