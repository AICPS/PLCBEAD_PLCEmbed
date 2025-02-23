PROGRAM INI_PARSER_FILE_DEMO

	VAR

	END_VAR


	VAR_EXTERNAL

	END_VAR

	VAR
		SMTP_SERVER :	STRING;
		SMTP_FROM :	STRING;
		STATION_NAME :	STRING;
		STATION_IP :	STRING;
	END_VAR

	VAR
		IPF :	INI_PARSER_FILE;
		FS :	FILE_SERVER;
		FSD :	oscat_FILE_SERVER_DATA;
		PT :	oscat_NETWORK_BUFFER;
		section :	INT;
		filename :	STRING;
		key :	oscat_STRING250;
		value :	oscat_STRING250;
		str :	oscat_STRING250;
		step :	INT;
		result :	BYTE;
		offset :	UDINT;
		run :	BYTE;
		done :	BOOL;
	END_VAR

	CASE step OF

	00:	IF NOT done THEN
			filename := 'config.ini'; 
			offset := UDINT#0; 
			str := '';
			run := BYTE#3; 
			step := 50;	
		END_IF;

	50:	IF run = BYTE#0 THEN

			run := BYTE#3;

			IF result = BYTE#1 THEN 
				IF EQ_STRING(key,'Station') THEN
					section := 1;
				ELSIF EQ_STRING(key,'SMTP') THEN
					section := 2;

				ELSE
					section := 0; 
				END_IF;

			ELSIF result = BYTE#2 AND section > 0 THEN 

				CASE section OF

				1:  
					IF EQ_STRING(key,'NAME') THEN
						STATION_NAME := value; 
					ELSIF EQ_STRING(key,'IP') THEN
						STATION_IP := value; 
					END_IF;

				2:  
					IF EQ_STRING(key,'SERVER') THEN
						SMTP_SERVER := value; 
					ELSIF EQ_STRING(key,'FROM') THEN
						SMTP_FROM := value; 
					END_IF;

				END_CASE;

			ELSIF result = BYTE#10 THEN 
				run := BYTE#0;
				FSD.MODE := BYTE#5; 
				step := 30;
			END_IF;
		END_IF;

	30:	IF FSD.MODE = BYTE#0 THEN
			step := 0;
			done := TRUE;
		END_IF;

	END_CASE;

	IPF(FILENAME:=FILENAME,FSD:=FSD,STR:=str,RUN:=run,OFFSET:=offset,KEY:=key,VALUE:=value,PT:=PT);
	FILENAME:=IPF.FILENAME;
	FSD:=IPF.FSD;
	str:=IPF.STR;
	run:=IPF.RUN;
	offset:=IPF.OFFSET;
	key:=IPF.KEY;
	value:=IPF.VALUE;
	PT:=IPF.PT;
	result:=IPF.RESULT;

	FS(FSD:=FSD,PT:=PT);
	FSD:=FS.FSD;
	PT:=FS.PT;

END_PROGRAM
