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
		_TP :	BOOL;
	END_VAR

	VAR
		in :	BYTE;
		last :	BYTE;
		old :	BYTE;
		lmode :	INT;
	END_VAR

	IF E THEN
	(* reset all vars when there is a mode change on thy fly *)
		IF mode <> lmode THEN
			out := BYTE#0;
			last := BYTE#0;
			old := BYTE#0;
			lmode := mode;
		END_IF;
		(* load inputs into in *)
		in:=BIT_LOAD_B(in,I0,0); (* in.0 *)
		in:=BIT_LOAD_B(in,I1,1); (* in.1 *)
		in:=BIT_LOAD_B(in,I2,2); (* in.2 *)
		in:=BIT_LOAD_B(in,I3,3); (* in.3 *)
		(* only execute when there is any change *)
		IF in <> last THEN
			(* only execute when inputs have chages state *)
			CASE mode OF
				0:	(* output directly display inputs as bits in byte out *)
					out := in;

				1:	(* the input with the highest number will be acepted *)
					IF    (in AND BYTE#2#00001000) > BYTE#0 (* in.3 *) THEN out := BYTE#8;
					ELSIF (in AND BYTE#2#00000100) > BYTE#0 (* in.2 *) THEN out := BYTE#4;
					ELSIF (in AND BYTE#2#00000010) > BYTE#0 (* in.1 *) THEN out := BYTE#2;
					ELSE out := in;
					END_IF;

				2:	(* input last pressed will be displayed only *)
					last := ((in XOR last) AND in);
					IF    (last AND BYTE#2#00001000) > BYTE#0 (* last.3 *) THEN out := BYTE#8;
					ELSIF (last AND BYTE#2#00000100) > BYTE#0 (* last.2 *) THEN out := BYTE#4;
					ELSIF (last AND BYTE#2#00000010) > BYTE#0 (* last.1 *) THEN out := BYTE#2;
					ELSE out := last;
					END_IF;

				3:	(* any input active will disable all other inputs *)
					IF (out AND in) = BYTE#0 THEN
						IF    (in AND BYTE#2#00001000) > BYTE#0 (* in.3 *) THEN out := BYTE#8;
						ELSIF (in AND BYTE#2#00000100) > BYTE#0 (* in.2 *) THEN out := BYTE#4;
						ELSIF (in AND BYTE#2#00000010) > BYTE#0 (* in.1 *) THEN out := BYTE#2;
						ELSE out := in;
						END_IF;
					END_IF;

			END_CASE;
			last := in;
		END_IF;
		_tp := out <> old;
		old := out;
	ELSE
		out := BYTE#0;
		last := BYTE#0;
		old := BYTE#0;
		lmode := 0;
		_tp := FALSE;
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
		_TP :	BOOL;
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
	_TP := func_block._TP;

END_PROGRAM

CONFIGURATION Config0

	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE

END_CONFIGURATION