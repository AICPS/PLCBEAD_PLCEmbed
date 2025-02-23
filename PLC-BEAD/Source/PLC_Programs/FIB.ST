FUNCTION FIB:DINT

VAR_INPUT
	X :	INT;
END_VAR

VAR
	t1 :	DINT;
	t2 :	DINT;
	X_tmp :	INT;
END_VAR

t1 := DINT#0;
t2 := DINT#0;
X_tmp := X;
IF X_tmp < 0 OR X_tmp > 46 THEN
	FIB := DINT#-1;
ELSIF X_tmp < 2 THEN
	FIB := INT_TO_DINT(X_tmp);
	RETURN;
ELSE
	t2 := DINT#1;
	WHILE X_tmp > 3 DO
		X_tmp := X_tmp - 2;
		t1 := t1 + t2;
		t2 := t1 + t2;
	END_WHILE;
	IF X_tmp > 2 THEN t1 := t1 + t2; END_IF;
	fib := t1 + t2;
END_IF;

END_FUNCTION

PROGRAM program0
  VAR
    LocalVar0 : INT;
	LocalOUT  : DINT;
  END_VAR
  	LocalOUT := FIB(LocalVar0);
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION
