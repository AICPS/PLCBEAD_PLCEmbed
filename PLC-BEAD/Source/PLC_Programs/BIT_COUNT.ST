FUNCTION BIT_COUNT:INT

	VAR_INPUT
		IN :	DWORD;
	END_VAR


	VAR
		in_temp :	DWORD;
	END_VAR

	in_temp := IN;
	WHILE in_temp > DWORD#0 DO
		IF (in_temp AND DWORD#16#00000001) > DWORD#0 THEN Bit_Count := Bit_Count +1; END_IF;
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

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION