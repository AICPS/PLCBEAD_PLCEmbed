TYPE
  oscat_STRING250             : STRING;
  oscat_STRING32             : STRING;
  oscat_STRING80             : STRING;
  oscat_STRING160             : STRING;
  oscat_STRING40             : STRING;
  oscat_STRING10             : STRING;
  oscat_STRING20             : STRING;
END_TYPE

TYPE oscat_url :
    STRUCT
    PROTOCOL : oscat_STRING10;
    USER     : oscat_STRING32;
    PASSWORD : oscat_STRING32;
    DOMAIN   : oscat_STRING80;
    PORT     : WORD;
    PATH     : oscat_STRING80;
    QUERY    : oscat_STRING250;
    ANCHOR   : oscat_STRING40;
    HEADER   : oscat_STRING160;
    END_STRUCT;
END_TYPE

FUNCTION_BLOCK STRING_TO_URL_Block

	VAR_INPUT
		STR :	oscat_STRING250;
		DEFAULT_PROTOCOL :	oscat_STRING20 := 'http';
		DEFAULT_PATH :	oscat_STRING80 := '/';
	END_VAR


	VAR_OUTPUT
		STRING_TO_URL :	oscat_url;
	END_VAR


	VAR
		pos :	INT;
		pos2 :	INT;
		temp :	STRING;
		x :	oscat_STRING250;
	END_VAR

	IF EQ_STRING(STR,'') THEN
		RETURN;
	END_IF;

	pos := FIND(STR, '://');
	IF pos > 0 THEN
		STRING_TO_URL.PROTOCOL := LEFT(STR, pos - 1);
		x := RIGHT(STR, LEN(STR) - pos - 2);
	ELSE
		x := STR;
		STRING_TO_URL.PROTOCOL := DEFAULT_PROTOCOL;
	END_IF;

	pos := FIND(x, '@');
	IF pos > 0 THEN
		pos2 := FIND(x,':')+1;
		IF pos2 > 1 AND pos2 <= pos THEN
			STRING_TO_URL.USER := LEFT(x,pos2 - 2);
			STRING_TO_URL.PASSWORD := MID(x, pos - pos2, pos2);
		ELSE
			STRING_TO_URL.USER := LEFT(x, pos - 2);
			STRING_TO_URL.PASSWORD := '';
		END_IF;
		x := RIGHT(x, LEN(x) - pos);
	ELSE
		STRING_TO_URL.USER := '';
		STRING_TO_URL.PASSWORD := '';
	END_IF;

	pos := FIND(x, '#');
	IF pos > 0 THEN
		STRING_TO_URL.ANCHOR := RIGHT(x, LEN(x) - pos);
		x := LEFT(x, pos - 1);
	ELSE
		STRING_TO_URL.ANCHOR := '';
	END_IF;

	pos := FIND(x, '?');
	IF pos > 0 THEN
		STRING_TO_URL.QUERY := RIGHT(x, LEN(x) - pos);
		x := LEFT(x, pos - 1);
	ELSE
		STRING_TO_URL.QUERY := '';
	END_IF;

	pos := FIND(x, '/');
	IF pos > 0 THEN
		STRING_TO_URL.PATH := RIGHT(x, LEN(x) - pos + 1);
		x := LEFT(x, pos - 1);
	ELSE
		STRING_TO_URL.PATH := DEFAULT_PATH;
	END_IF;

	pos := FIND(x, ':');
	IF pos > 0 THEN
		temp := RIGHT(x, LEN(x) - pos);
		STRING_TO_URL.PORT := STRING_TO_WORD(temp);
		STRING_TO_URL.DOMAIN := LEFT(x, pos - 1);
	ELSE
		STRING_TO_URL.PORT := WORD#0;
		STRING_TO_URL.DOMAIN := x;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		STR :	oscat_STRING250;
		DEFAULT_PROTOCOL :	oscat_STRING20 := 'http';
		DEFAULT_PATH :	oscat_STRING80 := '/';
		STRING_TO_URL :	oscat_url;

		func_block : STRING_TO_URL_Block;
	END_VAR
	func_block.STR := STR;
	func_block.DEFAULT_PROTOCOL := DEFAULT_PROTOCOL;
	func_block.DEFAULT_PATH := DEFAULT_PATH;

	func_block();
  	STRING_TO_URL  := func_block.STRING_TO_URL;
END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION