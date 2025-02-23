
FUNCTION_BLOCK BYTE_TO_STRH_Block
	VAR_INPUT
		IN :	BYTE;
	END_VAR

	VAR_OUTPUT
		BYTE_TO_STRH :	STRING;
	END_VAR

	BYTE_TO_STRH:=BYTE_TO_STRING(IN);

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : BYTE;
	LocalOUT  : STRING;
	func_block : BYTE_TO_STRH_Block;
  END_VAR
	func_block.IN  := LocalVar0;
	func_block();
	LocalOUT := func_block.BYTE_TO_STRH;

END_PROGRAM

