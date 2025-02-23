FUNCTION SIGN_R : BOOL
  VAR_INPUT
    IN : REAL;
  END_VAR

  SIGN_R := in < 0.0;
END_FUNCTION

FUNCTION _REAL_TO_DWORD: DWORD

  VAR_INPUT
    X :	REAL;
  END_VAR

  IF REAL_TO_DWORD(0.5) = DWORD#1 THEN
    _REAL_TO_DWORD := REAL_TO_DWORD(x);
  ELSIF X > 0.0 THEN
    _REAL_TO_DWORD := REAL_TO_DWORD(x+0.5); 
  ELSIF X < 0.0 THEN 
    _REAL_TO_DWORD := REAL_TO_DWORD(x-0.5); 
  ELSE 
    _REAL_TO_DWORD := DWORD#0;
  END_IF;
END_FUNCTION

FUNCTION AOUT1:DWORD

	VAR_INPUT
		IN :	REAL;
		BIT_0 :	INT;
		BIT_N :	INT;
		SIGN :	INT;
		LOW :	REAL;
		HIGH :	REAL;
	END_VAR


	VAR
		in2 :	REAL;
		sx :	BOOL;
	END_VAR


	IF sign < 32 THEN
		sx := sign_R(in);
		in2 := ABS(in);
	ELSE
		sx := FALSE;
		in2 := in;
	END_IF;

	in2 := LIMIT_REAL(low, in2, high);

	AOUT1 :=  SHL(_REAL_TO_DWORD((in2 - low) / (high - low) * UDINT_TO_REAL(DWORD_TO_UDINT(SHL(DWORD#2#1,bit_n - Bit_0 + 1)) - UDINT#1)),Bit_0);

	IF sx THEN AOUT1 := SHL(DWORD#2#1,sign) OR AOUT1; END_IF;

END_FUNCTION

PROGRAM program0
  VAR
    LocalVar0 : REAL;
	LocalVar1 : INT;
	LocalVar21 : INT;
	LocalVar2 : INT;
	LocalVar3 : REAL;
	LocalVar4 : REAL;
	LocalOUT  : DWORD;
  END_VAR
  	LocalOUT := AOUT1(LocalVar0, LocalVar1,LocalVar21, LocalVar2, LocalVar3,LocalVar4);
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION
