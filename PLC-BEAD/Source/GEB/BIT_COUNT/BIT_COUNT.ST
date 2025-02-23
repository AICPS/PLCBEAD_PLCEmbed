FUNCTION BIT_COUNT:INT

	VAR_INPUT
		IN :	DWORD;
	END_VAR


	VAR
		in_temp :	DWORD;
	END_VAR

	in_temp := IN;
	WHILE in_temp > DWORD#0 DO
		IF (in_temp AND DWORD#16#00000001) > DWORD#0 THEN BIT_COUNT := BIT_COUNT +1; END_IF;
		in_temp := SHR(in_temp,1);
	END_WHILE;

END_FUNCTION

PROGRAM program0
  VAR
    LocalVar0 : DWORD;
    LocalOUT  : INT;
  END_VAR

  LocalOUT := BIT_COUNT(LocalVar0);
END_PROGRAM

