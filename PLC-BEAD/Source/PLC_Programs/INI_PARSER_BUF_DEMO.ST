PROGRAM INI_PARSER_BUF_DEMO

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
		IPB :	INI_PARSER_BUF;
		FS :	FILE_SERVER;
		FSD :	oscat_FILE_SERVER_DATA;
		PT :	oscat_NETWORK_BUFFER;
		section :	INT;
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

	00:	IF NOT done then
			FSD.FILENAME := 'config.ini'; 
			FSD.MODE := BYTE#1; 
			FSD.OFFSET := UDINT#0;
			FSD.AUTO_CLOSE := T#0s; 
			PT.SIZE := UINT#65535; 
			step := 10;	
		END_IF;

	10:	IF FSD.MODE = BYTE#0 THEN
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
				step := 80;
			END_IF;
		END_IF;

	80:	IF FSD.MODE = BYTE#0 THEN 
			done := TRUE;
			step := 0;
		END_IF;

	END_CASE;

	IPB(STR:=str,RUN:=run,OFFSET:=offset,KEY:=key,VALUE:=value,PT:=PT);
	str:=IPB.STR;
	run:=IPB.RUN;
	offset:=IPB.OFFSET;
	key:=IPB.KEY;
	value:=IPB.VALUE;
	PT:=IPB.PT;
	result:=IPB.RESULT;

	FS(FSD:=FSD,PT:=PT);
	FSD:=FS.FSD;
	PT:=FS.PT;

END_PROGRAM
