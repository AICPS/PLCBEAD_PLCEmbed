FUNCTION _REAL_TO_DWORD: DWORD
	VAR_INPUT
		X :	REAL;
	END_VAR

	IF REAL_TO_DWORD(0.5) = DWORD#1 THEN
		_REAL_TO_DWORD := REAL_TO_DWORD(x);
	ELSIF X > 0.0 THEN
		_REAL_TO_DWORD := REAL_TO_DWORD(x+0.5); 
	ELSIF X < 0.0 THEN 
		_REAL_TO_DWORD := REAL_TO_DWORD(x-0.5); 
	ELSE 
		_REAL_TO_DWORD := DWORD#0;
	END_IF;
END_FUNCTION

FUNCTION _DWORD_TO_REAL:REAL
	VAR_INPUT
		IN :	DWORD;
	END_VAR

	_DWORD_TO_REAL := UDINT_TO_REAL(DWORD_TO_UDINT(IN));

END_FUNCTION

FUNCTION _INT_TO_UDINT:UDINT
	VAR_INPUT
		IN :	INT;
	END_VAR

	_INT_TO_UDINT := DINT_TO_UDINT(INT_TO_DINT(IN));
END_FUNCTION

FUNCTION D_TRUNC : DINT
	VAR_INPUT
		x : REAL;
	END_VAR

	D_TRUNC := REAL_TO_DINT(X);
	IF X > 0.0 THEN
		IF DINT_TO_REAL(D_TRUNC) > X THEN D_TRUNC := D_TRUNC - DINT#1; END_IF;
	ELSE
		IF DINT_TO_REAL(D_TRUNC) < X THEN D_TRUNC := D_TRUNC + DINT#1; END_IF;
	END_IF;
END_FUNCTION

FUNCTION FRACT:REAL
	VAR_INPUT
		X :	REAL;
	END_VAR

	IF ABS(x) < 2.0E9 THEN
		FRACT := x - DINT_TO_REAL(D_TRUNC(x));
	ELSE
		FRACT := 0.0;
	END_IF;
END_FUNCTION

FUNCTION BIT_LOAD_DW:DWORD

	VAR_INPUT
		IN :	DWORD;
		VAL :	BOOL;
		POS :	INT;
	END_VAR

	IF val THEN
		BIT_LOAD_DW := in OR SHL(DWORD#1,pos);
	ELSE
		BIT_LOAD_DW := in AND (NOT SHL(DWORD#1,pos));
	END_IF;
END_FUNCTION

FUNCTION BIT_OF_DWORD : BOOL
	VAR_INPUT
		IN : DWORD;
		N : INT;
	END_VAR

	BIT_OF_DWORD := (SHR(in,N) AND 16#00000001) > 0;
END_FUNCTION

FUNCTION BIT_COUNT:INT
	VAR_INPUT
		IN :	DWORD;
	END_VAR


	VAR
		in_temp :	DWORD;
	END_VAR

	in_temp := IN;
	WHILE in_temp > DWORD#0 DO
		IF (in_temp AND DWORD#16#00000001) > DWORD#0 THEN Bit_Count := Bit_Count +1; END_IF;
		in_temp := SHR(in_temp,1);
	END_WHILE;
END_FUNCTION

FUNCTION_BLOCK T_PLC_MS_Block
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

FUNCTION_BLOCK RDM_Block
	VAR_INPUT
		LAST :	REAL;
	END_VAR
	VAR_OUTPUT
		RDM :	REAL;
	END_VAR
	VAR
		T_PLC_MS :	T_PLC_MS_Block;
		tn :	DWORD;
		tc :	INT;
	END_VAR
	T_PLC_MS();
	tn := UDINT_TO_DWORD(T_PLC_MS.T_PLC_MS);
	tc := Bit_Count(tn);

	tn:=BIT_LOAD_DW(tn,BIT_OF_DWORD(tn,2),31); (* tn.31 := tn.2; *)
	tn:=BIT_LOAD_DW(tn,BIT_OF_DWORD(tn,5),30); (* tn.30 := tn.5; *)
	tn:=BIT_LOAD_DW(tn,BIT_OF_DWORD(tn,4),29); (* tn.29 := tn.4; *)
	tn:=BIT_LOAD_DW(tn,BIT_OF_DWORD(tn,1),28); (* tn.28 := tn.1; *)
	tn:=BIT_LOAD_DW(tn,BIT_OF_DWORD(tn,0),27); (* tn.27 := tn.0; *)
	tn:=BIT_LOAD_DW(tn,BIT_OF_DWORD(tn,7),26); (* tn.26 := tn.7; *)
	tn:=BIT_LOAD_DW(tn,BIT_OF_DWORD(tn,6),25); (* tn.25 := tn.6; *)
	tn:=BIT_LOAD_DW(tn,BIT_OF_DWORD(tn,3),24); (* tn.24 := tn.3; *)

	tn := ROL(tn,Bit_Count(tn)) OR DWORD#16#80000001;
	tn := UDINT_TO_DWORD(DWORD_TO_UDINT(tn) MOD UDINT#71474513 + _INT_TO_UDINT(tc) + UDINT#77);
	RDM := fract(_DWORD_TO_REAL(tn) / 10000000.0 * (2.71828182845904523536028747135266249 - LIMIT_REAL(0.0,last,1.0)));
END_FUNCTION_BLOCK

FUNCTION_BLOCK RDM2_Block
	VAR_INPUT
		LAST :	INT;
		LOW :	INT;
		HIGH :	INT;
	END_VAR

	VAR_OUTPUT
		RDM2 :	INT;
	END_VAR


	VAR
		rdm :	RDM_Block;
	END_VAR

	rdm(last:=fract(INT_TO_REAL(last) * 3.14159265358979323846264338327950288));
	RDM2 := TRUNC(rdm.RDM * INT_TO_REAL(high - low + 1)) + low;

END_FUNCTION_BLOCK

PROGRAM program0

	VAR
		LAST :	INT;
		LOW :	INT;
		HIGH :	INT;
		
        RDM2 :	INT;
		func_block : RDM2_Block;
	END_VAR
		func_block.LAST := LAST;
		func_block.LOW := LOW;
		func_block.HIGH := HIGH;
		func_block();
		RDM2 := func_block.RDM2;

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