FUNCTION_BLOCK UPPERCASE_Block

	VAR_INPUT
		STR :	STRING;
	END_VAR

	VAR_OUTPUT
		UPPERCASE :	STRING;
	END_VAR

	VAR
		char :	BYTE;
		char2 :	BYTE;
		pos :	INT;
		l :	INT;
		str_temp :	STRING;
	END_VAR

	UPPERCASE := str;
	l := LEN(str);
	FOR pos := 1 TO l DO
		char := INT_TO_BYTE(GET_CHAR(str,pos));
		char2 := TO_UPPER(char);
		IF char <> char2 THEN
			str_temp := UPPERCASE;
			UPPERCASE := REPLACE(str_temp,BYTE_TO_STRING(char2,'%c'),1,pos);
		END_IF;
	END_FOR;

END_FUNCTION_BLOCK

FUNCTION_BLOCK _STRING_TO_TIME
  VAR_INPUT
    _TIME :	STRING;
  END_VAR

  VAR_OUTPUT
    STRING_TO_TIME_O :	TIME;
  END_VAR

  VAR
    pos1 :	INT;
    pos2 :	INT;
    tmp :	STRING;
    tmp2 :	STRING;
    UPPERCASE :	UPPERCASE_Block;
    FINDB_NONUM :	FINDB_NONUM;
    FINDB_NUM :	FINDB_NUM;
    faktor :	UDINT;
    IS_ALNUM :	IS_ALNUM;
  END_VAR

  UPPERCASE(str:=_TIME);
  tmp:=UPPERCASE.UPPERCASE;

  STRING_TO_TIME_O := T#0s;

  WHILE (TRUE) DO
    FAKTOR := UDINT#0;

    FINDB_NONUM(str:=tmp);
    pos2:=FINDB_NONUM.findB_nonum;

    FINDB_NUM(str:=tmp);
    pos1:=FINDB_NUM.findB_num;

    (* bezeichner gefunden *)
    IF POS1>0 AND (POS2>POS1) THEN

      tmp2 := RIGHT(tmp,POS2-POS1);
      tmp := LEFT(tmp,pos1);

      IF EQ_STRING(tmp2,'MS') THEN
      FAKTOR := UDINT#1;
      ELSIF EQ_STRING(tmp2,'S') THEN
      FAKTOR := UDINT#1000;
      ELSIF EQ_STRING(tmp2,'M') THEN
      FAKTOR := UDINT#60000;
      ELSIF EQ_STRING(tmp2,'H') THEN
      FAKTOR := UDINT#3600000;
      ELSIF EQ_STRING(tmp2,'D') THEN
      FAKTOR := UDINT#864000000;
      END_IF;
    ELSE
      EXIT;
    END_IF;

    IF FAKTOR > UDINT#0 THEN

      FINDB_NONUM(str:=tmp);
      pos1:=FINDB_NONUM.findB_nonum;
      IF pos1>0 THEN
        tmp2 := RIGHT(tmp,LEN(tmp)-pos1);
        tmp := LEFT(tmp,pos1);
        IS_ALNUM(str:=tmp2);
        IF IS_ALNUM.IS_ALNUM THEN
          STRING_TO_TIME_O := STRING_TO_TIME_O + UDINT_TO_TIME(faktor * STRING_TO_UDINT(tmp2));
        END_IF;
      ELSE
      EXIT;
      END_IF;
    END_IF;
  END_WHILE;
END_FUNCTION_BLOCK

PROGRAM program0
	VAR
    LocalVar1 : STRING;
		LocalOUT  : TIME;
		func_block : _INSERT80;
  	END_VAR
	func_block._TIME := LocalVar1;
	func_block();
	LocalOUT := func_block.STRING_TO_TIME_O;
END_PROGRAM

CONFIGURATION Config0
  	RESOURCE Res0 ON PLC
    	TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    	PROGRAM instance0 WITH task0 : program0;
  	END_RESOURCE
END_CONFIGURATION
