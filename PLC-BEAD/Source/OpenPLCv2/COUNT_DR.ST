FUNCTION_BLOCK COUNT_DR
	VAR_INPUT
		SET :	BOOL;
		IN :	DWORD;
		UP :	BOOL;
		DN :	BOOL;
		STEPP :	DWORD := DWORD#1;
		MX :	DWORD := DWORD#16#FFFF_FFFF;
		RST :	BOOL;
	END_VAR

	VAR_OUTPUT
		CNT :	DWORD;
	END_VAR

	VAR
		CNT2 :	UDINT;
		STEPP2 :	UDINT;
		MX2 :	UDINT;
		last_up :	BOOL;
		last_dn :	BOOL;
	END_VAR

	STEPP2 := DWORD_TO_UDINT(STEPP);
	MX2   := DWORD_TO_UDINT(MX);
	CNT2  := DWORD_TO_UDINT(CNT);

	IF rst THEN
		CNT2 := UDINT#0;
	ELSIF set THEN
		CNT2 := LIMIT(UDINT#0,DWORD_TO_UDINT(in),mx2);
	ELSIF up AND NOT last_up THEN
		IF STEPP2 > MX2 - CNT2 THEN
			CNT2 := CNT2 - MX2 + STEPP2 - UDINT#1;
		ELSE
			CNT2 := CNT2 + STEPP2;
		END_IF;
	ELSIF dn AND NOT last_dn THEN
		IF STEPP2 > CNT2 THEN
			CNT2 := CNT2 - STEPP2 + MX2 + UDINT#1;
		ELSE
			CNT2 := CNT2 - STEPP2;
		END_IF;
	END_IF;
	last_up := up;
	last_dn := dn;
	CNT := UDINT_TO_DWORD(CNT2);
END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	SET :	BOOL;
	IN :	DWORD;
	UP :	BOOL;
	DN :	BOOL;
	STEPP :	DWORD;
	MX :	DWORD;
	RST :	BOOL;

	CNT :	DWORD;
	func_block : COUNT_DR;
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