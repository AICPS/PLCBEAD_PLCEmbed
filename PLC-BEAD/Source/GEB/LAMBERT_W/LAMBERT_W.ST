FUNCTION _REAL_TO_DWORD: DWORD

  VAR_INPUT
    X :	REAL;
  END_VAR

  IF REAL_TO_DWORD(0.5) = DWORD#1 THEN
    _REAL_TO_DWORD := REAL_TO_DWORD(X);
  ELSIF X > 0.0 THEN
    _REAL_TO_DWORD := REAL_TO_DWORD(X+0.5); 
  ELSIF X < 0.0 THEN 
    _REAL_TO_DWORD := REAL_TO_DWORD(X-0.5); 
  ELSE 
    _REAL_TO_DWORD := DWORD#0;
  END_IF;
END_FUNCTION

FUNCTION_BLOCK LAMBERT_W_Block

	VAR_INPUT
		X :	REAL;
	END_VAR


	VAR_OUTPUT
		LAMBERT_W :	REAL;
	END_VAR


	VAR
		w :	REAL;
		i :	INT;
		we :	REAL;
		w1e :	REAL;
		last :	DWORD;
		ewx :	REAL;
	END_VAR

	IF X < -0.367879441171442 THEN
		LAMBERT_W := -1000.0;
		RETURN;
	(* return 0 if x = 0 *)
	ELSIF X = 0.0 THEN
		RETURN;
	(* fiRST an estimate is calculated *)
	ELSIF X <= 500.0 THEN
		w := LN(X + 1.0);
		w := 0.665 * (1.0 + 0.0195 * w) * w + 0.04;
	ELSE
		w := LN(X - 4.0) - (1.0 - 1.0/LN(X)) * LN(LN(X));
	END_IF;
	(* USE estimate to calculate exact result *)
	FOR i := 0 TO 5 DO
		ewx := EXP(w);
		we := w * ewx - X;
		w1e := (w+1.0) * ewx;
		last := _REAL_TO_DWORD(w) AND DWORD#16#FFFF_FFFC;
		w := w - (we / (w1e - (w+2.0) * we / (2.0 * w + 2.0)));
		IF (_REAL_TO_DWORD(w) AND DWORD#16#FFFF_FFFC) = last THEN EXIT; END_IF;
	END_FOR;
	LAMBERT_W := w;

END_FUNCTION_BLOCK


PROGRAM program0

	VAR
		X :	REAL;
		LAMBERT_W :	REAL;
		func_block : LAMBERT_W_Block;
	END_VAR
	func_block.X := X;
	func_block();
	LAMBERT_W := func_block.LAMBERT_W;

END_PROGRAM

