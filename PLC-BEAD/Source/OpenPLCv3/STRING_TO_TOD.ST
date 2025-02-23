FUNCTION_BLOCK STRING_TO_TOD_Block

  VAR_INPUT
    _TOD :	STRING;
  END_VAR

  VAR_OUTPUT
    out_STRING_TO_TOD :	UDINT;
  END_VAR

  VAR
    pos :	INT;
    i :	INT;
    tmp :	STRING;
    tmp2 :	STRING;
  END_VAR


  out_STRING_TO_TOD := UDINT#0;
  i := LEN(_TOD);
  pos :=FIND(_TOD,'#');

  IF pos>0 AND i>pos THEN
    tmp := RIGHT(_TOD,LEN(_TOD)-pos);
    pos := FIND(tmp,':');
    IF pos>1 THEN
      tmp2 := LEFT(tmp,pos-1);
      tmp := RIGHT(tmp,LEN(tmp)-pos);
      out_STRING_TO_TOD := STRING_TO_UDINT(tmp2) * UDINT#3600000;

      pos :=FIND(tmp,':');
      IF pos>1 THEN
        tmp2 := LEFT(tmp,pos-1);
        tmp := RIGHT(tmp,LEN(tmp)-pos);
        out_STRING_TO_TOD := out_STRING_TO_TOD + STRING_TO_UDINT(tmp2) * UDINT#60000;

        out_STRING_TO_TOD := out_STRING_TO_TOD + STRING_TO_UDINT(tmp) * UDINT#1000;
      END_IF;
    END_IF;
  END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    _TOD :	STRING;
  	out_STRING_TO_TOD :	UDINT;
    func_block : STRING_TO_TOD_Block;
  END_VAR
	func_block._TOD  := _TOD;
	func_block();
	out_STRING_TO_TOD  := func_block.out_STRING_TO_TOD;
END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION