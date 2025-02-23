FUNCTION_BLOCK STRING_TO_TOD_Block

  VAR_INPUT
    _TOD :	STRING;
  END_VAR

  VAR_OUTPUT
    OUT_STRING_TO_TOD :	UDINT;
  END_VAR

  VAR
    POS :	INT;
    i :	INT;
    tmp :	STRING;
    tmp2 :	STRING;
  END_VAR


  OUT_STRING_TO_TOD := UDINT#0;
  i := LEN(_TOD);
  POS :=FIND(_TOD,'#');

  IF POS>0 AND i>POS THEN
    tmp := RIGHT(_TOD,LEN(_TOD)-POS);
    POS := FIND(tmp,':');
    IF POS>1 THEN
      tmp2 := LEFT(tmp,POS-1);
      tmp := RIGHT(tmp,LEN(tmp)-POS);
      OUT_STRING_TO_TOD := STRING_TO_UDINT(tmp2) * UDINT#3600000;

      POS :=FIND(tmp,':');
      IF POS>1 THEN
        tmp2 := LEFT(tmp,POS-1);
        tmp := RIGHT(tmp,LEN(tmp)-POS);
        OUT_STRING_TO_TOD := OUT_STRING_TO_TOD + STRING_TO_UDINT(tmp2) * UDINT#60000;

        OUT_STRING_TO_TOD := OUT_STRING_TO_TOD + STRING_TO_UDINT(tmp) * UDINT#1000;
      END_IF;
    END_IF;
  END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    _TOD :	STRING;
  	OUT_STRING_TO_TOD :	UDINT;
    func_block : STRING_TO_TOD_Block;
  END_VAR
	func_block._TOD  := _TOD;
	func_block();
	OUT_STRING_TO_TOD  := func_block.OUT_STRING_TO_TOD;
END_PROGRAM

