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

FUNCTION PERIOD:BOOL

	VAR
		day1 :	INT;
		day2 :	INT;
		dayx :	INT;
	END_VAR

	VAR_INPUT
		D1 :	UDINT;
		Dx :	UDINT;
		D2 :	UDINT;
	END_VAR


	day1 := day_of_year(d1);
	day2 := day_of_year(d2);
	dayx := day_of_year(dx);
	IF NOT leap_of_Date(dx) AND dayx > 58 THEN dayx := dayx + 1; END_IF;
	IF NOT leap_of_Date(d1) AND day1 > 58 THEN day1 := day1 + 1; END_IF;
	IF NOT leap_of_Date(d2) AND day2 > 58 THEN day2 := day2 + 1; END_IF;

	IF day2 < day1 THEN
		(* the period spans over the new year *)
		period := dayx <= day2 OR dayx >= day1;
	ELSE
		period := dayx >= day1 AND dayx <= day2;
	END_IF;

END_FUNCTION

PROGRAM program0
	VAR
		D1 :	UDINT;
		Dx :	UDINT;
		D2 :	UDINT;

		OUT : BOOL;
	END_VAR

	OUT := PERIOD(D1, Dx, D2);
END_PROGRAM


CONFIGURATION Config0

	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE

END_CONFIGURATION
