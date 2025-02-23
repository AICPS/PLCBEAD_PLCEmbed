FUNCTION_BLOCK AIN1

	VAR_INPUT
		IN :	DWORD;
		SIGN_BIT :	INT := 255;
		ERROR_BIT :	INT := 255;
		ERROR_CODE_EN :	BOOL := FALSE;
		ERROR_CODE :	DWORD;
		OVERFLOW_BIT :	INT := 255;
		OVERFLOW_CODE_EN :	BOOL;
		OVERFLOW_CODE :	DWORD;
		BIT_0 :	INT;
		BIT_N :	INT := 31;
		OUT_MIN :	REAL;
		OUT_MAX :	REAL := 10.0;
		CODE_MIN :	DWORD;
		CODE_MAX :	DWORD := DWORD#16#FFFFFFFF;
		ERROR_OUTPUT :	REAL;
		OVERFLOW_OUTPUT :	REAL := 10.0;
	END_VAR

	VAR_OUTPUT
		OUT :	REAL;
		SIGN :	BOOL;
		ERROR :	BOOL;
		OVERFLOW :	BOOL;
	END_VAR

	VAR
		tB :	DWORD;
	END_VAR

	error := ((SHR(in,error_bit) AND DWORD#16#0000_0001) = DWORD#1) OR (error_code_en AND error_code = in);
	IF error THEN
		out := error_output;
		RETURN;
	END_IF;

	tb := SHR(SHL(in, 31 - bit_N), 31 - bit_N + Bit_0);

	overflow := ((SHR(in,overflow_bit) AND DWORD#16#0000_0001) = DWORD#1) OR (overflow_code_en AND overflow_code = in) OR (tb < code_min OR tb > code_max);
	IF overflow THEN
		out := overflow_output;
		RETURN;
	END_IF;


	sign := (SHR(in,sign_bit) AND DWORD#16#0000_0001) = DWORD#1;

	out := (UDINT_TO_REAL(DWORD_TO_UDINT(tb) - DWORD_TO_UDINT(code_min)) * (out_max - out_min) / UDINT_TO_REAL(DWORD_TO_UDINT(code_max) - DWORD_TO_UDINT(code_min)) + out_min);
	IF sign THEN out := out * -1.0; END_IF;


	(* extract error bit *)
	error := ((SHR(in,error_bit) AND DWORD#16#0000_0001) = DWORD#1) OR (error_code_en AND error_code = in);
	IF error THEN
		out := error_output;
		RETURN;
	END_IF;

	(* strip off the data input *)
	tb := SHR(SHL(in, 31 - bit_N), 31 - bit_N + Bit_0);

	(* extract overflow bit *)
	overflow := ((SHR(in,overflow_bit) AND DWORD#16#0000_0001) = DWORD#1) OR (overflow_code_en AND overflow_code = in) OR (tb < code_min OR tb > code_max);
	IF overflow THEN
		out := overflow_output;
		RETURN;
	END_IF;

	(* extract sign bit *)
	sign := (SHR(in,sign_bit) AND DWORD#16#0000_0001) = DWORD#1;

	(* convert in to out *)
	out := (UDINT_TO_REAL(DWORD_TO_UDINT(tb) - DWORD_TO_UDINT(code_min)) * (out_max - out_min) / UDINT_TO_REAL(DWORD_TO_UDINT(code_max) - DWORD_TO_UDINT(code_min)) + out_min);
	IF sign THEN out := out * - 1.0; END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	IN               :	DWORD;
	SIGN_BIT         :	INT ;
	ERROR_BIT        :	INT ;
	ERROR_CODE_EN    :	BOOL ;
	ERROR_CODE       :	DWORD;
	OVERFLOW_BIT     :	INT ;
	OVERFLOW_CODE_EN :	BOOL;
	OVERFLOW_CODE    :	DWORD;
	BIT_0            :	INT;
	BIT_N            :	INT; 
	OUT_MIN          :	REAL;
	OUT_MAX          :	REAL ;
	CODE_MIN         :	DWORD;
	CODE_MAX         :	DWORD ;
	ERROR_OUTPUT     :	REAL;
	OVERFLOW_OUTPUT  :	REAL ;

	OUT      :	REAL;
	SIGN     :	BOOL;
	ERROR    :	BOOL;
	OVERFLOW :	BOOL;

	func_block : AIN1;
  END_VAR
	func_block.IN               :=IN              ;
	func_block.SIGN_BIT         :=SIGN_BIT        ;
	func_block.ERROR_BIT        :=ERROR_BIT       ;
	func_block.ERROR_CODE_EN    :=ERROR_CODE_EN   ;
	func_block.ERROR_CODE       :=ERROR_CODE      ;
	func_block.OVERFLOW_BIT     :=OVERFLOW_BIT    ;
	func_block.OVERFLOW_CODE_EN :=OVERFLOW_CODE_EN;
	func_block.OVERFLOW_CODE    :=OVERFLOW_CODE   ;
	func_block.BIT_0            :=BIT_0           ;
	func_block.BIT_N            :=BIT_N           ;
	func_block.OUT_MIN          :=OUT_MIN         ;
	func_block.OUT_MAX          :=OUT_MAX         ;
	func_block.CODE_MIN         :=CODE_MIN        ;
	func_block.CODE_MAX         :=CODE_MAX        ;
	func_block.ERROR_OUTPUT     :=ERROR_OUTPUT    ;
	func_block.OVERFLOW_OUTPUT  :=OVERFLOW_OUTPUT ;
	
	func_block();
	OUT     := func_block.OUT     ;
	SIGN    := func_block.SIGN    ;
	ERROR   := func_block.ERROR   ;
	OVERFLOW:= func_block.OVERFLOW;
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION