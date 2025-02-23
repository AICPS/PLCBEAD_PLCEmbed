FUNCTION_BLOCK BOILER_Block

	VAR_INPUT
		T_UPPER :	REAL;
		T_LOWER :	REAL;
		PRESSURE :	BOOL := TRUE;
		ENABLE :	BOOL := TRUE;
		REQ_1 :	BOOL;
		REQ_2 :	BOOL;
		BOOST :	BOOL;
		T_UPPER_MIN :	REAL := REAL#50.0;
		T_UPPER_MAX :	REAL := REAL#60.0;
		T_LOWER_ENABLE :	BOOL;
		T_LOWER_MAX :	REAL := REAL#60.0;
		T_REQUEST_1 :	REAL := REAL#70.0;
		T_REQUEST_2 :	REAL := REAL#50.0;
		T_REQUEST_HYS :	REAL := REAL#5.0;
		T_PROTECT_HIGH :	REAL := REAL#80.0;
		T_PROTECT_LOW :	REAL := REAL#10.0;
	END_VAR


	VAR_OUTPUT
		HEAT :	BOOL;
		ERROR :	BOOL;
		STATUS :	BYTE;
	END_VAR


	VAR
		edge :	BOOL;
		boost_MODE :	BOOL;
		flag_0 :	BOOL;
		flag_1 :	BOOL;
		flag_2 :	BOOL;
	END_VAR

	IF t_upper > t_protect_HIGH THEN
		STATUS := BYTE#1;
		heat := FALSE;
		ERROR := TRUE;
	ELSIF t_upper < t_protect_LOW THEN
		STATUS := BYTE#2;
		heat := TRUE;
		ERROR := TRUE;
	ELSIF t_LOWer > T_protect_HIGH AND t_LOWer_enable THEN
		STATUS := BYTE#3;
		heat := FALSE;
		ERROR := TRUE;
	ELSIF t_LOWer < t_protect_LOW AND t_LOWer_enable THEN
		STATUS := BYTE#4;
		heat := TRUE;
		ERROR := TRUE;
	ELSIF NOT pressure THEN
		STATUS := BYTE#5;
		heat := FALSE;
		ERROR := TRUE;
	ELSIF req_1 OR req_2 OR enable OR boost THEN
		ERROR := FALSE;

		IF boost AND NOT edge AND t_upper < t_upper_max THEN
			STATUS := BYTE#101;
			heat := TRUE;
			boost_MODE := TRUE;
		ELSIF enable AND t_upper < T_upper_mIN THEN
			STATUS := BYTE#102;
			heat := TRUE;
		ELSIF req_1 AND t_upper < T_request_1 THEN
			STATUS := BYTE#103;
			heat := TRUE;
		ELSIF req_2 AND t_upper < t_request_2 THEN
			STATUS := BYTE#104;
			heat := TRUE;
		END_IF;

		IF heat THEN
			IF (enable OR boost_MODE) THEN
				flag_0 := TRUE;
				IF T_LOWer_enable AND T_LOWer > T_LOWer_max THEN
					flag_0 := FALSE;
					boost_MODE := FALSE;
				ELSIF NOT T_LOWer_enable AND T_upper > T_upper_max THEN
					flag_0 := FALSE;
					boost_MODE := FALSE;
				END_IF;
			ELSE
				flag_0 := FALSE;
			END_IF;
			flag_1 := (req_1 AND T_upper > T_request_1 + T_request_HYS) AND req_1;
			flag_2 := (req_2 AND T_upper > T_request_2 + T_request_HYS) AND req_2;

			heat := flag_0 OR flag_1 OR flag_2;
			IF heat = FALSE THEN STATUS := BYTE#100; END_IF;
		END_IF;
	ELSE
		STATUS := BYTE#100;
		heat := FALSE;
		ERROR := FALSE;
	END_IF;
	edge := boost;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		T_UPPER :	REAL;
		T_LOWER :	REAL;
		PRESSURE :	BOOL := TRUE;
		ENABLE :	BOOL := TRUE;
		REQ_1 :	BOOL;
		REQ_2 :	BOOL;
		BOOST :	BOOL;
		T_UPPER_MIN :	REAL := REAL#50.0;
		T_UPPER_MAX :	REAL := REAL#60.0;
		T_LOWER_ENABLE :	BOOL;
		T_LOWER_MAX :	REAL := REAL#60.0;
		T_REQUEST_1 :	REAL := REAL#70.0;
		T_REQUEST_2 :	REAL := REAL#50.0;
		T_REQUEST_HYS :	REAL := REAL#5.0;
		T_PROTECT_HIGH :	REAL := REAL#80.0;
		T_PROTECT_LOW :	REAL := REAL#10.0;
		HEAT :	BOOL;
		ERROR :	BOOL;
		STATUS :	BYTE;

		func_block : BOILER_Block;
	END_VAR
	func_block.T_UPPER := T_UPPER;
	func_block.T_LOWER := T_LOWER;
	func_block.PRESSURE := PRESSURE ;
	func_block.ENABLE    := ENABLE    ;
	func_block.REQ_1 := REQ_1;
	func_block.REQ_2 := REQ_2;
	func_block.BOOST := BOOST ;
	func_block.T_UPPER_MIN := T_UPPER_MIN ;
	func_block.T_UPPER_MAX    := T_UPPER_MAX    ;
	func_block.T_LOWER_ENABLE := T_LOWER_ENABLE;
	func_block.T_LOWER_MAX := T_LOWER_MAX;
	func_block.T_REQUEST_1 := T_REQUEST_1 ;
	func_block.T_REQUEST_2 := T_REQUEST_2 ;
	func_block.T_REQUEST_HYS    := T_REQUEST_HYS    ;
	func_block.T_PROTECT_HIGH := T_PROTECT_HIGH;
	func_block.T_PROTECT_LOW := T_PROTECT_LOW;

	func_block();
	HEAT  := func_block.HEAT;
	ERROR  := func_block.ERROR;
	STATUS  := func_block.STATUS;
END_PROGRAM

