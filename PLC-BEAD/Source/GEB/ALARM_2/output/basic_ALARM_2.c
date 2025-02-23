/* --------------------------------------------------
 * This code has been automatically generated using 
 * GEB Automation IDE   https://www.gebautomation.com/
 * Version 3.2.15.107 	2022-06-29
 * ----------------------------------------------- */

#include <gebiec.h>	/* provided by GEB - includes geblib.h and geb.h */
#include <gebdebug.h>	/* provided by GEB - for debugging */
#include <gebud.h>	/* user defined, usually native functions provided by OEM */ 

/* --- begin literals decl --- */
/* --- end literals decl --- */
void Literals_init(void) {
} /* --- end literals init--- */
void Literals_destroy(void) {
} /* --- end literals destroy --- */

/* ---- module basic_ALARM_2 datatypes ----- */
/* ------------------- POUS HEADERS ----------------------*/
/* ---- module=basic_ALARM_2----- */
/* ---- pou=ALARM_2 pouId=2 begin header --- */
 /* basic_ALARM_2/ALARM_2.ST:1 	FUNCTION_BLOCK ALARM_2 */
typedef struct dt_FB_ALARM_2 {
	REAL_t v_HI_1;
	REAL_t v_HI_2;
	REAL_t v_HYS;
	REAL_t v_LO_1;
	REAL_t v_LO_2;
	REAL_t v_X;
	REAL_t v_tmp;
	BOOL_t v_EN;
	BOOL_t v_ENO;
	BOOL_t v_Q1_HI;
	BOOL_t v_Q1_LO;
	BOOL_t v_Q2_HI;
	BOOL_t v_Q2_LO;
} dt_FB_ALARM_2;
typedef dt_FB_ALARM_2 *dt_FB_ALARM_2_P;

void dt_FB_ALARM_2_copy(dt_FB_ALARM_2_P self,dt_FB_ALARM_2_P o);
void dt_FB_ALARM_2_init(dt_FB_ALARM_2_P self);
#ifdef GEB_DEBUG_MODE
#define dt_FB_ALARM_2_dump(s) dt_FB_ALARM_2_dump2(s,NULL,VARS_REPORT_WHAT_OUTPUT)
void dt_FB_ALARM_2_dump2(dt_FB_ALARM_2_P self,void *  aut, int mode);
#endif

#ifdef GEB_DEBUG_MODE
int dt_FB_ALARM_2_wv(dt_FB_ALARM_2_P self, void *  aut, int vnum, DEBUG_WV_VAL VAL);
#endif

#ifndef SUPPRESS_FORMATTED_OUTPUT
void dt_FB_ALARM_2_printVars(dt_FB_ALARM_2_P self, int indent, int detail);
#define dt_FB_ALARM_2_print(s,indent) dt_FB_ALARM_2_printVars(s,indent,1)
#endif
void dt_FB_ALARM_2_exec(dt_FB_ALARM_2_P self);
/* ---- ALARM_2 end header --- */
/* ---- pou=program0 pouId=3 begin header --- */
 /* basic_ALARM_2/ALARM_2.ST:35 	PROGRAM program0 */
typedef struct dt_PR_program0 {
	dt_FB_ALARM_2 v_func_block;
	REAL_t v_LocalVar0;
	REAL_t v_LocalVar1;
	REAL_t v_LocalVar2;
	REAL_t v_LocalVar3;
	REAL_t v_LocalVar4;
	REAL_t v_LocalVar5;
	BOOL_t v_LocalOUT1;
	BOOL_t v_LocalOUT2;
	BOOL_t v_LocalOUT3;
	BOOL_t v_LocalOUT4;
} dt_PR_program0;
typedef dt_PR_program0 *dt_PR_program0_P;

void dt_PR_program0_copy(dt_PR_program0_P self,dt_PR_program0_P o);
void dt_PR_program0_init(dt_PR_program0_P self);
#ifdef GEB_DEBUG_MODE
#define dt_PR_program0_dump(s) dt_PR_program0_dump2(s,NULL,VARS_REPORT_WHAT_OUTPUT)
void dt_PR_program0_dump2(dt_PR_program0_P self,void *  aut, int mode);
#endif

#ifdef GEB_DEBUG_MODE
int dt_PR_program0_wv(dt_PR_program0_P self, void *  aut, int vnum, DEBUG_WV_VAL VAL);
#endif

#ifndef SUPPRESS_FORMATTED_OUTPUT
void dt_PR_program0_printVars(dt_PR_program0_P self, int indent, int detail);
#define dt_PR_program0_print(s,indent) dt_PR_program0_printVars(s,indent,1)
#endif
void dt_PR_program0_exec(dt_PR_program0_P self);
/* ---- program0 end header --- */
/* ------------------- AT VARS ----------------------*/
#ifndef ATVARS_ALLOCATED_BY_DEVICE
/* ATVARS_ALLOCATED_BY_DEVICE (see gebdrv.h) signals that AT variables are allocated not here 
 but by the device implementation */ 
typedef struct {
	int dummyNoAtVars; /* no at vars - dummy field so that compilers don't get mad */
} ATvars;
ATvars v_ATvars; /* Create atvars allocation */
#endif

/* read write at vars: these should be called before and after running pous (cycle) */
void ATvars_read(void) {
	GEB_DRV_PRE_READ
	GEB_DRV_POST_READ
}
void ATvars_write(void) {
	GEB_DRV_PRE_WRITE
	GEB_DRV_POST_WRITE
}
void ATvars_dump(void) {
#ifdef GEB_DEBUG_MODE
	writeGcbor_mapBegin();
	writeGcbor_mapEnd();
#endif
}
/* ------------------- GLOBAL ----------------------*/
typedef struct {
	int _dummy; /* dummy field */
} Global;
typedef Global * Global_P;

int Global_nRetainBytes(Global_P self) {
	return 0; /* no retain data */
}

Global v_Global; /* Create global instance */

int v_GlobalRetainDataLen; /* Filled in global init */

void Global_init(Global_P self) { /* init global vars */
	v_GlobalRetainDataLen = Global_nRetainBytes(self);
} /* end global init */

#ifndef SUPPRESS_FORMATTED_OUTPUT
void Global_printVars(Global_P self, int indent, int detail) {
}
#endif

void Global_dump(bool includeAt) {
#ifdef GEB_DEBUG_MODE
	writeGcbor_mapBegin();
	writeGcbor_mapEnd();
#endif
}
/* ------------------- POUS BODY ----------------------*/

/* ---- ALARM_2 begin body  ---- */
/* ==== POU: ALARM_2 (num:2 module:53) */
/* === vars:  0:HI_1 1:HI_2 2:HYS 3:LO_1 4:LO_2 5:Q1_HI 6:Q1_LO
	 7:Q2_HI 8:Q2_LO 9:X 10:tmp */

void dt_FB_ALARM_2_copy(dt_FB_ALARM_2_P self,dt_FB_ALARM_2_P o){ *self=*o; }
void dt_FB_ALARM_2_init(dt_FB_ALARM_2_P self){
	ZERO_STRUCT(self);
	self->v_EN = true;
	BOOL_t_init(&(self->v_ENO));
	REAL_t_init(&(self->v_X));
	REAL_t_init(&(self->v_LO_1));
	REAL_t_init(&(self->v_HI_1));
	REAL_t_init(&(self->v_LO_2));
	REAL_t_init(&(self->v_HI_2));
	REAL_t_init(&(self->v_HYS));
	BOOL_t_init(&(self->v_Q1_LO));
	BOOL_t_init(&(self->v_Q1_HI));
	BOOL_t_init(&(self->v_Q2_LO));
	BOOL_t_init(&(self->v_Q2_HI));
	REAL_t_init(&(self->v_tmp));
}

#ifdef GEB_DEBUG_MODE
void dt_FB_ALARM_2_dump2(dt_FB_ALARM_2_P self,void *  aut, int mode) {
	writeGcbor_mapBegin();
	if((mode & VARS_REPORT_WHAT_STATIC) != 0 ) {
		DUMP_VAR( 0,	GEBLIB_dump_REAL( self->v_HI_1) );
		DUMP_VAR( 1,	GEBLIB_dump_REAL( self->v_HI_2) );
		DUMP_VAR( 2,	GEBLIB_dump_REAL( self->v_HYS) );
		DUMP_VAR( 3,	GEBLIB_dump_REAL( self->v_LO_1) );
		DUMP_VAR( 4,	GEBLIB_dump_REAL( self->v_LO_2) );
		DUMP_VAR( 9,	GEBLIB_dump_REAL( self->v_X) );
		DUMP_VAR( 10,	GEBLIB_dump_REAL( self->v_tmp) );
	}
	if((mode & VARS_REPORT_WHAT_OUTPUT) != 0 ) {
		DUMP_VAR( 5,	GEBLIB_dump_BOOL( self->v_Q1_HI) );
		DUMP_VAR( 6,	GEBLIB_dump_BOOL( self->v_Q1_LO) );
		DUMP_VAR( 7,	GEBLIB_dump_BOOL( self->v_Q2_HI) );
		DUMP_VAR( 8,	GEBLIB_dump_BOOL( self->v_Q2_LO) );
	}
	writeGcbor_mapEnd();
}
#endif

#ifdef GEB_DEBUG_MODE
int dt_FB_ALARM_2_wv(dt_FB_ALARM_2_P self, void *  aut, int vnum, DEBUG_WV_VAL VAL) {
	int ret;
	ret=0;
	switch(vnum) {
		case 0 : self->v_HI_1 = GEBLIB_WV_REAL(VAL,&ret,self->v_HI_1); break;
		case 1 : self->v_HI_2 = GEBLIB_WV_REAL(VAL,&ret,self->v_HI_2); break;
		case 2 : self->v_HYS = GEBLIB_WV_REAL(VAL,&ret,self->v_HYS); break;
		case 3 : self->v_LO_1 = GEBLIB_WV_REAL(VAL,&ret,self->v_LO_1); break;
		case 4 : self->v_LO_2 = GEBLIB_WV_REAL(VAL,&ret,self->v_LO_2); break;
		case 5 : self->v_Q1_HI = GEBLIB_WV_BOOL(VAL,&ret,self->v_Q1_HI); break;
		case 6 : self->v_Q1_LO = GEBLIB_WV_BOOL(VAL,&ret,self->v_Q1_LO); break;
		case 7 : self->v_Q2_HI = GEBLIB_WV_BOOL(VAL,&ret,self->v_Q2_HI); break;
		case 8 : self->v_Q2_LO = GEBLIB_WV_BOOL(VAL,&ret,self->v_Q2_LO); break;
		case 9 : self->v_X = GEBLIB_WV_REAL(VAL,&ret,self->v_X); break;
		case 10 : self->v_tmp = GEBLIB_WV_REAL(VAL,&ret,self->v_tmp); break;
		default : ret=GEB_WV_ERR_BADVAR; /* no apt var found */
	}
	return ret;
}
#endif

#ifndef SUPPRESS_FORMATTED_OUTPUT
void dt_FB_ALARM_2_printVars(dt_FB_ALARM_2_P self, int indent, int detail) {
	if(detail>=1) {
		GEBputsINL("HI_1:");
		GEBLIB_print_REAL(self->v_HI_1);
		GEBputsINL("HI_2:");
		GEBLIB_print_REAL(self->v_HI_2);
		GEBputsINL("HYS:");
		GEBLIB_print_REAL(self->v_HYS);
		GEBputsINL("LO_1:");
		GEBLIB_print_REAL(self->v_LO_1);
		GEBputsINL("LO_2:");
		GEBLIB_print_REAL(self->v_LO_2);
		GEBputsINL("Q1_HI:");
		GEBLIB_print_BOOL(self->v_Q1_HI);
		GEBputsINL("Q1_LO:");
		GEBLIB_print_BOOL(self->v_Q1_LO);
		GEBputsINL("Q2_HI:");
		GEBLIB_print_BOOL(self->v_Q2_HI);
		GEBputsINL("Q2_LO:");
		GEBLIB_print_BOOL(self->v_Q2_LO);
		GEBputsINL("X:");
		GEBLIB_print_REAL(self->v_X);
	}
	if(detail>=2) {
		GEBputsINL("tmp:");
		GEBLIB_print_REAL(self->v_tmp);
	}
}
#endif

void dt_FB_ALARM_2_exec(dt_FB_ALARM_2_P self) {
/* codeExecAutomaticVars begin */
#ifdef GEB_DEBUG_MODE
	DEBUG_PUSH_STACK(2,53,self,NULL,&dt_FB_ALARM_2_dump2, &dt_FB_ALARM_2_wv,POU_FLAG_TYPE_FUNCTION_BLOCK);
#endif
/* codeExecAutomaticVars end */
	EN_ENO_CHECK {
beginPouExec:
		DEBUG_ST(22,0); /* basic_ALARM_2/ALARM_2.ST:22 	tmp := X - HYS * 0.5; */
		self->v_tmp =  GEBLIB_SUB_REAL(self->v_X, GEBLIB_MUL_REAL(self->v_HYS,((REAL_t)0.5f)) ) ;
		DEBUG_ST(23,0); /* basic_ALARM_2/ALARM_2.ST:23 	IF tmp > LO_1 THEN Q1_LO := FALSE; END_IF; */
		if(  GEBLIB_GT_REAL(self->v_tmp,self->v_LO_1)  )	{
		DEBUG_ST(23,0); /* basic_ALARM_2/ALARM_2.ST:23 	IF tmp > LO_1 THEN Q1_LO := FALSE; END_IF; */
		self->v_Q1_LO = false;
		}
		DEBUG_ST(24,0); /* basic_ALARM_2/ALARM_2.ST:24 	IF tmp > LO_2 THEN Q2_LO := FALSE; END_IF; */
		if(  GEBLIB_GT_REAL(self->v_tmp,self->v_LO_2)  )	{
		DEBUG_ST(24,0); /* basic_ALARM_2/ALARM_2.ST:24 	IF tmp > LO_2 THEN Q2_LO := FALSE; END_IF; */
		self->v_Q2_LO = false;
		}
		DEBUG_ST(25,0); /* basic_ALARM_2/ALARM_2.ST:25 	IF tmp > HI_1 THEN Q1_HI := TRUE; END_IF; */
		if(  GEBLIB_GT_REAL(self->v_tmp,self->v_HI_1)  )	{
		DEBUG_ST(25,0); /* basic_ALARM_2/ALARM_2.ST:25 	IF tmp > HI_1 THEN Q1_HI := TRUE; END_IF; */
		self->v_Q1_HI = true;
		}
		DEBUG_ST(26,0); /* basic_ALARM_2/ALARM_2.ST:26 	IF tmp > HI_2 THEN Q2_HI := TRUE; END_IF; */
		if(  GEBLIB_GT_REAL(self->v_tmp,self->v_HI_2)  )	{
		DEBUG_ST(26,0); /* basic_ALARM_2/ALARM_2.ST:26 	IF tmp > HI_2 THEN Q2_HI := TRUE; END_IF; */
		self->v_Q2_HI = true;
		}
		DEBUG_ST(27,0); /* basic_ALARM_2/ALARM_2.ST:27 	tmp := tmp + HYS; */
		self->v_tmp =  GEBLIB_ADD_REAL(self->v_tmp,self->v_HYS) ;
		DEBUG_ST(28,0); /* basic_ALARM_2/ALARM_2.ST:28 	IF tmp < LO_1 THEN Q1_LO := TRUE; END_IF; */
		if(  GEBLIB_LT_REAL(self->v_tmp,self->v_LO_1)  )	{
		DEBUG_ST(28,0); /* basic_ALARM_2/ALARM_2.ST:28 	IF tmp < LO_1 THEN Q1_LO := TRUE; END_IF; */
		self->v_Q1_LO = true;
		}
		DEBUG_ST(29,0); /* basic_ALARM_2/ALARM_2.ST:29 	IF tmp < LO_2 THEN Q2_LO := TRUE; END_IF; */
		if(  GEBLIB_LT_REAL(self->v_tmp,self->v_LO_2)  )	{
		DEBUG_ST(29,0); /* basic_ALARM_2/ALARM_2.ST:29 	IF tmp < LO_2 THEN Q2_LO := TRUE; END_IF; */
		self->v_Q2_LO = true;
		}
		DEBUG_ST(30,0); /* basic_ALARM_2/ALARM_2.ST:30 	IF tmp < HI_1 THEN Q1_HI := FALSE; END_IF; */
		if(  GEBLIB_LT_REAL(self->v_tmp,self->v_HI_1)  )	{
		DEBUG_ST(30,0); /* basic_ALARM_2/ALARM_2.ST:30 	IF tmp < HI_1 THEN Q1_HI := FALSE; END_IF; */
		self->v_Q1_HI = false;
		}
		DEBUG_ST(31,0); /* basic_ALARM_2/ALARM_2.ST:31 	IF tmp < HI_2 THEN Q2_HI := FALSE; END_IF; */
		if(  GEBLIB_LT_REAL(self->v_tmp,self->v_HI_2)  )	{
		DEBUG_ST(31,0); /* basic_ALARM_2/ALARM_2.ST:31 	IF tmp < HI_2 THEN Q2_HI := FALSE; END_IF; */
		self->v_Q2_HI = false;
		}
endPouExec: ;
		geb_hook(GEB_WHERE_END_OF_FUNC_FB,DEBUGGING_MODE);
	}
	DEBUG_POP_STACK();
	return ;
}
/* ---- end ALARM_2 end body  --- */
/* ---- program0 begin body  ---- */
/* ==== POU: program0 (num:3 module:53) */
/* === vars:  0:LocalOUT1 1:LocalOUT2 2:LocalOUT3 3:LocalOUT4 4:LocalVar0 5:LocalVar1 6:LocalVar2
	 7:LocalVar3 8:LocalVar4 9:LocalVar5 10:func_block */

void dt_PR_program0_copy(dt_PR_program0_P self,dt_PR_program0_P o){ *self=*o; }
void dt_PR_program0_init(dt_PR_program0_P self){
	ZERO_STRUCT(self);
	REAL_t_init(&(self->v_LocalVar0));
	REAL_t_init(&(self->v_LocalVar1));
	REAL_t_init(&(self->v_LocalVar2));
	REAL_t_init(&(self->v_LocalVar3));
	REAL_t_init(&(self->v_LocalVar4));
	REAL_t_init(&(self->v_LocalVar5));
	BOOL_t_init(&(self->v_LocalOUT1));
	BOOL_t_init(&(self->v_LocalOUT2));
	BOOL_t_init(&(self->v_LocalOUT3));
	BOOL_t_init(&(self->v_LocalOUT4));
	dt_FB_ALARM_2_init(&(self->v_func_block));
}

int dt_PR_program0_nRetainBytes(dt_PR_program0_P self) {
	return 0; /* no retain data */
}

#ifdef GEB_DEBUG_MODE
void dt_PR_program0_dump2(dt_PR_program0_P self,void *  aut, int mode) {
	writeGcbor_mapBegin();
	if((mode & VARS_REPORT_WHAT_STATIC) != 0 ) {
		DUMP_VAR( 0,	GEBLIB_dump_BOOL( self->v_LocalOUT1) );
		DUMP_VAR( 1,	GEBLIB_dump_BOOL( self->v_LocalOUT2) );
		DUMP_VAR( 2,	GEBLIB_dump_BOOL( self->v_LocalOUT3) );
		DUMP_VAR( 3,	GEBLIB_dump_BOOL( self->v_LocalOUT4) );
		DUMP_VAR( 4,	GEBLIB_dump_REAL( self->v_LocalVar0) );
		DUMP_VAR( 5,	GEBLIB_dump_REAL( self->v_LocalVar1) );
		DUMP_VAR( 6,	GEBLIB_dump_REAL( self->v_LocalVar2) );
		DUMP_VAR( 7,	GEBLIB_dump_REAL( self->v_LocalVar3) );
		DUMP_VAR( 8,	GEBLIB_dump_REAL( self->v_LocalVar4) );
		DUMP_VAR( 9,	GEBLIB_dump_REAL( self->v_LocalVar5) );
		DUMP_VAR( 10,	dt_FB_ALARM_2_dump( &(self->v_func_block)) );
	}
	writeGcbor_mapEnd();
}
#endif

#ifdef GEB_DEBUG_MODE
int dt_PR_program0_wv(dt_PR_program0_P self, void *  aut, int vnum, DEBUG_WV_VAL VAL) {
	int ret;
	ret=0;
	switch(vnum) {
		case 0 : self->v_LocalOUT1 = GEBLIB_WV_BOOL(VAL,&ret,self->v_LocalOUT1); break;
		case 1 : self->v_LocalOUT2 = GEBLIB_WV_BOOL(VAL,&ret,self->v_LocalOUT2); break;
		case 2 : self->v_LocalOUT3 = GEBLIB_WV_BOOL(VAL,&ret,self->v_LocalOUT3); break;
		case 3 : self->v_LocalOUT4 = GEBLIB_WV_BOOL(VAL,&ret,self->v_LocalOUT4); break;
		case 4 : self->v_LocalVar0 = GEBLIB_WV_REAL(VAL,&ret,self->v_LocalVar0); break;
		case 5 : self->v_LocalVar1 = GEBLIB_WV_REAL(VAL,&ret,self->v_LocalVar1); break;
		case 6 : self->v_LocalVar2 = GEBLIB_WV_REAL(VAL,&ret,self->v_LocalVar2); break;
		case 7 : self->v_LocalVar3 = GEBLIB_WV_REAL(VAL,&ret,self->v_LocalVar3); break;
		case 8 : self->v_LocalVar4 = GEBLIB_WV_REAL(VAL,&ret,self->v_LocalVar4); break;
		case 9 : self->v_LocalVar5 = GEBLIB_WV_REAL(VAL,&ret,self->v_LocalVar5); break;
		case 10 : ret=GEB_WV_ERR_MULTI; break;
		default : ret=GEB_WV_ERR_BADVAR; /* no apt var found */
	}
	return ret;
}
#endif

#ifndef SUPPRESS_FORMATTED_OUTPUT
void dt_PR_program0_printVars(dt_PR_program0_P self, int indent, int detail) {
	if(detail>=1) {
		GEBputsINL("LocalOUT1:");
		GEBLIB_print_BOOL(self->v_LocalOUT1);
		GEBputsINL("LocalOUT2:");
		GEBLIB_print_BOOL(self->v_LocalOUT2);
		GEBputsINL("LocalOUT3:");
		GEBLIB_print_BOOL(self->v_LocalOUT3);
		GEBputsINL("LocalOUT4:");
		GEBLIB_print_BOOL(self->v_LocalOUT4);
		GEBputsINL("LocalVar0:");
		GEBLIB_print_REAL(self->v_LocalVar0);
		GEBputsINL("LocalVar1:");
		GEBLIB_print_REAL(self->v_LocalVar1);
		GEBputsINL("LocalVar2:");
		GEBLIB_print_REAL(self->v_LocalVar2);
		GEBputsINL("LocalVar3:");
		GEBLIB_print_REAL(self->v_LocalVar3);
		GEBputsINL("LocalVar4:");
		GEBLIB_print_REAL(self->v_LocalVar4);
		GEBputsINL("LocalVar5:");
		GEBLIB_print_REAL(self->v_LocalVar5);
		GEBputsINL("func_block:");
		dt_FB_ALARM_2_print(&(self->v_func_block), indent+1);
	}
}
#endif

void dt_PR_program0_exec(dt_PR_program0_P self) {
/* codeExecAutomaticVars begin */
#ifdef GEB_DEBUG_MODE
	DEBUG_PUSH_STACK(3,53,self,NULL,&dt_PR_program0_dump2, &dt_PR_program0_wv,POU_FLAG_TYPE_PROGRAM);
#endif
/* codeExecAutomaticVars end */
beginPouExec:
	DEBUG_ST(49,0); /* basic_ALARM_2/ALARM_2.ST:49 	func_block.X := LocalVar0; */
	self->v_func_block.v_X = self->v_LocalVar0;
	DEBUG_ST(50,0); /* basic_ALARM_2/ALARM_2.ST:50 	func_block.LO_1 := LocalVar1; */
	self->v_func_block.v_LO_1 = self->v_LocalVar1;
	DEBUG_ST(51,0); /* basic_ALARM_2/ALARM_2.ST:51 	func_block.HI_1 := LocalVar2; */
	self->v_func_block.v_HI_1 = self->v_LocalVar2;
	DEBUG_ST(52,0); /* basic_ALARM_2/ALARM_2.ST:52 	func_block.LO_2 := LocalVar3; */
	self->v_func_block.v_LO_2 = self->v_LocalVar3;
	DEBUG_ST(53,0); /* basic_ALARM_2/ALARM_2.ST:53 	func_block.HI_2 := LocalVar4; */
	self->v_func_block.v_HI_2 = self->v_LocalVar4;
	DEBUG_ST(54,0); /* basic_ALARM_2/ALARM_2.ST:54 	func_block.HYS := LocalVar5; */
	self->v_func_block.v_HYS = self->v_LocalVar5;
	DEBUG_ST(55,0); /* basic_ALARM_2/ALARM_2.ST:55 	func_block(); */
	/* beginFB call */
	dt_FB_ALARM_2_exec(&(self->v_func_block) );
	DEBUG_ST(56,0); /* basic_ALARM_2/ALARM_2.ST:56 	LocalOUT1 := func_block.Q1_LO; */
	self->v_LocalOUT1 = self->v_func_block.v_Q1_LO;
	DEBUG_ST(57,0); /* basic_ALARM_2/ALARM_2.ST:57 	LocalOUT2 := func_block.Q1_HI; */
	self->v_LocalOUT2 = self->v_func_block.v_Q1_HI;
	DEBUG_ST(58,0); /* basic_ALARM_2/ALARM_2.ST:58 	LocalOUT3 := func_block.Q2_LO; */
	self->v_LocalOUT3 = self->v_func_block.v_Q2_LO;
	DEBUG_ST(59,0); /* basic_ALARM_2/ALARM_2.ST:59 	LocalOUT4 := func_block.Q2_HI; */
	self->v_LocalOUT4 = self->v_func_block.v_Q2_HI;
endPouExec: ;
	geb_hook(GEB_WHERE_END_OF_PROGRAM,DEBUGGING_MODE);
	DEBUG_POP_STACK();
	return ;
}
/* ---- end program0 end body  --- */
/* ------------------- END POUS BODY ------------------*/
/* ----------- create one instance for each program and return them ----------- */
static GebRunnable dt_PR_program0_runnable;
static dt_PR_program0 dt_PR_program0_inst;
void dt_PR_program0_runR(void) {
	dt_PR_program0_exec(&dt_PR_program0_inst);
}
void dt_PR_program0_initR(void) {
	dt_PR_program0_init(&dt_PR_program0_inst);
}
void dt_PR_program0_destroyR(void) {
	/* not necessary anymore */
}
const char * dt_PR_program0_getName(void) {
	return  "program0";
}
#ifndef SUPPRESS_FORMATTED_OUTPUT
void dt_PR_program0_showVarsR(int detail) {
	dt_PR_program0_printVars(&dt_PR_program0_inst,0,detail);
}
#endif


/* one instance for each program , null terminated - getter: gebInstanceAllPrograms() */
static	 GebRunnable_P _programs[1+1];
static void programs_init(void) {
	 int _nprograms = 1;
	 /* ----- dt_PR_program0 -------- */
	 dt_PR_program0_runnable.getName = &dt_PR_program0_getName;
	 dt_PR_program0_runnable.data = (unsigned char*)&dt_PR_program0_inst;
	 dt_PR_program0_runnable.nBytesRetain = dt_PR_program0_nRetainBytes(&dt_PR_program0_inst);
	 dt_PR_program0_runnable.run = &dt_PR_program0_runR;
	 dt_PR_program0_runnable.init = &dt_PR_program0_initR;
	 dt_PR_program0_runnable.destroy = &dt_PR_program0_destroyR;
#ifndef SUPPRESS_FORMATTED_OUTPUT
	 dt_PR_program0_runnable.showVars = &dt_PR_program0_showVarsR;
#endif
	 _programs[0] = &dt_PR_program0_runnable;
	 dt_PR_program0_init(&dt_PR_program0_inst);

	 _programs[1] = NULL; /* NULL terminated list */
}

/* ----------- end of programs code ------------------------ */

static void afterInit(void) {
	_gebTestCase.enabled = false;
}

/* simple digest (code hash) : 6to1df6xkz18 */
const char * getDigest(void) { return "6to1df6xkz18"; }

/* ----------- serialize/deserialize retain data ----------- */
#define RETAIN_DATA_HEADER_LEN  12
#define RETAIN_DATA_HEADER_LEN_CRIT 8
static unsigned char retainDataHeader[RETAIN_DATA_HEADER_LEN]={'G','E','B','r',0xa1,0x2c,0xa3,0xc9,0xa1,0x24,0xba,0x2b};

#include <gebprogs_f.c>

/* ---------- end of automatically generated code ---------- */
