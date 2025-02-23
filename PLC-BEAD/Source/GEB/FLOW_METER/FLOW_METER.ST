FUNCTION_BLOCK T_PLC_MS_block
	VAR_OUTPUT
		T_PLC_MS :	UDINT;
	END_VAR

	VAR
		PLC_TICKS_PER_SEC :	INT;
		PLC_SYS_TICK_CNT :	DINT;
	END_VAR

	VAR
		debug :	BOOL;(*Debug-Mode ON / OFF*)
		N :	INT;(*Debug-Faktor*)
		Offset :	UDINT;(*Debug-Offset*)
		temp :	DWORD := DWORD#1;(*Debug-Offset*)
		MODE :	BOOL;(*modus*)
		faktor :	UDINT;(*Systemtakt-Faktor*)
		init :	BOOL;
		v_plc_ticks_per_sec :	UDINT;
		base :	UDINT := UDINT#1000;
	END_VAR


	IF init = FALSE THEN
		v_plc_ticks_per_sec := INT_TO_UDINT(PLC_TICKS_PER_SEC);
		IF v_plc_ticks_per_sec = UDINT#1024 THEN
			faktor := UDINT#1;
			MODE := FALSE;
		ELSIF v_plc_ticks_per_sec > UDINT#0 THEN
			IF v_plc_ticks_per_sec <= base THEN
				faktor := base / v_plc_ticks_per_sec;
				MODE := FALSE;
			ELSE
				faktor := v_plc_ticks_per_sec / base;
				MODE := TRUE;
			END_IF;
		ELSE
			faktor := UDINT#1;
		END_IF;
		init := TRUE;
	END_IF;

	IF MODE THEN
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
		X_LAST :	REAL;
		init :	BOOL;
		T_PLC_MS :	T_PLC_MS_block;
		last :	UDINT;
		TX :	UDINT;
	END_VAR


	T_PLC_MS();
	TX:= T_PLC_MS.T_PLC_MS;

	IF NOT init THEN
		init := TRUE;
		X_LAST := X;
	ELSIF E THEN
		Y := (X + X_LAST) * 0.5E-3 * UDINT_TO_REAL(TX-last) * K + Y;
		X_LAST := X;
	END_IF;
	last := TX;

END_FUNCTION_BLOCK

FUNCTION _INT_TO_UDINT:UDINT
	VAR_INPUT
		IN :	INT;
	END_VAR

	_INT_TO_UDINT := DINT_TO_UDINT(INT_TO_DINT(IN));
END_FUNCTION

FUNCTION FLOOR : INT
	VAR_INPUT
		X : REAL;
	END_VAR

	FLOOR := REAL_TO_INT(X);
	IF INT_TO_REAL(FLOOR) > X THEN
		FLOOR := FLOOR - 1;
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
		TX :	TIME;
		TL :	TIME;
		int1 :	INTEGRATE;
		init :	BOOL;
		e_last :	BOOL;
		tmp :	INT;
		X_LAST :	REAL;
		y_last :	UDINT;
	END_VAR

	IF NOT init THEN	(* init on power up *)
		init := TRUE;
		TL := TX;
		X_LAST := X;
		y_last := Y;
		int1.K := 2.7777777777777777E-4;
	END_IF;

	int1(E := NOT (RST OR PULSE_MODE) AND E, X := VX, Y := X);	(* gated operation *)
	X := int1.Y;

	IF RST THEN		(* reset *)
		X := 0.0;
		Y := UDINT#0;
		TL := TX;
		X_LAST := 0.0;
		y_last := UDINT#0;
	ELSIF E AND PULSE_MODE THEN	(* check for pulse MODE *)
		IF NOT e_last THEN X := X + VX; END_IF;
	END_IF;
	e_last := E;

	(* reduce X to be less than 1 and INCrease Y respectively *)
	IF X > 1.0 THEN
		tmp := FLOOR(X);
		Y := Y + _INT_TO_UDINT(tmp);
		X := X - INT_TO_REAL(tmp);
	END_IF;

	(* calculate the current flow *)
	T_PLC_MS();
	TX := UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);
	IF SUB_TIME(TX, TL) >= UPDATE_TIME AND UPDATE_TIME > t#0s THEN
		F := (UDINT_TO_REAL(Y - y_last) + X - X_LAST) / TIME_TO_REAL(SUB_TIME(TX, TL)) * 3.6E6;
		y_last := Y;
		X_LAST := X;
		TL := TX;
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

	func_block(X:=X, Y:=Y);
	F:= func_block.F;
	X:= func_block.X;
	Y:= func_block.Y;
END_PROGRAM

