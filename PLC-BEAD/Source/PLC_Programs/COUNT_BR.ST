FUNCTION _BYTE_TO_INT:INT
	VAR_INPUT
		IN :	BYTE;
	END_VAR

	_BYTE_TO_INT := USINT_TO_INT(BYTE_TO_USINT(IN));

END_FUNCTION

FUNCTION INC:INT
	VAR_INPUT
		X :	INT;
		D :	INT;
		M :	INT;
	END_VAR

	inc := (X + D + M + 1) MOD (M + 1);
END_FUNCTION

FUNCTION_BLOCK COUNT_BR
	VAR_INPUT
		SET :	BOOL;
		IN :	BYTE;
		UP :	BOOL;
		DN :	BOOL;
		STEPP :	BYTE := BYTE#1;
		MX :	BYTE := BYTE#255;
		RST :	BOOL;
	END_VAR
	VAR_OUTPUT
		CNT :	BYTE;
	END_VAR

	VAR
		last_up :	BOOL;
		last_dn :	BOOL;
	END_VAR

	IF rst THEN
		cnt := BYTE#0;
	ELSIF set THEN
		cnt := INT_TO_BYTE(LIMIT(0,_BYTE_TO_INT(in),_BYTE_TO_INT(mx)));
	ELSIF up AND NOT last_up THEN
		cnt := INT_TO_BYTE(inc(_BYTE_TO_INT(cnt),_BYTE_TO_INT(stepP),_BYTE_TO_INT(mx)));
	ELSIF dn AND NOT last_dn THEN
		cnt := INT_TO_BYTE(inc(_BYTE_TO_INT(cnt),_BYTE_TO_INT(stepP) * -1,_BYTE_TO_INT(mx)));
	END_IF;
	last_up := up;
	last_dn := dn;
END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	SET :	BOOL;
	IN :	BYTE;
	UP :	BOOL;
	DN :	BOOL;
	STEPP:	BYTE;
	MX :	BYTE;
	RST :	BOOL;

	CNT :	BYTE;
	func_block : COUNT_BR;
  END_VAR
	func_block.SET  :=SET  ;
	func_block.IN   :=IN   ;
	func_block.UP   :=UP   ;
	func_block.DN   :=DN   ;
	func_block.STEPP :=STEPP ;
	func_block.MX   :=MX   ;
	func_block.RST  :=RST  ;

	func_block();
	CNT := func_block.CNT;
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION
