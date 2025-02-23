FUNCTION_BLOCK T_PLC_US_Block
	VAR_OUTPUT
		T_PLC_US :	UDINT;
	END_VAR

	VAR_EXTERNAL
		PLC_TICKS_PER_SEC :	INT;
		PLC_SYS_TICK_CNT :	DINT;
	END_VAR

	VAR
		debug :	BOOL;
		N :	INT;
		Offset :	UDINT;
		temp :	DWORD := DWORD#1;
		mode :	BOOL;
		faktor :	UDINT;
		init :	BOOL;
		v_plc_ticks_per_sec :	UDINT;
		base :	UDINT := UDINT#1000000;
	END_VAR

	IF init = FALSE THEN
		v_plc_ticks_per_sec := INT_TO_UDINT(PLC_TICKS_PER_SEC);
		IF v_plc_ticks_per_sec = UDINT#1024 THEN
			faktor := UDINT#1000;
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
		tx :	UDINT;
		tc :	REAL;
		t_last :	UDINT;
		in_last :	REAL;
		i :	REAL;
		p :	REAL;
		T_PLC_US :	T_PLC_US_Block;
	END_VAR

	IF NOT init OR RST THEN
		init := TRUE;
		in_last := in;
		T_PLC_US();
		t_last := T_PLC_US.T_PLC_US;
		i := 0.0;
		tc := 0.0;
	ELSE
		(* read last cycle time in Microseconds *)
		T_PLC_US();
		tx := T_PLC_US.T_PLC_US;
		tc := UDINT_TO_REAL(tx - t_last);
		t_last := tx;

		(* calculate proportional part *)
		p := KP * IN;

		(* run integrator *)
		i := (IN + in_last) * 5.0E-7 * KI * tc + i;
		in_last := IN;

		(* calculate output Y *)
		Y := p + i;

		(* check output for limits *)
		IF Y >= LIM_H THEN
			Y := LIM_H;
			IF ki <> 0.0 THEN
				i := LIM_H - p;
			ELSE
				i := 0.0;
			END_IF;
			LIM := TRUE;
		ELSIF Y <= LIM_L THEN
			Y := LIM_L;
			IF ki <> 0.0 THEN
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

FUNCTION_BLOCK FT_DERIV
	VAR_INPUT
		IN :	REAL;
		K :	REAL := 1.0;
		RUN :	BOOL := TRUE;
	END_VAR

	VAR_OUTPUT
		OUT :	REAL;
	END_VAR

	VAR
		old :	REAL;
		tx :	UDINT;
		last :	UDINT;
		init :	BOOL;
		tc :	REAL;
		T_PLC_US :	T_PLC_US_Block;
	END_VAR

	T_PLC_US();
	tx:= T_PLC_US.T_PLC_US;
	tc := UDINT_TO_REAL(tx - last);

	IF NOT init THEN
		init := TRUE;
		old := in;
	ELSIF run AND tc > 0.0 THEN
		out := (in - old) / tc * 1000000.0 * K;
		old := in;
	ELSE
		out := 0.0;
	END_IF;

	last := tx;

	T_PLC_US();
	tx:= T_PLC_US.T_PLC_US;

	IF NOT init THEN
		init := TRUE;
	ELSIF run AND tx - last > UDINT#0 THEN
		out := (in - old) / UDINT_TO_REAL(tx - last) * 1000000.0 * K;
	ELSE
		out := 0.0;
	END_IF;
	old := in;
	last := tx;
END_FUNCTION_BLOCK

FUNCTION_BLOCK FT_PIDWL
	VAR_INPUT
		IN :	REAL;
		KP :	REAL := 1.0;
		TN :	REAL := 1.0;
		TV :	REAL := 1.0;
		LIM_L :	REAL := -1.0E38;
		LIM_H :	REAL := 1.0E38;
		RST :	BOOL;
	END_VAR

	VAR_OUTPUT
		Y :	REAL;
		LIM :	BOOL;
	END_VAR

	VAR
		piwl :	FT_PIWL;
		diff :	FT_DERIV;
	END_VAR

	IF rst THEN
		piwl(rst := TRUE);
		piwl.RST := FALSE;
	ELSE
		IF TN = 0.0 THEN
			piwl(in := IN * KP, KP := 1.0, KI := 0.0, LIM_L := LIM_L, LIM_H := LIM_H);
		ELSE
			piwl(in := IN * KP, KP := 1.0, KI := 1.0 / TN, LIM_L := LIM_L, LIM_H := LIM_H);
		END_IF;

		diff(IN := IN, K := KP * TV);
		Y := piwl.Y + diff.out;

		IF Y < LIM_L THEN
			LIM := TRUE;
			Y := LIM_L;
		ELSIF Y > LIM_H THEN
			LIM := TRUE;
			Y := LIM_H;
		ELSE
			LIM := FALSE;
		END_IF;
	END_IF;
END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	IN    :	REAL;
	KP    :	REAL;
	TN    :	REAL;
	TV    :	REAL;
	LIM_L :	REAL;
	LIM_H :	REAL;
	RST   :	BOOL;

	Y :	REAL;
	LIM :	BOOL;

	func_block : FT_PIDWL;
  END_VAR
	func_block.IN    :=IN   ;
	func_block.KP    :=KP   ;
	func_block.TN    :=TN   ;
	func_block.TV    :=TV   ;
	func_block.LIM_L :=LIM_L;
	func_block.LIM_H :=LIM_H;
	func_block.RST   :=RST  ;
	func_block();
	Y := func_block.Y;
	LIM := func_block.LIM;
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
