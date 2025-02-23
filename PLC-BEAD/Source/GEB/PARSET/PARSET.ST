TYPE
	oscat_parset_X              : ARRAY [1..4]    OF REAL;
	oscat_parset                : ARRAY [0..3]    OF oscat_parset_X := [0,0,0,0];
END_TYPE

FUNCTION TIME_TO_UDINT2:UDINT
	VAR_INPUT
		X :	TIME;
	END_VAR

	TIME_TO_UDINT2 := DINT_TO_UDINT(TIME_TO_DINT(X));
END_FUNCTION

FUNCTION _BYTE_TO_INT:INT
	VAR_INPUT
		IN :	BYTE;
	END_VAR

	_BYTE_TO_INT := USINT_TO_INT(BYTE_TO_USINT(IN));
END_FUNCTION

FUNCTION BIT_OF_DWORD : BOOL
  VAR_INPUT
    IN : DWORD;
    N : INT;
  END_VAR

  BIT_OF_DWORD := (SHR(IN,N) AND 16#00000001) > 0;
  (* from OSCAT library; www.oscat.de  *)
END_FUNCTION

FUNCTION BIT_LOAD_B:BYTE
	VAR_INPUT
		IN :	BYTE;
		VAL :	BOOL;
		POS :	INT;
	END_VAR

	IF VAL THEN
		BIT_LOAD_B := IN OR SHL(BYTE#1,POS);
	ELSE
		BIT_LOAD_B := IN AND (NOT SHL(BYTE#1,POS));
	END_IF;
END_FUNCTION

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

FUNCTION_BLOCK PARSET_Block

	VAR_INPUT
		A0 :	BOOL;
		A1 :	BOOL;
		X01 :	REAL;
		X02 :	REAL;
		X03 :	REAL;
		X04 :	REAL;
		X11 :	REAL;
		X12 :	REAL;
		X13 :	REAL;
		X14 :	REAL;
		X21 :	REAL;
		X22 :	REAL;
		X23 :	REAL;
		X24 :	REAL;
		X31 :	REAL;
		X32 :	REAL;
		X33 :	REAL;
		X34 :	REAL;
		TC :	TIME;
	END_VAR


	VAR_OUTPUT
		P1 :	REAL;
		P2 :	REAL;
		P3 :	REAL;
		P4 :	REAL;
	END_VAR


	VAR
		X :	oscat_parset;
		S1 :	REAL;
		S2 :	REAL;
		S3 :	REAL;
		S4 :	REAL;
		TX :	UDINT;
		last :	UDINT;
		START :	BOOL;
		set :	BYTE;
		set2 :	INT;
		init :	BOOL;
		T_PLC_MS :	T_PLC_MS_block;
	END_VAR


	(*@KEY@: WORKSHEET
	NAME: PARSET
	IEC_LANGUAGE: ST
	*)
	(* read system_time *)
	T_PLC_MS();
	TX:= T_PLC_MS.T_PLC_MS;

	(* init sequence *)
	IF NOT init THEN
		set:=BIT_LOAD_B(set,NOT A0,0); (* set.X0 := NOT A0; *)
		init := TRUE;
		X[0][1] := X01;
		X[0][2] := X02;
		X[0][3] := X03;
		X[0][4] := X04;
		X[1][1] := X11;
		X[1][2] := X12;
		X[1][3] := X13;
		X[1][4] := X14;
		X[2][1] := X21;
		X[2][2] := X22;
		X[2][3] := X23;
		X[2][4] := X24;
		X[3][1] := X31;
		X[3][2] := X32;
		X[3][3] := X33;
		X[3][4] := X34;
		P1 := X01;
		P2 := X02;
		P3 := X03;
		P4 := X04;
	END_IF;

	(* check for input CHAnge *)
	IF (A0 XOR BIT_OF_DWORD(BYTE_TO_DWORD(set),0)) OR (A1 XOR BIT_OF_DWORD(BYTE_TO_DWORD(set),1)) THEN  (* set.X0  ,  set.X1 *) 
		(* a new set is selected *)
		set := BIT_LOAD_B(set,A0,0); (* set.X0 := A0; *)
		set := BIT_LOAD_B(set,A1,1); (* set.X1 := A1; *)

		IF tc > t#0s THEN
			START := TRUE;
			last := TX;
			(* save the STEP SPEED for the OUTput CHAnges IN S *)
			set2 := _BYTE_TO_INT(set);
			S1 := (X[set2][1] - P1)/TIME_TO_REAL(tc);
			S2 := (X[set2][2] - P2)/TIME_TO_REAL(tc);
			S3 := (X[set2][3] - P3)/TIME_TO_REAL(tc);
			S4 := (X[set2][4] - P4)/TIME_TO_REAL(tc);
		END_IF;
	ELSIF START AND SUB_TIME(TX, last) < TIME_TO_UDINT2(tc) THEN
		(* ramp the OUTputs to the new VALue *)
		set2 := _BYTE_TO_INT(set);
		P1 := X[set2][1] - S1*(TIME_TO_REAL(Tc) - UDINT_TO_REAL(TX + last));
		P2 := X[set2][2] - S2*(TIME_TO_REAL(Tc) - UDINT_TO_REAL(TX + last));
		P3 := X[set2][3] - S3*(TIME_TO_REAL(Tc) - UDINT_TO_REAL(TX + last));
		P4 := X[set2][4] - S4*(TIME_TO_REAL(Tc) - UDINT_TO_REAL(TX + last));
	ELSE
		(* make sure OUTputs match the correct set VALues *)
		set2 := _BYTE_TO_INT(set);
		START := FALSE;
		P1 := X[set2][1];
		P2 := X[set2][2];
		P3 := X[set2][3];
		P4 := X[set2][4];
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	
	VAR
		A0 :	BOOL;
		A1 :	BOOL;
		X01 :	REAL;
		X02 :	REAL;
		X03 :	REAL;
		X04 :	REAL;
		X11 :	REAL;
		X12 :	REAL;
		X13 :	REAL;
		X14 :	REAL;
		X21 :	REAL;
		X22 :	REAL;
		X23 :	REAL;
		X24 :	REAL;
		X31 :	REAL;
		X32 :	REAL;
		X33 :	REAL;
		X34 :	REAL;
		TC :	TIME;

		P1 :	REAL;
		P2 :	REAL;
		P3 :	REAL;
		P4 :	REAL;
		func_block : PARSET_Block;
  	END_VAR
	func_block.A0 := A0;
	func_block.A1 := A1;
	func_block.X01 := X01;
	func_block.X02 := X02;
	func_block.X03 := X03;
	func_block.X04 := X04;
	func_block.X11 := X11;
	func_block.X12 := X12;
	func_block.X13 := X13;
	func_block.X14 := X14;
	func_block.X21 := X21;
	func_block.X22 := X22;
	func_block.X23 := X23;
	func_block.X24 := X24;
	func_block.X31 := X31;
	func_block.X32 := X32;
	func_block.X33 := X33;
	func_block.X34 := X34;
	func_block.TC := TC;
	func_block();
	P1 := func_block.P1;
	P2 := func_block.P2;
	P3 := func_block.P3;
	P4 := func_block.P4;

END_PROGRAM

