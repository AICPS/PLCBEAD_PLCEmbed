FUNCTION _INT_TO_UDINT:UDINT
	VAR_INPUT
		IN :	INT;
	END_VAR

	_INT_TO_UDINT := DINT_TO_UDINT(INT_TO_DINT(IN));
END_FUNCTION

FUNCTION SET_DATE:UDINT

	VAR_INPUT
		YEAR :	INT;
		MONTH :	INT;
		DAY :	INT;
	END_VAR

	VAR
		count :	INT;
	END_VAR

	IF month > 2 THEN
		count := (month - 1) * 30;
		IF month > 7 THEN
			count := count + DWORD_TO_INT(SHR(DINT_TO_DWORD(INT_TO_DINT(month) - INT_TO_DINT(3)),1));
		ELSE
			count := count + DWORD_TO_INT(SHR(DINT_TO_DWORD(INT_TO_DINT(month) - INT_TO_DINT(4)),1));
		END_IF;
		IF SHL(INT_TO_WORD(year),14) = WORD#0 THEN
			count := count + 1;
		END_IF;
	ELSE
		count := (month - 1) * 31;
	END_IF;
	SET_DATE := (_INT_TO_UDINT(count + day - 1) + DWORD_TO_UDINT(SHR(UDINT_TO_DWORD(_INT_TO_UDINT(year) * UDINT#1461 - UDINT#2878169), 2))) * UDINT#86400;

END_FUNCTION

FUNCTION SET_DT:UDINT
	VAR_INPUT
		YEAR :	INT;
		MONTH :	INT;
		DAY :	INT;
		HOUR :	INT;
		MINUTE :	INT;
		SECOND :	INT;
	END_VAR

	SET_DT := SET_DATE(YEAR, MONTH, DAY) + _INT_TO_UDINT(SECOND) + _INT_TO_UDINT(MINUTE) * UDINT#60 + _INT_TO_UDINT(HOUR) * UDINT#3600;
END_FUNCTION

FUNCTION DT_TO_DATE2:UDINT

	VAR_INPUT
		IN :	UDINT;
	END_VAR

	DT_TO_DATE2 := (IN / UDINT#86400) * UDINT#86400;

END_FUNCTION

FUNCTION YEAR_OF_DATE:INT
	VAR_INPUT
		IDATE :	UDINT;
	END_VAR

	YEAR_OF_DATE := UDINT_TO_INT((idate+UDINT#43200) / UDINT#31557600 + UDINT#1970);
END_FUNCTION

FUNCTION DST:BOOL
	VAR_INPUT
		UTC :	UDINT;
	END_VAR

	VAR
		yr :	INT;
		yr4 :	UDINT;
		ltc :	UDINT;
		idate :	UDINT;
	END_VAR

	yr := YEAR_OF_DATE(DT_TO_DATE2(UTC));
	ltc := UTC;
	idate := SET_DT(yr, 3, 31, 1, 0, 0);
	yr4 := DWORD_TO_UDINT(SHR(INT_TO_DWORD(5 * yr), 2)) + UDINT#1;
	DST := (idate - ((yr4 + UDINT#3) MOD UDINT#7) * UDINT#86400 <= ltc) AND (idate + (UDINT#214 - (yr4) MOD UDINT#7) * UDINT#86400 > ltc);

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

FUNCTION_BLOCK RTC_MS_Block

	VAR_INPUT
		SET :	BOOL;
		SDT :	UDINT;
		SMS :	INT;
	END_VAR


	VAR_OUTPUT
		XDT :	UDINT;
		XMS :	INT;
	END_VAR


	VAR
		init :	BOOL;
		last :	UDINT;
		tx :	UDINT;
		T_PLC_MS :	T_PLC_MS_Block;
	END_VAR

	T_PLC_MS();
	tx:= T_PLC_MS.T_PLC_MS;

	IF set OR NOT init THEN
		(* clock needs to be set when set is true or after power up *)
		init := TRUE;
		xdt := SDT;
		XMS := SMS;
	ELSE
		XMS := XMS + UDINT_TO_INT(tx - last);
		(* check if one second has expired *)
		IF XMS > 999 THEN
			XDT := XDT + UDINT#1; (* add one second *)
			XMS := XMS - 1000;
		END_IF;
	END_IF;
	last := tx;

END_FUNCTION_BLOCK

FUNCTION_BLOCK RTC_2_Block

	VAR_INPUT
		SET :	BOOL;
		SDT :	UDINT;
		SMS :	INT;
		DEN :	BOOL;
		OFS :	INT;
	END_VAR


	VAR_OUTPUT
		UDT :	UDINT;
		LDT :	UDINT;
		DSO :	BOOL;
		XMS :	INT;
	END_VAR


	VAR
		RT :	RTC_MS_Block;
	END_VAR


	RT(SET := SET, SDT := SDT, SMS := SMS);
	UDT := rt.xdt;
	XMS := rt.XMS;

	dso := DST(udt) AND DEN;

	LDT := UDT + _INT_TO_UDINT(ofs + BOOL_TO_INT(DSO) * 60) * UDINT#60;

END_FUNCTION_BLOCK

PROGRAM program0

	VAR
		SET :	BOOL;
		SDT :	UDINT;
		SMS :	INT;
		DEN :	BOOL;
		OFS :	INT;
		UDT :	UDINT;
		LDT :	UDINT;
		DSO :	BOOL;
		XMS :	INT;
		func_block : RTC_2_Block;
  	END_VAR
	func_block.SET  :=	SET;
	func_block.SDT  :=	SDT;
	func_block.SMS  :=	SMS;
	func_block.DEN  :=	DEN;
	func_block.OFS  :=	OFS;
	func_block();
	UDT := func_block.UDT;
	LDT := func_block.LDT;
	DSO := func_block.DSO;
	XMS := func_block.XMS;

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