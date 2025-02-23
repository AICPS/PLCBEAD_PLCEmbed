FUNCTION _OFFSET:REAL

	VAR_INPUT
		X :	REAL;
		O1 :	BOOL;
		O2 :	BOOL;
		O3 :	BOOL;
		O4 :	BOOL;
		D :	BOOL;
		OFFSET_1 :	REAL;
		OFFSET_2 :	REAL;
		OFFSET_3 :	REAL;
		OFFSET_4 :	REAL;
		DEFAULT :	REAL;
	END_VAR


	IF D THEN _Offset := default; ELSE _Offset := X; END_IF;
	IF O1 THEN _Offset := _Offset + offset_1; END_IF;
	IF O2 THEN _Offset := _Offset + offset_2; END_IF;
	IF O3 THEN _Offset := _Offset + offset_3; END_IF;
	IF O4 THEN _Offset := _Offset + offset_4; END_IF;

END_FUNCTION

PROGRAM program0
	
	VAR
		X :	REAL;
		O1 :	BOOL;
		O2 :	BOOL;
		O3 :	BOOL;
		O4 :	BOOL;
		D :	BOOL;
		OFFSET_1 :	REAL;
		OFFSET_2 :	REAL;
		OFFSET_3 :	REAL;
		OFFSET_4 :	REAL;
		DEFAULT :	REAL;
		OUT : REAL;
	END_VAR

	OUT := _OFFSET(X, O1, O2, O3, O4, D, OFFSET_1, OFFSET_2, OFFSET_3, OFFSET_4, DEFAULT);
END_PROGRAM


CONFIGURATION Config0

	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE

END_CONFIGURATION