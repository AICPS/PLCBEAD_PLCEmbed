TYPE
  oscat_ELEMENT_MONTHS 	: ARRAY [1..12] OF STRING;
  oscat_MONTHS			: ARRAY [1..3]  OF oscat_ELEMENT_MONTHS := [0, 0, 0];
  oscat_ELEMENT_MONTHS3	: ARRAY [1..12] OF STRING;
  oscat_MONTHS3			: ARRAY [1..3]  OF oscat_ELEMENT_MONTHS3 := [0,0,0];
END_TYPE

TYPE oscat_LANGUAGE:
  STRUCT
    DEFAULT 	: INT;
	LMAX    	: INT;    
  END_STRUCT;
END_TYPE

FUNCTION_BLOCK SETUP_LANGUAGE_Block

	VAR_IN_OUT
		LANGUAGE :	oscat_LANGUAGE;
	END_VAR

	VAR
		init :	BOOL;
	END_VAR

	IF init THEN RETURN; END_IF;
	init := TRUE;

	LANGUAGE.DEFAULT  := 1; (* 1=english, 2=german 3=french *)
	LANGUAGE.LMAX := 3;
END_FUNCTION_BLOCK

FUNCTION_BLOCK SETUP_MONTHS3_Block

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

FUNCTION_BLOCK SETUP_MONTHS_Block

	VAR_IN_OUT
		MONTHS :	oscat_MONTHS;
	END_VAR

	VAR
		init :	BOOL;
	END_VAR

	IF init THEN RETURN; END_IF;
	init := TRUE;

	(* ---- english --- *)
	MONTHS[1][01] := 'January';
	MONTHS[1][02] := 'February';
	MONTHS[1][03] := 'March';
	MONTHS[1][04] := 'April';
	MONTHS[1][05] := 'May';
	MONTHS[1][06] := 'June';
	MONTHS[1][07] := 'July';
	MONTHS[1][08] := 'August';
	MONTHS[1][09] := 'September';
	MONTHS[1][10] := 'October';
	MONTHS[1][11] := 'November';
	MONTHS[1][12] := 'December';

	(* ---- german --- *)
	MONTHS[2][01] := 'Januar';
	MONTHS[2][02] := 'Februar';
	MONTHS[2][03] := 'March';
	MONTHS[2][04] := 'April';
	MONTHS[2][05] := 'Mai';
	MONTHS[2][06] := 'Juni';
	MONTHS[2][07] := 'Juli';
	MONTHS[2][08] := 'August';
	MONTHS[2][09] := 'September';
	MONTHS[2][10] := 'Oktober';
	MONTHS[2][11] := 'November';
	MONTHS[2][12] := 'Dezember';

	(* ---- french --- *)
	MONTHS[3][01] := 'Janvier';
	MONTHS[3][02] := 'Fvrier';
	MONTHS[3][03] := 'mars';
	MONTHS[3][04] := 'Avril';
	MONTHS[3][05] := 'Mai';
	MONTHS[3][06] := 'Juin';
	MONTHS[3][07] := 'Juillet';
	MONTHS[3][08] := 'Aot';
	MONTHS[3][09] := 'Septembre';
	MONTHS[3][10] := 'Octobre';
	MONTHS[3][11] := 'Novembre';
	MONTHS[3][12] := 'Decembre';
END_FUNCTION_BLOCK

FUNCTION_BLOCK MONTH_TO_STRING_Block

	VAR_INPUT
		MTH :	INT;
		LANG :	INT;
		LX :	INT;
	END_VAR

	VAR_OUTPUT
		MONTH_TO_STRING :	STRING;
	END_VAR

	VAR
		LY :	INT;
		SETUP_MONTHS :	SETUP_MONTHS_Block;
		MONTHS :	oscat_MONTHS;
		SETUP_MONTHS3 :	SETUP_MONTHS3_Block;
		MONTHS3 :	oscat_MONTHS3;
		SETUP_LANGUAGE :	SETUP_LANGUAGE_Block;
		LANGUAGE :	oscat_LANGUAGE;
	END_VAR

	SETUP_MONTHS(MONTHS:=MONTHS);
	MONTHS:=SETUP_MONTHS.MONTHS;
	SETUP_MONTHS3(MONTHS3:=MONTHS3);
	MONTHS3:=SETUP_MONTHS3.MONTHS3;
	SETUP_LANGUAGE(LANGUAGE:=LANGUAGE);
	LANGUAGE:=SETUP_LANGUAGE.LANGUAGE;

	IF LANG = 0 THEN Ly := LANGUAGE.DEFAULT; ELSE ly := MIN(LANG, language.LMAX); END_IF;
	IF MTH < 1 OR MTH > 12 THEN
		RETURN;
	ELSIF LX = 0 THEN
		MONTH_TO_STRING := MONTHS[ly][MTH];
	ELSIF Lx = 3 THEN
		MONTH_TO_STRING := MONTHS3[ly][MTH];
	END_IF;

END_FUNCTION_BLOCK


PROGRAM program0
	VAR
		MTH :	INT;
		LANG :	INT;
		LX :	INT;
		MONTH_TO_STRING :	STRING;
		func_block : MONTH_TO_STRING_Block;
	END_VAR
		func_block.MTH  := MTH;
		func_block.LANG  := LANG;
		func_block.LX  := LX;
		func_block();
		MONTH_TO_STRING := func_block.MONTH_TO_STRING;
END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION