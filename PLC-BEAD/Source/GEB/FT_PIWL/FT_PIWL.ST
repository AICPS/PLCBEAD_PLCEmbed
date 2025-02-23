FUNCTION_BLOCK T_PLC_US_Block
	VAR_OUTPUT
		T_PLC_US :	UDINT;
	END_VAR

	VAR
		PLC_TICKS_PER_SEC :	INT;
		PLC_SYS_TICK_CNT :	DINT;
	END_VAR

	VAR
		debug :	BOOL;
		N :	INT;
		Offset :	UDINT;
		temp :	DWORD := DWORD#1;
		MODE :	BOOL;
		faktor :	UDINT;
		init :	BOOL;
		v_plc_ticks_per_sec :	UDINT;
		base :	UDINT := UDINT#1000000;
	END_VAR

	IF init = FALSE THEN
		v_plc_ticks_per_sec := INT_TO_UDINT(PLC_TICKS_PER_SEC);
		IF v_plc_ticks_per_sec = UDINT#1024 THEN
			faktor := UDINT#1000;
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
		T_PLC_US := DINT_TO_UDINT(PLC_SYS_TICK_CNT) / faktor;
	ELSE
		T_PLC_US := DINT_TO_UDINT(PLC_SYS_TICK_CNT) * faktor;
	END_IF;

	IF debug THEN
		T_PLC_US := (DWORD_TO_UDINT(SHL(UDINT_TO_DWORD(T_PLC_US),N) OR SHL(temp,N)) - UDINT#1) + Offset;
	END_IF;
END_FUNCTION_BLOCK

FUNCTION_BLOCK FT_PIWL

	VAR_INPUT
		IN :	REAL;
		KP :	REAL := 1.0;
		KI :	REAL := 1.0;
		LIM_L :	REAL := -1.0E38;
		LIM_H :	REAL := 1.0E38;
		RST :	BOOL;
	END_VAR

	VAR_OUTPUT
		Y :	REAL;
		LIM :	BOOL;
	END_VAR

	VAR
		init :	BOOL;
		TX :	UDINT;
		tc :	REAL;
		t_last :	UDINT;
		in_last :	REAL;
		i :	REAL;
		p :	REAL;
		T_PLC_US :	T_PLC_US_Block;
	END_VAR

	IF NOT init OR RST THEN
		init := TRUE;
		in_last := IN;
		T_PLC_US();
		t_last := T_PLC_US.T_PLC_US;
		i := 0.0;
		tc := 0.0;
	ELSE
		(* read last cycle time IN Microseconds *)
		T_PLC_US();
		TX := T_PLC_US.T_PLC_US;
		tc := UDINT_TO_REAL(TX - t_last);
		t_last := TX;

		(* calculate proportional part *)
		p := KP * IN;

		(* run INTEGrator *)
		i := (IN + in_last) * 5.0E-7 * KI * tc + i;
		in_last := IN;

		(* calculate OUTput Y *)
		Y := p + i;

		(* check OUTput for limits *)
		IF Y >= LIM_H THEN
			Y := LIM_H;
			IF KI <> 0.0 THEN
				i := LIM_H - p;
			ELSE
				i := 0.0;
			END_IF;
			LIM := TRUE;
		ELSIF Y <= LIM_L THEN
			Y := LIM_L;
			IF KI <> 0.0 THEN
				i := LIM_L - p;
			ELSE
				i := 0.0;
			END_IF;
			LIM := TRUE;
		ELSE
			LIM := FALSE;
		END_IF;
	END_IF;
END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	IN    :	REAL;
	KP    :	REAL;
	KI    :	REAL;
	LIM_L :	REAL;
	LIM_H :	REAL;
	RST   :	BOOL;

	Y :	REAL;
	LIM :	BOOL;

	func_block : FT_PIWL;
  END_VAR
	func_block.IN    :=IN   ;
	func_block.KP    :=KP   ;
	func_block.KI    :=KI   ;
	func_block.LIM_L :=LIM_L;
	func_block.LIM_H :=LIM_H;
	func_block.RST   :=RST  ;
	func_block();
	Y := func_block.Y;
	LIM := func_block.LIM;
END_PROGRAM


