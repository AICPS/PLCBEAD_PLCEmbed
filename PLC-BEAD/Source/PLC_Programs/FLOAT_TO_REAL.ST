
FUNCTION BIT_OF_DWORD : BOOL
  VAR_INPUT
    IN : DWORD;
    N : INT;
  END_VAR

  BIT_OF_DWORD := (SHR(in,N) AND 16#00000001) > 0;
END_FUNCTION

FUNCTION EXPN:REAL

	VAR_INPUT
		X :	REAL;
		N :	INT;
	END_VAR

	VAR
		N_word :	WORD;
		X_tmp :	REAL;
		sign :	BOOL;
	END_VAR

	N_word := INT_TO_WORD(N);
	X_tmp := X;
	sign := BIT_OF_DWORD(WORD_TO_DWORD(N_word),15);
	N_word := INT_TO_WORD(ABS(N));
	IF BIT_OF_DWORD(WORD_TO_DWORD(N_word),0) THEN expn := X_tmp; ELSE expn := 1.0; END_IF;    (* N_word.X0 *)
	N_word := SHR(N_word,1);
	WHILE N_word > WORD#0 DO
		X_tmp := X_tmp * X_tmp;
		IF BIT_OF_DWORD(WORD_TO_DWORD(N_word),0) THEN expn := expn * X_tmp; END_IF;       (* N_word.X0 *)
		N_word := SHR(N_word,1);
	END_WHILE;
	IF sign THEN EXPN := 1.0 / EXPN; END_IF;

END_FUNCTION

FUNCTION_BLOCK FLOAT_TO_REAL_Block

	VAR_INPUT
		FLT :	STRING;
	END_VAR

	VAR_OUTPUT
		FLOAT_TO_REAL :	REAL;
	END_VAR

	VAR
		i :	INT;
		X :	BYTE;
		sign :	INT := 1;
		stop :	INT;
		tmp :	DINT;
		d :	INT;
		DEC_TO_INT :	DEC_TO_INT;
		CODE :	CODE;
	END_VAR

	sign := 1;
	d := 0;
	stop := LEN(FLT);
	tmp := DINT#0;

	FOR i := 1 TO stop DO
		CODE(STR:=FLT,POS:=i);
		X := CODE.CODE;
		IF X > BYTE#47 AND X < BYTE#58 OR X = BYTE#46 THEN
			EXIT;
		ELSIF X = BYTE#45 THEN
			(* code 45 is sign *)
			sign := -1;
		END_IF;
	END_FOR;

	FOR i := i TO stop DO
		CODE(STR:=FLT,POS:=i);
		X := CODE.CODE;
		IF X = BYTE#44 OR X = BYTE#46 OR X = BYTE#69 OR X = BYTE#101 THEN
			EXIT;
		(* calculate the value of the digit *)
		ELSIF X > BYTE#47 AND x < BYTE#58 THEN
			tmp := tmp * DINT#10 + _BYTE_TO_DINT(X) - DINT#48;
		END_IF;
	END_FOR;

	IF x = BYTE#44 OR X = BYTE#46 THEN
		FOR i := i + 1 TO stop DO
			CODE(STR:=FLT,POS:=i);
			X := CODE.CODE;
			IF X = BYTE#69 OR X = BYTE#101 THEN
				EXIT;
			ELSIF x > BYTE#47 AND x < BYTE#58 THEN
				tmp := tmp * DINT#10 + _BYTE_TO_DINT(X) - DINT#48;
				d := d - 1;
			END_IF;
		END_FOR;
	END_IF;

	IF (X = BYTE#69 OR X = BYTE#101) AND i<=stop THEN
		DEC_TO_INT(DEC:=MID(FLT, MIN(stop - i,10),MIN(stop,i+1)));
		d := d + DEC_TO_INT.DEC_TO_INT;


	(*    DEC_TO_INT(DEC:=RIGHT(FLT, MIN(stop - i,10)));
		d := d + DEC_TO_INT.DEC_TO_INT;*)
	END_IF;

	FLOAT_TO_REAL :=  EXPN(10.0, d) * DINT_TO_REAL(TMP * INT_TO_DINT(SIGN));

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : STRING;
	LocalOUT  : REAL;
	func_block : FLOAT_TO_REAL_Block;
  END_VAR
	func_block.FLT  := LocalVar0;
	func_block();
	LocalOUT := func_block.FLOAT_TO_REAL;
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION