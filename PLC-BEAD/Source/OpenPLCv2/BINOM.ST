FUNCTION BINOM:INT
	VAR_INPUT
		N :	INT;
		K :	INT;
	END_VAR

	VAR
		i :	INT;
		N2 :	INT;
		K2 :	INT;
	END_VAR

	K2 := K;
	N2 := N;
	IF 2 * K2 > N2 THEN
		K2 := N2 - K2;
	END_IF;
	IF K2 > N2 THEN
		RETURN;
	ELSIF K2 = 0 OR K2 = N2 THEN
		BINOM := 1;
	ELSIF K2 = 1 THEN
		BINOM := N2;
	ELSE
		BINOM := N2;
		N2 := N2 + 1;
		FOR i := 2 TO K2 DO
			BINOM := BINOM * (N2 - i) / i;
		END_FOR;
	END_IF;
END_FUNCTION

PROGRAM program0
  VAR
    LocalVar0 : INT;
	LocalVar1 : INT;
    LocalOUT  : INT;
  END_VAR

  LocalOUT := BINOM(LocalVar0, LocalVar1);
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION