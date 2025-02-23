FUNCTION_BLOCK FILE_SERVER_Block

	VAR
		buf_size :	UDINT := UDINT#4096;
		handle :	UINT;
		read_max_length :	UDINT;
		file_position :	UDINT;
		used_filename :	STRING;
		close_time :	TIME;
		length_read :	UDINT;
		write_length :	UDINT;
		length_written :	UDINT;
		open_handle :	UINT;
		seek_mode :	UINT;
		seek_position :	UDINT;
		tell_position :	UDINT;
	END_VAR

	VAR
		last_mode :	BYTE;
		command :	BYTE;
		error_code :	BYTE;
		error :	BOOL;
		file_change :	BOOL;
		step :	INT;
		t_diff :	TIME;
		tx_last :	TIME;
		tx :	TIME;
	END_VAR

	VAR_IN_OUT
		FSD :	oscat_FILE_SERVER_DATA;
		PT :	oscat_NETWORK_BUFFER;
	END_VAR

	VAR
		FILE_REMOVE :	FILE_REMOVE;
		FILE_OPEN :	FILE_OPEN;
		FILE_SEEK :	FILE_SEEK;
		FILE_TELL :	FILE_TELL;
		FILE_CLOSE :	FILE_CLOSE;
		FILE_READ :	FILE_READ;
		FILE_WRITE :	FILE_WRITE;
		T_PLC_MS :	T_PLC_MS;
	END_VAR

	T_PLC_MS();
	tx := UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);
	t_diff := tx - tx_last;
	tx_last := tx;

	CASE step OF
	0:
		IF FSD.MODE = LIMIT(BYTE#1,FSD.MODE,BYTE#5) THEN
			close_time := T#1ms;
			IF handle = UINT#00 AND FSD.MODE <= BYTE#3 THEN 
				step := 100; 
			ELSE
				IF EQ_STRING(used_filename, FSD.FILENAME) AND FSD.MODE = last_mode THEN 
					step := 200; 
				ELSE
					step := 32000; 
					file_change := FSD.MODE <> BYTE#5; 
				END_IF;
			END_IF;
		ELSIF handle > UINT#0 THEN 
			IF FSD.AUTO_CLOSE > T#0s THEN
				close_time := close_time + t_diff; 
				IF close_time > FSD.AUTO_CLOSE THEN 
					step := 32000;
				END_IF;
			END_IF;
		END_IF;

	100:
		IF FSD.MODE = BYTE#3 OR FSD.MODE = BYTE#4 THEN
			command := BYTE#7;
			step := 110;
		ELSE
			step := 120;
		END_IF;

	110:
		IF command = BYTE#0  THEN
			IF (FSD.MODE = BYTE#4) OR (error and error_code <> BYTE#143) THEN
				step := 30000;
			ELSE
				step := 120;
			END_IF;
		END_IF;

	120:
		command := BYTE#1; 
		last_mode := FSD.MODE;
		step := 122;

	122: 
		IF command = BYTE#0 THEN
			IF error THEN
				step := 30000; 
			ELSE
				
				close_time := T#1ms; 
				handle := open_handle;
				used_filename := FSD.FILENAME;
				file_position := UDINT#4294967295; 
				FSD.FILE_SIZE := UDINT#0;
				step := 125;
			END_IF;
		END_IF;

	125:
		seek_mode := UINT#2; 
		seek_position := UDINT#0;
		command := BYTE#5; 
		step := 130;

	130: 
		IF command = BYTE#0 THEN
			IF Error THEN
				step := 30000; 
			ELSE
				step := 140;
			END_IF;
		END_IF;

	140: 
		command := BYTE#6;
		step := 150;

	150: 
		IF command = BYTE#0 THEN
			IF Error THEN
				step := 30000; 
			ELSE
				FSD.FILE_SIZE := tell_position;
				file_position := tell_position;
				FSD.FILE_OPEN := TRUE;
				step := 200;
			END_IF;
		END_IF;

	200: 
		IF FSD.OFFSET > FSD.FILE_SIZE THEN 
			error_code := BYTE#255;
			step := 30000; 
		ELSIF FSD.OFFSET <> file_position THEN
			command := BYTE#5; 
			seek_mode := UINT#0; 
			seek_position := FSD.OFFSET;
			step := 210;
		ELSE
			step := 300;
		END_IF;

	210: 
		IF command = BYTE#0 THEN
			file_position := seek_position;
			IF Error THEN
				step := 30000; 
			ELSE
				step := 300;
			END_IF;
		END_IF;

	300:
		IF FSD.MODE = BYTE#1 THEN
			step := 400;
		ELSE
			step := 500; 
		END_IF;

	400:
		IF UINT_TO_UDINT(PT.SIZE) > buf_size THEN 
			read_max_length := buf_size;
		ELSE
			read_max_length := UINT_TO_UDINT(PT.SIZE);
		END_IF;


		IF file_position + read_max_length > FSD.FILE_SIZE THEN
			read_max_length := FSD.FILE_SIZE - file_position;
		END_IF;

		IF read_max_length > UDINT#0 THEN
			command := BYTE#3; 
			step := INT#410;
		ELSE
			PT.SIZE := UINT#0;
			step := 30000;
		END_IF;

	410: 
		IF command = BYTE#0 THEN
			PT.SIZE := UDINT_TO_UINT(length_read);
			IF NOT Error THEN
				file_position := file_position + length_read; 
				FSD.OFFSET := file_position;
			END_IF;
			step := 30000; 
		END_IF;

	500:
		IF UINT_TO_UDINT(PT.SIZE) > buf_size THEN 
			write_length := buf_size;
		ELSE
			write_length := UINT_TO_UDINT(PT.SIZE);
		END_IF;

		IF write_length > UDINT#0 THEN
			command := BYTE#4; 
			step := INT#510;
		ELSE
			step := 30000;
		END_IF;

	510:
		IF command = BYTE#0 THEN
			IF NOT Error THEN
				file_position := file_position + length_written;
				FSD.OFFSET := file_position;
				IF file_position > FSD.FILE_SIZE THEN 
					FSD.FILE_SIZE := file_position;
				END_IF;
			END_IF;
			step := 30000; 
		END_IF;

	30000: 
		FSD.MODE := BYTE#0;
		FSD.ERROR := error_code;
		step := 0;

	32000:
		close_time := T#0s; 
		IF handle > UINT#0 THEN
			command := BYTE#2; 
		END_IF;
		step := 32100;

	32100:
		IF command = BYTE#0 THEN 
			FSD.FILE_OPEN := FALSE;
			file_position := UDINT#0;
			FSD.FILE_SIZE := UDINT#0;
			FSD.OFFSET := UDINT#0;
			used_filename := '';
			handle := UINT#00;

			IF file_change THEN
				file_change := FALSE;
				step := 100;
			ELSE 
				step := 30000;
			END_IF;
		END_IF;

	END_CASE;

	FILE_OPEN.Execute := command = BYTE#1;
	FILE_OPEN.Name := FSD.FILENAME;
	FILE_OPEN();
	open_handle := FILE_OPEN.Handle;

	IF command = BYTE#1 THEN
		IF FILE_OPEN.Done THEN
			error := FILE_OPEN.Error;
			command := BYTE#0;
			error_code := SEL_BYTE(error,BYTE#00,UINT_TO_BYTE(FILE_OPEN.ErrorID));
		END_IF;
	END_IF;

	FILE_CLOSE.Execute := command = BYTE#2;
	FILE_CLOSE.Handle := Handle;
	FILE_CLOSE();

	IF command = BYTE#2 THEN
		IF FILE_CLOSE.Done THEN
			error := FILE_CLOSE.Error;
			command := BYTE#0;
			error_code := SEL_BYTE(error,BYTE#00,UINT_TO_BYTE(FILE_CLOSE.ErrorID + UINT#10)); 
		END_IF;
	END_IF;

	FILE_READ.Execute := command = BYTE#3;
	FILE_READ.Handle := handle;
	FILE_READ.MaxLength := read_max_length;
	FILE_READ.Buffer := PT.BUFFER;
	FILE_READ();
	PT.BUFFER := FILE_READ.Buffer;

	IF command = BYTE#3 THEN
		IF FILE_READ.Done THEN
			error := FILE_READ.Error;
			command := BYTE#0;
			length_read :=  FILE_READ.LengthRead;
			error_code := SEL_BYTE(error,BYTE#00,UINT_TO_BYTE(FILE_READ.ErrorID + UINT#40));
		END_IF;
	END_IF;

	FILE_WRITE.Execute   := command = BYTE#4;
	FILE_WRITE.Handle    := handle;
	FILE_WRITE.Length    := write_length ;
	FILE_WRITE.Buffer    := PT.BUFFER;
	FILE_WRITE();
	PT.BUFFER := FILE_WRITE.Buffer;

	IF command = BYTE#4 THEN
		IF FILE_WRITE.Done THEN
			error := FILE_WRITE.Error;
			command := BYTE#0;
			length_written := write_length; 
			error_code := SEL_BYTE(error,BYTE#00,UINT_TO_BYTE(FILE_WRITE.ErrorID + UINT#70)); 
		END_IF;
	END_IF;

	FILE_SEEK.Execute  := command = BYTE#5;
	FILE_SEEK.Handle   := handle;
	FILE_SEEK.Mode     := seek_mode;
	FILE_SEEK.Position := UDINT_TO_DINT(seek_position);
	FILE_SEEK();

	IF command = BYTE#5 THEN
		IF FILE_SEEK.Done THEN
			error := FILE_SEEK.Error;
			command := BYTE#0;
			error_code := SEL_BYTE(error,BYTE#00,UINT_TO_BYTE(FILE_SEEK.ErrorID + UINT#100)); 
		END_IF;
	END_IF;

	FILE_TELL.Execute := command = BYTE#6;
	FILE_TELL.Handle := handle;
	FILE_TELL();

	IF command = BYTE#6 THEN
		IF FILE_TELL.Done THEN
			error := FILE_TELL.Error;
			command := BYTE#0;
			tell_position := DINT_TO_UDINT(FILE_TELL.Position);
			error_code := SEL_BYTE(error,BYTE#00,UINT_TO_BYTE(FILE_TELL.ErrorID + UINT#130));
		END_IF;
	END_IF;

	FILE_REMOVE.Execute := command = BYTE#7;
	FILE_REMOVE.Name := FSD.FILENAME;
	FILE_REMOVE();

	IF command = BYTE#7 THEN
		IF FILE_REMOVE.Done THEN
			error := FILE_REMOVE.Error;
			command := BYTE#0;
			error_code := SEL_BYTE(error,BYTE#00,UINT_TO_BYTE(FILE_REMOVE.ErrorID + UINT#140)); 
		END_IF;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		FSD :	oscat_FILE_SERVER_DATA;
		PT :	oscat_NETWORK_BUFFER;

		func_block : FILE_SERVER_Block;
	END_VAR
	func_block.FSD := FSD;
	func_block.PT := PT;

	func_block();
	FSD  := func_block.FSD;
	PT  := func_block.PT;
END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION