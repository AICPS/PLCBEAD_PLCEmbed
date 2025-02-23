FUNCTION MID3:REAL

	VAR_INPUT
		IN1 :	REAL;
		IN2 :	REAL;
		IN3 :	REAL;
	END_VAR

	VAR
		_IN1 :	REAL;
		_IN2 :	REAL;
		_IN3 :	REAL;
	END_VAR

	_IN1 := IN1;
	_IN2 := IN2;
	_IN3 := IN3;

	IF _IN1 > _IN2 THEN MID3 := _IN1; _IN1 := _IN2; _IN2 := MID3; END_IF;
	IF _IN2 > _IN3 THEN _IN2 := _IN3; END_IF;
	MID3 := SEL(_IN1 > _IN2, _IN2, _IN1);

END_FUNCTION

FUNCTION _BYTE_TO_INT:INT
	VAR_INPUT
		IN :	BYTE;
	END_VAR

	_BYTE_TO_INT := USINT_TO_INT(BYTE_TO_USINT(IN));
END_FUNCTION

FUNCTION MULTI_IN:REAL

	VAR_INPUT
		IN_1 :	REAL;
		IN_2 :	REAL;
		IN_3 :	REAL;
		DEFAULT :	REAL;
		IN_MIN :	REAL;
		IN_MAX :	REAL;
		MODE :	BYTE;
	END_VAR

	VAR
		count :	INT;
		F1 :	BOOL;
		F2 :	BOOL;
		F3 :	BOOL;
	END_VAR

	F1 :=  in_1 > in_min AND in_1 < in_max;
	F2 :=  in_2 > in_min AND in_2 < in_max;
	F3 :=  in_3 > in_min AND in_3 < in_max;

	CASE _BYTE_TO_INT(mode) OF
	0:	count := 0;
		IF F1 THEN
			count := count + 1;
			MULTI_IN := in_1;
		ELSE
			MULTI_IN := 0.0;
		END_IF;
		IF F2 THEN
			count := count + 1;
			MULTI_IN := MULTI_IN + in_2;
		END_IF;
		IF F3 THEN
			count := count + 1;
			MULTI_IN := MULTI_IN + in_3;
		END_IF;
		MULTI_IN := SEL_REAL(count = 0, MULTI_IN / INT_TO_REAL(count), default);

	1:	MULTI_IN := SEL_REAL(F1, default, IN_1);

	2:	MULTI_IN := SEL_REAL(F2, default, IN_2);

	3:	MULTI_IN := SEL_REAL(F3, default, IN_3);

	4:	MULTI_IN := default;

	5:	MULTI_IN := SEL_REAL(F1, in_max, IN_1);
		IF F2 AND in_2 < MULTI_IN THEN MULTI_IN := in_2; END_IF;
		IF F3 AND in_3 < MULTI_IN THEN MULTI_IN := in_3; END_IF;
		IF MULTI_IN = in_max THEN MULTI_IN := default; END_IF;

	6:	MULTI_IN := SEL_REAL(F1, in_min, IN_1);
		IF F2 AND in_2 > MULTI_IN THEN MULTI_IN := in_2; END_IF;
		IF F3 AND in_3 > MULTI_IN THEN MULTI_IN := in_3; END_IF;
		IF MULTI_IN = in_min THEN MULTI_IN := default; END_IF;

	7:	IF F1 AND F2 AND F3 THEN MULTI_IN := MID3(in_1, in_2, in_3);
		ELSIF F1 AND F2 THEN MULTI_IN := MIN(in_1, in_2);
		ELSIF F1 AND F3 THEN MULTI_IN := MIN(in_1, in_3);
		ELSIF F2 AND F3 THEN MULTI_IN := MIN(in_2, in_3);
		ELSIF F1 THEN MULTI_IN := in_1;
		ELSIF F2 THEN MULTI_IN := in_2;
		ELSIF F3 THEN MULTI_IN := in_3;
		ELSE MULTI_IN := default;
		END_IF;

	END_CASE;

END_FUNCTION

PROGRAM program0
	VAR
		IN_1 :	REAL;
		IN_2 :	REAL;
		IN_3 :	REAL;
		DEFAULT :	REAL;
		IN_MIN :	REAL;
		IN_MAX :	REAL;
		MODE :	BYTE;

		OUT : REAL;
	END_VAR

	OUT := MULTI_IN(IN_1, IN_2, IN_3, DEFAULT, IN_MIN, IN_MAX, MODE);
	
END_PROGRAM


CONFIGURATION Config0

	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE

END_CONFIGURATION
