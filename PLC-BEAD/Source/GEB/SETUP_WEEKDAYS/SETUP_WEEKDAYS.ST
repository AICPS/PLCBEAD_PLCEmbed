
TYPE
  oscat_ELEMENT_WEEKDAYS	: ARRAY [1..7] OF STRING;
  oscat_WEEKDAYS			: ARRAY [1..3]  OF oscat_ELEMENT_WEEKDAYS;
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

	WEEKDAYS[1][01] := 'MonDAY';
	WEEKDAYS[1][02] := 'TuesDAY';
	WEEKDAYS[1][03] := 'WednesDAY';
	WEEKDAYS[1][04] := 'ThursDAY';
	WEEKDAYS[1][05] := 'FriDAY';
	WEEKDAYS[1][06] := 'SaturDAY';
	WEEKDAYS[1][07] := 'SunDAY';

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

