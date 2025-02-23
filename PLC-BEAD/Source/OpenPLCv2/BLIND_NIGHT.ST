FUNCTION TIME_TO_UDINT2:UDINT
	VAR_INPUT
		X :	TIME;
	END_VAR

	TIME_TO_UDINT2 := DINT_TO_UDINT(TIME_TO_DINT(X));
END_FUNCTION

FUNCTION DT_TO_DATE2:UDINT

	VAR_INPUT
		IN :	UDINT;
	END_VAR

	DT_TO_DATE2 := (IN / UDINT#86400) * UDINT#86400;
END_FUNCTION

FUNCTION DT_TO_TOD2:UDINT
	VAR_INPUT
		IN :	UDINT;
	END_VAR

	DT_TO_TOD2 := (IN MOD UDINT#86400) * UDINT#1000;
END_FUNCTION

FUNCTION_BLOCK BLIND_NIGHT_Block

	VAR_INPUT
		UP :	BOOL;
		DN :	BOOL;
		S_IN :	BYTE;
		PI :	BYTE;
		AI :	BYTE;
		E_NIGHT :	BOOL := TRUE;
		E_DAY :	BOOL := TRUE;
		DTIN :	UDINT;
		SUNRISE :	UDINT;
		SUNSET :	UDINT;
		SUNRISE_OFFSET :	TIME;
		SUNSET_OFFSET :	TIME;
		NIGHT_POSITION :	BYTE;
		NIGHT_ANGLE :	BYTE;
	END_VAR


	VAR_OUTPUT
		QU :	BOOL;
		QD :	BOOL;
		STATUS :	BYTE;
		PO :	BYTE;
		AO :	BYTE;
	END_VAR


	VAR
		night :	BOOL;
		last_night :	UDINT;
		last_day :	UDINT;
	END_VAR

	IF NOT (up AND dn) AND night THEN
		night := FALSE;
	ELSIF (DT_TO_TOD2(dtin) > sunset + TIME_TO_UDINT2(sunset_offset)) AND (last_night < DT_TO_DATE2(dtin)) AND NOT night AND e_night THEN
		night := TRUE;
		last_night := DT_TO_DATE2(dtin);
	ELSIF (DT_TO_TOD2(dtin) > sunrise + TIME_TO_UDINT2(sunrise_offset)) AND (last_day < DT_TO_DATE2(dtin)) AND night AND e_day AND (last_night < DT_TO_DATE2(dtin)) THEN
		night := FALSE;
		last_day := DT_TO_DATE2(dtin);
	END_IF;

	IF UP AND DN AND night THEN
		status := BYTE#141;
		po := night_position;
		ao := night_angle;
	ELSE
		QU := UP;
		QD := DN;
		po := pi;
		ao := ai;
		status := s_in;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		UP :	BOOL;
		DN :	BOOL;
		S_IN :	BYTE;
		PI :	BYTE;
		AI :	BYTE;
		E_NIGHT :	BOOL := TRUE;
		E_DAY :	BOOL := TRUE;
		DTIN :	UDINT;
		SUNRISE :	UDINT;
		SUNSET :	UDINT;
		SUNRISE_OFFSET :	TIME;
		SUNSET_OFFSET :	TIME;
		NIGHT_POSITION :	BYTE;
		NIGHT_ANGLE :	BYTE;
		QU :	BOOL;
		QD :	BOOL;
		STATUS :	BYTE;
		PO :	BYTE;
		AO :	BYTE;

		func_block : BLIND_NIGHT_Block;
	END_VAR
	func_block.UP := UP;
	func_block.DN := DN;
	func_block.S_IN := S_IN ;
	func_block.PI    := PI    ;
	func_block.AI := AI;
	func_block.E_NIGHT := E_NIGHT;
	func_block.E_DAY := E_DAY ;
	func_block.DTIN    := DTIN    ;
	func_block.SUNRISE := SUNRISE;
	func_block.SUNSET := SUNSET;
	func_block.SUNRISE_OFFSET := SUNRISE_OFFSET ;
	func_block.SUNSET_OFFSET    := SUNSET_OFFSET    ;
	func_block.NIGHT_POSITION := NIGHT_POSITION ;
	func_block.NIGHT_ANGLE    := NIGHT_ANGLE    ;

	func_block();
	QU  := func_block.QU;
	QD  := func_block.QD;
	STATUS  := func_block.STATUS;
	PO  := func_block.PO;
	AO  := func_block.AO;
END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION