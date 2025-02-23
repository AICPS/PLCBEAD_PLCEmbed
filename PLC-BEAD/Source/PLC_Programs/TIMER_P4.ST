TYPE oscat_TIMER_EVENT_DATA :
  STRUCT
	TYP          : BYTE;
	CHANNEL      : BYTE;
	DAY          : BYTE;
	START        : UDINT;
	DURATION     : TIME;
	LAND         : BYTE;
	LOR          : BYTE;
	LAST         : UDINT;
  END_STRUCT;
END_TYPE

TYPE
  oscat_TIMER_EVENT           : ARRAY [0..63]    OF oscat_TIMER_EVENT_DATA;
  oscat_TP4_qn                : ARRAY [0..3]    OF BOOL;
END_TYPE

TYPE
  oscat_arb_0_3               : ARRAY [0..3]    OF BYTE;
END_TYPE

FUNCTION _BYTE_TO_INT:INT
	VAR_INPUT
		IN :	BYTE;
	END_VAR

	_BYTE_TO_INT := USINT_TO_INT(BYTE_TO_USINT(IN));
END_FUNCTION

FUNCTION DATE_TO_DT:UDINT
	VAR_INPUT
		IN :	UDINT;
	END_VAR
	DATE_TO_DT := IN;
END_FUNCTION

