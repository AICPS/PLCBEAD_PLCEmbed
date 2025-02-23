
FUNCTION_BLOCK REAL_TO_DW_Block
  VAR_INPUT
    X :	REAL;
  END_VAR

  VAR_OUTPUT
    REAL_TO_DW :	DWORD;
  END_VAR

  VAR
    REAL_TO_BUF :	REAL_TO_BUF;
    i :	INT;
  END_VAR

  FOR I := 0 TO 1 DO
    REAL_TO_BUF.REQ        := I > 0;
    REAL_TO_BUF.BUF_FORMAT := FALSE;
    REAL_TO_BUF.BUF_OFFS   := DINT#0;
    REAL_TO_BUF.BUF_CNT    := DINT#4;
    REAL_TO_BUF.SRC        := X;
    REAL_TO_BUF.BUFFER     := REAL_TO_DW;
    REAL_TO_BUF();
    X          := REAL_TO_BUF.SRC;
    REAL_TO_DW := REAL_TO_BUF.BUFFER;
  END_FOR;
END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : REAL;
    LocalOUT  : DWORD;
    func_block : REAL_TO_DW_Block;
  END_VAR
	func_block.X  := LocalVar0;
	func_block();
	LocalOUT := func_block.REAL_TO_DW;

END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION