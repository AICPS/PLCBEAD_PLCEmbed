FUNCTION_BLOCK BLIND_SECURITY_Block

	VAR_INPUT
		UP :	BOOL;
		DN :	BOOL;
		S_IN :	BYTE;
		PI :	BYTE;
		AI :	BYTE;
		FIRE :	BOOL;
		WIND :	BOOL;
		ALARM :	BOOL;
		DOOR :	BOOL;
		RAIN :	BOOL;
		ALARM_UP :	BOOL := TRUE;
		WIND_UP :	BOOL := TRUE;
		RAIN_UP :	BOOL := TRUE;
	END_VAR


	VAR_OUTPUT
		QU :	BOOL;
		QD :	BOOL;
		STATUS :	BYTE;
		PO :	BYTE;
		AO :	BYTE;
	END_VAR

	IF Fire THEN
		QU := TRUE;
		QD := FALSE;
		STATUS := BYTE#111;
	ELSIF Wind THEN
		QU := Wind_up;
		QD := NOT wind_up;
		STATUS := BYTE#112;
	ELSIF alarm THEN
		QU := Alarm_up;
		QD := NOT Alarm_up;
		STATUS := BYTE#113;
	ELSIF Door THEN
		QU := TRUE;
		QD := FALSE;
		STATUS := BYTE#114;
	ELSIF RaIN AND NOT (up XOR dn) THEN
		QU := rain_up;
		QD := NOT rain_up;
		STATUS := BYTE#115;
	ELSE
		QU := UP;
		QD := DN;
		STATUS := S_IN;
		po := pi;
		ao := ai;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		UP :	BOOL;
		DN :	BOOL;
		S_IN :	BYTE;
		PI :	BYTE;
		AI :	BYTE;
		FIRE :	BOOL;
		WIND :	BOOL;
		ALARM :	BOOL;
		DOOR :	BOOL;
		RAIN :	BOOL;
		ALARM_UP :	BOOL := TRUE;
		WIND_UP :	BOOL := TRUE;
		RAIN_UP :	BOOL := TRUE;
		QU :	BOOL;
		QD :	BOOL;
		STATUS :	BYTE;
		PO :	BYTE;
		AO :	BYTE;

		func_block : BLIND_SECURITY_Block;
	END_VAR
	func_block.UP := UP;
	func_block.DN := DN;
	func_block.S_IN := S_IN ;
	func_block.PI    := PI    ;
	func_block.AI := AI;
	func_block.FIRE := FIRE;
	func_block.WIND := WIND ;
	func_block.ALARM := ALARM ;
	func_block.DOOR    := DOOR    ;
	func_block.RAIN := RAIN;
	func_block.ALARM_UP := ALARM_UP;
	func_block.WIND_UP := WIND_UP ;
	func_block.RAIN_UP := RAIN_UP ;

	func_block();
	QU  := func_block.QU;
	QD  := func_block.QD;
	STATUS  := func_block.STATUS;
	PO  := func_block.PO;
	AO  := func_block.AO;
END_PROGRAM

