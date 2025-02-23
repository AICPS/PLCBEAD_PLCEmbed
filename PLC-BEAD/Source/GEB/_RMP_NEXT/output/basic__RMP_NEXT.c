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

/* ---- module basic__RMP_NEXT datatypes ----- */
/* ------------------- POUS HEADERS ----------------------*/
/* ---- module=basic__RMP_NEXT----- */
/* ---- pou=T_PLC_MS_block pouId=5 begin header --- */
 /* basic__RMP_NEXT/_RMP_NEXT.ST:12 	FUNCTION_BLOCK T_PLC_MS_block */
typedef struct dt_FB_T_PLC_MS_block {
	UDINT_t v_Offset;
	DINT_t v_PLC_SYS_TICK_CNT;
	UDINT_t v_T_PLC_MS;
	UDINT_t v_base;
	UDINT_t v_faktor;
	DWORD_t v_temp;
	UDINT_t v_v_plc_ticks_per_sec;
	INT_t v_N;
	INT_t v_PLC_TICKS_PER_SEC;
	BOOL_t v_EN;
	BOOL_t v_ENO;
	BOOL_t v_INit;
	BOOL_t v_debug;
	BOOL_t v_mode;
} dt_FB_T_PLC_MS_block;
typedef dt_FB_T_PLC_MS_block *dt_FB_T_PLC_MS_block_P;

void dt_FB_T_PLC_MS_block_copy(dt_FB_T_PLC_MS_block_P self,dt_FB_T_PLC_MS_block_P o);
void dt_FB_T_PLC_MS_block_init(dt_FB_T_PLC_MS_block_P self);
#ifdef GEB_DEBUG_MODE
#define dt_FB_T_PLC_MS_block_dump(s) dt_FB_T_PLC_MS_block_dump2(s,NULL,VARS_REPORT_WHAT_OUTPUT)
void dt_FB_T_PLC_MS_block_dump2(dt_FB_T_PLC_MS_block_P self,void *  aut, int mode);
#endif

#ifdef GEB_DEBUG_MODE
int dt_FB_T_PLC_MS_block_wv(dt_FB_T_PLC_MS_block_P self, void *  aut, int vnum, DEBUG_WV_VAL VAL);
#endif

#ifndef SUPPRESS_FORMATTED_OUTPUT
void dt_FB_T_PLC_MS_block_printVars(dt_FB_T_PLC_MS_block_P self, int indent, int detail);
#define dt_FB_T_PLC_MS_block_print(s,indent) dt_FB_T_PLC_MS_block_printVars(s,indent,1)
#endif
void dt_FB_T_PLC_MS_block_exec(dt_FB_T_PLC_MS_block_P self);
/* ---- T_PLC_MS_block end header --- */
/* ---- pou=TIME_TO_UDINT2 pouId=3 begin header --- */
 /* basic__RMP_NEXT/_RMP_NEXT.ST:64 	FUNCTION TIME_TO_UDINT2:UDINT */
typedef struct adt_FN_TIME_TO_UDINT2 {
	TIME_t_P v_X;
	UDINT_t_P v_TIME_TO_UDINT2;
} adt_FN_TIME_TO_UDINT2;
typedef adt_FN_TIME_TO_UDINT2 *adt_FN_TIME_TO_UDINT2_P;

#ifdef GEB_DEBUG_MODE
#define dt_FN_TIME_TO_UDINT2_dump(s)  /* nop */
void dt_FN_TIME_TO_UDINT2_dump2(void *  self,adt_FN_TIME_TO_UDINT2_P aut, int mode);
#endif

#ifdef GEB_DEBUG_MODE
int dt_FN_TIME_TO_UDINT2_wv(void *  self, adt_FN_TIME_TO_UDINT2_P aut, int vnum, DEBUG_WV_VAL VAL);
#endif

UDINT_t dt_FN_TIME_TO_UDINT2_exec( TIME_t v_X );
/* ---- TIME_TO_UDINT2 end header --- */
/* ---- pou=FRMP_B pouId=2 begin header --- */
 /* basic__RMP_NEXT/_RMP_NEXT.ST:72 	FUNCTION FRMP_B:BYTE */
typedef struct adt_FN_FRMP_B {
	TIME_t_P v_TD;
	TIME_t_P v_TR;
	BOOL_t_P v_DIR;
	BYTE_t_P v_FRMP_B;
	BYTE_t_P v_START;
} adt_FN_FRMP_B;
typedef adt_FN_FRMP_B *adt_FN_FRMP_B_P;

#ifdef GEB_DEBUG_MODE
#define dt_FN_FRMP_B_dump(s)  /* nop */
void dt_FN_FRMP_B_dump2(void *  self,adt_FN_FRMP_B_P aut, int mode);
#endif

#ifdef GEB_DEBUG_MODE
int dt_FN_FRMP_B_wv(void *  self, adt_FN_FRMP_B_P aut, int vnum, DEBUG_WV_VAL VAL);
#endif

BYTE_t dt_FN_FRMP_B_exec( BYTE_t v_START ,BOOL_t v_DIR ,TIME_t v_TD ,TIME_t v_TR );
/* ---- FRMP_B end header --- */
/* ---- pou=_RMP_B pouId=7 begin header --- */
 /* basic__RMP_NEXT/_RMP_NEXT.ST:92 	FUNCTION_BLOCK _RMP_B */
typedef struct dt_FB__RMP_B {
	dt_FB_T_PLC_MS_block v_T_PLC_MS;
	TIME_t v_TL;
	TIME_t v_TR;
	TIME_t v_tX;
	TIME_t v_tn;
	BOOL_t v_DIR;
	BOOL_t v_E;
	BOOL_t v_EN;
	BOOL_t v_ENO;
	BOOL_t v_INit;
	BYTE_t_P v_RMP;
	BOOL_t v_last_DIR;
	BYTE_t v_start;
} dt_FB__RMP_B;
typedef dt_FB__RMP_B *dt_FB__RMP_B_P;

void dt_FB__RMP_B_copy(dt_FB__RMP_B_P self,dt_FB__RMP_B_P o);
void dt_FB__RMP_B_init(dt_FB__RMP_B_P self);
#ifdef GEB_DEBUG_MODE
#define dt_FB__RMP_B_dump(s) dt_FB__RMP_B_dump2(s,NULL,VARS_REPORT_WHAT_OUTPUT)
void dt_FB__RMP_B_dump2(dt_FB__RMP_B_P self,void *  aut, int mode);
#endif

#ifdef GEB_DEBUG_MODE
int dt_FB__RMP_B_wv(dt_FB__RMP_B_P self, void *  aut, int vnum, DEBUG_WV_VAL VAL);
#endif

#ifndef SUPPRESS_FORMATTED_OUTPUT
void dt_FB__RMP_B_printVars(dt_FB__RMP_B_P self, int indent, int detail);
#define dt_FB__RMP_B_print(s,indent) dt_FB__RMP_B_printVars(s,indent,1)
#endif
void dt_FB__RMP_B_exec(dt_FB__RMP_B_P self);
/* ---- _RMP_B end header --- */
/* ---- pou=TREND_DW pouId=4 begin header --- */
 /* basic__RMP_NEXT/_RMP_NEXT.ST:131 	FUNCTION_BLOCK TREND_DW */
typedef struct dt_FB_TREND_DW {
	DWORD_t v_D;
	DWORD_t v_X;
	DWORD_t v_last_X;
	BOOL_t v_EN;
	BOOL_t v_ENO;
	BOOL_t v_Q;
	BOOL_t v_TD;
	BOOL_t v_TU;
} dt_FB_TREND_DW;
typedef dt_FB_TREND_DW *dt_FB_TREND_DW_P;

void dt_FB_TREND_DW_copy(dt_FB_TREND_DW_P self,dt_FB_TREND_DW_P o);
void dt_FB_TREND_DW_init(dt_FB_TREND_DW_P self);
#ifdef GEB_DEBUG_MODE
#define dt_FB_TREND_DW_dump(s) dt_FB_TREND_DW_dump2(s,NULL,VARS_REPORT_WHAT_OUTPUT)
void dt_FB_TREND_DW_dump2(dt_FB_TREND_DW_P self,void *  aut, int mode);
#endif

