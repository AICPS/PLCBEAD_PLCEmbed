FUNCTION_BLOCK EXEC_Block
	VAR_INPUT
		STR :	STRING;
	END_VAR

	VAR_OUTPUT
		EXEC :	STRING;
	END_VAR

	VAR
		pos :	INT;
		R1 :	REAL;
		R2 :	REAL;
		operator :	STRING;
		temp :	STRING;
		uppercase :	uppercase;
		trim :	trim;
		findB_num :	findB_num;
		findB_nonum :	findB_nonum;
	END_VAR


	trim(str:=str);
	temp:=trim.trim;

	uppercase(str:=temp);
	exec:=uppercase.uppercase;

	findB_nonum(str:=exec);
	pos :=findB_nonum.findB_nonum;

	IF pos > 1 THEN
	temp := LEFT(EXEC,pos-1);
	findB_num(str:=temp);
	IF findB_num.findB_num > 0 THEN
	R1 := STRING_TO_REAL(temp);
	END_IF;
	END_IF;
	temp := RIGHT(exec,LEN(exec)-pos);
	R2 := STRING_TO_REAL(temp);
	exec := LEFT(exec,pos);

	findB_num(str:=exec);
	pos :=findB_num.findB_num;
	operator := RIGHT(exec,LEN(exec) - pos);
	IF EQ_STRING(operator,'') AND LEN(str) = 0 THEN
		exec := '';
		RETURN;
	ELSIF EQ_STRING(operator,'') THEN
		exec := str;
		RETURN;
	END_IF;
	IF EQ_STRING(operator,'^') THEN
		exec := REAL_TO_STRING(EXPT(R1, R2),'%f');
	ELSIF EQ_STRING(operator,'SQRT') THEN
		exec := REAL_TO_STRING(SQRT(R2),'%f');
	ELSIF EQ_STRING(operator,'SIN') THEN
		exec := REAL_TO_STRING(SIN(r2),'%f');
	ELSIF EQ_STRING(operator,'COS') THEN
		exec := REAL_TO_STRING(COS(r2),'%f');
	ELSIF EQ_STRING(operator,'TAN') THEN
		exec := REAL_TO_STRING(TAN(R2),'%f');
	ELSIF EQ_STRING(operator,'*') THEN
		exec := REAL_TO_STRING(R1 * R2,'%f');
	ELSIF EQ_STRING(operator,'/') THEN
		IF R2 <> 0.0 THEN exec := REAL_TO_STRING(R1 / R2,'%f'); ELSE exec := 'ERROR'; END_IF;
	ELSIF EQ_STRING(operator,'+') THEN
		exec := REAL_TO_STRING(r1 + r2,'%f');
	ELSIF EQ_STRING(operator,'-') THEN
		exec := REAL_TO_STRING(r1 - r2,'%f');
	ELSE
		exec := 'ERROR';
	END_IF;
	IF EQ_STRING(EXEC,'ERROR') THEN
		RETURN;
	ELSIF FIND(EXEC,'.') = 0 THEN
		EXEC := CONCAT(EXEC, '.0');
	ELSE
	temp := RIGHT(EXEC,1);
	IF EQ_STRING(temp,'.') THEN
		EXEC := CONCAT(EXEC,'0');
	END_IF;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		STR :	STRING;

		EXEC :	STRING;

		func_block : EXEC_Block;
	END_VAR
	func_block.STR := STR;
	func_block();
	EXEC  := func_block.EXEC;
END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION