FUNCTION_BLOCK ASTRO
	VAR_INPUT
		M :	REAL;
		AE :	REAL;
		PC :	REAL;
		LJ :	REAL;
	END_VAR

	VAR_OUTPUT
		YM :	REAL;
		YAE :	REAL;
		YPC :	REAL;
		YLJ :	REAL;
	END_VAR

	YAE :=	AE + M * 6.6845871535E-012
			+ PC * 206265.0
			+ LJ * 63240.0;
	YM := YAE * 149.597870E9;
	YPC := YAE * 4.8481322570E-006;
	YLJ := YAE * 1.5812776724E-005;
END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : REAL;
    LocalVaR1  : REAL;
	LocalVaR2 : REAL;
	LocalVar3 : REAL;
	LocalOUT1 : REAL;
	LocalOUT2 : REAL;
	LocalOUT3 : REAL;
	LocalOUT4 : REAL;
	func_block : ASTRO;
  END_VAR
	func_block.M  := LocalVar0;
	func_block.AE := LocalVaR1 ;
	func_block.PC := LocalVaR2;
	func_block.LJ := LocalVar3;
	func_block();
	LocalOUT1 := func_block.YM ;
	LocalOUT2 := func_block.YAE;
	LocalOUT3 := func_block.YPC;
	LocalOUT4 := func_block.YLJ;

END_PROGRAM