#ifdef GEB_DEBUG_MODE
int dt_FB_TREND_DW_wv(dt_FB_TREND_DW_P self, void *  aut, int vnum, DEBUG_WV_VAL VAL);
#endif

#ifndef SUPPRESS_FORMATTED_OUTPUT
void dt_FB_TREND_DW_printVars(dt_FB_TREND_DW_P self, int indent, int detail);
#define dt_FB_TREND_DW_print(s,indent) dt_FB_TREND_DW_printVars(s,indent,1)
#endif
void dt_FB_TREND_DW_exec(dt_FB_TREND_DW_P self);
/* ---- TREND_DW end header --- */
/* ---- pou=_RMP_NEXT pouId=8 begin header --- */
 /* basic__RMP_NEXT/_RMP_NEXT.ST:164 	FUNCTION_BLOCK _RMP_NEXT */
typedef struct dt_FB__RMP_NEXT {
	dt_FB_TREND_DW v_DIRX;
	dt_FB__RMP_B v_rmX;
	dt_FB_TP v_t_lock;
	TIME_t v_TF;
	TIME_t v_TL;
	TIME_t v_TR;
	BOOL_t v_DIR;
	BOOL_t v_DN;
	BOOL_t v_E;
	BOOL_t v_EN;
	BOOL_t v_ENO;
	BYTE_t v_IN;
	BYTE_t_P v_OUT;
	BOOL_t v_UP;
	BOOL_t v_XDIR;
	BOOL_t v_Xen;
} dt_FB__RMP_NEXT;
typedef dt_FB__RMP_NEXT *dt_FB__RMP_NEXT_P;

void dt_FB__RMP_NEXT_copy(dt_FB__RMP_NEXT_P self,dt_FB__RMP_NEXT_P o);
void dt_FB__RMP_NEXT_init(dt_FB__RMP_NEXT_P self);
#ifdef GEB_DEBUG_MODE
#define dt_FB__RMP_NEXT_dump(s) dt_FB__RMP_NEXT_dump2(s,NULL,VARS_REPORT_WHAT_OUTPUT)
void dt_FB__RMP_NEXT_dump2(dt_FB__RMP_NEXT_P self,void *  aut, int mode);
#endif

#ifdef GEB_DEBUG_MODE
int dt_FB__RMP_NEXT_wv(dt_FB__RMP_NEXT_P self, void *  aut, int vnum, DEBUG_WV_VAL VAL);
#endif

#ifndef SUPPRESS_FORMATTED_OUTPUT
void dt_FB__RMP_NEXT_printVars(dt_FB__RMP_NEXT_P self, int indent, int detail);
#define dt_FB__RMP_NEXT_print(s,indent) dt_FB__RMP_NEXT_printVars(s,indent,1)
#endif
void dt_FB__RMP_NEXT_exec(dt_FB__RMP_NEXT_P self);
/* ---- _RMP_NEXT end header --- */
/* ---- pou=program0 pouId=9 begin header --- */
 /* basic__RMP_NEXT/_RMP_NEXT.ST:222 	PROGRAM program0 */
typedef struct dt_PR_program0 {
	dt_FB__RMP_NEXT v_func_block;
	TIME_t v_LocalVar3;
	TIME_t v_LocalVar4;
	TIME_t v_LocalVar5;
	BYTE_t v_LocalINOUT;
	BOOL_t v_LocalVar1;
	BYTE_t v_LocalVar2;
	BOOL_t v_LocalVar6;
	BOOL_t v_LocalVar7;
	BOOL_t v_LocalVar8;
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

/* ---- T_PLC_MS_block begin body  ---- */
/* ==== POU: T_PLC_MS_block (num:5 module:1) */
/* === vars:  0:INit 1:N 2:Offset 3:PLC_SYS_TICK_CNT 4:PLC_TICKS_PER_SEC 5:T_PLC_MS 6:base
	 7:debug 8:faktor 9:mode 10:temp 11:v_plc_ticks_per_sec */

void dt_FB_T_PLC_MS_block_copy(dt_FB_T_PLC_MS_block_P self,dt_FB_T_PLC_MS_block_P o){ *self=*o; }
void dt_FB_T_PLC_MS_block_init(dt_FB_T_PLC_MS_block_P self){
	ZERO_STRUCT(self);
	self->v_EN = true;
	BOOL_t_init(&(self->v_ENO));
	UDINT_t_init(&(self->v_T_PLC_MS));
	INT_t_init(&(self->v_PLC_TICKS_PER_SEC));
	DINT_t_init(&(self->v_PLC_SYS_TICK_CNT));
	BOOL_t_init(&(self->v_debug));
	INT_t_init(&(self->v_N));
	UDINT_t_init(&(self->v_Offset));
	self->v_temp = ((DWORD_t)0x1L);
	BOOL_t_init(&(self->v_mode));
	UDINT_t_init(&(self->v_faktor));
	BOOL_t_init(&(self->v_INit));
	UDINT_t_init(&(self->v_v_plc_ticks_per_sec));
	self->v_base = ((UDINT_t)1000UL);
}

#ifdef GEB_DEBUG_MODE
void dt_FB_T_PLC_MS_block_dump2(dt_FB_T_PLC_MS_block_P self,void *  aut, int mode) {
	writeGcbor_mapBegin();
	if((mode & VARS_REPORT_WHAT_STATIC) != 0 ) {
		DUMP_VAR( 0,	GEBLIB_dump_BOOL( self->v_INit) );
		DUMP_VAR( 1,	GEBLIB_dump_INT( self->v_N) );
		DUMP_VAR( 2,	GEBLIB_dump_UDINT( self->v_Offset) );
		DUMP_VAR( 3,	GEBLIB_dump_DINT( self->v_PLC_SYS_TICK_CNT) );
		DUMP_VAR( 4,	GEBLIB_dump_INT( self->v_PLC_TICKS_PER_SEC) );
		DUMP_VAR( 6,	GEBLIB_dump_UDINT( self->v_base) );
		DUMP_VAR( 7,	GEBLIB_dump_BOOL( self->v_debug) );
		DUMP_VAR( 8,	GEBLIB_dump_UDINT( self->v_faktor) );
		DUMP_VAR( 9,	GEBLIB_dump_BOOL( self->v_mode) );
		DUMP_VAR( 10,	GEBLIB_dump_DWORD( self->v_temp) );
		DUMP_VAR( 11,	GEBLIB_dump_UDINT( self->v_v_plc_ticks_per_sec) );
	}
	if((mode & VARS_REPORT_WHAT_OUTPUT) != 0 ) {
		DUMP_VAR( 5,	GEBLIB_dump_UDINT( self->v_T_PLC_MS) );
	}
	writeGcbor_mapEnd();
}
#endif

#ifdef GEB_DEBUG_MODE
int dt_FB_T_PLC_MS_block_wv(dt_FB_T_PLC_MS_block_P self, void *  aut, int vnum, DEBUG_WV_VAL VAL) {
	int ret;
	ret=0;
	switch(vnum) {
		case 0 : self->v_INit = GEBLIB_WV_BOOL(VAL,&ret,self->v_INit); break;
		case 1 : self->v_N = GEBLIB_WV_INT(VAL,&ret,self->v_N); break;
		case 2 : self->v_Offset = GEBLIB_WV_UDINT(VAL,&ret,self->v_Offset); break;
		case 3 : self->v_PLC_SYS_TICK_CNT = GEBLIB_WV_DINT(VAL,&ret,self->v_PLC_SYS_TICK_CNT); break;
		case 4 : self->v_PLC_TICKS_PER_SEC = GEBLIB_WV_INT(VAL,&ret,self->v_PLC_TICKS_PER_SEC); break;
		case 5 : self->v_T_PLC_MS = GEBLIB_WV_UDINT(VAL,&ret,self->v_T_PLC_MS); break;
		case 6 : self->v_base = GEBLIB_WV_UDINT(VAL,&ret,self->v_base); break;
		case 7 : self->v_debug = GEBLIB_WV_BOOL(VAL,&ret,self->v_debug); break;
		case 8 : self->v_faktor = GEBLIB_WV_UDINT(VAL,&ret,self->v_faktor); break;
		case 9 : self->v_mode = GEBLIB_WV_BOOL(VAL,&ret,self->v_mode); break;
		case 10 : self->v_temp = GEBLIB_WV_DWORD(VAL,&ret,self->v_temp); break;
		case 11 : self->v_v_plc_ticks_per_sec = GEBLIB_WV_UDINT(VAL,&ret,self->v_v_plc_ticks_per_sec); break;
		default : ret=GEB_WV_ERR_BADVAR; /* no apt var found */
	}
	return ret;
}
#endif

#ifndef SUPPRESS_FORMATTED_OUTPUT
void dt_FB_T_PLC_MS_block_printVars(dt_FB_T_PLC_MS_block_P self, int indent, int detail) {
	if(detail>=1) {
		GEBputsINL("T_PLC_MS:");
		GEBLIB_print_UDINT(self->v_T_PLC_MS);
	}
	if(detail>=2) {
		GEBputsINL("INit:");
		GEBLIB_print_BOOL(self->v_INit);
		GEBputsINL("N:");
		GEBLIB_print_INT(self->v_N);
		GEBputsINL("Offset:");
		GEBLIB_print_UDINT(self->v_Offset);
		GEBputsINL("PLC_SYS_TICK_CNT:");
		GEBLIB_print_DINT(self->v_PLC_SYS_TICK_CNT);
		GEBputsINL("PLC_TICKS_PER_SEC:");
		GEBLIB_print_INT(self->v_PLC_TICKS_PER_SEC);
		GEBputsINL("base:");
		GEBLIB_print_UDINT(self->v_base);
		GEBputsINL("debug:");
		GEBLIB_print_BOOL(self->v_debug);
		GEBputsINL("faktor:");
		GEBLIB_print_UDINT(self->v_faktor);
		GEBputsINL("mode:");
		GEBLIB_print_BOOL(self->v_mode);
		GEBputsINL("temp:");
		GEBLIB_print_DWORD(self->v_temp);
		GEBputsINL("v_plc_ticks_per_sec:");
		GEBLIB_print_UDINT(self->v_v_plc_ticks_per_sec);
	}
}
#endif

void dt_FB_T_PLC_MS_block_exec(dt_FB_T_PLC_MS_block_P self) {
/* codeExecAutomaticVars begin */
#ifdef GEB_DEBUG_MODE
	DEBUG_PUSH_STACK(5,1,self,NULL,&dt_FB_T_PLC_MS_block_dump2, &dt_FB_T_PLC_MS_block_wv,POU_FLAG_TYPE_FUNCTION_BLOCK);
#endif
/* codeExecAutomaticVars end */
	EN_ENO_CHECK {
beginPouExec:
		DEBUG_ST(34,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:34 	IF INit = FALSE THEN */
		if(  GEBLIB_EQ_BOOL(self->v_INit,false)  )	{
		DEBUG_ST(35,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:35 	v_plc_ticks_per_sec := INT_TO_UDINT(PLC_TICKS_PER_SEC); */
		self->v_v_plc_ticks_per_sec = gebx_MOVE_UDINT(self->v_PLC_TICKS_PER_SEC);
		DEBUG_ST(36,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:36 	IF v_plc_ticks_per_sec = UDINT#1024 THEN */
		if(  GEBLIB_EQ_UDINT(self->v_v_plc_ticks_per_sec,((UDINT_t)1024UL))  )	{
		DEBUG_ST(37,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:37 	faktor := UDINT#1; */
		self->v_faktor = ((UDINT_t)1UL);
		DEBUG_ST(38,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:38 	mode := FALSE; */
		self->v_mode = false;
		} else if (  GEBLIB_GT_UDINT(self->v_v_plc_ticks_per_sec,((UDINT_t)0UL))  )	{
			DEBUG_ST(40,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:40 	IF v_plc_ticks_per_sec <= base THEN */
			if(  GEBLIB_LE_UDINT(self->v_v_plc_ticks_per_sec,self->v_base)  )	{
			DEBUG_ST(41,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:41 	faktor := base / v_plc_ticks_per_sec; */
			self->v_faktor =  GEBLIB_DIV_UDINT(self->v_base,self->v_v_plc_ticks_per_sec) ;
			DEBUG_ST(42,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:42 	mode := FALSE; */
			self->v_mode = false;
			} else	{
				DEBUG_ST(44,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:44 	faktor := v_plc_ticks_per_sec / base; */
				self->v_faktor =  GEBLIB_DIV_UDINT(self->v_v_plc_ticks_per_sec,self->v_base) ;
				DEBUG_ST(45,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:45 	mode := TRUE; */
				self->v_mode = true;
			}
		} else	{
			DEBUG_ST(48,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:48 	faktor := UDINT#1; */
			self->v_faktor = ((UDINT_t)1UL);
		}
		DEBUG_ST(50,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:50 	INit := TRUE; */
		self->v_INit = true;
		}
		DEBUG_ST(53,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:53 	IF mode THEN */
		if( self->v_mode )	{
		DEBUG_ST(54,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:54 	T_PLC_MS := DINT_TO_UDINT(PLC_SYS_TICK_CNT) / faktor; */
		self->v_T_PLC_MS =  GEBLIB_DIV_UDINT(gebx_MOVE_UDINT(self->v_PLC_SYS_TICK_CNT),self->v_faktor) ;
		} else	{
			DEBUG_ST(56,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:56 	T_PLC_MS := DINT_TO_UDINT(PLC_SYS_TICK_CNT) * faktor; */
			self->v_T_PLC_MS =  GEBLIB_MUL_UDINT(gebx_MOVE_UDINT(self->v_PLC_SYS_TICK_CNT),self->v_faktor) ;
		}
		DEBUG_ST(59,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:59 	IF debug THEN */
		if( self->v_debug )	{
		DEBUG_ST(60,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:60 	T_PLC_MS := (DWORD_TO_UDINT(SHL(UDINT_TO_DWORD(T_PLC_MS),N) OR SHL(temp,N)) - UDINT#1) + Offset; */
		self->v_T_PLC_MS =  GEBLIB_ADD_UDINT( GEBLIB_SUB_UDINT(gebx_MOVE_UDINT( GEBLIB_OR_DWORD(gebx_SHL_DWORD(gebx_MOVE_UDINT(self->v_T_PLC_MS),self->v_N),gebx_SHL_DWORD(self->v_temp,self->v_N)) ),((UDINT_t)1UL)) ,self->v_Offset) ;
		}
endPouExec: ;
		geb_hook(GEB_WHERE_END_OF_FUNC_FB,DEBUGGING_MODE);
	}
	DEBUG_POP_STACK();
	return ;
}
/* ---- end T_PLC_MS_block end body  --- */
/* ---- TIME_TO_UDINT2 begin body  ---- */
/* ==== POU: TIME_TO_UDINT2 (num:3 module:1) */
/* === vars:  0:TIME_TO_UDINT2 1:X */

#ifdef GEB_DEBUG_MODE
void dt_FN_TIME_TO_UDINT2_dump2(void *  self,adt_FN_TIME_TO_UDINT2_P aut, int mode) {
	writeGcbor_mapBegin();
	if((mode & VARS_REPORT_WHAT_AUTO) != 0  && aut != NULL) {
		DUMP_VAR( 0,	GEBLIB_dump_UDINT( *(aut->v_TIME_TO_UDINT2)) );
		DUMP_VAR( 1,	GEBLIB_dump_TIME( *(aut->v_X)) );
	}
	writeGcbor_mapEnd();
}
#endif

#ifdef GEB_DEBUG_MODE
int dt_FN_TIME_TO_UDINT2_wv(void *  self, adt_FN_TIME_TO_UDINT2_P aut, int vnum, DEBUG_WV_VAL VAL) {
	int ret;
	ret=0;
	switch(vnum) {
		case 0 : if(aut!=NULL){ *(aut->v_TIME_TO_UDINT2) = GEBLIB_WV_UDINT(VAL,&ret,*(aut->v_TIME_TO_UDINT2)); } else {ret=GEB_WV_ERR_NOAUTO;} break;
		case 1 : ret=GEB_WV_ERR_DATETIME; break;
		default : ret=GEB_WV_ERR_BADVAR; /* no apt var found */
	}
	return ret;
}
#endif

UDINT_t dt_FN_TIME_TO_UDINT2_exec( TIME_t v_X ) {
/* codeExecAutomaticVars begin */
#ifdef GEB_DEBUG_MODE
	adt_FN_TIME_TO_UDINT2 aut;
#endif
	UDINT_t v_TIME_TO_UDINT2;
	/* automatic vars initialization */
#ifdef GEB_DEBUG_MODE
	DEBUG_PUSH_STACK(3,1,NULL,&aut,&dt_FN_TIME_TO_UDINT2_dump2, &dt_FN_TIME_TO_UDINT2_wv,POU_FLAG_TYPE_FUNCTION);
	aut.v_X=  &(v_X);
	aut.v_TIME_TO_UDINT2=  &(v_TIME_TO_UDINT2);
#endif
/* codeExecAutomaticVars end */
beginPouExec:
	DEBUG_ST(69,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:69 	TIME_TO_UDINT2 := DINT_TO_UDINT(TIME_TO_DINT(X)); */
	v_TIME_TO_UDINT2 = gebx_MOVE_UDINT(gebx_TIME_TO_DINT(v_X));
endPouExec: ;
	geb_hook(GEB_WHERE_END_OF_FUNC_FB,DEBUGGING_MODE);
	DEBUG_POP_STACK();
	return v_TIME_TO_UDINT2;
}
/* ---- end TIME_TO_UDINT2 end body  --- */
/* ---- FRMP_B begin body  ---- */
/* ==== POU: FRMP_B (num:2 module:1) */
/* === vars:  0:DIR 1:FRMP_B 2:START 3:TD 4:TR */

#ifdef GEB_DEBUG_MODE
void dt_FN_FRMP_B_dump2(void *  self,adt_FN_FRMP_B_P aut, int mode) {
	writeGcbor_mapBegin();
	if((mode & VARS_REPORT_WHAT_AUTO) != 0  && aut != NULL) {
		DUMP_VAR( 0,	GEBLIB_dump_BOOL( *(aut->v_DIR)) );
		DUMP_VAR( 1,	GEBLIB_dump_BYTE( *(aut->v_FRMP_B)) );
		DUMP_VAR( 2,	GEBLIB_dump_BYTE( *(aut->v_START)) );
		DUMP_VAR( 3,	GEBLIB_dump_TIME( *(aut->v_TD)) );
		DUMP_VAR( 4,	GEBLIB_dump_TIME( *(aut->v_TR)) );
	}
	writeGcbor_mapEnd();
}
#endif

#ifdef GEB_DEBUG_MODE
int dt_FN_FRMP_B_wv(void *  self, adt_FN_FRMP_B_P aut, int vnum, DEBUG_WV_VAL VAL) {
	int ret;
	ret=0;
	switch(vnum) {
		case 0 : if(aut!=NULL){ *(aut->v_DIR) = GEBLIB_WV_BOOL(VAL,&ret,*(aut->v_DIR)); } else {ret=GEB_WV_ERR_NOAUTO;} break;
		case 1 : if(aut!=NULL){ *(aut->v_FRMP_B) = GEBLIB_WV_BYTE(VAL,&ret,*(aut->v_FRMP_B)); } else {ret=GEB_WV_ERR_NOAUTO;} break;
		case 2 : if(aut!=NULL){ *(aut->v_START) = GEBLIB_WV_BYTE(VAL,&ret,*(aut->v_START)); } else {ret=GEB_WV_ERR_NOAUTO;} break;
		case 3 : ret=GEB_WV_ERR_DATETIME; break;
		case 4 : ret=GEB_WV_ERR_DATETIME; break;
		default : ret=GEB_WV_ERR_BADVAR; /* no apt var found */
	}
	return ret;
}
#endif

BYTE_t dt_FN_FRMP_B_exec( BYTE_t v_START ,BOOL_t v_DIR ,TIME_t v_TD ,TIME_t v_TR ) {
/* codeExecAutomaticVars begin */
#ifdef GEB_DEBUG_MODE
	adt_FN_FRMP_B aut;
#endif
	BYTE_t v_FRMP_B;
	/* automatic vars initialization */
#ifdef GEB_DEBUG_MODE
	DEBUG_PUSH_STACK(2,1,NULL,&aut,&dt_FN_FRMP_B_dump2, &dt_FN_FRMP_B_wv,POU_FLAG_TYPE_FUNCTION);
	aut.v_TD=  &(v_TD);
	aut.v_TR=  &(v_TR);
	aut.v_DIR=  &(v_DIR);
	aut.v_FRMP_B=  &(v_FRMP_B);
	aut.v_START=  &(v_START);
#endif
/* codeExecAutomaticVars end */
beginPouExec:
	DEBUG_ST(80,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:80 	IF TD < TR THEN */
	if(  GEBLIB_LT_TIME(v_TD,v_TR)  )	{
	DEBUG_ST(81,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:81 	FRMP_B := MIN(UDINT_TO_BYTE(DWORD_TO_UDINT(SHL(TIME_TO_DWORD(TD), 8)) / TIME_TO_UDINT2(TR)), SEL(DIR, START, USINT_TO_BYTE(USINT#255 - BYTE_TO_USINT(START)))); */
	v_FRMP_B = gebx_MIN_BYTE2(gebx_DINT_TO_SINT( GEBLIB_DIV_UDINT(gebx_MOVE_UDINT(gebx_SHL_DWORD(gebx_TIME_TO_DINT(v_TD),((INT_t)8))),dt_FN_TIME_TO_UDINT2_exec(v_TR)) ),gebx_SEL_BYTE(v_DIR,v_START,gebx_MOVE_BYTE( GEBLIB_SUB_USINT(((USINT_t)255),gebx_MOVE_USINT(v_START)) )));
	DEBUG_ST(82,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:82 	IF DIR THEN */
	if( v_DIR )	{
	DEBUG_ST(83,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:83 	FRMP_B := USINT_TO_BYTE(BYTE_TO_USINT(START) + BYTE_TO_USINT(FRMP_B)); */
	v_FRMP_B = gebx_MOVE_BYTE( GEBLIB_ADD_USINT(gebx_MOVE_USINT(v_START),gebx_MOVE_USINT(v_FRMP_B)) );
	} else	{
		DEBUG_ST(85,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:85 	FRMP_B := USINT_TO_BYTE(BYTE_TO_USINT(START) - BYTE_TO_USINT(FRMP_B)); */
		v_FRMP_B = gebx_MOVE_BYTE( GEBLIB_SUB_USINT(gebx_MOVE_USINT(v_START),gebx_MOVE_USINT(v_FRMP_B)) );
	}
	} else	{
		DEBUG_ST(88,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:88 	FRMP_B := SEL(DIR, BYTE#0, BYTE#255); */
		v_FRMP_B = gebx_SEL_BYTE(v_DIR,((BYTE_t)0x0),((BYTE_t)0xff));
	}
endPouExec: ;
	geb_hook(GEB_WHERE_END_OF_FUNC_FB,DEBUGGING_MODE);
	DEBUG_POP_STACK();
	return v_FRMP_B;
}
/* ---- end FRMP_B end body  --- */
/* ---- _RMP_B begin body  ---- */
/* ==== POU: _RMP_B (num:7 module:1) */
/* === vars:  0:DIR 1:E 2:INit 3:RMP 4:TL 5:TR 6:T_PLC_MS
	 7:last_DIR 8:start 9:tX 10:tn */

void dt_FB__RMP_B_copy(dt_FB__RMP_B_P self,dt_FB__RMP_B_P o){ *self=*o; }
void dt_FB__RMP_B_init(dt_FB__RMP_B_P self){
	ZERO_STRUCT(self);
	self->v_EN = true;
	BOOL_t_init(&(self->v_ENO));
	BOOL_t_init(&(self->v_DIR));
	self->v_E = true;
	TIME_t_init(&(self->v_TR));
	dt_FB_T_PLC_MS_block_init(&(self->v_T_PLC_MS));
	TIME_t_init(&(self->v_tX));
	TIME_t_init(&(self->v_TL));
	TIME_t_init(&(self->v_tn));
	BOOL_t_init(&(self->v_INit));
	BOOL_t_init(&(self->v_last_DIR));
	BYTE_t_init(&(self->v_start));
}

#ifdef GEB_DEBUG_MODE
void dt_FB__RMP_B_dump2(dt_FB__RMP_B_P self,void *  aut, int mode) {
	writeGcbor_mapBegin();
	if((mode & VARS_REPORT_WHAT_STATIC) != 0 ) {
		DUMP_VAR( 0,	GEBLIB_dump_BOOL( self->v_DIR) );
		DUMP_VAR( 1,	GEBLIB_dump_BOOL( self->v_E) );
		DUMP_VAR( 2,	GEBLIB_dump_BOOL( self->v_INit) );
		DUMP_VAR( 4,	GEBLIB_dump_TIME( self->v_TL) );
		DUMP_VAR( 5,	GEBLIB_dump_TIME( self->v_TR) );
		DUMP_VAR( 6,	dt_FB_T_PLC_MS_block_dump( &(self->v_T_PLC_MS)) );
		DUMP_VAR( 7,	GEBLIB_dump_BOOL( self->v_last_DIR) );
		DUMP_VAR( 8,	GEBLIB_dump_BYTE( self->v_start) );
		DUMP_VAR( 9,	GEBLIB_dump_TIME( self->v_tX) );
		DUMP_VAR( 10,	GEBLIB_dump_TIME( self->v_tn) );
	}
	writeGcbor_mapEnd();
}
#endif

#ifdef GEB_DEBUG_MODE
int dt_FB__RMP_B_wv(dt_FB__RMP_B_P self, void *  aut, int vnum, DEBUG_WV_VAL VAL) {
	int ret;
	ret=0;
	switch(vnum) {
		case 0 : self->v_DIR = GEBLIB_WV_BOOL(VAL,&ret,self->v_DIR); break;
		case 1 : self->v_E = GEBLIB_WV_BOOL(VAL,&ret,self->v_E); break;
		case 2 : self->v_INit = GEBLIB_WV_BOOL(VAL,&ret,self->v_INit); break;
		case 3 : ret=GEB_WV_ERR_INOUT; break;
		case 4 : ret=GEB_WV_ERR_DATETIME; break;
		case 5 : ret=GEB_WV_ERR_DATETIME; break;
		case 6 : ret=GEB_WV_ERR_MULTI; break;
		case 7 : self->v_last_DIR = GEBLIB_WV_BOOL(VAL,&ret,self->v_last_DIR); break;
		case 8 : self->v_start = GEBLIB_WV_BYTE(VAL,&ret,self->v_start); break;
		case 9 : ret=GEB_WV_ERR_DATETIME; break;
		case 10 : ret=GEB_WV_ERR_DATETIME; break;
		default : ret=GEB_WV_ERR_BADVAR; /* no apt var found */
	}
	return ret;
}
#endif

#ifndef SUPPRESS_FORMATTED_OUTPUT
void dt_FB__RMP_B_printVars(dt_FB__RMP_B_P self, int indent, int detail) {
	if(detail>=1) {
		GEBputsINL("DIR:");
		GEBLIB_print_BOOL(self->v_DIR);
		GEBputsINL("E:");
		GEBLIB_print_BOOL(self->v_E);
		GEBputsINL("TR:");
		GEBLIB_print_TIME(self->v_TR);
	}
	if(detail>=2) {
		GEBputsINL("INit:");
		GEBLIB_print_BOOL(self->v_INit);
		GEBputsINL("TL:");
		GEBLIB_print_TIME(self->v_TL);
		GEBputsINL("T_PLC_MS:");
		dt_FB_T_PLC_MS_block_print(&(self->v_T_PLC_MS), indent+1);
		GEBputsINL("last_DIR:");
		GEBLIB_print_BOOL(self->v_last_DIR);
		GEBputsINL("start:");
		GEBLIB_print_BYTE(self->v_start);
		GEBputsINL("tX:");
		GEBLIB_print_TIME(self->v_tX);
		GEBputsINL("tn:");
		GEBLIB_print_TIME(self->v_tn);
	}
}
#endif

void dt_FB__RMP_B_exec(dt_FB__RMP_B_P self) {
/* codeExecAutomaticVars begin */
#ifdef GEB_DEBUG_MODE
	DEBUG_PUSH_STACK(7,1,self,NULL,&dt_FB__RMP_B_dump2, &dt_FB__RMP_B_wv,POU_FLAG_TYPE_FUNCTION_BLOCK);
#endif
/* codeExecAutomaticVars end */
	EN_ENO_CHECK {
beginPouExec:
		DEBUG_ST(116,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:116 	T_PLC_MS(); */
		/* beginFB call */
		dt_FB_T_PLC_MS_block_exec(&(self->v_T_PLC_MS) );
		DEBUG_ST(117,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:117 	tX := UDINT_TO_TIME(T_PLC_MS.T_PLC_MS); */
		self->v_tX = gebx_DINT_TO_TIME(self->v_T_PLC_MS.v_T_PLC_MS);
		DEBUG_ST(119,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:119 	IF E AND INit AND (DIR = last_DIR) AND (RMP <> SEL(DIR, BYTE#0, BYTE#255)) AND TR = tn THEN */
		if(  GEBLIB_AND_BOOL( GEBLIB_AND_BOOL( GEBLIB_AND_BOOL( GEBLIB_AND_BOOL(self->v_E,self->v_INit) , GEBLIB_EQ_BOOL(self->v_DIR,self->v_last_DIR) ) , GEBLIB_NE_BYTE(*(self->v_RMP),gebx_SEL_BYTE(self->v_DIR,((BYTE_t)0x0),((BYTE_t)0xff))) ) , GEBLIB_EQ_TIME(self->v_TR,self->v_tn) )  )	{
		DEBUG_ST(120,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:120 	RMP := FRMP_B(start, DIR, SUB_TIME(tX ,TL), TR); */
		(*self->v_RMP) = dt_FN_FRMP_B_exec(self->v_start,self->v_DIR,gebx_SUB_TIME(self->v_tX,self->v_TL),self->v_TR);
		} else	{
			DEBUG_ST(122,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:122 	INit := TRUE; */
			self->v_INit = true;
			DEBUG_ST(123,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:123 	TL := tX; */
			self->v_TL = self->v_tX;
			DEBUG_ST(124,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:124 	tn := TR; */
			self->v_tn = self->v_TR;
			DEBUG_ST(125,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:125 	start := RMP; */
			self->v_start = *(self->v_RMP);
		}
		DEBUG_ST(127,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:127 	last_DIR := DIR; */
		self->v_last_DIR = self->v_DIR;
endPouExec: ;
		geb_hook(GEB_WHERE_END_OF_FUNC_FB,DEBUGGING_MODE);
	}
	DEBUG_POP_STACK();
	return ;
}
/* ---- end _RMP_B end body  --- */
/* ---- TREND_DW begin body  ---- */
/* ==== POU: TREND_DW (num:4 module:1) */
/* === vars:  0:D 1:Q 2:TD 3:TU 4:X 5:last_X */

void dt_FB_TREND_DW_copy(dt_FB_TREND_DW_P self,dt_FB_TREND_DW_P o){ *self=*o; }
void dt_FB_TREND_DW_init(dt_FB_TREND_DW_P self){
	ZERO_STRUCT(self);
	self->v_EN = true;
	BOOL_t_init(&(self->v_ENO));
	DWORD_t_init(&(self->v_X));
	BOOL_t_init(&(self->v_Q));
	BOOL_t_init(&(self->v_TU));
	BOOL_t_init(&(self->v_TD));
	DWORD_t_init(&(self->v_D));
	DWORD_t_init(&(self->v_last_X));
}

#ifdef GEB_DEBUG_MODE
void dt_FB_TREND_DW_dump2(dt_FB_TREND_DW_P self,void *  aut, int mode) {
	writeGcbor_mapBegin();
	if((mode & VARS_REPORT_WHAT_STATIC) != 0 ) {
		DUMP_VAR( 4,	GEBLIB_dump_DWORD( self->v_X) );
		DUMP_VAR( 5,	GEBLIB_dump_DWORD( self->v_last_X) );
	}
	if((mode & VARS_REPORT_WHAT_OUTPUT) != 0 ) {
		DUMP_VAR( 0,	GEBLIB_dump_DWORD( self->v_D) );
		DUMP_VAR( 1,	GEBLIB_dump_BOOL( self->v_Q) );
		DUMP_VAR( 2,	GEBLIB_dump_BOOL( self->v_TD) );
		DUMP_VAR( 3,	GEBLIB_dump_BOOL( self->v_TU) );
	}
	writeGcbor_mapEnd();
}
#endif

#ifdef GEB_DEBUG_MODE
int dt_FB_TREND_DW_wv(dt_FB_TREND_DW_P self, void *  aut, int vnum, DEBUG_WV_VAL VAL) {
	int ret;
	ret=0;
	switch(vnum) {
		case 0 : self->v_D = GEBLIB_WV_DWORD(VAL,&ret,self->v_D); break;
		case 1 : self->v_Q = GEBLIB_WV_BOOL(VAL,&ret,self->v_Q); break;
		case 2 : self->v_TD = GEBLIB_WV_BOOL(VAL,&ret,self->v_TD); break;
		case 3 : self->v_TU = GEBLIB_WV_BOOL(VAL,&ret,self->v_TU); break;
		case 4 : self->v_X = GEBLIB_WV_DWORD(VAL,&ret,self->v_X); break;
		case 5 : self->v_last_X = GEBLIB_WV_DWORD(VAL,&ret,self->v_last_X); break;
		default : ret=GEB_WV_ERR_BADVAR; /* no apt var found */
	}
	return ret;
}
#endif

#ifndef SUPPRESS_FORMATTED_OUTPUT
void dt_FB_TREND_DW_printVars(dt_FB_TREND_DW_P self, int indent, int detail) {
	if(detail>=1) {
		GEBputsINL("D:");
		GEBLIB_print_DWORD(self->v_D);
		GEBputsINL("Q:");
		GEBLIB_print_BOOL(self->v_Q);
		GEBputsINL("TD:");
		GEBLIB_print_BOOL(self->v_TD);
		GEBputsINL("TU:");
		GEBLIB_print_BOOL(self->v_TU);
		GEBputsINL("X:");
		GEBLIB_print_DWORD(self->v_X);
	}
	if(detail>=2) {
		GEBputsINL("last_X:");
		GEBLIB_print_DWORD(self->v_last_X);
	}
}
#endif

void dt_FB_TREND_DW_exec(dt_FB_TREND_DW_P self) {
/* codeExecAutomaticVars begin */
#ifdef GEB_DEBUG_MODE
	DEBUG_PUSH_STACK(4,1,self,NULL,&dt_FB_TREND_DW_dump2, &dt_FB_TREND_DW_wv,POU_FLAG_TYPE_FUNCTION_BLOCK);
#endif
/* codeExecAutomaticVars end */
	EN_ENO_CHECK {
beginPouExec:
		DEBUG_ST(146,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:146 	IF X > last_X THEN */
		if(  GEBLIB_GT_UDINT(self->v_X,self->v_last_X)  )	{
		DEBUG_ST(147,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:147 	TU := TRUE; */
		self->v_TU = true;
		DEBUG_ST(148,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:148 	TD := FALSE; */
		self->v_TD = false;
		DEBUG_ST(149,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:149 	D := UDINT_TO_DWORD(DWORD_TO_UDINT(X) - DWORD_TO_UDINT(last_X)); */
		self->v_D = gebx_MOVE_UDINT( GEBLIB_SUB_UDINT(gebx_MOVE_UDINT(self->v_X),gebx_MOVE_UDINT(self->v_last_X)) );
		DEBUG_ST(150,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:150 	Q := TRUE; */
		self->v_Q = true;
		} else if (  GEBLIB_LT_UDINT(self->v_X,self->v_last_X)  )	{
			DEBUG_ST(152,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:152 	TD := TRUE; */
			self->v_TD = true;
			DEBUG_ST(153,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:153 	TU := FALSE; */
			self->v_TU = false;
			DEBUG_ST(154,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:154 	D := UDINT_TO_DWORD(DWORD_TO_UDINT(last_X) - DWORD_TO_UDINT(X)); */
			self->v_D = gebx_MOVE_UDINT( GEBLIB_SUB_UDINT(gebx_MOVE_UDINT(self->v_last_X),gebx_MOVE_UDINT(self->v_X)) );
			DEBUG_ST(155,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:155 	Q := FALSE; */
			self->v_Q = false;
		} else	{
			DEBUG_ST(157,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:157 	TU := FALSE; */
			self->v_TU = false;
			DEBUG_ST(158,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:158 	TD := FALSE; */
			self->v_TD = false;
			DEBUG_ST(159,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:159 	D := DWORD#0; */
			self->v_D = ((DWORD_t)0x0L);
		}
		DEBUG_ST(161,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:161 	last_X := X; */
		self->v_last_X = self->v_X;
endPouExec: ;
		geb_hook(GEB_WHERE_END_OF_FUNC_FB,DEBUGGING_MODE);
	}
	DEBUG_POP_STACK();
	return ;
}
/* ---- end TREND_DW end body  --- */
/* ---- _RMP_NEXT begin body  ---- */
/* ==== POU: _RMP_NEXT (num:8 module:1) */
/* === vars:  0:DIR 1:DIRX 2:DN 3:E 4:IN 5:OUT 6:TF
	 7:TL 8:TR 9:UP 10:XDIR 11:Xen 12:rmX 13:t_lock */

void dt_FB__RMP_NEXT_copy(dt_FB__RMP_NEXT_P self,dt_FB__RMP_NEXT_P o){ *self=*o; }
void dt_FB__RMP_NEXT_init(dt_FB__RMP_NEXT_P self){
	ZERO_STRUCT(self);
	self->v_EN = true;
	BOOL_t_init(&(self->v_ENO));
	self->v_E = true;
	BYTE_t_init(&(self->v_IN));
	TIME_t_init(&(self->v_TR));
	TIME_t_init(&(self->v_TF));
	TIME_t_init(&(self->v_TL));
	BOOL_t_init(&(self->v_DIR));
	BOOL_t_init(&(self->v_UP));
	BOOL_t_init(&(self->v_DN));
	dt_FB__RMP_B_init(&(self->v_rmX));
	dt_FB_TREND_DW_init(&(self->v_DIRX));
	dt_FB_TP_init(&(self->v_t_lock));
	BOOL_t_init(&(self->v_Xen));
	BOOL_t_init(&(self->v_XDIR));
}

#ifdef GEB_DEBUG_MODE
void dt_FB__RMP_NEXT_dump2(dt_FB__RMP_NEXT_P self,void *  aut, int mode) {
	writeGcbor_mapBegin();
	if((mode & VARS_REPORT_WHAT_STATIC) != 0 ) {
		DUMP_VAR( 1,	dt_FB_TREND_DW_dump( &(self->v_DIRX)) );
		DUMP_VAR( 3,	GEBLIB_dump_BOOL( self->v_E) );
		DUMP_VAR( 4,	GEBLIB_dump_BYTE( self->v_IN) );
		DUMP_VAR( 6,	GEBLIB_dump_TIME( self->v_TF) );
		DUMP_VAR( 7,	GEBLIB_dump_TIME( self->v_TL) );
		DUMP_VAR( 8,	GEBLIB_dump_TIME( self->v_TR) );
		DUMP_VAR( 10,	GEBLIB_dump_BOOL( self->v_XDIR) );
		DUMP_VAR( 11,	GEBLIB_dump_BOOL( self->v_Xen) );
		DUMP_VAR( 12,	dt_FB__RMP_B_dump( &(self->v_rmX)) );
		DUMP_VAR( 13,	dt_FB_TP_dump( &(self->v_t_lock)) );
	}
	if((mode & VARS_REPORT_WHAT_OUTPUT) != 0 ) {
		DUMP_VAR( 0,	GEBLIB_dump_BOOL( self->v_DIR) );
		DUMP_VAR( 2,	GEBLIB_dump_BOOL( self->v_DN) );
		DUMP_VAR( 9,	GEBLIB_dump_BOOL( self->v_UP) );
	}
	writeGcbor_mapEnd();
}
#endif

#ifdef GEB_DEBUG_MODE
int dt_FB__RMP_NEXT_wv(dt_FB__RMP_NEXT_P self, void *  aut, int vnum, DEBUG_WV_VAL VAL) {
	int ret;
	ret=0;
	switch(vnum) {
		case 0 : self->v_DIR = GEBLIB_WV_BOOL(VAL,&ret,self->v_DIR); break;
		case 1 : ret=GEB_WV_ERR_MULTI; break;
		case 2 : self->v_DN = GEBLIB_WV_BOOL(VAL,&ret,self->v_DN); break;
		case 3 : self->v_E = GEBLIB_WV_BOOL(VAL,&ret,self->v_E); break;
		case 4 : self->v_IN = GEBLIB_WV_BYTE(VAL,&ret,self->v_IN); break;
		case 5 : ret=GEB_WV_ERR_INOUT; break;
		case 6 : ret=GEB_WV_ERR_DATETIME; break;
		case 7 : ret=GEB_WV_ERR_DATETIME; break;
		case 8 : ret=GEB_WV_ERR_DATETIME; break;
		case 9 : self->v_UP = GEBLIB_WV_BOOL(VAL,&ret,self->v_UP); break;
		case 10 : self->v_XDIR = GEBLIB_WV_BOOL(VAL,&ret,self->v_XDIR); break;
		case 11 : self->v_Xen = GEBLIB_WV_BOOL(VAL,&ret,self->v_Xen); break;
		case 12 : ret=GEB_WV_ERR_MULTI; break;
		case 13 : ret=GEB_WV_ERR_MULTI; break;
		default : ret=GEB_WV_ERR_BADVAR; /* no apt var found */
	}
	return ret;
}
#endif

#ifndef SUPPRESS_FORMATTED_OUTPUT
void dt_FB__RMP_NEXT_printVars(dt_FB__RMP_NEXT_P self, int indent, int detail) {
	if(detail>=1) {
		GEBputsINL("DIR:");
		GEBLIB_print_BOOL(self->v_DIR);
		GEBputsINL("DN:");
		GEBLIB_print_BOOL(self->v_DN);
		GEBputsINL("E:");
		GEBLIB_print_BOOL(self->v_E);
		GEBputsINL("IN:");
		GEBLIB_print_BYTE(self->v_IN);
		GEBputsINL("TF:");
		GEBLIB_print_TIME(self->v_TF);
		GEBputsINL("TL:");
		GEBLIB_print_TIME(self->v_TL);
		GEBputsINL("TR:");
		GEBLIB_print_TIME(self->v_TR);
		GEBputsINL("UP:");
		GEBLIB_print_BOOL(self->v_UP);
	}
	if(detail>=2) {
		GEBputsINL("DIRX:");
		dt_FB_TREND_DW_print(&(self->v_DIRX), indent+1);
		GEBputsINL("XDIR:");
		GEBLIB_print_BOOL(self->v_XDIR);
		GEBputsINL("Xen:");
		GEBLIB_print_BOOL(self->v_Xen);
		GEBputsINL("rmX:");
		dt_FB__RMP_B_print(&(self->v_rmX), indent+1);
		GEBputsINL("t_lock:");
		dt_FB_TP_print(&(self->v_t_lock), indent+1);
	}
}
#endif

void dt_FB__RMP_NEXT_exec(dt_FB__RMP_NEXT_P self) {
/* codeExecAutomaticVars begin */
#ifdef GEB_DEBUG_MODE
	DEBUG_PUSH_STACK(8,1,self,NULL,&dt_FB__RMP_NEXT_dump2, &dt_FB__RMP_NEXT_wv,POU_FLAG_TYPE_FUNCTION_BLOCK);
#endif
/* codeExecAutomaticVars end */
	EN_ENO_CHECK {
beginPouExec:
		DEBUG_ST(190,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:190 	DIRX(X := BYTE_TO_DWORD(IN)); */
		/* beginFB call */
		self->v_DIRX.v_X = gebx_MOVE_UDINT(self->v_IN);
		dt_FB_TREND_DW_exec(&(self->v_DIRX) );
		DEBUG_ST(192,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:192 	t_lock(IN := FALSE, PT := TL); */
		/* beginFB call */
		self->v_t_lock.v_IN = false;
		self->v_t_lock.v_PT = self->v_TL;
		dt_FB_TP_exec(&(self->v_t_lock) );
		DEBUG_ST(194,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:194 	IF DIRX.TU AND (OUT < IN) THEN */
		if(  GEBLIB_AND_BOOL(self->v_DIRX.v_TU, GEBLIB_LT_USINT(*(self->v_OUT),self->v_IN) )  )	{
		DEBUG_ST(195,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:195 	IF NOT XDIR AND Xen THEN t_lock(IN := TRUE); END_IF; */
		if(  GEBLIB_AND_BOOL( GEBLIB_NOT_BOOL(self->v_XDIR),self->v_Xen)  )	{
		DEBUG_ST(195,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:195 	IF NOT XDIR AND Xen THEN t_lock(IN := TRUE); END_IF; */
		/* beginFB call */
		self->v_t_lock.v_IN = true;
		dt_FB_TP_exec(&(self->v_t_lock) );
		}
		DEBUG_ST(196,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:196 	Xen := TRUE; */
		self->v_Xen = true;
		DEBUG_ST(197,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:197 	XDIR := TRUE; */
		self->v_XDIR = true;
		} else if (  GEBLIB_AND_BOOL(self->v_DIRX.v_TD, GEBLIB_GT_USINT(*(self->v_OUT),self->v_IN) )  )	{
			DEBUG_ST(199,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:199 	IF XDIR AND Xen THEN t_lock(IN := TRUE); END_IF; */
			if(  GEBLIB_AND_BOOL(self->v_XDIR,self->v_Xen)  )	{
			DEBUG_ST(199,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:199 	IF XDIR AND Xen THEN t_lock(IN := TRUE); END_IF; */
			/* beginFB call */
			self->v_t_lock.v_IN = true;
			dt_FB_TP_exec(&(self->v_t_lock) );
			}
			DEBUG_ST(200,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:200 	Xen := TRUE; */
			self->v_Xen = true;
			DEBUG_ST(201,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:201 	XDIR := FALSE; */
			self->v_XDIR = false;
		} else if ( self->v_Xen )	{
			DEBUG_ST(203,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:203 	IF (XDIR AND (OUT >= IN)) OR (NOT XDIR AND (OUT <= IN)) THEN */
			if(  GEBLIB_OR_BOOL( GEBLIB_AND_BOOL(self->v_XDIR, GEBLIB_GE_USINT(*(self->v_OUT),self->v_IN) ) , GEBLIB_AND_BOOL( GEBLIB_NOT_BOOL(self->v_XDIR), GEBLIB_LE_USINT(*(self->v_OUT),self->v_IN) ) )  )	{
			DEBUG_ST(204,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:204 	Xen := FALSE; */
			self->v_Xen = false;
			DEBUG_ST(205,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:205 	IF TL > t#0s THEN t_lock(IN := TRUE); END_IF; */
			if(  GEBLIB_GT_TIME(self->v_TL,((TIME_t)TIME_t_fromVal(0L)))  )	{
			DEBUG_ST(205,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:205 	IF TL > t#0s THEN t_lock(IN := TRUE); END_IF; */
			/* beginFB call */
			self->v_t_lock.v_IN = true;
			dt_FB_TP_exec(&(self->v_t_lock) );
			}
			}
		}
		DEBUG_ST(209,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:209 	IF NOT t_lock.Q AND Xen THEN */
		if(  GEBLIB_AND_BOOL( GEBLIB_NOT_BOOL(self->v_t_lock.v_Q),self->v_Xen)  )	{
		DEBUG_ST(210,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:210 	UP := XDIR; */
		self->v_UP = self->v_XDIR;
		DEBUG_ST(211,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:211 	DIR := XDIR; */
		self->v_DIR = self->v_XDIR;
		DEBUG_ST(212,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:212 	DN := NOT XDIR; */
		self->v_DN =  GEBLIB_NOT_BOOL(self->v_XDIR);
		} else	{
			DEBUG_ST(214,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:214 	UP := FALSE; */
			self->v_UP = false;
			DEBUG_ST(215,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:215 	DN := FALSE; */
			self->v_DN = false;
		}
		DEBUG_ST(218,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:218 	rmX(RMP := OUT, E := E AND (UP OR DN) , DIR := DIR, TR := SEL(DIR, TF, TR)); */
		/* beginFB call */
		self->v_rmX.v_DIR = self->v_DIR;
		self->v_rmX.v_E =  GEBLIB_AND_BOOL(self->v_E, GEBLIB_OR_BOOL(self->v_UP,self->v_DN) ) ;
		self->v_rmX.v_TR = gebx_SEL_TIME(self->v_DIR,self->v_TF,self->v_TR);
		self->v_rmX.v_RMP = self->v_OUT;
		dt_FB__RMP_B_exec(&(self->v_rmX) );
		DEBUG_ST(219,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:219 	OUT := rmX.RMP; */
		(*self->v_OUT) = self->v_rmX.v_RMP;
endPouExec: ;
		geb_hook(GEB_WHERE_END_OF_FUNC_FB,DEBUGGING_MODE);
	}
	DEBUG_POP_STACK();
	return ;
}
/* ---- end _RMP_NEXT end body  --- */
/* ---- program0 begin body  ---- */
/* ==== POU: program0 (num:9 module:1) */
/* === vars:  0:LocalINOUT 1:LocalVar1 2:LocalVar2 3:LocalVar3 4:LocalVar4 5:LocalVar5 6:LocalVar6
	 7:LocalVar7 8:LocalVar8 9:func_block */

void dt_PR_program0_copy(dt_PR_program0_P self,dt_PR_program0_P o){ *self=*o; }
void dt_PR_program0_init(dt_PR_program0_P self){
	ZERO_STRUCT(self);
	BOOL_t_init(&(self->v_LocalVar1));
	BYTE_t_init(&(self->v_LocalVar2));
	TIME_t_init(&(self->v_LocalVar3));
	TIME_t_init(&(self->v_LocalVar4));
	TIME_t_init(&(self->v_LocalVar5));
	BOOL_t_init(&(self->v_LocalVar6));
	BOOL_t_init(&(self->v_LocalVar7));
	BOOL_t_init(&(self->v_LocalVar8));
	BYTE_t_init(&(self->v_LocalINOUT));
	dt_FB__RMP_NEXT_init(&(self->v_func_block));
}

int dt_PR_program0_nRetainBytes(dt_PR_program0_P self) {
	return 0; /* no retain data */
}

#ifdef GEB_DEBUG_MODE
void dt_PR_program0_dump2(dt_PR_program0_P self,void *  aut, int mode) {
	writeGcbor_mapBegin();
	if((mode & VARS_REPORT_WHAT_STATIC) != 0 ) {
		DUMP_VAR( 0,	GEBLIB_dump_BYTE( self->v_LocalINOUT) );
		DUMP_VAR( 1,	GEBLIB_dump_BOOL( self->v_LocalVar1) );
		DUMP_VAR( 2,	GEBLIB_dump_BYTE( self->v_LocalVar2) );
		DUMP_VAR( 3,	GEBLIB_dump_TIME( self->v_LocalVar3) );
		DUMP_VAR( 4,	GEBLIB_dump_TIME( self->v_LocalVar4) );
		DUMP_VAR( 5,	GEBLIB_dump_TIME( self->v_LocalVar5) );
		DUMP_VAR( 6,	GEBLIB_dump_BOOL( self->v_LocalVar6) );
		DUMP_VAR( 7,	GEBLIB_dump_BOOL( self->v_LocalVar7) );
		DUMP_VAR( 8,	GEBLIB_dump_BOOL( self->v_LocalVar8) );
		DUMP_VAR( 9,	dt_FB__RMP_NEXT_dump( &(self->v_func_block)) );
	}
	writeGcbor_mapEnd();
}
#endif

#ifdef GEB_DEBUG_MODE
int dt_PR_program0_wv(dt_PR_program0_P self, void *  aut, int vnum, DEBUG_WV_VAL VAL) {
	int ret;
	ret=0;
	switch(vnum) {
		case 0 : self->v_LocalINOUT = GEBLIB_WV_BYTE(VAL,&ret,self->v_LocalINOUT); break;
		case 1 : self->v_LocalVar1 = GEBLIB_WV_BOOL(VAL,&ret,self->v_LocalVar1); break;
		case 2 : self->v_LocalVar2 = GEBLIB_WV_BYTE(VAL,&ret,self->v_LocalVar2); break;
		case 3 : ret=GEB_WV_ERR_DATETIME; break;
		case 4 : ret=GEB_WV_ERR_DATETIME; break;
		case 5 : ret=GEB_WV_ERR_DATETIME; break;
		case 6 : self->v_LocalVar6 = GEBLIB_WV_BOOL(VAL,&ret,self->v_LocalVar6); break;
		case 7 : self->v_LocalVar7 = GEBLIB_WV_BOOL(VAL,&ret,self->v_LocalVar7); break;
		case 8 : self->v_LocalVar8 = GEBLIB_WV_BOOL(VAL,&ret,self->v_LocalVar8); break;
		case 9 : ret=GEB_WV_ERR_MULTI; break;
		default : ret=GEB_WV_ERR_BADVAR; /* no apt var found */
	}
	return ret;
}
#endif

#ifndef SUPPRESS_FORMATTED_OUTPUT
void dt_PR_program0_printVars(dt_PR_program0_P self, int indent, int detail) {
	if(detail>=1) {
		GEBputsINL("LocalINOUT:");
		GEBLIB_print_BYTE(self->v_LocalINOUT);
		GEBputsINL("LocalVar1:");
		GEBLIB_print_BOOL(self->v_LocalVar1);
		GEBputsINL("LocalVar2:");
		GEBLIB_print_BYTE(self->v_LocalVar2);
		GEBputsINL("LocalVar3:");
		GEBLIB_print_TIME(self->v_LocalVar3);
		GEBputsINL("LocalVar4:");
		GEBLIB_print_TIME(self->v_LocalVar4);
		GEBputsINL("LocalVar5:");
		GEBLIB_print_TIME(self->v_LocalVar5);
		GEBputsINL("LocalVar6:");
		GEBLIB_print_BOOL(self->v_LocalVar6);
		GEBputsINL("LocalVar7:");
		GEBLIB_print_BOOL(self->v_LocalVar7);
		GEBputsINL("LocalVar8:");
		GEBLIB_print_BOOL(self->v_LocalVar8);
		GEBputsINL("func_block:");
		dt_FB__RMP_NEXT_print(&(self->v_func_block), indent+1);
	}
}
#endif

void dt_PR_program0_exec(dt_PR_program0_P self) {
/* codeExecAutomaticVars begin */
#ifdef GEB_DEBUG_MODE
	DEBUG_PUSH_STACK(9,1,self,NULL,&dt_PR_program0_dump2, &dt_PR_program0_wv,POU_FLAG_TYPE_PROGRAM);
#endif
/* codeExecAutomaticVars end */
beginPouExec:
	DEBUG_ST(235,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:235 	func_block(E  := LocalVar1,IN := LocalVar2, TR := LocalVar3, TF := LocalVar4, TL := LocalVar5, OUT := LocalINOUT); */
	/* beginFB call */
	self->v_func_block.v_E = self->v_LocalVar1;
	self->v_func_block.v_IN = self->v_LocalVar2;
	self->v_func_block.v_TR = self->v_LocalVar3;
	self->v_func_block.v_TF = self->v_LocalVar4;
	self->v_func_block.v_TL = self->v_LocalVar5;
	self->v_func_block.v_OUT = &(self->v_LocalINOUT);
	dt_FB__RMP_NEXT_exec(&(self->v_func_block) );
	DEBUG_ST(236,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:236 	LocalINOUT := func_block.OUT; */
	self->v_LocalINOUT = self->v_func_block.v_OUT;
	DEBUG_ST(237,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:237 	LocalVar6 := func_block.DIR; */
	self->v_LocalVar6 = self->v_func_block.v_DIR;
	DEBUG_ST(238,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:238 	LocalVar7 := func_block.UP; */
	self->v_LocalVar7 = self->v_func_block.v_UP;
	DEBUG_ST(239,0); /* basic__RMP_NEXT/_RMP_NEXT.ST:239 	LocalVar8 := func_block.DN; */
	self->v_LocalVar8 = self->v_func_block.v_DN;
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

/* simple digest (code hash) : 3cozjftgwcr6 */
const char * getDigest(void) { return "3cozjftgwcr6"; }

/* ----------- serialize/deserialize retain data ----------- */
#define RETAIN_DATA_HEADER_LEN  12
#define RETAIN_DATA_HEADER_LEN_CRIT 8
static unsigned char retainDataHeader[RETAIN_DATA_HEADER_LEN]={'G','E','B','r',0x62,0xde,0xa2,0x51,0x60,0x9e,0x33,0x4e};

#include <gebprogs_f.c>

/* ---------- end of automatically generated code ---------- */
