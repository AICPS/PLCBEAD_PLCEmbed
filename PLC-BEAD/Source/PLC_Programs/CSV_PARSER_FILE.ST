TYPE
  oscat_FILE_SERVER_DATA : STRUCT
	FILE_OPEN	: BOOL;
    FILENAME 	: STRING;
    MODE	 	: BYTE;
    OFFSET   	: UDINT;
    FILE_SIZE   : UDINT;
    AUTO_CLOSE	: TIME;
    ERROR	 	: BYTE;
  END_STRUCT;
END_TYPE

TYPE
	oscat_arb_0_249 			  : ARRAY [0..249] 	OF BYTE;
END_TYPE

TYPE
  oscat_NW_BUF_LONG  : ARRAY [0..4095] OF BYTE;
  oscat_NETWORK_BUFFER :
  STRUCT
    SIZE   : UINT;	
    BUFFER : oscat_NW_BUF_LONG;
  END_STRUCT;
END_TYPE

FUNCTION_BLOCK FILE_BLOCK

	VAR_IN_OUT
		MODE :	BYTE;
		FILENAME :	STRING;
		FSD :	oscat_FILE_SERVER_DATA;
		PT :	oscat_NETWORK_BUFFER;
	END_VAR

	VAR_INPUT
		POS :	UDINT;
	END_VAR

	VAR_OUTPUT
		ERROR :	BYTE;
		DATA :	BYTE;
	END_VAR

	VAR
		steppp :	INT;
		i :	INT;
		data_start :	UDINT;
		data_stop :	UDINT;
	END_VAR

	CASE steppp OF
	0:	IF MODE > BYTE#0 THEN
			ERROR := BYTE#0;
			IF FSD.FILE_OPEN AND (FSD.FILE_SIZE = UDINT#0 OR POS >= FSD.FILE_SIZE) THEN
				ERROR := BYTE#255;
				MODE := BYTE#0;
			ELSIF POS < data_start OR POS > data_stop OR NOT FSD.FILE_OPEN THEN (* Daten lesen notwendig *)
				FSD.FILENAME := FILENAME;
				FSD.MODE := BYTE#1; (* open + read *)
				FSD.OFFSET := POS;
				PT.SIZE := UINT#65535; 
				data_start := UDINT#0;
				data_stop := UDINT#0;
				steppp := 10;
			ELSE (* Daten sind im Buffer vorhanden *)
				i := UDINT_TO_INT(POS - data_start); (* index berechnen *)
				DATA := PT.BUFFER[i];
				MODE := BYTE#0;
				(* ---------------------- Debug-Message ----------------------------*)
				(*IF _debug_enable THEN
					LOG_CL.NEW_MSG := 'FB: Pos: ~1 Byte: ~2 >~3<';
					LOG_CL.PRINTF[1] := UDINT_TO_STRING(POS,'%03u');
					LOG_CL.PRINTF[2] := BYTE_TO_STRING(DATA,'%03u');
					LOG_CL.PRINTF[3] := BYTE_TO_STRING(DATA,'%c');
					LOG_MSG();
				END_IF;*)
				(* -----------------------------------------------------------------*)
			END_IF;
		END_IF;

	10:	IF FSD.MODE = BYTE#0 THEN (* Befehl beendet *)
			IF FSD.ERROR > BYTE#0 THEN
				ERROR := FSD.ERROR; (* Fehler ausgeben *)
				MODE := BYTE#0;
			ELSE
				data_start := POS;
				data_stop := POS + UINT_TO_UDINT(PT.SIZE) - UDINT#1;
			END_IF;
			steppp := 0;
		END_IF;
	END_CASE;
END_FUNCTION_BLOCK

FUNCTION_BLOCK CSV_PARSER_FILE
	VAR_INPUT
		SEP :	BYTE;
	END_VAR

	VAR_IN_OUT
		FILENAME :	STRING;
		FSD :	oscat_FILE_SERVER_DATA;
		RUN :	BYTE;
		OFFSET :	UDINT;
		VALUE :	STRING;
		PT :	oscat_NETWORK_BUFFER;
	END_VAR
	

	VAR_OUTPUT
		RESULT :	BYTE;
	END_VAR


	VAR
		FB :	FILE_BLOCK;
		i :	UDINT;
		state :	BYTE;
		e :	BYTE;
		mode :	BYTE;
		stepp :	INT;
		c :	BYTE;
		v_add :	BYTE;
		v_idx :	INT;
		v_buf :	oscat_arb_0_249;
		BUFFER_TO_STRING :	BUFFER_TO_STRING;
		eof :	BOOL;
		watchdog :	TON;
		x :	BOOL;
	END_VAR

	IF RUN > BYTE#0 THEN

		IF state = BYTE#0 THEN
			VALUE := '';
			v_idx := 0;
			i := OFFSET;
			RESULT := BYTE#0;
			state := BYTE#5; (* Befehl in Arbeit (Busy) *)
			stepp := 0; (* Auswertung neu beginnen *)

		END_IF;

		watchdog(IN:=FALSE,PT:=T#1ms); (* Timer neustarten *)
		watchdog.IN := TRUE;

		WHILE (state = BYTE#5) DO (* Schleife solange kein Ergebnis *)

			mode := BYTE#1;
			FB(MODE:=mode,FSD:=fsd,PT:=PT,FILENAME:=FILENAME,POS:=i);
			FILENAME:=FB.FILENAME;
			mode:=FB.MODE;
			fsd:=FB.FSD;
			PT:=FB.PT;
			e:=FB.ERROR;
			c:=FB.DATA;

			eof := i + UDINT#1 = FSD.FILE_SIZE; (* End of File *)
			watchdog(); (* Timer aktualisieren *)

			IF mode > BYTE#0 OR watchdog.Q THEN (* Baustein noch aktiv, oder watchdog ausgel�st *)
				state := BYTE#5;
				EXIT;
			ELSIF e > BYTE#0 THEN (* File_error oder kein weiteres zeichen vorhanden *)
				state := BYTE#10; (* nichts gefunden - Daten-Ende erreicht *)
				EXIT;
			ELSE

				v_add := BYTE#0;

				IF c = SEP THEN (* Neues Element erkannt *)
					state := BYTE#1;
					x := TRUE;
				ELSIF c >= BYTE#32 THEN (* Element erkannt *)
					v_add := c; (* Zeichen ablegen *)
					IF eof THEN
						state := BYTE#2; (* Element und Zeilenende erkannt *)
					ELSE
						x := TRUE;
					END_IF;
				ELSE
					IF x THEN
						state := BYTE#2; (* Element und Zeilenende erkannt *)
						x := FALSE;
					END_IF;
				END_IF;

				IF v_add > BYTE#0 AND v_idx < 250 THEN (* Zeichen zu Value-String hinzuf�gen *)
					v_buf[v_idx] := v_add;
					v_idx := v_idx + 1;
				END_IF;

				i := i + UDINT#1; (* Datenzeiger erh�hen *)

			END_IF;
		END_WHILE;

		IF (state = BYTE#1 OR state = BYTE#2) AND v_idx > 0 THEN (* VALUE-String ausgeben *)
			BUFFER_TO_STRING(PT:=v_buf,SIZE:=INT_TO_UINT(v_idx),START:=UINT#0,STOP:=UINT#249);
			v_buf := BUFFER_TO_STRING.PT;
			VALUE := BUFFER_TO_STRING.BUFFER_TO_STRING;
		END_IF;

		CASE _BYTE_TO_INT(state) OF
		01:	(* Element gefunden *)
			RESULT := BYTE#1; (* Element gefunden *)
			OFFSET := i; (* Offset uebernehmen *)
			RUN := BYTE#0;
			state := BYTE#0;
		02:	(* Element gefunden *)
			RESULT := BYTE#2; (* Element und Zeilenende erkannt *)
			OFFSET := i; (* Offset uebernehmen *)
			RUN := BYTE#0;
			state := BYTE#0;

		05:	RESULT := BYTE#5; (* in Arbeit *)

		10:	
			RESULT := BYTE#10; (* nichts gefunden - Datenende erreicht *)
			OFFSET := i; (* Offset uebernehmen *)
			RUN := BYTE#0;
			state := BYTE#0;
		END_CASE;
	END_IF;
END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	SEP      :	BYTE;
	FILENAME :	STRING;
	FSD      :	oscat_FILE_SERVER_DATA;
	RUN      :	BYTE;
	OFFSET   :	UDINT;
	VALUE    :	STRING;
	PT       :	oscat_NETWORK_BUFFER;
	RESULT   :	BYTE;

	func_block : CSV_PARSER_FILE;
  END_VAR
	func_block.SEP      :=SEP     ;
	func_block.FILENAME :=FILENAME;
	func_block.FSD      :=FSD     ;
	func_block.RUN      :=RUN     ;
	func_block.OFFSET   :=OFFSET  ;
	func_block.VALUE    :=VALUE   ;
	func_block.PT       :=PT      ;

	func_block();
	FILENAME := func_block.FILENAME;
	FSD      := func_block.FSD     ;
	RUN      := func_block.RUN     ;
	OFFSET   := func_block.OFFSET  ;
	VALUE    := func_block.VALUE   ;
	PT       := func_block.PT      ;
	RESULT   := func_block.RESULT  ;
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION