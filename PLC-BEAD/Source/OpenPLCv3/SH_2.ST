TYPE
	oscat_arr_0_15              : ARRAY [0..15]   OF REAL;
END_TYPE


FUNCTION EVEN:BOOL

	VAR_INPUT
		IN :	DINT;
	END_VAR

	even := NOT BIT_OF_DWORD(DINT_TO_DWORD(in),0);

END_FUNCTION

FUNCTION BIT_OF_DWORD : BOOL
  VAR_INPUT
    IN : DWORD;
    N : INT;
  END_VAR

  BIT_OF_DWORD := (SHR(in,N) AND 16#00000001) > 0;
END_FUNCTION

FUNCTION UDINT_TO_TIME2:TIME

	VAR_INPUT
		IN :	UDINT;
	END_VAR


	UDINT_TO_TIME2 := DINT_TO_TIME(UDINT_TO_DINT(IN));

END_FUNCTION

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

FUNCTION_BLOCK SH_2_Block

	VAR_INPUT
		IN :	REAL;
		PT :	TIME;
		N :	INT := INT#16;
		DISC :	INT;
	END_VAR


	VAR_OUTPUT
		OUT :	REAL;
		TRIG :	BOOL;
		AVG :	REAL;
		HIGH :	REAL;
		LOW :	REAL;
	END_VAR

	VAR
		M :	INT;
		buf :	oscat_arr_0_15;
		buf2 :	oscat_arr_0_15;
		last :	TIME;
		i :	INT;
		I2 :	INT;
		start :	INT;
		temp :	REAL;
		stop :	INT;
		tx :	TIME;
		d2 :	INT;
		T_PLC_MS :	T_PLC_MS_Block;
	END_VAR


	T_PLC_MS();
	tx:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);
	d2 := WORD_TO_INT(SHR(INT_TO_WORD(disc),1));

	IF tx - last >= PT THEN
		last := tx;
		trig := TRUE;

		M := LIMIT(1,N,16);

		i := M-1;
		WHILE (i>=1) DO
		i2 := i-1;
		buf2[i] := buf2[i2];
		i:=i-1;
		END_WHILE;

		buf2[0] := in;
		out := in;
		buf := buf2;

		(* sort the ARRAY lowest value AT 0 *)
		FOR start := 0 TO M - 2 DO
			FOR i := start+1 TO M - 1 DO
				IF buf[start] > buf[i] THEN
					temp := buf[start];
					buf[start] := buf[i];
					buf[i] := temp;
				END_IF;
			END_FOR;
		END_FOR;

		stop := M - 1 - d2;
		start := d2;
		IF NOT even(INT_TO_DINT(disc)) THEN start := start + 1; END_IF;
		avg := 0.0;
		FOR i := start TO stop DO avg := avg + buf[i]; END_FOR;
		avg := avg / INT_TO_REAL(stop - start +1);
		low := buf[start];
		high := buf[stop];
	ELSE
		Trig := FALSE;
	END_IF;
END_FUNCTION_BLOCK

PROGRAM program0
	
	VAR
		IN :	REAL;
		PT :	TIME;
		N :	INT := INT#16;
		DISC :	INT;
		OUT :	REAL;
		TRIG :	BOOL;
		AVG :	REAL;
		HIGH :	REAL;
		LOW :	REAL;
		func_block : SH_2_Block;
	END_VAR
		func_block.IN  :=IN;
		func_block.PT  :=PT;
		func_block.N  :=N;
		func_block.DISC  :=DISC;
		func_block();
		OUT := func_block.OUT;
		TRIG := func_block.TRIG;
		AVG := func_block.AVG;
		HIGH := func_block.HIGH;
		LOW := func_block.LOW;

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