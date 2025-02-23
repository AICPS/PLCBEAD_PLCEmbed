TYPE
  oscat_CHARNAMES	: ARRAY [1..11] OF STRING;
END_TYPE


FUNCTION_BLOCK SETUP_CHARNAMES_Block

	VAR_IN_OUT
		CHARNAMES :	oscat_CHARNAMES;
	END_VAR
	
	VAR
		init :	BOOL;
	END_VAR

	IF init THEN RETURN; END_IF;

	init := TRUE;

	CHARNAMES[01] := '123';
	CHARNAMES[02] := '456';
	CHARNAMES[03] := 'zgsdafasf';
	CHARNAMES[04] := 'sadfsdfa';
	CHARNAMES[05] := 'asdfdsafdfds';
	CHARNAMES[06] := 'sadfsdfsdf';
	CHARNAMES[07] := 'sfsfdfdddd';
	CHARNAMES[08] := 'dddddted';
	CHARNAMES[10] := 'wer';
	CHARNAMES[11] := 'werwer';

END_FUNCTION_BLOCK

PROGRAM program0

	VAR
		CHARNAMES :	oscat_CHARNAMES;
		func_block : SETUP_CHARNAMES_Block;
  	END_VAR
	func_block.CHARNAMES  :=CHARNAMES;
	func_block();
	CHARNAMES := func_block.CHARNAMES;

END_PROGRAM

CONFIGURATION Config0

	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE

END_CONFIGURATION