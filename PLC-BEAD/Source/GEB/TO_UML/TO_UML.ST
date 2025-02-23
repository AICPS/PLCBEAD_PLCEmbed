FUNCTION _BYTE_TO_INT:INT
	VAR_INPUT
		IN :	BYTE;
	END_VAR

	_BYTE_TO_INT := USINT_TO_INT(BYTE_TO_USINT(IN));
END_FUNCTION

FUNCTION_BLOCK TO_UML_Block

	VAR_INPUT
		IN :	BYTE;
	END_VAR


	VAR_OUTPUT
		TO_UML :	STRING;
	END_VAR

	CASE _BYTE_TO_INT(IN) OF
		196:
			TO_UML := 'Ae';
		214:
			TO_UML := 'Oe';
		220:
			TO_UML := 'Ue';
		223:
			TO_UML := 'ss';
		228:
			TO_UML := 'ae';
		246:
			TO_UML := 'oe';
		252:
			TO_UML := 'ue';
	ELSE
		TO_UML := BYTE_TO_STRING(IN);
	END_CASE;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	IN :	BYTE;
	TO_UML :	STRING;
	func_block : TO_UML_Block;
  END_VAR
	func_block.IN  := IN;
	func_block();
	TO_UML := func_block.TO_UML;

END_PROGRAM

