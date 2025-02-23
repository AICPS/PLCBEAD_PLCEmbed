TYPE
  oscat_DCf77_bits            : ARRAY [0..58]   OF BOOL;
END_TYPE

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

FUNCTION BIT_LOAD_W:WORD
	VAR_INPUT
		IN :	WORD;
		VAL :	BOOL;
		POS :	INT;
	END_VAR

	IF VAL THEN
		BIT_LOAD_W := IN OR SHL(WORD#1,POS);
	ELSE
		BIT_LOAD_W := IN AND (NOT SHL(WORD#1,POS));
	END_IF;
END_FUNCTION

FUNCTION BIT_OF_DWORD:BOOL
	VAR_INPUT
		IN :	DWORD;
		N :	INT;
	END_VAR
	BIT_OF_DWORD := (SHR(IN,N) AND DWORD#1) > DWORD#0;
END_FUNCTION

FUNCTION EVEN:BOOL
	VAR_INPUT
		IN :	DINT;
	END_VAR
	EVEN := NOT BIT_OF_DWORD(DINT_TO_DWORD(IN),0);
END_FUNCTION

FUNCTION _INT_TO_UDINT:UDINT
	VAR_INPUT
		IN :	INT;
	END_VAR

	_INT_TO_UDINT := DINT_TO_UDINT(INT_TO_DINT(IN));
END_FUNCTION


FUNCTION SET_DATE:UDINT

	VAR_INPUT
		YEAR  :	INT;
		MONTH :	INT;
		DAY  :	INT;
	END_VAR

	VAR
		count :	INT;
	END_VAR

	IF MONTH > 2 THEN
		count := (MONTH - 1) * 30;
		IF MONTH > 7 THEN
			count := count + DWORD_TO_INT(SHR(DINT_TO_DWORD(INT_TO_DINT(MONTH) - INT_TO_DINT(3)),1));
		ELSE
			count := count + DWORD_TO_INT(SHR(DINT_TO_DWORD(INT_TO_DINT(MONTH) - INT_TO_DINT(4)),1));
		END_IF;
		IF SHL(INT_TO_WORD(YEAR),14) = WORD#0 THEN
			count := count + 1;
		END_IF;
	ELSE
		count := (MONTH - 1) * 31;
	END_IF;
	SET_DATE := (_INT_TO_UDINT(count + DAY  - 1) + DWORD_TO_UDINT(SHR(UDINT_TO_DWORD(_INT_TO_UDINT(YEAR) * UDINT#1461 - UDINT#2878169), 2))) * UDINT#86400;

END_FUNCTION

FUNCTION DST:BOOL
	VAR_INPUT
		UTC :	UDINT;
	END_VAR

	VAR
		yr :	INT;
		yr4 :	UDINT;
		ltc :	UDINT;
		IDATE :	UDINT;
	END_VAR

	yr := YEAR_OF_DATE(DT_TO_DATE2(UTC));
	ltc := UTC;
	IDATE := SET_DT(yr, 3, 31, 1, 0, 0);
	yr4 := DWORD_TO_UDINT(SHR(INT_TO_DWORD(5 * yr), 2)) + UDINT#1;
	DST := (IDATE - ((yr4 + UDINT#3) MOD UDINT#7) * UDINT#86400 <= ltc) AND (IDATE + (UDINT#214 - (yr4) MOD UDINT#7) * UDINT#86400 > ltc);

END_FUNCTION

FUNCTION YEAR_OF_DATE:INT
	VAR_INPUT
		IDATE :	UDINT;
	END_VAR

	YEAR_OF_DATE := UDINT_TO_INT((IDATE+UDINT#43200) / UDINT#31557600 + UDINT#1970);
END_FUNCTION

FUNCTION DAY_OF_WEEK:INT

	VAR_INPUT
		IDATE :	UDINT;
	END_VAR


	DAY_OF_WEEK := UDINT_TO_INT((IDATE / UDINT#86400 + UDINT#3) MOD UDINT#7) + INT#01;
END_FUNCTION

FUNCTION SET_DT:UDINT
	VAR_INPUT
		YEAR  :	INT;
		MONTH :	INT;
		DAY  :	INT;
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
		TPP :	BOOL;
		DS :	BOOL;
		WDAY  :	INT;
		ERROR :	BOOL;
		RTC2 :	UDINT;
		RTC21 :	UDINT;
		MSEC :	INT;
		SYNC :	BOOL;
	END_VAR

	VAR
		MEZ :	UDINT;
		UTC :	UDINT;
		STATE :	INT;
		edge :	BOOL;
		TX :	TIME;
		ty :	TIME;
		last :	TIME;
		bits :	oscat_DCf77_bits;
		CNT :	INT;
		i :	INT;
		old_time :	UDINT;
		minute :	INT;
		HOUR :	INT;
		DAY  :	INT;
		MONTH :	INT;
		YEAR  :	INT;
		last_SYNC :	TIME;
		t1 :	TIME;
		tz :	TIME;
		init :	BOOL;
		word_temp :	WORD;
		bool_temp :	BOOL;
		T_PLC_MS :	T_PLC_MS_block;
	END_VAR


	TPP := FALSE;

	T_PLC_MS();
	t1:= UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);
	TX := SUB_TIME(t1, last);

	IF REC XOR edge THEN
		edge := REC;
		IF NOT REC AND TX > t#1700ms AND TX < t#2000ms THEN
			(* START condition reached *)
			STATE := 0;
			TPP := NOT ERROR;
		ELSIF NOT REC AND TX > t#700ms AND TX < t#1000ms THEN
			(* second switch detected *)
			IF STATE < 58 THEN STATE := STATE +1; ELSE STATE := 0; END_IF;
		ELSIF REC AND TX  < t#120ms THEN
			(* bit 0 detected  *)
			bits[STATE] := FALSE;
		ELSIF REC AND TX > t#120ms AND TX < t#250ms THEN
			(* bit 1 detected *)
			bits[STATE] := TRUE;
		ELSE
			(* ERROR condition RECeived SIGNal is not VALid *)
			ERROR := TRUE;
			STATE := 0;
		END_IF;
		last := ADD_TIME (last , TX);
		IF REC AND STATE = 58 THEN
			ERROR := FALSE;

			IF bits[0] OR NOT (bits[17] XOR bits[18]) OR NOT bits[20] THEN ERROR := TRUE; END_IF;
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
			IF minute > 59 OR (bits[21] XOR bits[22] XOR bits[23] XOR bits[24] XOR bits[25] XOR bits[26] XOR bits[27] XOR bits[28]) THEN ERROR := TRUE; END_IF;

			(* decode HOUR *)
			word_temp := WORD#0;

			bool_temp:=bits[29];
			word_temp:=BIT_LOAD_W(word_temp,bool_temp,0);    (* word_temp.X0 := bits[29]; *)
			bool_temp:=bits[30];
			word_temp:=BIT_LOAD_W(word_temp,bool_temp,1);    (* word_temp.X1 := bits[30]; *)
			bool_temp:=bits[31];
			word_temp:=BIT_LOAD_W(word_temp,bool_temp,2);    (* word_temp.X2 := bits[31]; *)
			bool_temp:=bits[32];
			word_temp:=BIT_LOAD_W(word_temp,bool_temp,3);    (* word_temp.X3 := bits[32]; *)

			HOUR := WORD_TO_INT(word_temp);
			IF bits[33] THEN HOUR := HOUR +10; END_IF;
			IF bits[34] THEN HOUR := HOUR +20; END_IF;
			IF HOUR > 23 OR (bits[29] XOR bits[30] XOR bits[31] XOR bits[32] XOR bits[33] XOR bits[34] XOR bits[35]) THEN ERROR := TRUE; END_IF;

			(* decode DAY  of MONTH *)
			word_temp := WORD#0;

			bool_temp:=bits[36];
			word_temp:=BIT_LOAD_W(word_temp,bool_temp,0);    (* word_temp.X0 := bits[36]; *)
			bool_temp:=bits[37];
			word_temp:=BIT_LOAD_W(word_temp,bool_temp,1);    (* word_temp.X1 := bits[37]; *)
			bool_temp:=bits[38];
			word_temp:=BIT_LOAD_W(word_temp,bool_temp,2);    (* word_temp.X2 := bits[38]; *)
			bool_temp:=bits[39];
			word_temp:=BIT_LOAD_W(word_temp,bool_temp,3);    (* word_temp.X3 := bits[39]; *)

			DAY  := WORD_TO_INT(word_temp);
			IF bits[40] THEN DAY  := DAY  + 10; END_IF;
			IF bits[41] THEN DAY  := DAY  + 20; END_IF;
			IF DAY  > 31 THEN ERROR := TRUE; END_IF;

			(* decode DAY  of week *)
			word_temp := WORD#0;

			bool_temp:=bits[42];
			word_temp:=BIT_LOAD_W(word_temp,bool_temp,0);    (* word_temp.X0 := bits[42]; *)
			bool_temp:=bits[43];
			word_temp:=BIT_LOAD_W(word_temp,bool_temp,1);    (* word_temp.X1 := bits[43]; *)
			bool_temp:=bits[44];
			word_temp:=BIT_LOAD_W(word_temp,bool_temp,2);    (* word_temp.X2 := bits[44]; *)

			WDAY  := WORD_TO_INT(word_temp);
			IF WDAY  > 7 OR WDAY  < 1 THEN ERROR := TRUE; END_IF;

			(* decode MONTH *)
			word_temp := WORD#0;

			bool_temp:=bits[45];
			word_temp:=BIT_LOAD_W(word_temp,bool_temp,0);    (* word_temp.X0 := bits[45]; *)
			bool_temp:=bits[46];
			word_temp:=BIT_LOAD_W(word_temp,bool_temp,1);    (* word_temp.X1 := bits[46]; *)
			bool_temp:=bits[47];
			word_temp:=BIT_LOAD_W(word_temp,bool_temp,2);    (* word_temp.X2 := bits[47]; *)
			bool_temp:=bits[48];
			word_temp:=BIT_LOAD_W(word_temp,bool_temp,3);    (* word_temp.X3 := bits[48]; *)

			MONTH := WORD_TO_INT(word_temp);
			IF bits[49] THEN MONTH := MONTH +10; END_IF;
			IF MONTH > 12 THEN ERROR := TRUE; END_IF;

			(* decode YEAR  *)
			word_temp := WORD#0;

			bool_temp:=bits[50];
			word_temp:=BIT_LOAD_W(word_temp,bool_temp,0);    (* word_temp.X0 := bits[50]; *)
			bool_temp:=bits[51];
			word_temp:=BIT_LOAD_W(word_temp,bool_temp,1);    (* word_temp.X1 := bits[51]; *)
			bool_temp:=bits[52];
			word_temp:=BIT_LOAD_W(word_temp,bool_temp,2);    (* word_temp.X2 := bits[52]; *)
			bool_temp:=bits[53];
			word_temp:=BIT_LOAD_W(word_temp,bool_temp,3);    (* word_temp.X3 := bits[53]; *)

			YEAR  := WORD_TO_INT(word_temp);
			IF bits[54] THEN YEAR  := YEAR  + 10; END_IF;
			IF bits[55] THEN YEAR  := YEAR  + 20; END_IF;
			IF bits[56] THEN YEAR  := YEAR  + 40; END_IF;
			IF bits[57] THEN YEAR  := YEAR  + 80; END_IF;

			(* check parity for bits 36 to 58 *)
			CNT := 0;
			FOR i := 36 TO 58 DO IF bits[i] THEN CNT := CNT + 1; END_IF; END_FOR;
			IF NOT EVEN(INT_TO_DINT(CNT)) THEN ERROR := TRUE; END_IF;

			(* time must be VALid for two CYCLES to clear ERROR flag *)
			IF NOT ERROR THEN
				(* set OUTputs *)
				old_time := MEZ;
				IF YEAR  >= 70 THEN YEAR  := YEAR  + 1900; ELSE YEAR  := YEAR  + 2000; END_IF;
				MEZ := SET_DT(YEAR,MONTH,DAY,HOUR,minute,0);
				DS := bits[17];
				IF DS THEN
					UTC := MEZ - UDINT#7200;
				ELSE
					UTC := MEZ - UDINT#3600;
				END_IF;

				(* set TRIGger SIGNal only if the RECeiver has RECeived 2 successive minutes *)
				IF MEZ <> old_time + TIME_TO_UDINT(t#1m) THEN ERROR := TRUE ; END_IF;
			END_IF;
		END_IF;
	END_IF;

	tz := UDINT_TO_TIME(_INT_TO_UDINT(ABS(TIME_OFFSET))* UDINT#3600000);

	IF NOT init OR SET THEN
		init := TRUE;
		UTC := SDT;
		TPP := TRUE;
		DS := DSI;
	END_IF;

	IF TPP THEN
		RTC2 := UTC;
		IF DS AND DST_EN THEN
			IF TIME_OFFSET < 0 THEN
				RTC21 := RTC2 - TIME_TO_UDINT(ADD_TIME(tz , t#1h));
			ELSE 
				RTC21 := RTC2 + TIME_TO_UDINT(ADD_TIME(tz , t#1h));
			END_IF;
		ELSE
			IF TIME_OFFSET < 0 THEN
				RTC21 := RTC2 - TIME_TO_UDINT(tz);
			ELSE
				RTC21 := RTC2 + TIME_TO_UDINT(tz);
			END_IF;
		END_IF;
		SYNC := TRUE;
		last_SYNC := last;
		ty := last;
	ELSIF RTC2 > UDINT#0 AND SUB_TIME(t1 , ty) >= t#1s THEN
		RTC2 := RTC2 + TIME_TO_UDINT(t#1s);
		RTC21 := RTC21 + TIME_TO_UDINT(t#1s);
		ty := ADD_TIME( ty, t#1s);
		SYNC := SUB_TIME(ty, last_SYNC) < SYNC_TIMEOUT AND last_SYNC > t#0s;
		WDAY  := DAY_OF_WEEK(DT_TO_DATE2(RTC21));
		DS := DST_EN AND DST(UTC);
	END_IF;
	MSEC := DINT_TO_INT(TIME_TO_DINT(SUB_TIME(t1 ,ty)));

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

	TPP   :	BOOL;
	DS   :	BOOL;
	WDAY  :	INT;
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
	TPP   := func_block.TPP   ;
	DS   := func_block.DS   ;
	WDAY  := func_block.WDAY  ;
	ERROR:= func_block.ERROR;
	RTC2  := func_block.RTC2  ;
	RTC21 := func_block.RTC21 ;
	MSEC := func_block.MSEC ;
	SYNC := func_block.SYNC ;
END_PROGRAM

