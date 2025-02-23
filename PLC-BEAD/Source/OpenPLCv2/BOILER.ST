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
		boost_mode :	BOOL;
		flag_0 :	BOOL;
		flag_1 :	BOOL;
		flag_2 :	BOOL;
	END_VAR

	IF t_upper > t_protect_high THEN
		status := BYTE#1;
		heat := FALSE;
		error := TRUE;
	ELSIF t_upper < t_protect_low THEN
		status := BYTE#2;
		heat := TRUE;
		error := TRUE;
	ELSIF t_lower > T_protect_high AND t_lower_enable THEN
		status := BYTE#3;
		heat := FALSE;
		error := TRUE;
	ELSIF t_lower < t_protect_low AND t_lower_enable THEN
		status := BYTE#4;
		heat := TRUE;
		error := TRUE;
	ELSIF NOT pressure THEN
		status := BYTE#5;
		heat := FALSE;
		error := TRUE;
	ELSIF req_1 OR req_2 OR enable OR boost THEN
		error := FALSE;

		IF boost AND NOT edge AND t_upper < t_upper_max THEN
			status := BYTE#101;
			heat := TRUE;
			boost_mode := TRUE;
		ELSIF enable AND t_upper < T_upper_min THEN
			status := BYTE#102;
			heat := TRUE;
		ELSIF req_1 AND t_upper < T_request_1 THEN
			status := BYTE#103;
			heat := TRUE;
		ELSIF req_2 AND t_upper < t_request_2 THEN
			status := BYTE#104;
			heat := TRUE;
		END_IF;

		IF heat THEN
			IF (enable OR boost_mode) THEN
				flag_0 := TRUE;
				IF T_lower_enable AND T_lower > T_lower_max THEN
					flag_0 := FALSE;
					boost_mode := FALSE;
				ELSIF NOT T_lower_enable AND T_upper > T_upper_max THEN
					flag_0 := FALSE;
					boost_mode := FALSE;
				END_IF;
			ELSE
				flag_0 := FALSE;
			END_IF;
			flag_1 := (req_1 AND T_upper > T_request_1 + T_request_hys) AND req_1;
			flag_2 := (req_2 AND T_upper > T_request_2 + T_request_hys) AND req_2;

			heat := flag_0 OR flag_1 OR flag_2;
			IF heat = FALSE THEN status := BYTE#100; END_IF;
		END_IF;
	ELSE
		status := BYTE#100;
		heat := FALSE;
		error := FALSE;
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

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION