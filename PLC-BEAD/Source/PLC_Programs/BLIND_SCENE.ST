TYPE
	oscat_bsa_X                 : ARRAY [0..2]    OF BYTE;
  	oscat_blind_scene_array     : ARRAY [0..15]   OF oscat_bsa_X := [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
END_TYPE

FUNCTION _BYTE_TO_INT:INT
	VAR_INPUT
		IN :	BYTE;
	END_VAR

	_BYTE_TO_INT := USINT_TO_INT(BYTE_TO_USINT(IN));
END_FUNCTION

FUNCTION_BLOCK BLIND_SCENE_Block

	VAR_INPUT
		UP :	BOOL;
		DN :	BOOL;
		S_IN :	BYTE;
		PI :	BYTE;
		AI :	BYTE;
		ENABLE :	BOOL;
		SWRITE :	BOOL;
		SCENE :	BYTE;
	END_VAR


	VAR_OUTPUT
		QU :	BOOL;
		QD :	BOOL;
		STATUS :	BYTE;
		PO :	BYTE;
		AO :	BYTE;
	END_VAR


	VAR
		x :	INT;
	END_VAR


	VAR RETAIN 
		sx :	oscat_blind_scene_array;
	END_VAR

	x := _BYTE_TO_INT(scene AND BYTE#2#0000_1111);

	IF enable AND (sx[x][2] > BYTE#0) AND UP AND DN THEN
		po := sx[x][0];
		ao := sx[x][1];
		status := INT_TO_BYTE(160 + x);  
		QU := TRUE;
		QD := TRUE;
	ELSE
		QU := UP;
		QD := DN;
		status := S_IN;
		po := pi;
		ao := ai;
	END_IF;

	IF swrite THEN
		status := BYTE#176;	
		sx[x][0] := pi;
		sx[x][1] := ai;
		IF enable THEN sx[x][2] := BYTE#1; ELSE sx[x][2] := BYTE#0; END_IF; 
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		UP :	BOOL;
		DN :	BOOL;
		S_IN :	BYTE;
		PI :	BYTE;
		AI :	BYTE;
		ENABLE :	BOOL;
		SWRITE :	BOOL;
		SCENE :	BYTE;
		QU :	BOOL;
		QD :	BOOL;
		STATUS :	BYTE;
		PO :	BYTE;
		AO :	BYTE;

		func_block : BLIND_SCENE_Block;
	END_VAR
	func_block.UP := UP;
	func_block.DN := DN;
	func_block.S_IN := S_IN ;
	func_block.PI    := PI    ;
	func_block.AI := AI;
	func_block.ENABLE := ENABLE;
	func_block.SWRITE := SWRITE ;
	func_block.SCENE := SCENE ;

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