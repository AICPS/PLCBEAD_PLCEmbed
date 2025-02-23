
FUNCTION BIT_OF_DWORD : BOOL
  VAR_INPUT
    IN : DWORD;
    N : INT;
  END_VAR

  BIT_OF_DWORD := (SHR(IN,N) AND 16#00000001) > 0;
END_FUNCTION

FUNCTION EXPN:REAL

	VAR_INPUT
		X :	REAL;
		N :	INT;
	END_VAR

	VAR
		N_word :	WORD;
		X_tmp :	REAL;
		SIGN :	BOOL;
	END_VAR

	N_word := INT_TO_WORD(N);
	X_tmp := X;
	SIGN := BIT_OF_DWORD(WORD_TO_DWORD(N_word),15);
	N_word := INT_TO_WORD(ABS(N));
	IF BIT_OF_DWORD(WORD_TO_DWORD(N_word),0) THEN EXPN := X_tmp; ELSE EXPN := 1.0; END_IF;    (* N_word.X0 *)
	N_word := SHR(N_word,1);
	WHILE N_word > WORD#0 DO
		X_tmp := X_tmp * X_tmp;
		IF BIT_OF_DWORD(WORD_TO_DWORD(N_word),0) THEN EXPN := EXPN * X_tmp; END_IF;       (* N_word.X0 *)
		N_word := SHR(N_word,1);
	END_WHILE;
	IF SIGN THEN EXPN := 1.0 / EXPN; END_IF;

END_FUNCTION

PROGRAM program0
  VAR
    LocalVar0 : REAL;
	LocalVaR1  : INT;
	LocalOUT  : REAL;
  END_VAR
  	LocalOUT := EXPN(LocalVar0, LocalVaR1 );
END_PROGRAM

