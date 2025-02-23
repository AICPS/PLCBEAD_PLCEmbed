TYPE
	oscat_pt_ARRAY: ARRAY [1..100] OF REAL;
	oscat_stack_array: ARRAY [1..32]   OF INT;
END_TYPE

FUNCTION _INT_TO_UDINT:UDINT
	VAR_INPUT
		IN :	INT;
	END_VAR

	_INT_TO_UDINT := DINT_TO_UDINT(INT_TO_DINT(IN));
END_FUNCTION

FUNCTION_BLOCK _ARRAY_SORT2
	VAR_IN_OUT
		PT :	oscat_pt_ARRAY;
	END_VAR

	VAR_INPUT
		SIZE :	UINT;
	END_VAR

	VAR_OUTPUT
		_ARRAY_SORT :BOOL;
	END_VAR

	VAR
		stack_count :	INT;
		stack :	oscat_stack_array;
		links :	INT;
		rechts :	INT;
		pivot :	REAL;
		i :	INT;
		j :	INT;
		ende_innen :	BOOL;
		ende_aussen :	BOOL;
		tmp :	REAL;
		x :	INT;
	END_VAR

	links := 1;
	rechts := DWORD_TO_INT(SHR(UINT_TO_DWORD(size),2)); 
	stack_count := 1; 

	WHILE NOT ende_aussen DO
		IF links < rechts THEN
			x := DWORD_TO_INT(SHR(UDINT_TO_DWORD(_INT_TO_UDINT(rechts)+ _INT_TO_UDINT(links)),1));
			pivot := PT[x];
			i := links - 1;
			j := rechts + 1;

			ende_innen := FALSE;
			REPEAT
				REPEAT	i := i+1;	UNTIL (PT[i] >= pivot) OR NOT (i < rechts)	END_REPEAT;
				REPEAT	j := j-1;	UNTIL (PT[j] <= pivot) OR NOT (j > links)	END_REPEAT;
				IF i >= j THEN
					ende_innen := TRUE;
				ELSE
					tmp := PT[j];
					PT[j] := PT[i];
					PT[i] := tmp;
				END_IF;

			UNTIL ende_innen END_REPEAT;

			stack[stack_count] := rechts;	
			IF Stack_count < 32 THEN
				stack_count := stack_count +1;
			ELSE
				ende_aussen := TRUE;
				_ARRAY_SORT := FALSE;				
			END_IF;
			rechts := MAX(links, i-1);

		ELSE
			IF stack_count = 1 THEN
				ende_aussen := TRUE;
			ELSE
				links := rechts+1;
				stack_count := stack_count - 1;	
				rechts:= stack[stack_count];
			END_IF;
		END_IF;
	END_WHILE;

	_ARRAY_SORT := TRUE;			
END_FUNCTION_BLOCK


PROGRAM program0
  VAR
    LocalVar0 : oscat_pt_ARRAY;
    LocalVar1 : UINT;
	LocalOUT  : BOOL;
	func_block : _ARRAY_SORT2;
  END_VAR
	func_block.pt := LocalVar0;
	func_block.size := LocalVar1;
	func_block();
	LocalOUT := func_block._ARRAY_SORT;

END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION