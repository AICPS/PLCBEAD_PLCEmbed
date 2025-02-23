FUNCTION_BLOCK T_PLC_MS_block
	VAR_OUTPUT
		T_PLC_MS :	UDINT;
	END_VAR

	VAR_EXTERNAL
		PLC_TICKS_PER_SEC :	INT;
		PLC_SYS_TICK_CNT :	DINT;
	END_VAR

	VAR
		debug :	BOOL;(*Debug-Mode ON / OFF*)
		N :	INT;(*Debug-Faktor*)
		Offset :	UDINT;(*Debug-Offset*)
		temp :	DWORD := DWORD#1;(*Debug-Offset*)
		mode :	BOOL;(*modus*)
		faktor :	UDINT;(*Systemtakt-Faktor*)
		init :	BOOL;
		v_plc_ticks_per_sec :	UDINT;
		base :	UDINT := UDINT#1000;
	END_VAR


	IF init = FALSE THEN
		v_plc_ticks_per_sec := INT_TO_UDINT(PLC_TICKS_PER_SEC);
		IF v_plc_ticks_per_sec = UDINT#1024 THEN
			faktor := UDINT#1;
			mode := FALSE;
		ELSIF v_plc_ticks_per_sec > UDINT#0 THEN
			IF v_plc_ticks_per_sec <= base THEN
				faktor := base / v_plc_ticks_per_sec;
				mode := FALSE;
			ELSE
				faktor := v_plc_ticks_per_sec / base;
				mode := TRUE;
			END_IF;
		ELSE
			faktor := UDINT#1;
		END_IF;
		init := TRUE;
	END_IF;

	IF mode THEN
		T_PLC_MS := DINT_TO_UDINT(PLC_SYS_TICK_CNT) / faktor;
	ELSE
		T_PLC_MS := DINT_TO_UDINT(PLC_SYS_TICK_CNT) * faktor;
	END_IF;

	IF debug THEN
		T_PLC_MS := (DWORD_TO_UDINT(SHL(UDINT_TO_DWORD(T_PLC_MS),N) OR SHL(temp,N)) - UDINT#1) + Offset;
	END_IF;
END_FUNCTION_BLOCK

FUNCTION_BLOCK INTEGRATE

	VAR_INPUT
		E :	BOOL := TRUE;
		X :	REAL;
		K :	REAL := 1.0;
	END_VAR

	VAR_IN_OUT
		Y :	REAL;
	END_VAR

	VAR
		X_last :	REAL;
		init :	BOOL;
		T_PLC_MS :	T_PLC_MS_block;
		last :	UDINT;
		tx :	UDINT;
	END_VAR


	T_PLC_MS();
	tx:= T_PLC_MS.T_PLC_MS;

	IF NOT init THEN
		init := TRUE;
		X_last := X;
	ELSIF E THEN
		Y := (X + X_LAST) * 0.5E-3 * UDINT_TO_REAL(tx-last) * K + Y;
		X_last := X;
	END_IF;
	last := tx;

END_FUNCTION_BLOCK

FUNCTION _INT_TO_UDINT:UDINT
	VAR_INPUT
		IN :	INT;
	END_VAR

	_INT_TO_UDINT := DINT_TO_UDINT(INT_TO_DINT(IN));
END_FUNCTION

FUNCTION FLOOR : INT
	VAR_INPUT
		x : REAL;
	END_VAR

	FLOOR := REAL_TO_INT(X);
	IF INT_TO_REAL(FLOOR) > X THEN
		floor := floor - 1;
	END_IF;
END_FUNCTION

FUNCTION_BLOCK FLOW_METER
	VAR_INPUT
		VX :	REAL;
		E :	BOOL;
		RST :	BOOL;
		PULSE_MODE :	BOOL;
		UPDATE_TIME :	TIME := T#1s;
	END_VAR

	VAR_OUTPUT
		F :	REAL;
	END_VAR

	VAR_IN_OUT
		X :	REAL;
		Y :	UDINT;
	END_VAR

	VAR
		T_PLC_MS :	T_PLC_MS_block;
		tx :	TIME;
		tl :	TIME;
		int1 :	INTEGRATE;
		init :	BOOL;
		e_last :	BOOL;
		tmp :	INT;
		x_last :	REAL;
		y_last :	UDINT;
	END_VAR

	IF NOT init THEN	(* init on power up *)
		init := TRUE;
		tl := tx;
		x_last := X;
		y_last := Y;
		int1.K := 2.7777777777777777E-4;
	END_IF;

	int1(E := NOT (RST OR PULSE_MODE) AND E, X := VX, Y := X);	(* gated operation *)
	X := int1.Y;

	IF RST THEN		(* reset *)
		X := 0.0;
		Y := UDINT#0;
		tl := tx;
		x_last := 0.0;
		y_last := UDINT#0;
	ELSIF E AND PULSE_MODE THEN	(* check for pulse mode *)
		IF NOT e_last THEN X := X + VX; END_IF;
	END_IF;
	e_last := E;

	(* reduce X to be less than 1 and increase Y respectively *)
	IF X > 1.0 THEN
		tmp := FLOOR(X);
		Y := Y + _INT_TO_UDINT(tmp);
		X := X - INT_TO_REAL(tmp);
	END_IF;

	(* calculate the current flow *)
	T_PLC_MS();
	tx := UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);
	IF tx - tl >= UPDATE_TIME AND UPDATE_TIME > t#0s THEN
		F := (UDINT_TO_REAL(Y - y_last) + X - x_last) / TIME_TO_REAL(tx - tl) * 3.6E6;
		y_last := Y;
		x_last := X;
		tl := tx;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	VX :	REAL;
	E :	BOOL;
	RST :	BOOL;
	PULSE_MODE :	BOOL;
	UPDATE_TIME :	TIME := T#1s;

	F :	REAL;

	X :	REAL;
	Y :	UDINT;

	func_block : FLOW_METER;
  END_VAR
	func_block.VX:=VX;
	func_block.E:=E;
	func_block.RST:=RST;
	func_block.PULSE_MODE:=PULSE_MODE;
	func_block.UPDATE_TIME :=UPDATE_TIME ;
	func_block.X:=X;
	func_block.Y:=Y;
	func_block();
	F:= func_block.F;
	X:= func_block.X;
	Y:= func_block.Y;
END_PROGRAM

CONFIGURATION Config0
	VAR_GLOBAL
		PLC_TICKS_PER_SEC :	INT;
		PLC_SYS_TICK_CNT :	DINT;
	END_VAR
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION