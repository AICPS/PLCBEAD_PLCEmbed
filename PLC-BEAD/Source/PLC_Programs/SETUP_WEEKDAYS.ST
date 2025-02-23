
TYPE
  oscat_ELEMENT_WEEKDAYS	: ARRAY [1..7] OF STRING;
  oscat_WEEKDAYS			: ARRAY [1..3]  OF oscat_ELEMENT_WEEKDAYS := [0, 0, 0];
END_TYPE

FUNCTION_BLOCK SETUP_WEEKDAYS

	VAR_IN_OUT
		WEEKDAYS :	oscat_WEEKDAYS;
	END_VAR

	VAR
		init :	BOOL;
	END_VAR

	IF init THEN RETURN; END_IF;
	init := TRUE;

	WEEKDAYS[1][01] := 'Monday';
	WEEKDAYS[1][02] := 'Tuesday';
	WEEKDAYS[1][03] := 'Wednesday';
	WEEKDAYS[1][04] := 'Thursday';
	WEEKDAYS[1][05] := 'Friday';
	WEEKDAYS[1][06] := 'Saturday';
	WEEKDAYS[1][07] := 'Sunday';

	WEEKDAYS[2][01] := 'Montag';
	WEEKDAYS[2][02] := 'Dienstag';
	WEEKDAYS[2][03] := 'Mittwoch';
	WEEKDAYS[2][04] := 'Donnerstag';
	WEEKDAYS[2][05] := 'Freitag';
	WEEKDAYS[2][06] := 'Samstag';
	WEEKDAYS[2][07] := 'Sonntag';

	WEEKDAYS[3][01] := 'Lundi';
	WEEKDAYS[3][02] := 'Mardi';
	WEEKDAYS[3][03] := 'Mercredi';
	WEEKDAYS[3][04] := 'Jeudi';
	WEEKDAYS[3][05] := 'Vendredi';
	WEEKDAYS[3][06] := 'Samedi';
	WEEKDAYS[3][07] := 'Dimanche';
END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    WEEKDAYS :	oscat_WEEKDAYS;
	func_block : SETUP_WEEKDAYS;
  END_VAR
	func_block.WEEKDAYS  := WEEKDAYS;
	func_block();
	WEEKDAYS := func_block.WEEKDAYS;

END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION