TYPE
  oscat_dcf77_bits            : ARRAY [0..58]   OF BOOL;
END_TYPE

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

FUNCTION BIT_LOAD_W:WORD
	VAR_INPUT
		IN :	WORD;
		VAL :	BOOL;
		POS :	INT;
	END_VAR

	IF VAL THEN
		BIT_LOAD_W := in OR SHL(WORD#1,pos);
	ELSE
		BIT_LOAD_W := in AND (NOT SHL(WORD#1,pos));
	END_IF;
END_FUNCTION

FUNCTION BIT_OF_DWORD:BOOL
	VAR_INPUT
		IN :	DWORD;
		N :	INT;
	END_VAR
	BIT_OF_DWORD := (SHR(in,n) AND DWORD#1) > DWORD#0;
END_FUNCTION

FUNCTION EVEN:BOOL
	VAR_INPUT
		IN :	DINT;
	END_VAR
	even := NOT BIT_OF_DWORD(DINT_TO_DWORD(in),0);
END_FUNCTION

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

FUNCTION YEAR_OF_DATE:INT
	VAR_INPUT
		IDATE :	UDINT;
	END_VAR

	YEAR_OF_DATE := UDINT_TO_INT((idate+UDINT#43200) / UDINT#31557600 + UDINT#1970);
END_FUNCTION

FUNCTION DAY_OF_WEEK:INT

	VAR_INPUT
		IDATE :	UDINT;
	END_VAR


	DAY_OF_WEEK := UDINT_TO_INT((idate / UDINT#86400 + UDINT#3) MOD UDINT#7) + INT#01;
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

FUNCTION_BLOCK DCF77
	VAR_INPUT
		REC :	BOOL;
		SET :	BOOL;
		SDT :	UDINT;
		DSI :	BOOL;
		SYNC_TIMEOUT :	TIME := t#2m;
		TIME_OFFSET :	INT := 1;
		DST_EN :	BOOL := TRUE;
	END_VAR

	VAR_OUTPUT
		TPp :	BOOL;
		DS :	BOOL;
		WDAY :	INT;
		ERROR :	BOOL;
		RTC2 :	UDINT;
		RTC21 :	UDINT;
		MSEC :	INT;
		SYNC :	BOOL;
	END_VAR

	VAR
		MEZ :	UDINT;
		UTC :	UDINT;
		state :	INT;
		edge :	BOOL;
		tx :	TIME;
		ty :	TIME;
		last :	TIME;
		bits :	oscat_dcf77_bits;
		cnt :	INT;
		i :	INT;
		old_time :	UDINT;
		minute :	INT;
		hour :	INT;
		day :	INT;
		month :	INT;
		year :	INT;
		last_sync :	TIME;
		t1 :	TIME;
		tz :	TIME;
		init :	BOOL;
		word_temp :	WORD;
		bool_temp :	BOOL;
		T_PLC_MS :	T_PLC_MS_block;
	END_VAR


	TPp := FALSE;

	T_PLC_MS();
	t1:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);
	tx := t1 - last;

	IF rec XOR edge THEN
		edge := rec;
		IF NOT rec AND tx > t#1700ms AND tx < t#2000ms THEN
			(* start condition reached *)
			state := 0;
			tpp := NOT error;
		ELSIF NOT rec AND tx > t#700ms AND tx < t#1000ms THEN
			(* second switch detected *)
			IF state < 58 THEN state := state +1; ELSE state := 0; END_IF;
		ELSIF rec AND tx  < t#120ms THEN
			(* bit 0 detected  *)
			bits[state] := FALSE;
		ELSIF rec AND tx > t#120ms AND tx < t#250ms THEN
			(* bit 1 detected *)
			bits[state] := TRUE;
		ELSE
			(* error condition received signal is not valid *)
			error := TRUE;
			state := 0;
		END_IF;
		last := last + tx;
		IF rec AND state = 58 THEN
			error := FALSE;

			IF bits[0] OR NOT (bits[17] XOR bits[18]) OR NOT bits[20] THEN error := TRUE; END_IF;
			word_temp := WORD#0;

			bool_temp:=bits[21];
			word_temp:=BIT_LOAD_W(word_temp,bool_temp,0);   
			bool_temp:=bits[22];
			word_temp:=BIT_LOAD_W(word_temp,bool_temp,1);    
			bool_temp:=bits[23];
			word_temp:=BIT_LOAD_W(word_temp,bool_temp,2); 
			bool_temp:=bits[24];
			word_temp:=BIT_LOAD_W(word_temp,bool_temp,3);   

			minute := WORD_TO_INT(word_temp);
			IF bits[25] THEN minute := minute +10; END_IF;
			IF bits[26] THEN minute := minute +20; END_IF;
			IF bits[27] THEN minute := minute +40; END_IF;
			IF minute > 59 OR (bits[21] XOR bits[22] XOR bits[23] XOR bits[24] XOR bits[25] XOR bits[26] XOR bits[27] XOR bits[28]) THEN error := TRUE; END_IF;

			(* decode hour *)
			word_temp := WORD#0;

			bool_temp:=bits[29];
			word_temp:=BIT_LOAD_W(word_temp,bool_temp,0);    (* word_temp.X0 := bits[29]; *)
			bool_temp:=bits[30];
			word_temp:=BIT_LOAD_W(word_temp,bool_temp,1);    (* word_temp.X1 := bits[30]; *)
			bool_temp:=bits[31];
			word_temp:=BIT_LOAD_W(word_temp,bool_temp,2);    (* word_temp.X2 := bits[31]; *)
			bool_temp:=bits[32];
			word_temp:=BIT_LOAD_W(word_temp,bool_temp,3);    (* word_temp.X3 := bits[32]; *)

			hour := WORD_TO_INT(word_temp);
			IF bits[33] THEN hour := hour +10; END_IF;
			IF bits[34] THEN hour := hour +20; END_IF;
			IF hour > 23 OR (bits[29] XOR bits[30] XOR bits[31] XOR bits[32] XOR bits[33] XOR bits[34] XOR bits[35]) THEN error := TRUE; END_IF;

			(* decode day of month *)
			word_temp := WORD#0;

			bool_temp:=bits[36];
			word_temp:=BIT_LOAD_W(word_temp,bool_temp,0);    (* word_temp.X0 := bits[36]; *)
			bool_temp:=bits[37];
			word_temp:=BIT_LOAD_W(word_temp,bool_temp,1);    (* word_temp.X1 := bits[37]; *)
			bool_temp:=bits[38];
			word_temp:=BIT_LOAD_W(word_temp,bool_temp,2);    (* word_temp.X2 := bits[38]; *)
			bool_temp:=bits[39];
			word_temp:=BIT_LOAD_W(word_temp,bool_temp,3);    (* word_temp.X3 := bits[39]; *)

			day := WORD_TO_INT(word_temp);
			IF bits[40] THEN day := day + 10; END_IF;
			IF bits[41] THEN day := day + 20; END_IF;
			IF day > 31 THEN error := TRUE; END_IF;

			(* decode day of week *)
			word_temp := WORD#0;

			bool_temp:=bits[42];
			word_temp:=BIT_LOAD_W(word_temp,bool_temp,0);    (* word_temp.X0 := bits[42]; *)
			bool_temp:=bits[43];
			word_temp:=BIT_LOAD_W(word_temp,bool_temp,1);    (* word_temp.X1 := bits[43]; *)
			bool_temp:=bits[44];
			word_temp:=BIT_LOAD_W(word_temp,bool_temp,2);    (* word_temp.X2 := bits[44]; *)

			wday := WORD_TO_INT(word_temp);
			IF wday > 7 OR wday < 1 THEN error := TRUE; END_IF;

			(* decode month *)
			word_temp := WORD#0;

			bool_temp:=bits[45];
			word_temp:=BIT_LOAD_W(word_temp,bool_temp,0);    (* word_temp.X0 := bits[45]; *)
			bool_temp:=bits[46];
			word_temp:=BIT_LOAD_W(word_temp,bool_temp,1);    (* word_temp.X1 := bits[46]; *)
			bool_temp:=bits[47];
			word_temp:=BIT_LOAD_W(word_temp,bool_temp,2);    (* word_temp.X2 := bits[47]; *)
			bool_temp:=bits[48];
			word_temp:=BIT_LOAD_W(word_temp,bool_temp,3);    (* word_temp.X3 := bits[48]; *)

			month := WORD_TO_INT(word_temp);
			IF bits[49] THEN month := month +10; END_IF;
			IF month > 12 THEN error := TRUE; END_IF;

			(* decode year *)
			word_temp := WORD#0;

			bool_temp:=bits[50];
			word_temp:=BIT_LOAD_W(word_temp,bool_temp,0);    (* word_temp.X0 := bits[50]; *)
			bool_temp:=bits[51];
			word_temp:=BIT_LOAD_W(word_temp,bool_temp,1);    (* word_temp.X1 := bits[51]; *)
			bool_temp:=bits[52];
			word_temp:=BIT_LOAD_W(word_temp,bool_temp,2);    (* word_temp.X2 := bits[52]; *)
			bool_temp:=bits[53];
			word_temp:=BIT_LOAD_W(word_temp,bool_temp,3);    (* word_temp.X3 := bits[53]; *)

			year := WORD_TO_INT(word_temp);
			IF bits[54] THEN year := year + 10; END_IF;
			IF bits[55] THEN year := year + 20; END_IF;
			IF bits[56] THEN year := year + 40; END_IF;
			IF bits[57] THEN year := year + 80; END_IF;

			(* check parity for bits 36 to 58 *)
			cnt := 0;
			FOR i := 36 TO 58 DO IF bits[i] THEN cnt := cnt + 1; END_IF; END_FOR;
			IF NOT even(INT_TO_DINT(cnt)) THEN error := TRUE; END_IF;

			(* time must be valid for two cycles to clear error flag *)
			IF NOT error THEN
				(* set outputs *)
				old_time := mez;
				IF year >= 70 THEN year := year + 1900; ELSE year := year + 2000; END_IF;
				mez := set_DT(year,month,day,hour,minute,0);
				DS := bits[17];
				IF DS THEN
					UTC := mez - UDINT#7200;
				ELSE
					UTC := mez - UDINT#3600;
				END_IF;

				(* set trigger signal only if the receiver has received 2 successive minutes *)
				IF mez <> old_time + TIME_TO_UDINT(t#1m) THEN error := TRUE ; END_IF;
			END_IF;
		END_IF;
	END_IF;

	tz := UDINT_TO_TIME(_INT_TO_UDINT(ABS(time_offset))* UDINT#3600000);

	IF NOT init OR SET THEN
		init := TRUE;
		utc := sdt;
		tpp := TRUE;
		DS := DSI;
	END_IF;

	IF tpp THEN
		rtc2 := utc;
		IF DS AND dst_en THEN
			IF time_offset < 0 THEN
				rtc21 := rtc2 - TIME_TO_UDINT(tz + t#1h);
			ELSE 
				rtc21 := rtc2 + TIME_TO_UDINT(tz + t#1h);
			END_IF;
		ELSE
			IF time_offset < 0 THEN
				rtc21 := rtc2 - TIME_TO_UDINT(tz);
			ELSE
				rtc21 := rtc2 + TIME_TO_UDINT(tz);
			END_IF;
		END_IF;
		sync := TRUE;
		last_sync := last;
		ty := last;
	ELSIF rtc2 > UDINT#0 AND T1 - ty >= t#1s THEN
		rtc2 := rtc2 + TIME_TO_UDINT(t#1s);
		rtc21 := rtc21 + TIME_TO_UDINT(t#1s);
		ty := ty + t#1s;
		sync := ty - last_sync < sync_timeout AND last_sync > t#0s;
		wday := DAY_OF_WEEK(DT_TO_DATE2(rtc21));
		DS := dst_en AND DST(utc);
	END_IF;
	msec := TIME_TO_INT(t1 - ty);

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	REC         :	BOOL;
	SET         :	BOOL;
	SDT         :	UDINT;
	DSI         :	BOOL;
	SYNC_TIMEOUT:	TIME;
	TIME_OFFSET :	INT;
	DST_EN 	    :	BOOL;

	TPp   :	BOOL;
	DS   :	BOOL;
	WDAY :	INT;
	ERROR:	BOOL;
	RTC2  :	UDINT;
	RTC21 :	UDINT;
	MSEC :	INT;
	SYNC :	BOOL;

	func_block : DCF77;
  END_VAR
	func_block.REC           :=REC         ;
	func_block.SET           :=SET         ;
	func_block.SDT           :=SDT         ;
	func_block.DSI           :=DSI         ;
	func_block.SYNC_TIMEOUT  :=SYNC_TIMEOUT;
	func_block.TIME_OFFSET   :=TIME_OFFSET ;
	func_block.DST_EN 	      :=DST_EN 	    ;
	func_block();
	TPp   := func_block.TPp   ;
	DS   := func_block.DS   ;
	WDAY := func_block.WDAY ;
	ERROR:= func_block.ERROR;
	RTC2  := func_block.RTC2  ;
	RTC21 := func_block.RTC21 ;
	MSEC := func_block.MSEC ;
	SYNC := func_block.SYNC ;
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