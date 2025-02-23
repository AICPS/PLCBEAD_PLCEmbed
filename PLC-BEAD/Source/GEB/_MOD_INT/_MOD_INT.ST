FUNCTION _MOD_INT:INT
  VAR_INPUT
    IN :	INT;
    DIVISOR :	INT;
  END_VAR

  IF IN = 0 THEN
    _MOD_INT := 0;
  ELSE
    _MOD_INT := IN MOD DIVISOR;
  END_IF;
END_FUNCTION

PROGRAM program0
  VAR
    LocalVar0 : INT;
    LocalVaR1  : INT;
	  LocalOUT  : INT;
  END_VAR

  LocalOUT := _MOD_INT(LocalVar0, LocalVaR1 );
END_PROGRAM

