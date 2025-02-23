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
		POS :	INT;
		POS2 :	INT;
		temp :	STRING;
		x :	oscat_STRING250;
	END_VAR

	IF EQ_STRING(STR,'') THEN
		RETURN;
	END_IF;

	POS := FIND(STR, '://');
	IF POS > 0 THEN
		STRING_TO_URL.PROTOCOL := LEFT(STR, POS - 1);
		x := RIGHT(STR, LEN(STR) - POS - 2);
	ELSE
		x := STR;
		STRING_TO_URL.PROTOCOL := DEFAULT_PROTOCOL;
	END_IF;

	POS := FIND(x, '@');
	IF POS > 0 THEN
		POS2 := FIND(x,':')+1;
		IF POS2 > 1 AND POS2 <= POS THEN
			STRING_TO_URL.USER := LEFT(x,POS2 - 2);
			STRING_TO_URL.PASSWORD := MID(x, POS - POS2, POS2);
		ELSE
			STRING_TO_URL.USER := LEFT(x, POS - 2);
			STRING_TO_URL.PASSWORD := '';
		END_IF;
		x := RIGHT(x, LEN(X) - POS);
	ELSE
		STRING_TO_URL.USER := '';
		STRING_TO_URL.PASSWORD := '';
	END_IF;

	POS := FIND(x, '#');
	IF POS > 0 THEN
		STRING_TO_URL.ANCHOR := RIGHT(x, LEN(X) - POS);
		x := LEFT(x, POS - 1);
	ELSE
		STRING_TO_URL.ANCHOR := '';
	END_IF;

	POS := FIND(x, '?');
	IF POS > 0 THEN
		STRING_TO_URL.QUERY := RIGHT(x, LEN(X) - POS);
		x := LEFT(x, POS - 1);
	ELSE
		STRING_TO_URL.QUERY := '';
	END_IF;

	POS := FIND(x, '/');
	IF POS > 0 THEN
		STRING_TO_URL.PATH := RIGHT(x, LEN(X) - POS + 1);
		x := LEFT(x, POS - 1);
	ELSE
		STRING_TO_URL.PATH := DEFAULT_PATH;
	END_IF;

	POS := FIND(x, ':');
	IF POS > 0 THEN
		temp := RIGHT(x, LEN(X) - POS);
		STRING_TO_URL.PORT := STRING_TO_WORD(temp);
		STRING_TO_URL.DOMAIN := LEFT(x, POS - 1);
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

