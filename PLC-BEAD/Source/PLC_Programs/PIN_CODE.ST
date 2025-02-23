FUNCTION_BLOCK PIN_CODE_Block

	VAR_INPUT
		CB :	BYTE;
		E :	BOOL;
		PIN :	STRING;
	END_VAR


	VAR_OUTPUT
		_TP :	BOOL;
	END_VAR


	VAR
		POS :	INT := 1;
	END_VAR


	_tp := FALSE;
	IF e THEN

		IF CB = INT_TO_BYTE(GET_CHAR(PIN,POS)) THEN
			pos := pos + 1;
			IF pos > LEN(PIN) THEN
				_TP := TRUE;
				pos := 1;
			END_IF;
		ELSE
			pos := 1;
		END_IF;
	END_IF;

END_FUNCTION_BLOCK