FUNCTION _DT_TO_DATE_B:UDINT

	VAR_INPUT
		_INN :	UDINT;
	END_VAR

	_DT_TO_DATE_B := (_INN / UDINT#86400) * UDINT#86400;
END_FUNCTION

FUNCTION TIME_TO_UDINT2:UDINT
	VAR_INPUT
		X :	TIME;
	END_VAR

	TIME_TO_UDINT2 := DINT_TO_UDINT(TIME_TO_DINT(X));
END_FUNCTION

FUNCTION DATE_TO_UDINT2:UDINT
	VAR_INPUT
		IN :	UDINT;
	END_VAR

	DATE_TO_UDINT2 := IN;
END_FUNCTION

FUNCTION DAY_OF_WEEK:INT
  VAR_INPUT
    IDATE :	UDINT;
  END_VAR

  DAY_OF_WEEK := UDINT_TO_INT((idate / UDINT#86400 + UDINT#3) MOD UDINT#7) + INT#01;
END_FUNCTION

FUNCTION _BYTE_TO_DINT:DINT
	VAR_INPUT
		IN :	BYTE;
	END_VAR

	_BYTE_TO_DINT := USINT_TO_DINT(BYTE_TO_USINT(IN));
END_FUNCTION

FUNCTION DAY_OF_YEAR_UDINT:INT
	VAR_INPUT
		IDATE :	UDINT;
	END_VAR

	DAY_OF_YEAR_UDINT := UDINT_TO_INT((idate / UDINT#86400) MOD UDINT#1461);
	IF DAY_OF_YEAR_UDINT > 729 THEN
		IF DAY_OF_YEAR_UDINT > 1095 THEN DAY_OF_YEAR_UDINT := DAY_OF_YEAR_UDINT - 1095; ELSE DAY_OF_YEAR_UDINT := DAY_OF_YEAR_UDINT - 729; END_IF;
	ELSIF DAY_OF_YEAR_UDINT > 364 THEN
		DAY_OF_YEAR_UDINT := DAY_OF_YEAR_UDINT - 364;
	ELSE
		DAY_OF_YEAR_UDINT := DAY_OF_YEAR_UDINT + 1;
	END_IF;
END_FUNCTION

FUNCTION MONTH_OF_DATE_UDINT:INT

	VAR_INPUT
		IDATE :	UDINT;
	END_VAR

	MONTH_OF_DATE_UDINT := DAY_OF_YEAR_UDINT(idate);
	IF MONTH_OF_DATE_UDINT < 32 THEN
		MONTH_OF_DATE_UDINT := 1;
	ELSIF LEAP_OF_DATE(IDATE) THEN
		MONTH_OF_DATE_UDINT := (MONTH_OF_DATE_UDINT * 53 + 1668) / 1623;
	ELSE
		MONTH_OF_DATE_UDINT := (MONTH_OF_DATE_UDINT * 53 + 1700) / 1620;
	END_IF;

END_FUNCTION

FUNCTION DAY_OF_MONTH:INT
	VAR_INPUT
		IDATE :	UDINT;
	END_VAR

	day_of_month := day_of_year_UDINT(idate);

	IF leap_of_Date(idate) THEN
		CASE day_of_month OF
			32..60	:	day_of_month := day_of_month - 31;
			61..91	:	day_of_month := day_of_month - 60;
			92..121 :	day_of_month := day_of_month - 91;
			122..152:	day_of_month := day_of_month - 121;
			153..182:	day_of_month := day_of_month - 152;
			183..213:	day_of_month := day_of_month - 182;
			214..244:	day_of_month := day_of_month - 213;
			245..274:	day_of_month := day_of_month - 244;
			275..305:	day_of_month := day_of_month - 274;
			306..335:	day_of_month := day_of_month - 305;
			336..366:	day_of_month := day_of_month - 335;
		END_CASE;
	ELSE
		CASE day_of_month OF
			32..59	:	day_of_month := day_of_month - 31;
			60..90	:	day_of_month := day_of_month - 59;
			91..120 :	day_of_month := day_of_month - 90;
			121..151:	day_of_month := day_of_month - 120;
			152..181:	day_of_month := day_of_month - 151;
			182..212:	day_of_month := day_of_month - 181;
			213..243:	day_of_month := day_of_month - 212;
			244..273:	day_of_month := day_of_month - 243;
			274..304:	day_of_month := day_of_month - 273;
			305..334:	day_of_month := day_of_month - 304;
			335..365:	day_of_month := day_of_month - 334;
		END_CASE;
	END_IF;

END_FUNCTION

FUNCTION LEAP_OF_DATE:BOOL

	VAR_INPUT
		IDATE :	UDINT;
	END_VAR

	LEAP_OF_DATE := SHL(UDINT_TO_DWORD((idate + UDINT#43200) / UDINT#31557600), 30) = DWORD#16#80000000;
END_FUNCTION

FUNCTION DAY_OF_YEAR:INT
	VAR_INPUT
		IDATE :	UDINT;
	END_VAR

	DAY_OF_YEAR := UDINT_TO_INT(((idate) / UDINT#86400) MOD UDINT#1461);
	IF DAY_OF_YEAR > 729 THEN
		IF DAY_OF_YEAR > 1095 THEN DAY_OF_YEAR := DAY_OF_YEAR - 1095; ELSE DAY_OF_YEAR := DAY_OF_YEAR - 729; END_IF;
	ELSIF DAY_OF_YEAR > 364 THEN
		DAY_OF_YEAR := DAY_OF_YEAR - 364;
	ELSE
		DAY_OF_YEAR := DAY_OF_YEAR + 1;
	END_IF;
END_FUNCTION



FUNCTION MONTH_OF_DATE:INT

	VAR_INPUT
		IDATE :	UDINT;
	END_VAR

	MONTH_OF_DATE := DAY_OF_YEAR(idate);
	IF MONTH_OF_DATE < 32 THEN
		MONTH_OF_DATE := 1;
	ELSIF LEAP_OF_DATE((IDATE)) THEN
		MONTH_OF_DATE := (MONTH_OF_DATE * 53 + 1668) / 1623;
	ELSE
		MONTH_OF_DATE := (MONTH_OF_DATE * 53 + 1700) / 1620;
	END_IF;
END_FUNCTION

FUNCTION YEAR_OF_DATE:INT
	VAR_INPUT
		IDATE :	UDINT;
	END_VAR

	YEAR_OF_DATE := UDINT_TO_INT((idate+UDINT#43200) / UDINT#31557600 + UDINT#1970);
END_FUNCTION

FUNCTION _INT_TO_UDINT:UDINT
	VAR_INPUT
		IN :	INT;
	END_VAR

	_INT_TO_UDINT := DINT_TO_UDINT(INT_TO_DINT(IN));
END_FUNCTION

FUNCTION DT_TO_DATE:UDINT
	VAR_INPUT
		IN :	UDINT;
	END_VAR

	DT_TO_DATE := (IN / UDINT#86400) * UDINT#86400;
END_FUNCTION

FUNCTION SET_DT:UDINT

	VAR_INPUT
		YEAR : INT;
		MONTH :	INT;
		DAY : INT;
		HOUR : INT;
		MINUTE : INT;
		SECOND : INT;
	END_VAR

	SET_DT := SET_DATE(YEAR, MONTH, DAY) + _INT_TO_UDINT(SECOND) + _INT_TO_UDINT(MINUTE) * UDINT#60 + _INT_TO_UDINT(HOUR) * UDINT#3600;

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

FUNCTION MONTH_END:UDINT

	VAR_INPUT
		IDATE :	UDINT;
	END_VAR


	MONTH_END := SET_DATE(YEAR_OF_DATE(idate),MONTH_OF_DATE(idate)+1,1) - UDINT#86400;

END_FUNCTION

FUNCTION YEAR_END:UDINT


	VAR_INPUT
		Y :	INT;
	END_VAR

	YEAR_END := DWORD_TO_UDINT(SHR(UDINT_TO_DWORD(INT_TO_UDINT(y) * UDINT#1461 - UDINT#2876712), 2)) * UDINT#86400;

END_FUNCTION

FUNCTION LEAP_DAY:BOOL

	VAR_INPUT
		IDATE :	UDINT;
	END_VAR

	LEAP_DAY := IDATE MOD UDINT#126230400 = UDINT#68169600;


END_FUNCTION

FUNCTION BIT_LOAD_B:BYTE
	VAR_INPUT
		IN :	BYTE;
		VAL :	BOOL;
		POS :	INT;
	END_VAR

	IF VAL THEN
		BIT_LOAD_B := in OR SHL(BYTE#1,pos);
	ELSE
		BIT_LOAD_B := in AND (NOT SHL(BYTE#1,pos));
	END_IF;
END_FUNCTION

FUNCTION BIT_OF_DWORD : BOOL
  VAR_INPUT
    IN : DWORD;
    N : INT;
  END_VAR

  BIT_OF_DWORD := (SHR(in,N) AND 16#00000001) > 0;
END_FUNCTION

FUNCTION_BLOCK TIMER_P4_Block

	VAR_INPUT
		DTIME :	UDINT;
		TREF_0 :	UDINT;
		TREF_1 :	UDINT;
		HOLY :	BOOL;
		L0 :	BOOL;
		L1 :	BOOL;
		L2 :	BOOL;
		L3 :	BOOL;
		OFS :	BYTE;
		ENQ :	BOOL;
		MAN :	BOOL;
		MI :	BYTE;
		RST :	BOOL;
	END_VAR


	VAR_IN_OUT
		PROG :	oscat_TIMER_EVENT;
	END_VAR


	VAR_OUTPUT
		Q0 :	BOOL;
		Q1 :	BOOL;
		Q2 :	BOOL;
		Q3 :	BOOL;
		STATUS :	BYTE;
	END_VAR


	VAR
		day_start :	UDINT;
		start :	UDINT;
		event :	oscat_TIMER_EVENT_DATA;
		pos :	INT;
		last_execute :	UDINT;
		current_day :	DINT;
		mask :	BYTE;
		ma :	oscat_arb_0_3;
		mo :	oscat_arb_0_3;
		qn :	oscat_TP4_qn;
		qs :	oscat_TP4_qn;
		channel :	INT;
		tx :	UDINT;
		array_max :	INT := 63;
		channel_max :	INT := 3;
	END_VAR

	IF RST THEN
		last_execute := UDINT#00; 
		FOR pos := 0 TO ARRAY_MAX DO
			IF (PROG[pos].CHANNEL >= OFS) AND (_BYTE_TO_INT(PROG[pos].CHANNEL) < (_BYTE_TO_INT(OFS) + 4)) THEN PROG[pos].LAST := last_execute; END_IF;
		END_FOR;

		FOR pos := 0 TO channel_max DO
			qs[pos] := FALSE;
		END_FOR;

	ELSIF dtime <> last_execute THEN
		last_execute := DTIME;

		day_start := DATE_TO_DT(_DT_TO_DATE_B(DTIME));

		FOR pos := 0 TO channel_max DO qn[pos] := FALSE; END_FOR;

		FOR pos := 0 TO ARRAY_MAX DO
			event := prog[pos];
			channel := _BYTE_TO_INT(event.CHANNEL) - _BYTE_TO_INT(OFS);
			IF (event.TYP > BYTE#0) AND (channel >= 0) AND (channel <= channel_max) THEN
				ma[channel] := event.LAND;
				mo[channel] := event.LOR;
				CASE _BYTE_TO_INT(event.TYP) OF
					1:	
						start := day_start + event.start;
						qn[channel] := dtime >= start AND dtime <= start + TIME_TO_UDINT2(event.DURATION);

					2: 	
						IF (SHR(BYTE#128, DAY_OF_WEEK(_DT_TO_DATE_B(Dtime))) AND event.DAY) > BYTE#0 THEN
							start := day_start + event.start;
							qn[channel] := dtime >= start AND dtime <= start + TIME_TO_UDINT2(event.DURATION);
						END_IF;

					3:	
						IF current_day MOD _BYTE_TO_DINT(event.DAY) = DINT#0 THEN
							start := day_start + event.start;
							qn[channel] := dtime >= start AND dtime <= start + TIME_TO_UDINT2(event.DURATION);
						END_IF;

					10:	
						IF DAY_OF_WEEK(_DT_TO_DATE_B(DTIME)) = BYTE_TO_INT(event.DAY) THEN
							start := day_start + event.start;
							qn[channel] := dtime >= start AND dtime <= start + TIME_TO_UDINT2(event.DURATION);
						END_IF;

					20:
						IF DAY_OF_MONTH(_DT_TO_DATE_B(DTIME)) = BYTE_TO_INT(event.DAY) THEN
							start := day_start + event.start;
							qn[channel] := dtime >= start AND dtime <= start + TIME_TO_UDINT2(event.DURATION);
						END_IF;

					21:	
						IF _DT_TO_DATE_B(DTIME) = MONTH_END(_DT_TO_DATE_B(dtime)) THEN
							start := day_start + event.start;
							qn[channel] := dtime >= start AND dtime <= start + TIME_TO_UDINT2(event.DURATION);
						END_IF;

					30:
						IF DAY_OF_YEAR(_DT_TO_DATE_B(DTIME)) = BYTE_TO_INT(event.DAY) THEN
							start := day_start + event.start;
							qn[channel] := dtime >= start AND dtime <= start + TIME_TO_UDINT2(event.DURATION);
						END_IF;

					31:
						IF _DT_TO_DATE_B(DTIME) = YEAR_END(YEAR_OF_DATE(_DT_TO_DATE_B(dtime))) THEN
							start := day_start + event.start;
							qn[channel] := dtime >= start AND dtime <= start + TIME_TO_UDINT2(event.DURATION);
						END_IF;

					40:	
						IF LEAP_DAY(_DT_TO_DATE_B(dtime)) THEN
							start := day_start + event.start;
							qn[channel] := dtime >= start AND dtime <= start + TIME_TO_UDINT2(event.DURATION);
						END_IF;

					41:
						IF HOLY THEN
							start := day_start + event.start;
							qn[channel] := dtime >= start AND dtime <= start + TIME_TO_UDINT2(event.DURATION);
						END_IF;

					42: 
						IF (Holy OR (DAY_OF_WEEK(_DT_TO_DATE_B(dtime)) = 6) OR (DAY_OF_WEEK(_DT_TO_DATE_B(dtime)) = 7)) THEN
							start := day_start + event.start;
							qn[channel] := dtime >= start AND dtime <= start + TIME_TO_UDINT2(event.DURATION);
						END_IF;

					43:
						IF DAY_OF_WEEK(_DT_TO_DATE_B(dtime)) < 6 THEN
							start := day_start + event.start;
							qn[channel] := dtime >= start AND dtime <= start + TIME_TO_UDINT2(event.DURATION);
						END_IF;

					50: 
						CASE _BYTE_TO_INT(prog[pos].DAY) OF
							0:	tx := tref_0;
							1:	tx := tref_1;
						ELSE
							tx := UDINT#0 ;
						END_CASE;
						start := day_start + tx + event.start;
						qn[channel] := dtime >= start AND dtime <= start + TIME_TO_UDINT2(event.DURATION);

					51:	
						CASE _BYTE_TO_INT(prog[pos].DAY) OF
							0:	tx := tref_0;
							1:	tx := tref_1;
						ELSE
							tx := UDINT#0;
						END_CASE;
						start := day_start + tx - event.start;
						qn[channel] := dtime >= start AND dtime <= start + TIME_TO_UDINT2(event.DURATION);

					52 : 
						CASE _BYTE_TO_INT(prog[pos].DAY) OF
							0:	tx := tref_0;
							1:	tx := tref_1;
						ELSE
							tx := UDINT#0 ;
						END_CASE;
						start := day_start + tx + event.start;
						IF dtime >= start AND day_start > event.LAST THEN
							qs[channel] := TRUE;
							prog[pos].LAST := day_start;
						END_IF;

					53 : 
						CASE _BYTE_TO_INT(prog[pos].DAY) OF
							0:	tx := tref_0;
							1:	tx := tref_1;
						ELSE
							tx := UDINT#0 ;
						END_CASE;
						start := day_start + tx + event.start;
						IF dtime >= start AND day_start > event.LAST THEN
							qs[channel] := FALSE;
							prog[pos].LAST := day_start;
						END_IF;

					54 :
						CASE _BYTE_TO_INT(prog[pos].DAY) OF
							0:	tx := tref_0;
							1:	tx := tref_1;
						ELSE
							tx := UDINT#0 ;
						END_CASE;
						start := day_start + tx - event.start;
						IF dtime >= start AND day_start > event.LAST THEN
							qs[channel] := TRUE;
							prog[pos].LAST := day_start;
						END_IF;

					55 : 
						CASE _BYTE_TO_INT(prog[pos].DAY) OF
							0:	tx := tref_0;
							1:	tx := tref_1;
						ELSE
							tx := UDINT#0 ;
						END_CASE;
						start := day_start + tx - event.start;
						IF dtime >= start AND day_start > event.LAST THEN
							qs[channel] := FALSE;
							prog[pos].LAST := day_start;
						END_IF;
				END_CASE;
			END_IF;
		END_FOR;
	END_IF;

	mask := BYTE#255;
	mask:=BIT_LOAD_B(mask,L0,0);
	mask:=BIT_LOAD_B(mask,L1,1);
	mask:=BIT_LOAD_B(mask,L2,2);
	mask:=BIT_LOAD_B(mask,L3,3);

	Q0 := ENQ AND ((qn[0] OR qs[0]) AND ((ma[0] AND mask) = ma[0]) OR ((mo[0] AND mask) > BYTE#0) OR (man AND BIT_OF_DWORD(BYTE_TO_DWORD(MI),0)));
	Q1 := ENQ AND ((qn[1] OR qs[1]) AND ((ma[1] AND mask) = ma[1]) OR ((mo[1] AND mask) > BYTE#1) OR (man AND BIT_OF_DWORD(BYTE_TO_DWORD(MI),1)));
	Q2 := ENQ AND ((qn[2] OR qs[2]) AND ((ma[2] AND mask) = ma[2]) OR ((mo[2] AND mask) > BYTE#2) OR (man AND BIT_OF_DWORD(BYTE_TO_DWORD(MI),2)));
	Q3 := ENQ AND ((qn[3] OR qs[3]) AND ((ma[3] AND mask) = ma[3]) OR ((mo[3] AND mask) > BYTE#3) OR (man AND BIT_OF_DWORD(BYTE_TO_DWORD(MI),3)));

	IF NOT enq THEN
		status := BYTE#100;
	ELSIF man THEN
		status := BYTE#101;
	ELSE
		status := BYTE#102;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		DTIME :	UDINT;
		TREF_0 :	UDINT;
		TREF_1 :	UDINT;
		HOLY :	BOOL;
		L0 :	BOOL;
		L1 :	BOOL;
		L2 :	BOOL;
		L3 :	BOOL;
		OFS :	BYTE;
		ENQ :	BOOL;
		MAN :	BOOL;
		MI :	BYTE;
		RST :	BOOL;
		PROG :	oscat_TIMER_EVENT;
		Q0 :	BOOL;
		Q1 :	BOOL;
		Q2 :	BOOL;
		Q3 :	BOOL;
		STATUS :	BYTE;

		func_block : TIMER_P4_Block;
	END_VAR
	func_block.DTIME := DTIME;
	func_block.TREF_0 := TREF_0;
	func_block.TREF_1 := TREF_1;
	func_block.HOLY := HOLY;
	func_block.L0 := L0;
	func_block.L1 := L1;
	func_block.L2 := L2;
	func_block.L3 := L3;
	func_block.OFS := OFS;
	func_block.ENQ := ENQ;
	func_block.MAN := MAN;
	func_block.MI := MI;
	func_block.RST := RST;
	func_block.PROG := PROG;

	func_block();
	PROG  := func_block.PROG;
	Q0  := func_block.Q0;
	Q1  := func_block.Q1;
	Q2  := func_block.Q2;
	Q3  := func_block.Q3;
	STATUS  := func_block.STATUS;
END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION