FUNCTION_BLOCK FLOW_CONTROL_4
	VAR_INPUT
		I0 :	BOOL;
		I1 :	BOOL;
		I2 :	BOOL;
		I3 :	BOOL;
		PR :	BOOL;
		ICE :	BOOL;
		DIAG :	BOOL;
		ENQ :	BOOL;
		RST :	BOOL := FALSE;
		TD_WAIT :	TIME := T#5s;
		TD_S :	TIME := T#10s;
		TD_0 :	TIME := T#10s;
	END_VAR


	VAR_OUTPUT
		QS :	BOOL;
		Q0 :	BOOL;
		Q1 :	BOOL;
		Q2 :	BOOL;
		Q3 :	BOOL;
		ERROR :	BOOL;
		STATUS :	BYTE;
	END_VAR


	VAR
		state :	INT;
		timer :	TP;
	END_VAR


	IF RST THEN
		STATUS := BYTE#100;
		state := 0;
		ERROR := FALSE;

	ELSIF DIAG THEN
		CASE state OF
			0 : (* START diag operation *)
				(* close all VALVEs and pressurize the system *)
				QS := TRUE;
				Q0 := FALSE;
				Q1 := FALSE;
				Q2 := FALSE;
				Q3 := FALSE;
				timer(IN := TRUE, PT := TD_WAIT);
				timer.IN := FALSE;
				state := 1;
			1 : (* wait for TD_wait *)
				timer();
				IF NOT timer.Q THEN
					QS := FALSE;
					timer(IN := TRUE, PT := TD_S);
					timer.IN := FALSE;
					state := 2;
				END_IF;
			2:	(* wait for safety VALVE pressure test *)
				timer();
				IF NOT timer.Q THEN
					IF NOT PR THEN
						(* system pressure failure *)
						ERROR := TRUE;
						STATUS := BYTE#1;
						RETURN;
					END_IF;
					timer(IN := TRUE, PT := TD_0);
					timer.IN := FALSE;
					Q0 := TRUE;
					state := 3;
				END_IF;
			3:	(* wait for pressure on Q0 to hold TD_0 *)
				timer();
				IF NOT timer.Q THEN
					IF NOT PR THEN
						(* VALVE 0 pressure failure *)
						ERROR := TRUE;
						STATUS := BYTE#1;
						RETURN;
					END_IF;
					Q0 := FALSE;
					QS := TRUE;
				END_IF;
		END_CASE;
	ELSIF ICE THEN
		(* when frost is present we close the safety VALVE and open all other VALVEs to depressurize the VALVEs *)
		QS := FALSE;
		Q0 := TRUE;
		Q1 := TRUE;
		Q2 := TRUE;
		Q3 := TRUE;
		STATUS := BYTE#110;

	ELSIF NOT ERROR AND ENQ THEN
			Q0 := I0;
			Q1 := I1;
			Q2 := I2;
			Q3 := I3;
			QS := Q0 OR Q1 OR Q2 OR Q3;
			STATUS := BYTE#100;

			(* maximum ontime check *)
	ELSE
		Q0 := FALSE;
		Q1 := FALSE;
		Q2 := FALSE;
		Q3 := FALSE;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
		I0   :	BOOL;
		I1   :	BOOL;
		I2   :	BOOL;
		I3   :	BOOL;
		PR   :	BOOL;
		ICE  :	BOOL;
		DIAG :	BOOL;
		ENQ  :	BOOL;
		RST  :	BOOL ;
		TD_WAIT :	TIME;
		TD_S    :	TIME;
		TD_0    :	TIME;

		QS     :	BOOL;
		Q0     :	BOOL;
		Q1     :	BOOL;
		Q2     :	BOOL;
		Q3     :	BOOL;
		ERROR  :	BOOL;
		STATUS :	BYTE;

	func_block : FLOW_CONTROL_4;
  END_VAR
	func_block.I0  :=I0  ;
	func_block.I1  :=I1  ;
	func_block.I2  :=I2  ;
	func_block.I3  :=I3  ;
	func_block.PR  :=PR  ;
	func_block.ICE :=ICE ;
	func_block.DIAG:=DIAG;
	func_block.ENQ :=ENQ ;
	func_block.RST :=RST ;
	func_block.TD_WAIT:=TD_WAIT;
	func_block.TD_S   :=TD_S   ;
	func_block.TD_0   :=TD_0   ;
	func_block();
	QS    := func_block.QS    ;
	Q0    := func_block.Q0    ;
	Q1    := func_block.Q1    ;
	Q2    := func_block.Q2    ;
	Q3    := func_block.Q3    ;
	ERROR := func_block.ERROR ;
	STATUS:= func_block.STATUS;
	 
	 
END_PROGRAM

