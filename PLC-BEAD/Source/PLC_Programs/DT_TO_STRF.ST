
FUNCTION DT_TO_DATE2:UDINT

	VAR_INPUT
		IN :	UDINT;
	END_VAR

	DT_TO_DATE2 := (IN / UDINT#86400) * UDINT#86400;
END_FUNCTION

FUNCTION DT_TO_TOD2:UDINT
	VAR_INPUT
		IN :	UDINT;
	END_VAR

	DT_TO_TOD2 := (IN MOD UDINT#86400) * UDINT#1000;
END_FUNCTION

FUNCTION _BYTE_TO_INT:INT
	VAR_INPUT
		IN :	BYTE;
	END_VAR

	_BYTE_TO_INT := USINT_TO_INT(BYTE_TO_USINT(IN));
END_FUNCTION

FUNCTION_BLOCK DT_TO_STRF_Block

	VAR_INPUT
		DTI :	UDINT;
		MS :	INT;
		FMT :	STRING;
		LANG :	INT;
	END_VAR

	VAR_OUTPUT
		DT_TO_STRF :	STRING;
	END_VAR

	VAR
		FILL :	STRING;
		BLANK :	STRING;
		ly :	INT;
		dx :	UDINT;
		fs :	STRING;
		fs_tmp :	STRING;
		td :	UDINT;
		tmp :	INT;
		pos :	INT;
		f :	INT;
		CODEE :	CODE;
		MONTH_TO_STRING :	MONTH_TO_STRING;
		WEEKDAY_TO_STRING :	WEEKDAY_TO_STRING;
	END_VAR

	IF LANG < 1 THEN ly := 1; ELSE ly := MIN(2, LANG); END_IF;

	dx := DT_TO_DATE2(DTI);
	td := DT_TO_TOD2(DTI);

	DT_TO_STRF := FMT;
	pos := FIND(DT_TO_STRF, '#');
	WHILE pos > 0 DO
		CODEE(STR:=DT_TO_STRF,POS:=pos + 1);
		f := _BYTE_TO_INT(CODEE.CODEE);
		(* generate the return string according to the format character *)
		fs := '';
		CASE f OF
			0: RETURN; (* illegal character index *)
	
			65 : (* letter A retunrs the year in 4 digits *)
				fs := INT_TO_STRING(YEAR_OF_DATE(dx),'%d');
			66 : (* letter B returns the year in exactly 2 digits *)
				fs := RIGHT(INT_TO_STRING(YEAR_OF_DATE(dx),'%02d'),2);
			67 : (* letter C returns the month with 1 or 2 digits *)
				fs := INT_TO_STRING(MONTH_OF_DATE(dx),'%d');
			68 : (* letter D returns the month with exactly 2 digits *)
				fs := INT_TO_STRING(MONTH_OF_DATE(dx),'%02d');
			69 : (* letter E returns the month with 3 characters *)
				MONTH_TO_STRING(MTH:=MONTH_OF_DATE(dx),LANG:=ly,LX:=3);
				fs:=MONTH_TO_STRING.MONTH_TO_STRING;
			70 : (* letter F returns the month with all characters *)
				MONTH_TO_STRING(MTH:=MONTH_OF_DATE(dx),LANG:=ly,LX:=0);
				fs:=MONTH_TO_STRING.MONTH_TO_STRING;
			71 : (* letter G returns the day with up to 2 digits *)
				fs := INT_TO_STRING(DAY_OF_MONTH(dx),'%d');
			72 : (* letter H returns the day of the month with exactly 2 digits *)
				fs := INT_TO_STRING(DAY_OF_MONTH(dx),'%d');
				IF LEN(fs) < 2 THEN fs_tmp:=fs; fs := CONCAT(FILL, fs_tmp); END_IF;
			73 : (* letter I returns the weekday as the number 1..7 1 = monday *)
				fs := INT_TO_STRING(DAY_OF_WEEK(dx),'%d');
			74 : (* letter J returns the weekday in 2 character writing *)
				WEEKDAY_TO_STRING(WDAY:=DAY_OF_WEEK(dx),LANG:=ly,LX:=2);
				fs := WEEKDAY_TO_STRING.WEEKDAY_TO_STRING;
			75 : (* letter K returns the weekday with all characters *)
				WEEKDAY_TO_STRING(WDAY:=DAY_OF_WEEK(dx),LANG:=ly,LX:=0);
				fs := WEEKDAY_TO_STRING.WEEKDAY_TO_STRING;
			76 : (* letter L returns AM or PM for the given DateTime *)
				IF td >= UDINT#43200000 THEN fs := 'PM'; ELSE fs := 'AM'; END_IF;
			77 : (* letter M returns the hour in 1 or 2 digit form 0..24h *)
				fs := INT_TO_STRING(HOUR(td),'%d');
			78 : (* letter N returns the hour in exactly 2 digit form 0..24h *)
				fs := INT_TO_STRING(HOUR(td),'%d');
				IF LEN(fs) < 2 THEN fs_tmp:=fs; fs := CONCAT(FILL, fs_tmp); END_IF;
			79 : (* letter O returns the hour in 1 or 2 digit form 0..12h *)
				tmp := HOUR(td) MOD 12;
				IF tmp = 0 THEN tmp := 12; END_IF;
				fs := INT_TO_STRING(tmp,'%d');
			80 : (* letter P returns the hour in exactly 2 digit form 0..12h *)
				tmp := HOUR(td) MOD 12;
				IF tmp = 0 THEN tmp := 12; END_IF;
				fs := INT_TO_STRING(tmp,'%d');
				IF LEN(fs) < 2 THEN fs_tmp:=fs; fs := CONCAT(FILL, fs_tmp); END_IF;
			81 : (* letter Q returns the minute of the hour in 1 or two digit form *)
				fs := INT_TO_STRING(MINUTE(td),'%d');
			82 : (* letter R returns the minute of the hour in exactly two digit form *)
				fs := INT_TO_STRING(MINUTE(td),'%d');
				IF LEN(fs) < 2 THEN fs_tmp:=fs; fs := CONCAT(FILL, fs_tmp); END_IF;
			83 : (* letter S returns the second of the minute in 1 or two digit form *)
				fs := INT_TO_STRING(REAL_TO_INT(SECOND(td)),'%d');
			84 : (* letter T returns the second of the minute in exactly two digit form *)
				fs := INT_TO_STRING(REAL_TO_INT(SECOND(td)),'%d');
				IF LEN(fs) < 2 THEN fs_tmp:=fs; fs := CONCAT(FILL, fs_tmp); END_IF;
			85 : (* letter U returns the milliseconds in 1 to 3 digits *)
				fs := INT_TO_STRING(MS,'%d');
			86 : (* letter V returns the milliseconds in exactly 3 digit form *)
				fs := INT_TO_STRING(MS,'%03d');
			87 : (* letter W returns the day of the month with exactly 2 digits first digit is filled with blank if necessary *)
				fs := INT_TO_STRING(DAY_OF_MONTH(dx),'%d');
				IF LEN(fs) < 2 THEN fs_tmp:=fs; fs := CONCAT(BLANK, fs_tmp); END_IF;
			88 : (* letter X returns the month with exactly 2 digits first digit is filled with blank if necessary *)
				fs := INT_TO_STRING(MONTH_OF_DATE(dx),'%d');
				IF LEN(fs) < 2 THEN fs_tmp:=fs; fs := CONCAT(BLANK, fs_tmp); END_IF;
		END_CASE;
		DT_TO_STRF := REPLACE(DT_TO_STRF, fs, 2, pos);
		pos := FIND(DT_TO_STRF, '#');
	END_WHILE;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	DTI  :	UDINT;
	MS   :	INT;
	FMT  :	STRING;
	LANG :	INT;

	DT_TO_STRF :	STRING;

	func_block : DT_TO_STRF_Block;
  END_VAR
	func_block.DTI  :=DTI ;
	func_block.MS   :=MS  ;
	func_block.FMT  :=FMT ;
	func_block.LANG :=LANG;
	func_block();
	DT_TO_STRF := func_block.DT_TO_STRF;
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION