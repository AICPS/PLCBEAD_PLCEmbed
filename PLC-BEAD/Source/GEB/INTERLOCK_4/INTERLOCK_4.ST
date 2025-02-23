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

FUNCTION_BLOCK INTERLOCK_4_Block

	VAR_INPUT
		I0 :	BOOL;
		I1 :	BOOL;
		I2 :	BOOL;
		I3 :	BOOL;
		E :	BOOL;
		MODE :	INT;
	END_VAR

	VAR_OUTPUT
		OUT :	BYTE;
		TPP :	BOOL;
	END_VAR

	VAR
		IN :	BYTE;
		last :	BYTE;
		old :	BYTE;
		lMODE :	INT;
	END_VAR

	IF E THEN
	(* reset all vars when there is a MODE CHAnge on thy fly *)
		IF MODE <> lMODE THEN
			OUT := BYTE#0;
			last := BYTE#0;
			old := BYTE#0;
			lMODE := MODE;
		END_IF;
		(* load inputs into IN *)
		IN:=BIT_LOAD_B(IN,I0,0); (* in.0 *)
		IN:=BIT_LOAD_B(IN,I1,1); (* in.1 *)
		IN:=BIT_LOAD_B(IN,I2,2); (* in.2 *)
		IN:=BIT_LOAD_B(IN,I3,3); (* in.3 *)
		(* only execute when there is any CHAnge *)
		IF IN <> last THEN
			(* only execute when inputs have CHAges STATE *)
			CASE MODE OF
				0:	(* OUTput DIRecTLy display inputs as bits IN byte OUT *)
					OUT := IN;

				1:	(* the input with the highest number will be acePTed *)
					IF    (IN AND BYTE#2#00001000) > BYTE#0 (* in.3 *) THEN OUT := BYTE#8;
					ELSIF (IN AND BYTE#2#00000100) > BYTE#0 (* in.2 *) THEN OUT := BYTE#4;
					ELSIF (IN AND BYTE#2#00000010) > BYTE#0 (* in.1 *) THEN OUT := BYTE#2;
					ELSE OUT := IN;
					END_IF;

				2:	(* input last pressed will be displayed only *)
					last := ((IN XOR last) AND IN);
					IF    (last AND BYTE#2#00001000) > BYTE#0 (* last.3 *) THEN OUT := BYTE#8;
					ELSIF (last AND BYTE#2#00000100) > BYTE#0 (* last.2 *) THEN OUT := BYTE#4;
					ELSIF (last AND BYTE#2#00000010) > BYTE#0 (* last.1 *) THEN OUT := BYTE#2;
					ELSE OUT := last;
					END_IF;

				3:	(* any input active will disable all other inputs *)
					IF (OUT AND IN) = BYTE#0 THEN
						IF    (IN AND BYTE#2#00001000) > BYTE#0 (* in.3 *) THEN OUT := BYTE#8;
						ELSIF (IN AND BYTE#2#00000100) > BYTE#0 (* in.2 *) THEN OUT := BYTE#4;
						ELSIF (IN AND BYTE#2#00000010) > BYTE#0 (* in.1 *) THEN OUT := BYTE#2;
						ELSE OUT := IN;
						END_IF;
					END_IF;

			END_CASE;
			last := IN;
		END_IF;
		TPP := OUT <> old;
		old := OUT;
	ELSE
		OUT := BYTE#0;
		last := BYTE#0;
		old := BYTE#0;
		lMODE := 0;
		TPP := FALSE;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0

	VAR
		I0 :	BOOL;
		I1 :	BOOL;
		I2 :	BOOL;
		I3 :	BOOL;
		E :	BOOL;
		MODE :	INT;
		OUT :	BYTE;
		TPP :	BOOL;
		func_block : INTERLOCK_4_Block;
	END_VAR
	func_block.I0 := I0;
	func_block.I1 := I1;
	func_block.I2 := I2;
	func_block.I3 := I3;
	func_block.E := E;
	func_block.MODE := MODE;
	func_block();
	OUT := func_block.OUT;
	TPP := func_block.TPP;

END_PROGRAM

