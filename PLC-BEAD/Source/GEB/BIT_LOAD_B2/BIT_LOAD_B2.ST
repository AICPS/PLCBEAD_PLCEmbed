FUNCTION BIT_LOAD_B2:BYTE
	VAR_INPUT
		I :	BYTE;
		D :	BOOL;
		P :	INT;
		N :	INT;
	END_VAR

	IF D THEN
		BIT_LOAD_B2 := ROL(SHR(BYTE#255, 8 - N) OR ROR(I, P), P);
	ELSE
		BIT_LOAD_B2 := ROL(SHL(BYTE#255, N) AND ROR(I, P), P);
	END_IF;
END_FUNCTION

PROGRAM program0
  VAR
    LocalVar0 : BYTE;
	LocalVaR1  : BOOL;
	LocalVaR2 : INT;
	LocalVar3 : INT;
    LocalOUT  : BYTE;
  END_VAR

  LocalOUT := BIT_LOAD_B2(LocalVar0, LocalVaR1 , LocalVaR2, LocalVar3);
END_PROGRAM

