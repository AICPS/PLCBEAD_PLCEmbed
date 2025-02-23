TYPE
  oscat_ELEMENT_MONTHS3	: ARRAY [1..12] OF STRING;
  oscat_MONTHS3			: ARRAY [1..3]  OF oscat_ELEMENT_MONTHS3 := [0,0,0];
END_TYPE

FUNCTION_BLOCK SETUP_MONTHS3

	VAR_IN_OUT
		MONTHS3 :	oscat_MONTHS3;
	END_VAR

	VAR
		init :	BOOL;
	END_VAR

	IF init THEN RETURN; END_IF;
	init := TRUE;

	(* ---- english --- *)
	MONTHS3[1][01] := 'Jan';
	MONTHS3[1][02] := 'Feb';
	MONTHS3[1][03] := 'Mar';
	MONTHS3[1][04] := 'Apr';
	MONTHS3[1][05] := 'May';
	MONTHS3[1][06] := 'Jun';
	MONTHS3[1][07] := 'Jul';
	MONTHS3[1][08] := 'Aug';
	MONTHS3[1][09] := 'Sep';
	MONTHS3[1][10] := 'Oct';
	MONTHS3[1][11] := 'Nov';
	MONTHS3[1][12] := 'Dec';

	(* ---- german --- *)
	MONTHS3[2][01] := 'Jan';
	MONTHS3[2][02] := 'Feb';
	MONTHS3[2][03] := 'Mrz';
	MONTHS3[2][04] := 'Apr';
	MONTHs3[2][05] := 'Mai';
	MONTHS3[2][06] := 'Jun';
	MONTHS3[2][07] := 'Jul';
	MONTHS3[2][08] := 'Aug';
	MONTHS3[2][09] := 'Sep';
	MONTHS3[2][10] := 'Okt';
	MONTHS3[2][11] := 'Nov';
	MONTHS3[2][12] := 'Dez';

	(* ---- french --- *)
	MONTHS3[3][01] := 'Jan';
	MONTHS3[3][02] := 'Fev';
	MONTHS3[3][03] := 'Mar';
	MONTHS3[3][04] := 'Avr';
	MONTHs3[3][05] := 'Mai';
	MONTHS3[3][06] := 'Jun';
	MONTHS3[3][07] := 'Jul';
	MONTHS3[3][08] := 'Aou';
	MONTHS3[3][09] := 'Sep';
	MONTHS3[3][10] := 'Oct';
	MONTHS3[3][11] := 'Nov';
	MONTHS3[3][12] := 'Dec';
	(*@KEY@: END_WORKSHEET *)
	END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : oscat_MONTHS3;
	func_block : SETUP_MONTHS3;
  END_VAR
	func_block.MONTHS3  := LocalVar0;
	func_block();
	LocalVar0 := func_block.MONTHS3;
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION