TYPE
  oscat_VMAP_DATA :
  STRUCT
	FC       : DWORD;
    V_ADR    : INT;	
    V_SIZE   : INT;
    P_ADR    : INT;
	TIME_OUT : TIME;
  END_STRUCT;

  oscat_MB_VMAP : ARRAY [1..10] OF oscat_VMAP_DATA;

  csv_parser_demo_col : ARRAY [1..4] OF REAL;
  csv_parser_demo     : ARRAY [1..2] OF csv_parser_demo_col;

END_TYPE

FUNCTION_BLOCK MB_VMAP_Block

	VAR_IN_OUT
		VMAP :	oscat_MB_VMAP;
	END_VAR


	VAR_INPUT
		FC :	INT;
		V_ADR :	INT;
		V_CNT :	INT;
		SIZE :	INT;
	END_VAR


	VAR_OUTPUT
		P_ADR :	INT;
		P_BIT :	INT;
		ERROR :	BYTE;
	END_VAR


	VAR
		i :	INT;
		vopt :	DWORD;
		vadr :	INT;
		padr :	INT;
		mask :	DWORD;
		vsize :	INT;
		w_tmp :	WORD;
		i_tmp :	INT;
		init :	BOOL;
	END_VAR

	IF init = FALSE THEN
		init := TRUE;
		IF VMAP[1].FC = DWORD#0 THEN
			VMAP[1].FC := DWORD#16#FFFF_FFFF;
			VMAP[1].V_ADR := 0;
			VMAP[1].V_SIZE := 256;
			VMAP[1].P_ADR := 0;
		END_IF;
	END_IF;

	ERROR := BYTE#02; 
	mask := SHL(DWORD#1,FC);

	IF (mask AND DWORD#2#00000000_01000000_00000000_01100000) <> DWORD#0 THEN 
		V_CNT := 1;
	ELSIF V_CNT = 0 THEN
		RETURN;
	END_IF;

	FOR i := 1 TO 10 DO
		vopt := VMAP[i].FC; 
		IF (vopt AND mask) <> DWORD#0 THEN
			vadr := VMAP[i].V_ADR;
			vsize := VMAP[i].V_SIZE;
			padr := VMAP[i].P_ADR;

			IF (mask AND DWORD#2#00000000_00000000_10000000_00100110) <> DWORD#0 THEN
				i_tmp := WORD_TO_INT(SHR(INT_TO_WORD(V_ADR + V_CNT -1),4))+1;
				IF i_tmp <= SIZE AND i_tmp <= vsize THEN
					w_tmp := INT_TO_WORD(V_ADR);
					P_ADR := WORD_TO_INT(SHR(w_tmp,4)) + padr; 
					P_BIT := WORD_TO_INT(w_tmp AND WORD#16#000F);
					ERROR := BYTE#0;
					EXIT;
				END_IF;
			ELSIF (mask AND DWORD#2#00000000_11000001_00000000_01011000) <> DWORD#0 THEN 
				IF V_ADR >= vadr AND V_ADR + V_CNT <= vadr + vsize THEN 
					P_ADR := V_ADR - vadr + padr;
					IF P_ADR + V_CNT <= SIZE THEN 
						ERROR := BYTE#0;
						EXIT;
					END_IF;
				END_IF;
			ELSE
				ERROR := BYTE#01;
				RETURN;
			END_IF;
		END_IF;
	END_FOR;

	IF ERROR = BYTE#0 THEN
		IF (mask AND DWORD#2#00000000_11000001_10000000_01100000) <> DWORD#0 THEN 
			VMAP[i].TIME_OUT := T#1ms;
		END_IF;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		VMAP :	oscat_MB_VMAP;
		FC :	INT;
		V_ADR :	INT;
		V_CNT :	INT;
		SIZE :	INT;
		P_ADR :	INT;
		P_BIT :	INT;
		ERROR :	BYTE;

		func_block : MB_VMAP_Block;
	END_VAR
	func_block.VMAP := VMAP;
	func_block.V_ADR := V_ADR;
	func_block.FC := FC;
	func_block.V_CNT := V_CNT;
	func_block.SIZE := SIZE;

	func_block();
  	VMAP  := func_block.VMAP;
	P_ADR  := func_block.P_ADR;
	P_BIT  := func_block.P_BIT;
	ERROR  := func_block.ERROR;
END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION