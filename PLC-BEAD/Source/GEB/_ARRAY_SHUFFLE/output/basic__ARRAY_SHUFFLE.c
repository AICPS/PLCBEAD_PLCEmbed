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

/* ---- module basic__ARRAY_SHUFFLE datatypes ----- */
/* array (anonymous) type definition */
typedef struct {
	REAL_t a[100]; /* flat array */ 
} dt_ARR__g575_2;
typedef dt_ARR__g575_2 *dt_ARR__g575_2_P;
void dt_ARR__g575_2_copy(dt_ARR__g575_2_P self,dt_ARR__g575_2_P o) {
	*self=*o; }
#define dt_ARR__g575_2_IDX(i0) GEB_BOUNDS_CHECK(100, __LINE__ ,(i0 - 1))
void dt_ARR__g575_2_init(dt_ARR__g575_2_P self) {
	int i;
	for( i=0;i<100;i++) {
		self->a[i] = (REAL_t)0.0;
	}
}

#ifndef SUPPRESS_FORMATTED_OUTPUT
void dt_ARR__g575_2_print(dt_ARR__g575_2_P self, int indent) {
	int i;
	for( i=0;i<100;i++) {
		GEBputsINL("[");	GEBLIB_print_REAL(self->a[i]);
	}
} /* end show variables */
#endif

#ifdef GEB_DEBUG_MODE
void dt_ARR__g575_2_dump(dt_ARR__g575_2_P self) {
	int i;
	writeGcbor_arrayBegin();
	for( i=0;i<100;i++) {
		GEBLIB_dump_REAL(self->a[i]);
	}
	writeGcbor_arrayEnd();
}
#endif

typedef dt_ARR__g575_2 dt_Der_oscat_PT_ARRAY; /* derived type oscat_PT_ARRAY*/
typedef dt_Der_oscat_PT_ARRAY *dt_Der_oscat_PT_ARRAY_P;
void dt_Der_oscat_PT_ARRAY_init(dt_Der_oscat_PT_ARRAY_P self) {
	dt_ARR__g575_2_init(self); /* codeDataTypeDefDerived */
}
/* ------------------- POUS HEADERS ----------------------*/
/* ---- module=basic__ARRAY_SHUFFLE----- */
/* ---- pou=T_PLC_MS_block pouId=10 begin header --- */
 /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:49 	FUNCTION_BLOCK T_PLC_MS_block */
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
	BOOL_t v_debug;
	BOOL_t v_init;
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
/* ---- pou=_INT_TO_UDINT pouId=12 begin header --- */
 /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:127 	FUNCTION _INT_TO_UDINT:UDINT */
typedef struct adt_FN__INT_TO_UDINT {
	UDINT_t_P v__INT_TO_UDINT;
	INT_t_P v_IN;
} adt_FN__INT_TO_UDINT;
typedef adt_FN__INT_TO_UDINT *adt_FN__INT_TO_UDINT_P;

#ifdef GEB_DEBUG_MODE
#define dt_FN__INT_TO_UDINT_dump(s)  /* nop */
void dt_FN__INT_TO_UDINT_dump2(void *  self,adt_FN__INT_TO_UDINT_P aut, int mode);
#endif

#ifdef GEB_DEBUG_MODE
int dt_FN__INT_TO_UDINT_wv(void *  self, adt_FN__INT_TO_UDINT_P aut, int vnum, DEBUG_WV_VAL VAL);
#endif

UDINT_t dt_FN__INT_TO_UDINT_exec( INT_t v_IN );
/* ---- _INT_TO_UDINT end header --- */
/* ---- pou=D_TRUNC pouId=6 begin header --- */
 /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:6 	FUNCTION D_TRUNC : DINT */
typedef struct adt_FN_D_TRUNC {
	DINT_t_P v_D_TRUNC;
	REAL_t_P v_X;
} adt_FN_D_TRUNC;
typedef adt_FN_D_TRUNC *adt_FN_D_TRUNC_P;

#ifdef GEB_DEBUG_MODE
#define dt_FN_D_TRUNC_dump(s)  /* nop */
void dt_FN_D_TRUNC_dump2(void *  self,adt_FN_D_TRUNC_P aut, int mode);
#endif

#ifdef GEB_DEBUG_MODE
int dt_FN_D_TRUNC_wv(void *  self, adt_FN_D_TRUNC_P aut, int vnum, DEBUG_WV_VAL VAL);
#endif

DINT_t dt_FN_D_TRUNC_exec( REAL_t v_X );
/* ---- D_TRUNC end header --- */
/* ---- pou=FRACT pouId=7 begin header --- */
 /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:37 	FUNCTION FRACT:REAL */
typedef struct adt_FN_FRACT {
	REAL_t_P v_FRACT;
	REAL_t_P v_X;
} adt_FN_FRACT;
typedef adt_FN_FRACT *adt_FN_FRACT_P;

#ifdef GEB_DEBUG_MODE
#define dt_FN_FRACT_dump(s)  /* nop */
void dt_FN_FRACT_dump2(void *  self,adt_FN_FRACT_P aut, int mode);
#endif

#ifdef GEB_DEBUG_MODE
int dt_FN_FRACT_wv(void *  self, adt_FN_FRACT_P aut, int vnum, DEBUG_WV_VAL VAL);
#endif

REAL_t dt_FN_FRACT_exec( REAL_t v_X );
/* ---- FRACT end header --- */
/* ---- pou=BIT_COUNT pouId=3 begin header --- */
 /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:19 	FUNCTION BIT_COUNT:INT */
typedef struct adt_FN_BIT_COUNT {
	DWORD_t_P v_IN;
	DWORD_t_P v_in_temp;
	INT_t_P v_BIT_COUNT;
} adt_FN_BIT_COUNT;
typedef adt_FN_BIT_COUNT *adt_FN_BIT_COUNT_P;

#ifdef GEB_DEBUG_MODE
#define dt_FN_BIT_COUNT_dump(s)  /* nop */
void dt_FN_BIT_COUNT_dump2(void *  self,adt_FN_BIT_COUNT_P aut, int mode);
#endif

#ifdef GEB_DEBUG_MODE
int dt_FN_BIT_COUNT_wv(void *  self, adt_FN_BIT_COUNT_P aut, int vnum, DEBUG_WV_VAL VAL);
#endif

INT_t dt_FN_BIT_COUNT_exec( DWORD_t v_IN );
/* ---- BIT_COUNT end header --- */
/* ---- pou=BIT_OF_DWORD pouId=5 begin header --- */
 /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:117 	FUNCTION BIT_OF_DWORD : BOOL */
typedef struct adt_FN_BIT_OF_DWORD {
	DWORD_t_P v_IN;
	INT_t_P v_N;
	BOOL_t_P v_BIT_OF_DWORD;
} adt_FN_BIT_OF_DWORD;
typedef adt_FN_BIT_OF_DWORD *adt_FN_BIT_OF_DWORD_P;

#ifdef GEB_DEBUG_MODE
#define dt_FN_BIT_OF_DWORD_dump(s)  /* nop */
void dt_FN_BIT_OF_DWORD_dump2(void *  self,adt_FN_BIT_OF_DWORD_P aut, int mode);
#endif

#ifdef GEB_DEBUG_MODE
int dt_FN_BIT_OF_DWORD_wv(void *  self, adt_FN_BIT_OF_DWORD_P aut, int vnum, DEBUG_WV_VAL VAL);
#endif

BOOL_t dt_FN_BIT_OF_DWORD_exec( DWORD_t v_IN ,INT_t v_N );
/* ---- BIT_OF_DWORD end header --- */
/* ---- pou=BIT_LOAD_DW pouId=4 begin header --- */
 /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:102 	FUNCTION BIT_LOAD_DW:DWORD */
typedef struct adt_FN_BIT_LOAD_DW {
	DWORD_t_P v_BIT_LOAD_DW;
	DWORD_t_P v_IN;
	INT_t_P v_pos;
	BOOL_t_P v_VAL;
} adt_FN_BIT_LOAD_DW;
typedef adt_FN_BIT_LOAD_DW *adt_FN_BIT_LOAD_DW_P;

#ifdef GEB_DEBUG_MODE
#define dt_FN_BIT_LOAD_DW_dump(s)  /* nop */
void dt_FN_BIT_LOAD_DW_dump2(void *  self,adt_FN_BIT_LOAD_DW_P aut, int mode);
#endif

#ifdef GEB_DEBUG_MODE
int dt_FN_BIT_LOAD_DW_wv(void *  self, adt_FN_BIT_LOAD_DW_P aut, int vnum, DEBUG_WV_VAL VAL);
#endif

DWORD_t dt_FN_BIT_LOAD_DW_exec( DWORD_t v_IN ,BOOL_t v_VAL ,INT_t v_pos );
/* ---- BIT_LOAD_DW end header --- */
/* ---- pou=_DWORD_TO_REAL pouId=11 begin header --- */
 /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:135 	FUNCTION _DWORD_TO_REAL:REAL */
typedef struct adt_FN__DWORD_TO_REAL {
	DWORD_t_P v_IN;
	REAL_t_P v__DWORD_TO_REAL;
} adt_FN__DWORD_TO_REAL;
typedef adt_FN__DWORD_TO_REAL *adt_FN__DWORD_TO_REAL_P;

#ifdef GEB_DEBUG_MODE
#define dt_FN__DWORD_TO_REAL_dump(s)  /* nop */
void dt_FN__DWORD_TO_REAL_dump2(void *  self,adt_FN__DWORD_TO_REAL_P aut, int mode);
#endif

#ifdef GEB_DEBUG_MODE
int dt_FN__DWORD_TO_REAL_wv(void *  self, adt_FN__DWORD_TO_REAL_P aut, int vnum, DEBUG_WV_VAL VAL);
#endif

REAL_t dt_FN__DWORD_TO_REAL_exec( DWORD_t v_IN );
/* ---- _DWORD_TO_REAL end header --- */
/* ---- pou=RDM_block pouId=9 begin header --- */
 /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:144 	FUNCTION_BLOCK RDM_block */
typedef struct dt_FB_RDM_block {
	dt_FB_T_PLC_MS_block v_T_PLC_MS;
	REAL_t v_RDM;
	REAL_t v_last;
	DWORD_t v_tn;
	INT_t v_tc;
	BOOL_t v_EN;
	BOOL_t v_ENO;
} dt_FB_RDM_block;
typedef dt_FB_RDM_block *dt_FB_RDM_block_P;

void dt_FB_RDM_block_copy(dt_FB_RDM_block_P self,dt_FB_RDM_block_P o);
void dt_FB_RDM_block_init(dt_FB_RDM_block_P self);
#ifdef GEB_DEBUG_MODE
#define dt_FB_RDM_block_dump(s) dt_FB_RDM_block_dump2(s,NULL,VARS_REPORT_WHAT_OUTPUT)
void dt_FB_RDM_block_dump2(dt_FB_RDM_block_P self,void *  aut, int mode);
#endif

#ifdef GEB_DEBUG_MODE
int dt_FB_RDM_block_wv(dt_FB_RDM_block_P self, void *  aut, int vnum, DEBUG_WV_VAL VAL);
#endif

#ifndef SUPPRESS_FORMATTED_OUTPUT
void dt_FB_RDM_block_printVars(dt_FB_RDM_block_P self, int indent, int detail);
#define dt_FB_RDM_block_print(s,indent) dt_FB_RDM_block_printVars(s,indent,1)
#endif
void dt_FB_RDM_block_exec(dt_FB_RDM_block_P self);
/* ---- RDM_block end header --- */
/* ---- pou=RDM22 pouId=8 begin header --- */
 /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:174 	FUNCTION_BLOCK RDM22 */
typedef struct dt_FB_RDM22 {
	dt_FB_RDM_block v_RDM_p;
	INT_t v_RDM2;
	INT_t v_high;
	INT_t v_last;
	INT_t v_low;
	BOOL_t v_EN;
	BOOL_t v_ENO;
} dt_FB_RDM22;
typedef dt_FB_RDM22 *dt_FB_RDM22_P;

void dt_FB_RDM22_copy(dt_FB_RDM22_P self,dt_FB_RDM22_P o);
void dt_FB_RDM22_init(dt_FB_RDM22_P self);
#ifdef GEB_DEBUG_MODE
#define dt_FB_RDM22_dump(s) dt_FB_RDM22_dump2(s,NULL,VARS_REPORT_WHAT_OUTPUT)
void dt_FB_RDM22_dump2(dt_FB_RDM22_P self,void *  aut, int mode);
#endif

#ifdef GEB_DEBUG_MODE
int dt_FB_RDM22_wv(dt_FB_RDM22_P self, void *  aut, int vnum, DEBUG_WV_VAL VAL);
#endif

#ifndef SUPPRESS_FORMATTED_OUTPUT
void dt_FB_RDM22_printVars(dt_FB_RDM22_P self, int indent, int detail);
#define dt_FB_RDM22_print(s,indent) dt_FB_RDM22_printVars(s,indent,1)
#endif
void dt_FB_RDM22_exec(dt_FB_RDM22_P self);
/* ---- RDM22 end header --- */
/* ---- pou=ARRAY_SHUFFLE2 pouId=2 begin header --- */
 /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:195 	FUNCTION_BLOCK ARRAY_SHUFFLE2 */
typedef struct dt_FB_ARRAY_SHUFFLE2 {
	dt_Der_oscat_PT_ARRAY_P v_PT;
	dt_FB_RDM22 v_RDM2;
	REAL_t v_temp;
	UINT_t v_SIZE;
	INT_t v_i;
	INT_t v_pos;
	INT_t v_stop;
	BOOL_t v_ARRAY_SHUFFLE;
	BOOL_t v_EN;
	BOOL_t v_ENO;
} dt_FB_ARRAY_SHUFFLE2;
typedef dt_FB_ARRAY_SHUFFLE2 *dt_FB_ARRAY_SHUFFLE2_P;

void dt_FB_ARRAY_SHUFFLE2_copy(dt_FB_ARRAY_SHUFFLE2_P self,dt_FB_ARRAY_SHUFFLE2_P o);
void dt_FB_ARRAY_SHUFFLE2_init(dt_FB_ARRAY_SHUFFLE2_P self);
#ifdef GEB_DEBUG_MODE
#define dt_FB_ARRAY_SHUFFLE2_dump(s) dt_FB_ARRAY_SHUFFLE2_dump2(s,NULL,VARS_REPORT_WHAT_OUTPUT)
void dt_FB_ARRAY_SHUFFLE2_dump2(dt_FB_ARRAY_SHUFFLE2_P self,void *  aut, int mode);
#endif

#ifdef GEB_DEBUG_MODE
int dt_FB_ARRAY_SHUFFLE2_wv(dt_FB_ARRAY_SHUFFLE2_P self, void *  aut, int vnum, DEBUG_WV_VAL VAL);
#endif

#ifndef SUPPRESS_FORMATTED_OUTPUT
void dt_FB_ARRAY_SHUFFLE2_printVars(dt_FB_ARRAY_SHUFFLE2_P self, int indent, int detail);
#define dt_FB_ARRAY_SHUFFLE2_print(s,indent) dt_FB_ARRAY_SHUFFLE2_printVars(s,indent,1)
#endif
void dt_FB_ARRAY_SHUFFLE2_exec(dt_FB_ARRAY_SHUFFLE2_P self);
/* ---- ARRAY_SHUFFLE2 end header --- */
/* ---- pou=program0 pouId=13 begin header --- */
 /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:228 	PROGRAM program0 */
typedef struct dt_PR_program0 {
	dt_Der_oscat_PT_ARRAY v_LocalVar0;
	dt_FB_ARRAY_SHUFFLE2 v_func_block;
	UINT_t v_LocalVar1;
	BOOL_t v_LocalOUT;
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
/* ==== POU: T_PLC_MS_block (num:10 module:575) */
/* === vars:  0:N 1:Offset 2:PLC_SYS_TICK_CNT 3:PLC_TICKS_PER_SEC 4:T_PLC_MS 5:base 6:debug
	 7:faktor 8:init 9:mode 10:temp 11:v_plc_ticks_per_sec */

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
	BOOL_t_init(&(self->v_init));
	UDINT_t_init(&(self->v_v_plc_ticks_per_sec));
	self->v_base = ((UDINT_t)1000UL);
}

#ifdef GEB_DEBUG_MODE
void dt_FB_T_PLC_MS_block_dump2(dt_FB_T_PLC_MS_block_P self,void *  aut, int mode) {
	writeGcbor_mapBegin();
	if((mode & VARS_REPORT_WHAT_STATIC) != 0 ) {
		DUMP_VAR( 0,	GEBLIB_dump_INT( self->v_N) );
		DUMP_VAR( 1,	GEBLIB_dump_UDINT( self->v_Offset) );
		DUMP_VAR( 2,	GEBLIB_dump_DINT( self->v_PLC_SYS_TICK_CNT) );
		DUMP_VAR( 3,	GEBLIB_dump_INT( self->v_PLC_TICKS_PER_SEC) );
		DUMP_VAR( 5,	GEBLIB_dump_UDINT( self->v_base) );
		DUMP_VAR( 6,	GEBLIB_dump_BOOL( self->v_debug) );
		DUMP_VAR( 7,	GEBLIB_dump_UDINT( self->v_faktor) );
		DUMP_VAR( 8,	GEBLIB_dump_BOOL( self->v_init) );
		DUMP_VAR( 9,	GEBLIB_dump_BOOL( self->v_mode) );
		DUMP_VAR( 10,	GEBLIB_dump_DWORD( self->v_temp) );
		DUMP_VAR( 11,	GEBLIB_dump_UDINT( self->v_v_plc_ticks_per_sec) );
	}
	if((mode & VARS_REPORT_WHAT_OUTPUT) != 0 ) {
		DUMP_VAR( 4,	GEBLIB_dump_UDINT( self->v_T_PLC_MS) );
	}
	writeGcbor_mapEnd();
}
#endif

#ifdef GEB_DEBUG_MODE
int dt_FB_T_PLC_MS_block_wv(dt_FB_T_PLC_MS_block_P self, void *  aut, int vnum, DEBUG_WV_VAL VAL) {
	int ret;
	ret=0;
	switch(vnum) {
		case 0 : self->v_N = GEBLIB_WV_INT(VAL,&ret,self->v_N); break;
		case 1 : self->v_Offset = GEBLIB_WV_UDINT(VAL,&ret,self->v_Offset); break;
		case 2 : self->v_PLC_SYS_TICK_CNT = GEBLIB_WV_DINT(VAL,&ret,self->v_PLC_SYS_TICK_CNT); break;
		case 3 : self->v_PLC_TICKS_PER_SEC = GEBLIB_WV_INT(VAL,&ret,self->v_PLC_TICKS_PER_SEC); break;
		case 4 : self->v_T_PLC_MS = GEBLIB_WV_UDINT(VAL,&ret,self->v_T_PLC_MS); break;
		case 5 : self->v_base = GEBLIB_WV_UDINT(VAL,&ret,self->v_base); break;
		case 6 : self->v_debug = GEBLIB_WV_BOOL(VAL,&ret,self->v_debug); break;
		case 7 : self->v_faktor = GEBLIB_WV_UDINT(VAL,&ret,self->v_faktor); break;
		case 8 : self->v_init = GEBLIB_WV_BOOL(VAL,&ret,self->v_init); break;
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
		GEBputsINL("init:");
		GEBLIB_print_BOOL(self->v_init);
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
	DEBUG_PUSH_STACK(10,575,self,NULL,&dt_FB_T_PLC_MS_block_dump2, &dt_FB_T_PLC_MS_block_wv,POU_FLAG_TYPE_FUNCTION_BLOCK);
#endif
/* codeExecAutomaticVars end */
	EN_ENO_CHECK {
beginPouExec:
		DEBUG_ST(72,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:72 	IF init = FALSE THEN */
		if(  GEBLIB_EQ_BOOL(self->v_init,false)  )	{
		DEBUG_ST(73,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:73 	v_plc_ticks_per_sec := INT_TO_UDINT(PLC_TICKS_PER_SEC); */
		self->v_v_plc_ticks_per_sec = gebx_MOVE_UDINT(self->v_PLC_TICKS_PER_SEC);
		DEBUG_ST(74,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:74 	IF v_plc_ticks_per_sec = UDINT#1024 THEN */
		if(  GEBLIB_EQ_UDINT(self->v_v_plc_ticks_per_sec,((UDINT_t)1024UL))  )	{
		DEBUG_ST(75,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:75 	faktor := UDINT#1; */
		self->v_faktor = ((UDINT_t)1UL);
		DEBUG_ST(76,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:76 	mode := FALSE; */
		self->v_mode = false;
		} else if (  GEBLIB_GT_UDINT(self->v_v_plc_ticks_per_sec,((UDINT_t)0UL))  )	{
			DEBUG_ST(78,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:78 	IF v_plc_ticks_per_sec <= base THEN */
			if(  GEBLIB_LE_UDINT(self->v_v_plc_ticks_per_sec,self->v_base)  )	{
			DEBUG_ST(79,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:79 	faktor := base / v_plc_ticks_per_sec; */
			self->v_faktor =  GEBLIB_DIV_UDINT(self->v_base,self->v_v_plc_ticks_per_sec) ;
			DEBUG_ST(80,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:80 	mode := FALSE; */
			self->v_mode = false;
			} else	{
				DEBUG_ST(82,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:82 	faktor := v_plc_ticks_per_sec / base; */
				self->v_faktor =  GEBLIB_DIV_UDINT(self->v_v_plc_ticks_per_sec,self->v_base) ;
				DEBUG_ST(83,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:83 	mode := TRUE; */
				self->v_mode = true;
			}
		} else	{
			DEBUG_ST(86,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:86 	faktor := UDINT#1; */
			self->v_faktor = ((UDINT_t)1UL);
		}
		DEBUG_ST(88,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:88 	init := TRUE; */
		self->v_init = true;
		}
		DEBUG_ST(91,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:91 	IF mode THEN */
		if( self->v_mode )	{
		DEBUG_ST(92,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:92 	T_PLC_MS := DINT_TO_UDINT(PLC_SYS_TICK_CNT) / faktor; */
		self->v_T_PLC_MS =  GEBLIB_DIV_UDINT(gebx_MOVE_UDINT(self->v_PLC_SYS_TICK_CNT),self->v_faktor) ;
		} else	{
			DEBUG_ST(94,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:94 	T_PLC_MS := DINT_TO_UDINT(PLC_SYS_TICK_CNT) * faktor; */
			self->v_T_PLC_MS =  GEBLIB_MUL_UDINT(gebx_MOVE_UDINT(self->v_PLC_SYS_TICK_CNT),self->v_faktor) ;
		}
		DEBUG_ST(97,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:97 	IF debug THEN */
		if( self->v_debug )	{
		DEBUG_ST(98,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:98 	T_PLC_MS := (DWORD_TO_UDINT(SHL(UDINT_TO_DWORD(T_PLC_MS),N) OR SHL(temp,N)) - UDINT#1) + Offset; */
		self->v_T_PLC_MS =  GEBLIB_ADD_UDINT( GEBLIB_SUB_UDINT(gebx_MOVE_UDINT( GEBLIB_OR_DWORD(gebx_SHL_DWORD(gebx_MOVE_UDINT(self->v_T_PLC_MS),self->v_N),gebx_SHL_DWORD(self->v_temp,self->v_N)) ),((UDINT_t)1UL)) ,self->v_Offset) ;
		}
endPouExec: ;
		geb_hook(GEB_WHERE_END_OF_FUNC_FB,DEBUGGING_MODE);
	}
	DEBUG_POP_STACK();
	return ;
}
/* ---- end T_PLC_MS_block end body  --- */
/* ---- _INT_TO_UDINT begin body  ---- */
/* ==== POU: _INT_TO_UDINT (num:12 module:575) */
/* === vars:  0:IN 1:_INT_TO_UDINT */

#ifdef GEB_DEBUG_MODE
void dt_FN__INT_TO_UDINT_dump2(void *  self,adt_FN__INT_TO_UDINT_P aut, int mode) {
	writeGcbor_mapBegin();
	if((mode & VARS_REPORT_WHAT_AUTO) != 0  && aut != NULL) {
		DUMP_VAR( 0,	GEBLIB_dump_INT( *(aut->v_IN)) );
		DUMP_VAR( 1,	GEBLIB_dump_UDINT( *(aut->v__INT_TO_UDINT)) );
	}
	writeGcbor_mapEnd();
}
#endif

#ifdef GEB_DEBUG_MODE
int dt_FN__INT_TO_UDINT_wv(void *  self, adt_FN__INT_TO_UDINT_P aut, int vnum, DEBUG_WV_VAL VAL) {
	int ret;
	ret=0;
	switch(vnum) {
		case 0 : if(aut!=NULL){ *(aut->v_IN) = GEBLIB_WV_INT(VAL,&ret,*(aut->v_IN)); } else {ret=GEB_WV_ERR_NOAUTO;} break;
		case 1 : if(aut!=NULL){ *(aut->v__INT_TO_UDINT) = GEBLIB_WV_UDINT(VAL,&ret,*(aut->v__INT_TO_UDINT)); } else {ret=GEB_WV_ERR_NOAUTO;} break;
		default : ret=GEB_WV_ERR_BADVAR; /* no apt var found */
	}
	return ret;
}
#endif

UDINT_t dt_FN__INT_TO_UDINT_exec( INT_t v_IN ) {
/* codeExecAutomaticVars begin */
#ifdef GEB_DEBUG_MODE
	adt_FN__INT_TO_UDINT aut;
#endif
	UDINT_t v__INT_TO_UDINT;
	/* automatic vars initialization */
#ifdef GEB_DEBUG_MODE
	DEBUG_PUSH_STACK(12,575,NULL,&aut,&dt_FN__INT_TO_UDINT_dump2, &dt_FN__INT_TO_UDINT_wv,POU_FLAG_TYPE_FUNCTION);
	aut.v__INT_TO_UDINT=  &(v__INT_TO_UDINT);
	aut.v_IN=  &(v_IN);
#endif
/* codeExecAutomaticVars end */
beginPouExec:
	DEBUG_ST(132,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:132 	_INT_TO_UDINT := DINT_TO_UDINT(INT_TO_DINT(IN)); */
	v__INT_TO_UDINT = gebx_MOVE_UDINT(gebx_MOVE_DINT(v_IN));
endPouExec: ;
	geb_hook(GEB_WHERE_END_OF_FUNC_FB,DEBUGGING_MODE);
	DEBUG_POP_STACK();
	return v__INT_TO_UDINT;
}
/* ---- end _INT_TO_UDINT end body  --- */
/* ---- D_TRUNC begin body  ---- */
/* ==== POU: D_TRUNC (num:6 module:575) */
/* === vars:  0:D_TRUNC 1:X */

#ifdef GEB_DEBUG_MODE
void dt_FN_D_TRUNC_dump2(void *  self,adt_FN_D_TRUNC_P aut, int mode) {
	writeGcbor_mapBegin();
	if((mode & VARS_REPORT_WHAT_AUTO) != 0  && aut != NULL) {
		DUMP_VAR( 0,	GEBLIB_dump_DINT( *(aut->v_D_TRUNC)) );
		DUMP_VAR( 1,	GEBLIB_dump_REAL( *(aut->v_X)) );
	}
	writeGcbor_mapEnd();
}
#endif

#ifdef GEB_DEBUG_MODE
int dt_FN_D_TRUNC_wv(void *  self, adt_FN_D_TRUNC_P aut, int vnum, DEBUG_WV_VAL VAL) {
	int ret;
	ret=0;
	switch(vnum) {
		case 0 : if(aut!=NULL){ *(aut->v_D_TRUNC) = GEBLIB_WV_DINT(VAL,&ret,*(aut->v_D_TRUNC)); } else {ret=GEB_WV_ERR_NOAUTO;} break;
		case 1 : if(aut!=NULL){ *(aut->v_X) = GEBLIB_WV_REAL(VAL,&ret,*(aut->v_X)); } else {ret=GEB_WV_ERR_NOAUTO;} break;
		default : ret=GEB_WV_ERR_BADVAR; /* no apt var found */
	}
	return ret;
}
#endif

DINT_t dt_FN_D_TRUNC_exec( REAL_t v_X ) {
/* codeExecAutomaticVars begin */
#ifdef GEB_DEBUG_MODE
	adt_FN_D_TRUNC aut;
#endif
	DINT_t v_D_TRUNC;
	/* automatic vars initialization */
#ifdef GEB_DEBUG_MODE
	DEBUG_PUSH_STACK(6,575,NULL,&aut,&dt_FN_D_TRUNC_dump2, &dt_FN_D_TRUNC_wv,POU_FLAG_TYPE_FUNCTION);
	aut.v_D_TRUNC=  &(v_D_TRUNC);
	aut.v_X=  &(v_X);
#endif
/* codeExecAutomaticVars end */
beginPouExec:
	DEBUG_ST(11,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:11 	D_TRUNC := REAL_TO_DINT(X); */
	v_D_TRUNC = gebx_REAL_TO_DINT(v_X);
	DEBUG_ST(12,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:12 	IF X > 0.0 THEN */
	if(  GEBLIB_GT_REAL(v_X,((REAL_t)0.0f))  )	{
	DEBUG_ST(13,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:13 	IF DINT_TO_REAL(D_TRUNC) > X THEN D_TRUNC := D_TRUNC - DINT#1; END_IF; */
	if(  GEBLIB_GT_REAL(gebx_DINT_TO_REAL(v_D_TRUNC),v_X)  )	{
	DEBUG_ST(13,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:13 	IF DINT_TO_REAL(D_TRUNC) > X THEN D_TRUNC := D_TRUNC - DINT#1; END_IF; */
	v_D_TRUNC =  GEBLIB_SUB_DINT(v_D_TRUNC,((DINT_t)1L)) ;
	}
	} else	{
		DEBUG_ST(15,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:15 	IF DINT_TO_REAL(D_TRUNC) < X THEN D_TRUNC := D_TRUNC + DINT#1; END_IF; */
		if(  GEBLIB_LT_REAL(gebx_DINT_TO_REAL(v_D_TRUNC),v_X)  )	{
		DEBUG_ST(15,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:15 	IF DINT_TO_REAL(D_TRUNC) < X THEN D_TRUNC := D_TRUNC + DINT#1; END_IF; */
		v_D_TRUNC =  GEBLIB_ADD_DINT(v_D_TRUNC,((DINT_t)1L)) ;
		}
	}
endPouExec: ;
	geb_hook(GEB_WHERE_END_OF_FUNC_FB,DEBUGGING_MODE);
	DEBUG_POP_STACK();
	return v_D_TRUNC;
}
/* ---- end D_TRUNC end body  --- */
/* ---- FRACT begin body  ---- */
/* ==== POU: FRACT (num:7 module:575) */
/* === vars:  0:FRACT 1:X */

#ifdef GEB_DEBUG_MODE
void dt_FN_FRACT_dump2(void *  self,adt_FN_FRACT_P aut, int mode) {
	writeGcbor_mapBegin();
	if((mode & VARS_REPORT_WHAT_AUTO) != 0  && aut != NULL) {
		DUMP_VAR( 0,	GEBLIB_dump_REAL( *(aut->v_FRACT)) );
		DUMP_VAR( 1,	GEBLIB_dump_REAL( *(aut->v_X)) );
	}
	writeGcbor_mapEnd();
}
#endif

#ifdef GEB_DEBUG_MODE
int dt_FN_FRACT_wv(void *  self, adt_FN_FRACT_P aut, int vnum, DEBUG_WV_VAL VAL) {
	int ret;
	ret=0;
	switch(vnum) {
		case 0 : if(aut!=NULL){ *(aut->v_FRACT) = GEBLIB_WV_REAL(VAL,&ret,*(aut->v_FRACT)); } else {ret=GEB_WV_ERR_NOAUTO;} break;
		case 1 : if(aut!=NULL){ *(aut->v_X) = GEBLIB_WV_REAL(VAL,&ret,*(aut->v_X)); } else {ret=GEB_WV_ERR_NOAUTO;} break;
		default : ret=GEB_WV_ERR_BADVAR; /* no apt var found */
	}
	return ret;
}
#endif

REAL_t dt_FN_FRACT_exec( REAL_t v_X ) {
/* codeExecAutomaticVars begin */
#ifdef GEB_DEBUG_MODE
	adt_FN_FRACT aut;
#endif
	REAL_t v_FRACT;
	/* automatic vars initialization */
#ifdef GEB_DEBUG_MODE
	DEBUG_PUSH_STACK(7,575,NULL,&aut,&dt_FN_FRACT_dump2, &dt_FN_FRACT_wv,POU_FLAG_TYPE_FUNCTION);
	aut.v_FRACT=  &(v_FRACT);
	aut.v_X=  &(v_X);
#endif
/* codeExecAutomaticVars end */
beginPouExec:
	DEBUG_ST(42,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:42 	IF ABS(X) < 2.0E9 THEN */
	if(  GEBLIB_LT_REAL(gebx_ABS_REAL(v_X),((REAL_t)2.0E9f))  )	{
	DEBUG_ST(43,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:43 	FRACT := X - DINT_TO_REAL(D_TRUNC(X)); */
	v_FRACT =  GEBLIB_SUB_REAL(v_X,gebx_DINT_TO_REAL(dt_FN_D_TRUNC_exec(v_X))) ;
	} else	{
		DEBUG_ST(45,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:45 	FRACT := 0.0; */
		v_FRACT = ((REAL_t)0.0f);
	}
endPouExec: ;
	geb_hook(GEB_WHERE_END_OF_FUNC_FB,DEBUGGING_MODE);
	DEBUG_POP_STACK();
	return v_FRACT;
}
/* ---- end FRACT end body  --- */
/* ---- BIT_COUNT begin body  ---- */
/* ==== POU: BIT_COUNT (num:3 module:575) */
/* === vars:  0:BIT_COUNT 1:IN 2:in_temp */

#ifdef GEB_DEBUG_MODE
void dt_FN_BIT_COUNT_dump2(void *  self,adt_FN_BIT_COUNT_P aut, int mode) {
	writeGcbor_mapBegin();
	if((mode & VARS_REPORT_WHAT_AUTO) != 0  && aut != NULL) {
		DUMP_VAR( 0,	GEBLIB_dump_INT( *(aut->v_BIT_COUNT)) );
		DUMP_VAR( 1,	GEBLIB_dump_DWORD( *(aut->v_IN)) );
		DUMP_VAR( 2,	GEBLIB_dump_DWORD( *(aut->v_in_temp)) );
	}
	writeGcbor_mapEnd();
}
#endif

#ifdef GEB_DEBUG_MODE
int dt_FN_BIT_COUNT_wv(void *  self, adt_FN_BIT_COUNT_P aut, int vnum, DEBUG_WV_VAL VAL) {
	int ret;
	ret=0;
	switch(vnum) {
		case 0 : if(aut!=NULL){ *(aut->v_BIT_COUNT) = GEBLIB_WV_INT(VAL,&ret,*(aut->v_BIT_COUNT)); } else {ret=GEB_WV_ERR_NOAUTO;} break;
		case 1 : if(aut!=NULL){ *(aut->v_IN) = GEBLIB_WV_DWORD(VAL,&ret,*(aut->v_IN)); } else {ret=GEB_WV_ERR_NOAUTO;} break;
		case 2 : if(aut!=NULL){ *(aut->v_in_temp) = GEBLIB_WV_DWORD(VAL,&ret,*(aut->v_in_temp)); } else {ret=GEB_WV_ERR_NOAUTO;} break;
		default : ret=GEB_WV_ERR_BADVAR; /* no apt var found */
	}
	return ret;
}
#endif

INT_t dt_FN_BIT_COUNT_exec( DWORD_t v_IN ) {
/* codeExecAutomaticVars begin */
#ifdef GEB_DEBUG_MODE
	adt_FN_BIT_COUNT aut;
#endif
	DWORD_t v_in_temp;
	INT_t v_BIT_COUNT;
	/* automatic vars initialization */
	DWORD_t_init(&(v_in_temp));
#ifdef GEB_DEBUG_MODE
	DEBUG_PUSH_STACK(3,575,NULL,&aut,&dt_FN_BIT_COUNT_dump2, &dt_FN_BIT_COUNT_wv,POU_FLAG_TYPE_FUNCTION);
	aut.v_IN=  &(v_IN);
	aut.v_in_temp=  &(v_in_temp);
	aut.v_BIT_COUNT=  &(v_BIT_COUNT);
#endif
/* codeExecAutomaticVars end */
beginPouExec:
	DEBUG_ST(29,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:29 	in_temp := IN; */
	v_in_temp = v_IN;
	DEBUG_ST(30,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:30 	WHILE in_temp > DWORD#0 DO */
	while (  GEBLIB_GT_UDINT(v_in_temp,((DWORD_t)0x0L))  )	{
		DEBUG_ST(31,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:31 	IF (in_temp AND DWORD#16#00000001) > DWORD#0 THEN BIT_COUNT := BIT_COUNT +1; END_IF; */
		if(  GEBLIB_GT_UDINT( GEBLIB_AND_DWORD(v_in_temp,((DWORD_t)0x1L)) ,((DWORD_t)0x0L))  )	{
		DEBUG_ST(31,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:31 	IF (in_temp AND DWORD#16#00000001) > DWORD#0 THEN BIT_COUNT := BIT_COUNT +1; END_IF; */
		v_BIT_COUNT =  GEBLIB_ADD_INT(v_BIT_COUNT,((INT_t)1)) ;
		}
		DEBUG_ST(32,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:32 	in_temp := SHR(in_temp,1); */
		v_in_temp = gebx_SHR_DWORD(v_in_temp,((INT_t)1));
	}
endPouExec: ;
	geb_hook(GEB_WHERE_END_OF_FUNC_FB,DEBUGGING_MODE);
	DEBUG_POP_STACK();
	return v_BIT_COUNT;
}
/* ---- end BIT_COUNT end body  --- */
/* ---- BIT_OF_DWORD begin body  ---- */
/* ==== POU: BIT_OF_DWORD (num:5 module:575) */
/* === vars:  0:BIT_OF_DWORD 1:IN 2:N */

#ifdef GEB_DEBUG_MODE
void dt_FN_BIT_OF_DWORD_dump2(void *  self,adt_FN_BIT_OF_DWORD_P aut, int mode) {
	writeGcbor_mapBegin();
	if((mode & VARS_REPORT_WHAT_AUTO) != 0  && aut != NULL) {
		DUMP_VAR( 0,	GEBLIB_dump_BOOL( *(aut->v_BIT_OF_DWORD)) );
		DUMP_VAR( 1,	GEBLIB_dump_DWORD( *(aut->v_IN)) );
		DUMP_VAR( 2,	GEBLIB_dump_INT( *(aut->v_N)) );
	}
	writeGcbor_mapEnd();
}
#endif

#ifdef GEB_DEBUG_MODE
int dt_FN_BIT_OF_DWORD_wv(void *  self, adt_FN_BIT_OF_DWORD_P aut, int vnum, DEBUG_WV_VAL VAL) {
	int ret;
	ret=0;
	switch(vnum) {
		case 0 : if(aut!=NULL){ *(aut->v_BIT_OF_DWORD) = GEBLIB_WV_BOOL(VAL,&ret,*(aut->v_BIT_OF_DWORD)); } else {ret=GEB_WV_ERR_NOAUTO;} break;
		case 1 : if(aut!=NULL){ *(aut->v_IN) = GEBLIB_WV_DWORD(VAL,&ret,*(aut->v_IN)); } else {ret=GEB_WV_ERR_NOAUTO;} break;
		case 2 : if(aut!=NULL){ *(aut->v_N) = GEBLIB_WV_INT(VAL,&ret,*(aut->v_N)); } else {ret=GEB_WV_ERR_NOAUTO;} break;
		default : ret=GEB_WV_ERR_BADVAR; /* no apt var found */
	}
	return ret;
}
#endif

BOOL_t dt_FN_BIT_OF_DWORD_exec( DWORD_t v_IN ,INT_t v_N ) {
/* codeExecAutomaticVars begin */
#ifdef GEB_DEBUG_MODE
	adt_FN_BIT_OF_DWORD aut;
#endif
	BOOL_t v_BIT_OF_DWORD;
	/* automatic vars initialization */
#ifdef GEB_DEBUG_MODE
	DEBUG_PUSH_STACK(5,575,NULL,&aut,&dt_FN_BIT_OF_DWORD_dump2, &dt_FN_BIT_OF_DWORD_wv,POU_FLAG_TYPE_FUNCTION);
	aut.v_IN=  &(v_IN);
	aut.v_N=  &(v_N);
	aut.v_BIT_OF_DWORD=  &(v_BIT_OF_DWORD);
#endif
/* codeExecAutomaticVars end */
beginPouExec:
	DEBUG_ST(123,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:123 	BIT_OF_DWORD := (SHR(IN,N) AND 16#00000001) > 0; */
	v_BIT_OF_DWORD =  GEBLIB_GT_UDINT( GEBLIB_AND_DWORD(gebx_SHR_DWORD(v_IN,v_N),((DWORD_t)0x1L)) ,((UDINT_t)0UL)) ;
endPouExec: ;
	geb_hook(GEB_WHERE_END_OF_FUNC_FB,DEBUGGING_MODE);
	DEBUG_POP_STACK();
	return v_BIT_OF_DWORD;
}
/* ---- end BIT_OF_DWORD end body  --- */
/* ---- BIT_LOAD_DW begin body  ---- */
/* ==== POU: BIT_LOAD_DW (num:4 module:575) */
/* === vars:  0:BIT_LOAD_DW 1:IN 2:pos 3:VAL */

#ifdef GEB_DEBUG_MODE
void dt_FN_BIT_LOAD_DW_dump2(void *  self,adt_FN_BIT_LOAD_DW_P aut, int mode) {
	writeGcbor_mapBegin();
	if((mode & VARS_REPORT_WHAT_AUTO) != 0  && aut != NULL) {
		DUMP_VAR( 0,	GEBLIB_dump_DWORD( *(aut->v_BIT_LOAD_DW)) );
		DUMP_VAR( 1,	GEBLIB_dump_DWORD( *(aut->v_IN)) );
		DUMP_VAR( 2,	GEBLIB_dump_INT( *(aut->v_pos)) );
		DUMP_VAR( 3,	GEBLIB_dump_BOOL( *(aut->v_VAL)) );
	}
	writeGcbor_mapEnd();
}
#endif

#ifdef GEB_DEBUG_MODE
int dt_FN_BIT_LOAD_DW_wv(void *  self, adt_FN_BIT_LOAD_DW_P aut, int vnum, DEBUG_WV_VAL VAL) {
	int ret;
	ret=0;
	switch(vnum) {
		case 0 : if(aut!=NULL){ *(aut->v_BIT_LOAD_DW) = GEBLIB_WV_DWORD(VAL,&ret,*(aut->v_BIT_LOAD_DW)); } else {ret=GEB_WV_ERR_NOAUTO;} break;
		case 1 : if(aut!=NULL){ *(aut->v_IN) = GEBLIB_WV_DWORD(VAL,&ret,*(aut->v_IN)); } else {ret=GEB_WV_ERR_NOAUTO;} break;
		case 2 : if(aut!=NULL){ *(aut->v_pos) = GEBLIB_WV_INT(VAL,&ret,*(aut->v_pos)); } else {ret=GEB_WV_ERR_NOAUTO;} break;
		case 3 : if(aut!=NULL){ *(aut->v_VAL) = GEBLIB_WV_BOOL(VAL,&ret,*(aut->v_VAL)); } else {ret=GEB_WV_ERR_NOAUTO;} break;
		default : ret=GEB_WV_ERR_BADVAR; /* no apt var found */
	}
	return ret;
}
#endif

DWORD_t dt_FN_BIT_LOAD_DW_exec( DWORD_t v_IN ,BOOL_t v_VAL ,INT_t v_pos ) {
/* codeExecAutomaticVars begin */
#ifdef GEB_DEBUG_MODE
	adt_FN_BIT_LOAD_DW aut;
#endif
	DWORD_t v_BIT_LOAD_DW;
	/* automatic vars initialization */
#ifdef GEB_DEBUG_MODE
	DEBUG_PUSH_STACK(4,575,NULL,&aut,&dt_FN_BIT_LOAD_DW_dump2, &dt_FN_BIT_LOAD_DW_wv,POU_FLAG_TYPE_FUNCTION);
	aut.v_BIT_LOAD_DW=  &(v_BIT_LOAD_DW);
	aut.v_IN=  &(v_IN);
	aut.v_pos=  &(v_pos);
	aut.v_VAL=  &(v_VAL);
#endif
/* codeExecAutomaticVars end */
beginPouExec:
	DEBUG_ST(110,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:110 	IF VAL THEN */
	if( v_VAL )	{
	DEBUG_ST(111,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:111 	BIT_LOAD_DW := IN OR SHL(DWORD#1,pos); */
	v_BIT_LOAD_DW =  GEBLIB_OR_DWORD(v_IN,gebx_SHL_DWORD(((DWORD_t)0x1L),v_pos)) ;
	} else	{
		DEBUG_ST(113,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:113 	BIT_LOAD_DW := IN AND (NOT SHL(DWORD#1,pos)); */
		v_BIT_LOAD_DW =  GEBLIB_AND_DWORD(v_IN, GEBLIB_NOT_DWORD(gebx_SHL_DWORD(((DWORD_t)0x1L),v_pos))) ;
	}
endPouExec: ;
	geb_hook(GEB_WHERE_END_OF_FUNC_FB,DEBUGGING_MODE);
	DEBUG_POP_STACK();
	return v_BIT_LOAD_DW;
}
/* ---- end BIT_LOAD_DW end body  --- */
/* ---- _DWORD_TO_REAL begin body  ---- */
/* ==== POU: _DWORD_TO_REAL (num:11 module:575) */
/* === vars:  0:IN 1:_DWORD_TO_REAL */

#ifdef GEB_DEBUG_MODE
void dt_FN__DWORD_TO_REAL_dump2(void *  self,adt_FN__DWORD_TO_REAL_P aut, int mode) {
	writeGcbor_mapBegin();
	if((mode & VARS_REPORT_WHAT_AUTO) != 0  && aut != NULL) {
		DUMP_VAR( 0,	GEBLIB_dump_DWORD( *(aut->v_IN)) );
		DUMP_VAR( 1,	GEBLIB_dump_REAL( *(aut->v__DWORD_TO_REAL)) );
	}
	writeGcbor_mapEnd();
}
#endif

#ifdef GEB_DEBUG_MODE
int dt_FN__DWORD_TO_REAL_wv(void *  self, adt_FN__DWORD_TO_REAL_P aut, int vnum, DEBUG_WV_VAL VAL) {
	int ret;
	ret=0;
	switch(vnum) {
		case 0 : if(aut!=NULL){ *(aut->v_IN) = GEBLIB_WV_DWORD(VAL,&ret,*(aut->v_IN)); } else {ret=GEB_WV_ERR_NOAUTO;} break;
		case 1 : if(aut!=NULL){ *(aut->v__DWORD_TO_REAL) = GEBLIB_WV_REAL(VAL,&ret,*(aut->v__DWORD_TO_REAL)); } else {ret=GEB_WV_ERR_NOAUTO;} break;
		default : ret=GEB_WV_ERR_BADVAR; /* no apt var found */
	}
	return ret;
}
#endif

REAL_t dt_FN__DWORD_TO_REAL_exec( DWORD_t v_IN ) {
/* codeExecAutomaticVars begin */
#ifdef GEB_DEBUG_MODE
	adt_FN__DWORD_TO_REAL aut;
#endif
	REAL_t v__DWORD_TO_REAL;
	/* automatic vars initialization */
#ifdef GEB_DEBUG_MODE
	DEBUG_PUSH_STACK(11,575,NULL,&aut,&dt_FN__DWORD_TO_REAL_dump2, &dt_FN__DWORD_TO_REAL_wv,POU_FLAG_TYPE_FUNCTION);
	aut.v_IN=  &(v_IN);
	aut.v__DWORD_TO_REAL=  &(v__DWORD_TO_REAL);
#endif
/* codeExecAutomaticVars end */
beginPouExec:
	DEBUG_ST(140,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:140 	_DWORD_TO_REAL := UDINT_TO_REAL(DWORD_TO_UDINT(IN)); */
	v__DWORD_TO_REAL = gebx_UDINT_TO_REAL(gebx_MOVE_UDINT(v_IN));
endPouExec: ;
	geb_hook(GEB_WHERE_END_OF_FUNC_FB,DEBUGGING_MODE);
	DEBUG_POP_STACK();
	return v__DWORD_TO_REAL;
}
/* ---- end _DWORD_TO_REAL end body  --- */
/* ---- RDM_block begin body  ---- */
/* ==== POU: RDM_block (num:9 module:575) */
/* === vars:  0:RDM 1:T_PLC_MS 2:last 3:tc 4:tn */

void dt_FB_RDM_block_copy(dt_FB_RDM_block_P self,dt_FB_RDM_block_P o){ *self=*o; }
void dt_FB_RDM_block_init(dt_FB_RDM_block_P self){
	ZERO_STRUCT(self);
	self->v_EN = true;
	BOOL_t_init(&(self->v_ENO));
	REAL_t_init(&(self->v_last));
	REAL_t_init(&(self->v_RDM));
	dt_FB_T_PLC_MS_block_init(&(self->v_T_PLC_MS));
	DWORD_t_init(&(self->v_tn));
	INT_t_init(&(self->v_tc));
}

#ifdef GEB_DEBUG_MODE
void dt_FB_RDM_block_dump2(dt_FB_RDM_block_P self,void *  aut, int mode) {
	writeGcbor_mapBegin();
	if((mode & VARS_REPORT_WHAT_STATIC) != 0 ) {
		DUMP_VAR( 1,	dt_FB_T_PLC_MS_block_dump( &(self->v_T_PLC_MS)) );
		DUMP_VAR( 2,	GEBLIB_dump_REAL( self->v_last) );
		DUMP_VAR( 3,	GEBLIB_dump_INT( self->v_tc) );
		DUMP_VAR( 4,	GEBLIB_dump_DWORD( self->v_tn) );
	}
	if((mode & VARS_REPORT_WHAT_OUTPUT) != 0 ) {
		DUMP_VAR( 0,	GEBLIB_dump_REAL( self->v_RDM) );
	}
	writeGcbor_mapEnd();
}
#endif

#ifdef GEB_DEBUG_MODE
int dt_FB_RDM_block_wv(dt_FB_RDM_block_P self, void *  aut, int vnum, DEBUG_WV_VAL VAL) {
	int ret;
	ret=0;
	switch(vnum) {
		case 0 : self->v_RDM = GEBLIB_WV_REAL(VAL,&ret,self->v_RDM); break;
		case 1 : ret=GEB_WV_ERR_MULTI; break;
		case 2 : self->v_last = GEBLIB_WV_REAL(VAL,&ret,self->v_last); break;
		case 3 : self->v_tc = GEBLIB_WV_INT(VAL,&ret,self->v_tc); break;
		case 4 : self->v_tn = GEBLIB_WV_DWORD(VAL,&ret,self->v_tn); break;
		default : ret=GEB_WV_ERR_BADVAR; /* no apt var found */
	}
	return ret;
}
#endif

#ifndef SUPPRESS_FORMATTED_OUTPUT
void dt_FB_RDM_block_printVars(dt_FB_RDM_block_P self, int indent, int detail) {
	if(detail>=1) {
		GEBputsINL("RDM:");
		GEBLIB_print_REAL(self->v_RDM);
		GEBputsINL("last:");
		GEBLIB_print_REAL(self->v_last);
	}
	if(detail>=2) {
		GEBputsINL("T_PLC_MS:");
		dt_FB_T_PLC_MS_block_print(&(self->v_T_PLC_MS), indent+1);
		GEBputsINL("tc:");
		GEBLIB_print_INT(self->v_tc);
		GEBputsINL("tn:");
		GEBLIB_print_DWORD(self->v_tn);
	}
}
#endif

void dt_FB_RDM_block_exec(dt_FB_RDM_block_P self) {
/* codeExecAutomaticVars begin */
#ifdef GEB_DEBUG_MODE
	DEBUG_PUSH_STACK(9,575,self,NULL,&dt_FB_RDM_block_dump2, &dt_FB_RDM_block_wv,POU_FLAG_TYPE_FUNCTION_BLOCK);
#endif
/* codeExecAutomaticVars end */
	EN_ENO_CHECK {
beginPouExec:
		DEBUG_ST(156,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:156 	T_PLC_MS(); */
		/* beginFB call */
		dt_FB_T_PLC_MS_block_exec(&(self->v_T_PLC_MS) );
		DEBUG_ST(157,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:157 	tn := UDINT_TO_DWORD(T_PLC_MS.T_PLC_MS); */
		self->v_tn = gebx_MOVE_UDINT(self->v_T_PLC_MS.v_T_PLC_MS);
		DEBUG_ST(158,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:158 	tc := BIT_COUNT(tn); */
		self->v_tc = dt_FN_BIT_COUNT_exec(self->v_tn);
		DEBUG_ST(160,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:160 	tn:=BIT_LOAD_DW(tn,BIT_OF_DWORD(tn,2),31); (* tn.31 := tn.2; *) */
		self->v_tn = dt_FN_BIT_LOAD_DW_exec(self->v_tn,dt_FN_BIT_OF_DWORD_exec(self->v_tn,((INT_t)2)),((INT_t)31));
		DEBUG_ST(161,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:161 	tn:=BIT_LOAD_DW(tn,BIT_OF_DWORD(tn,5),30); (* tn.30 := tn.5; *) */
		self->v_tn = dt_FN_BIT_LOAD_DW_exec(self->v_tn,dt_FN_BIT_OF_DWORD_exec(self->v_tn,((INT_t)5)),((INT_t)30));
		DEBUG_ST(162,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:162 	tn:=BIT_LOAD_DW(tn,BIT_OF_DWORD(tn,4),29); (* tn.29 := tn.4; *) */
		self->v_tn = dt_FN_BIT_LOAD_DW_exec(self->v_tn,dt_FN_BIT_OF_DWORD_exec(self->v_tn,((INT_t)4)),((INT_t)29));
		DEBUG_ST(163,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:163 	tn:=BIT_LOAD_DW(tn,BIT_OF_DWORD(tn,1),28); (* tn.28 := tn.1; *) */
		self->v_tn = dt_FN_BIT_LOAD_DW_exec(self->v_tn,dt_FN_BIT_OF_DWORD_exec(self->v_tn,((INT_t)1)),((INT_t)28));
		DEBUG_ST(164,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:164 	tn:=BIT_LOAD_DW(tn,BIT_OF_DWORD(tn,0),27); (* tn.27 := tn.0; *) */
		self->v_tn = dt_FN_BIT_LOAD_DW_exec(self->v_tn,dt_FN_BIT_OF_DWORD_exec(self->v_tn,((INT_t)0)),((INT_t)27));
		DEBUG_ST(165,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:165 	tn:=BIT_LOAD_DW(tn,BIT_OF_DWORD(tn,7),26); (* tn.26 := tn.7; *) */
		self->v_tn = dt_FN_BIT_LOAD_DW_exec(self->v_tn,dt_FN_BIT_OF_DWORD_exec(self->v_tn,((INT_t)7)),((INT_t)26));
		DEBUG_ST(166,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:166 	tn:=BIT_LOAD_DW(tn,BIT_OF_DWORD(tn,6),25); (* tn.25 := tn.6; *) */
		self->v_tn = dt_FN_BIT_LOAD_DW_exec(self->v_tn,dt_FN_BIT_OF_DWORD_exec(self->v_tn,((INT_t)6)),((INT_t)25));
		DEBUG_ST(167,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:167 	tn:=BIT_LOAD_DW(tn,BIT_OF_DWORD(tn,3),24); (* tn.24 := tn.3; *) */
		self->v_tn = dt_FN_BIT_LOAD_DW_exec(self->v_tn,dt_FN_BIT_OF_DWORD_exec(self->v_tn,((INT_t)3)),((INT_t)24));
		DEBUG_ST(169,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:169 	tn := ROL(tn,BIT_COUNT(tn)) OR DWORD#16#80000001; */
		self->v_tn =  GEBLIB_OR_DWORD(gebx_ROL_DWORD(self->v_tn,dt_FN_BIT_COUNT_exec(self->v_tn)),((DWORD_t)0x80000001L)) ;
		DEBUG_ST(170,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:170 	tn := UDINT_TO_DWORD(DWORD_TO_UDINT(tn) MOD UDINT#71474513 + _INT_TO_UDINT(tc) + UDINT#77); */
		self->v_tn = gebx_MOVE_UDINT( GEBLIB_ADD_UDINT( GEBLIB_ADD_UDINT( GEBLIB_MOD_UDINT(gebx_MOVE_UDINT(self->v_tn),((UDINT_t)71474513UL)) ,dt_FN__INT_TO_UDINT_exec(self->v_tc)) ,((UDINT_t)77UL)) );
		DEBUG_ST(171,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:171 	RDM := FRACT(_DWORD_TO_REAL(tn) / 10000000.0 * (2.71828182845904523536028747135266249 - LIMIT_REAL(0.0,last,1.0))); */
		self->v_RDM = dt_FN_FRACT_exec( GEBLIB_MUL_REAL( GEBLIB_DIV_REAL(dt_FN__DWORD_TO_REAL_exec(self->v_tn),((REAL_t)1.0E7f)) , GEBLIB_SUB_REAL(((REAL_t)2.7182817f),gebx_LIMIT_REAL(((REAL_t)0.0f),self->v_last,((REAL_t)1.0f))) ) );
endPouExec: ;
		geb_hook(GEB_WHERE_END_OF_FUNC_FB,DEBUGGING_MODE);
	}
	DEBUG_POP_STACK();
	return ;
}
/* ---- end RDM_block end body  --- */
/* ---- RDM22 begin body  ---- */
/* ==== POU: RDM22 (num:8 module:575) */
/* === vars:  0:RDM2 1:RDM_p 2:high 3:last 4:low */

void dt_FB_RDM22_copy(dt_FB_RDM22_P self,dt_FB_RDM22_P o){ *self=*o; }
void dt_FB_RDM22_init(dt_FB_RDM22_P self){
	ZERO_STRUCT(self);
	self->v_EN = true;
	BOOL_t_init(&(self->v_ENO));
	INT_t_init(&(self->v_last));
	INT_t_init(&(self->v_low));
	INT_t_init(&(self->v_high));
	INT_t_init(&(self->v_RDM2));
	dt_FB_RDM_block_init(&(self->v_RDM_p));
}

#ifdef GEB_DEBUG_MODE
void dt_FB_RDM22_dump2(dt_FB_RDM22_P self,void *  aut, int mode) {
	writeGcbor_mapBegin();
	if((mode & VARS_REPORT_WHAT_STATIC) != 0 ) {
		DUMP_VAR( 1,	dt_FB_RDM_block_dump( &(self->v_RDM_p)) );
		DUMP_VAR( 2,	GEBLIB_dump_INT( self->v_high) );
		DUMP_VAR( 3,	GEBLIB_dump_INT( self->v_last) );
		DUMP_VAR( 4,	GEBLIB_dump_INT( self->v_low) );
	}
	if((mode & VARS_REPORT_WHAT_OUTPUT) != 0 ) {
		DUMP_VAR( 0,	GEBLIB_dump_INT( self->v_RDM2) );
	}
	writeGcbor_mapEnd();
}
#endif

#ifdef GEB_DEBUG_MODE
int dt_FB_RDM22_wv(dt_FB_RDM22_P self, void *  aut, int vnum, DEBUG_WV_VAL VAL) {
	int ret;
	ret=0;
	switch(vnum) {
		case 0 : self->v_RDM2 = GEBLIB_WV_INT(VAL,&ret,self->v_RDM2); break;
		case 1 : ret=GEB_WV_ERR_MULTI; break;
		case 2 : self->v_high = GEBLIB_WV_INT(VAL,&ret,self->v_high); break;
		case 3 : self->v_last = GEBLIB_WV_INT(VAL,&ret,self->v_last); break;
		case 4 : self->v_low = GEBLIB_WV_INT(VAL,&ret,self->v_low); break;
		default : ret=GEB_WV_ERR_BADVAR; /* no apt var found */
	}
	return ret;
}
#endif

#ifndef SUPPRESS_FORMATTED_OUTPUT
void dt_FB_RDM22_printVars(dt_FB_RDM22_P self, int indent, int detail) {
	if(detail>=1) {
		GEBputsINL("RDM2:");
		GEBLIB_print_INT(self->v_RDM2);
		GEBputsINL("high:");
		GEBLIB_print_INT(self->v_high);
		GEBputsINL("last:");
		GEBLIB_print_INT(self->v_last);
		GEBputsINL("low:");
		GEBLIB_print_INT(self->v_low);
	}
	if(detail>=2) {
		GEBputsINL("RDM_p:");
		dt_FB_RDM_block_print(&(self->v_RDM_p), indent+1);
	}
}
#endif

void dt_FB_RDM22_exec(dt_FB_RDM22_P self) {
/* codeExecAutomaticVars begin */
#ifdef GEB_DEBUG_MODE
	DEBUG_PUSH_STACK(8,575,self,NULL,&dt_FB_RDM22_dump2, &dt_FB_RDM22_wv,POU_FLAG_TYPE_FUNCTION_BLOCK);
#endif
/* codeExecAutomaticVars end */
	EN_ENO_CHECK {
beginPouExec:
		DEBUG_ST(190,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:190 	RDM_p(last:=FRACT(INT_TO_REAL(last) * 3.14159265358979323846264338327950288)); */
		/* beginFB call */
		self->v_RDM_p.v_last = dt_FN_FRACT_exec( GEBLIB_MUL_REAL(gebx_INT_TO_REAL(self->v_last),((REAL_t)3.1415927f)) );
		dt_FB_RDM_block_exec(&(self->v_RDM_p) );
		DEBUG_ST(191,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:191 	RDM2 := DINT_TO_INT(D_TRUNC(RDM_p.RDM * INT_TO_REAL(high - low + 1))) + low; */
		self->v_RDM2 =  GEBLIB_ADD_INT(gebx_DINT_TO_INT(dt_FN_D_TRUNC_exec( GEBLIB_MUL_REAL(self->v_RDM_p.v_RDM,gebx_INT_TO_REAL( GEBLIB_ADD_INT( GEBLIB_SUB_INT(self->v_high,self->v_low) ,((INT_t)1)) )) )),self->v_low) ;
endPouExec: ;
		geb_hook(GEB_WHERE_END_OF_FUNC_FB,DEBUGGING_MODE);
	}
	DEBUG_POP_STACK();
	return ;
}
/* ---- end RDM22 end body  --- */
/* ---- ARRAY_SHUFFLE2 begin body  ---- */
/* ==== POU: ARRAY_SHUFFLE2 (num:2 module:575) */
/* === vars:  0:ARRAY_SHUFFLE 1:PT 2:RDM2 3:SIZE 4:i 5:pos 6:stop
	 7:temp */

void dt_FB_ARRAY_SHUFFLE2_copy(dt_FB_ARRAY_SHUFFLE2_P self,dt_FB_ARRAY_SHUFFLE2_P o){ *self=*o; }
void dt_FB_ARRAY_SHUFFLE2_init(dt_FB_ARRAY_SHUFFLE2_P self){
	ZERO_STRUCT(self);
	self->v_EN = true;
	BOOL_t_init(&(self->v_ENO));
	UINT_t_init(&(self->v_SIZE));
	BOOL_t_init(&(self->v_ARRAY_SHUFFLE));
	REAL_t_init(&(self->v_temp));
	INT_t_init(&(self->v_pos));
	INT_t_init(&(self->v_i));
	INT_t_init(&(self->v_stop));
	dt_FB_RDM22_init(&(self->v_RDM2));
}

#ifdef GEB_DEBUG_MODE
void dt_FB_ARRAY_SHUFFLE2_dump2(dt_FB_ARRAY_SHUFFLE2_P self,void *  aut, int mode) {
	writeGcbor_mapBegin();
	if((mode & VARS_REPORT_WHAT_STATIC) != 0 ) {
		DUMP_VAR( 2,	dt_FB_RDM22_dump( &(self->v_RDM2)) );
		DUMP_VAR( 3,	GEBLIB_dump_UINT( self->v_SIZE) );
		DUMP_VAR( 4,	GEBLIB_dump_INT( self->v_i) );
		DUMP_VAR( 5,	GEBLIB_dump_INT( self->v_pos) );
		DUMP_VAR( 6,	GEBLIB_dump_INT( self->v_stop) );
		DUMP_VAR( 7,	GEBLIB_dump_REAL( self->v_temp) );
	}
	if((mode & VARS_REPORT_WHAT_OUTPUT) != 0 ) {
		DUMP_VAR( 0,	GEBLIB_dump_BOOL( self->v_ARRAY_SHUFFLE) );
	}
	writeGcbor_mapEnd();
}
#endif

#ifdef GEB_DEBUG_MODE
int dt_FB_ARRAY_SHUFFLE2_wv(dt_FB_ARRAY_SHUFFLE2_P self, void *  aut, int vnum, DEBUG_WV_VAL VAL) {
	int ret;
	ret=0;
	switch(vnum) {
		case 0 : self->v_ARRAY_SHUFFLE = GEBLIB_WV_BOOL(VAL,&ret,self->v_ARRAY_SHUFFLE); break;
		case 1 : ret=GEB_WV_ERR_MULTI; break;
		case 2 : ret=GEB_WV_ERR_MULTI; break;
		case 3 : self->v_SIZE = GEBLIB_WV_UINT(VAL,&ret,self->v_SIZE); break;
		case 4 : self->v_i = GEBLIB_WV_INT(VAL,&ret,self->v_i); break;
		case 5 : self->v_pos = GEBLIB_WV_INT(VAL,&ret,self->v_pos); break;
		case 6 : self->v_stop = GEBLIB_WV_INT(VAL,&ret,self->v_stop); break;
		case 7 : self->v_temp = GEBLIB_WV_REAL(VAL,&ret,self->v_temp); break;
		default : ret=GEB_WV_ERR_BADVAR; /* no apt var found */
	}
	return ret;
}
#endif

#ifndef SUPPRESS_FORMATTED_OUTPUT
void dt_FB_ARRAY_SHUFFLE2_printVars(dt_FB_ARRAY_SHUFFLE2_P self, int indent, int detail) {
	if(detail>=1) {
		GEBputsINL("ARRAY_SHUFFLE:");
		GEBLIB_print_BOOL(self->v_ARRAY_SHUFFLE);
		GEBputsINL("SIZE:");
		GEBLIB_print_UINT(self->v_SIZE);
	}
	if(detail>=2) {
		GEBputsINL("RDM2:");
		dt_FB_RDM22_print(&(self->v_RDM2), indent+1);
		GEBputsINL("i:");
		GEBLIB_print_INT(self->v_i);
		GEBputsINL("pos:");
		GEBLIB_print_INT(self->v_pos);
		GEBputsINL("stop:");
		GEBLIB_print_INT(self->v_stop);
		GEBputsINL("temp:");
		GEBLIB_print_REAL(self->v_temp);
	}
}
#endif

void dt_FB_ARRAY_SHUFFLE2_exec(dt_FB_ARRAY_SHUFFLE2_P self) {
/* codeExecAutomaticVars begin */
#ifdef GEB_DEBUG_MODE
	DEBUG_PUSH_STACK(2,575,self,NULL,&dt_FB_ARRAY_SHUFFLE2_dump2, &dt_FB_ARRAY_SHUFFLE2_wv,POU_FLAG_TYPE_FUNCTION_BLOCK);
#endif
/* codeExecAutomaticVars end */
	EN_ENO_CHECK {
beginPouExec:
		DEBUG_ST(215,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:215 	stop :=LIMIT_INT(1,UINT_TO_INT(SIZE),1000); */
		self->v_stop = gebx_LIMIT_INT(((INT_t)1),gebx_MOVE_INT(self->v_SIZE),((INT_t)1000));
		DEBUG_ST(216,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:216 	FOR i := 1 TO stop DO */
		for( self->v_i = ((INT_t)1) ; self->v_i <= self->v_stop ; self->v_i += 1 )	{
			DEBUG_ST(217,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:217 	RDM2(last:=i+pos,low:=1,high:=stop); */
			/* beginFB call */
			self->v_RDM2.v_last =  GEBLIB_ADD_INT(self->v_i,self->v_pos) ;
			self->v_RDM2.v_low = ((INT_t)1);
			self->v_RDM2.v_high = self->v_stop;
			dt_FB_RDM22_exec(&(self->v_RDM2) );
			DEBUG_ST(218,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:218 	pos := RDM2.RDM2; */
			self->v_pos = self->v_RDM2.v_RDM2;
			DEBUG_ST(220,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:220 	temp := PT[i]; */
			self->v_temp = (*self->v_PT).a[dt_ARR__g575_2_IDX(self->v_i)];
			DEBUG_ST(221,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:221 	PT[i] := PT[pos]; */
			(*self->v_PT).a[dt_ARR__g575_2_IDX(self->v_i)] = (*self->v_PT).a[dt_ARR__g575_2_IDX(self->v_pos)];
			DEBUG_ST(222,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:222 	PT[pos] := temp; */
			(*self->v_PT).a[dt_ARR__g575_2_IDX(self->v_pos)] = self->v_temp;
		}
		DEBUG_ST(225,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:225 	ARRAY_SHUFFLE := TRUE; */
		self->v_ARRAY_SHUFFLE = true;
endPouExec: ;
		geb_hook(GEB_WHERE_END_OF_FUNC_FB,DEBUGGING_MODE);
	}
	DEBUG_POP_STACK();
	return ;
}
/* ---- end ARRAY_SHUFFLE2 end body  --- */
/* ---- program0 begin body  ---- */
/* ==== POU: program0 (num:13 module:575) */
/* === vars:  0:LocalOUT 1:LocalVar0 2:LocalVar1 3:func_block */

void dt_PR_program0_copy(dt_PR_program0_P self,dt_PR_program0_P o){ *self=*o; }
void dt_PR_program0_init(dt_PR_program0_P self){
	ZERO_STRUCT(self);
	dt_Der_oscat_PT_ARRAY_init(&(self->v_LocalVar0));
	UINT_t_init(&(self->v_LocalVar1));
	BOOL_t_init(&(self->v_LocalOUT));
	dt_FB_ARRAY_SHUFFLE2_init(&(self->v_func_block));
}

int dt_PR_program0_nRetainBytes(dt_PR_program0_P self) {
	return 0; /* no retain data */
}

#ifdef GEB_DEBUG_MODE
void dt_PR_program0_dump2(dt_PR_program0_P self,void *  aut, int mode) {
	writeGcbor_mapBegin();
	if((mode & VARS_REPORT_WHAT_STATIC) != 0 ) {
		DUMP_VAR( 0,	GEBLIB_dump_BOOL( self->v_LocalOUT) );
		DUMP_VAR( 1,	dt_ARR__g575_2_dump( &(self->v_LocalVar0)) );
		DUMP_VAR( 2,	GEBLIB_dump_UINT( self->v_LocalVar1) );
		DUMP_VAR( 3,	dt_FB_ARRAY_SHUFFLE2_dump( &(self->v_func_block)) );
	}
	writeGcbor_mapEnd();
}
#endif

#ifdef GEB_DEBUG_MODE
int dt_PR_program0_wv(dt_PR_program0_P self, void *  aut, int vnum, DEBUG_WV_VAL VAL) {
	int ret;
	ret=0;
	switch(vnum) {
		case 0 : self->v_LocalOUT = GEBLIB_WV_BOOL(VAL,&ret,self->v_LocalOUT); break;
		case 1 : ret=GEB_WV_ERR_MULTI; break;
		case 2 : self->v_LocalVar1 = GEBLIB_WV_UINT(VAL,&ret,self->v_LocalVar1); break;
		case 3 : ret=GEB_WV_ERR_MULTI; break;
		default : ret=GEB_WV_ERR_BADVAR; /* no apt var found */
	}
	return ret;
}
#endif

#ifndef SUPPRESS_FORMATTED_OUTPUT
void dt_PR_program0_printVars(dt_PR_program0_P self, int indent, int detail) {
	if(detail>=1) {
		GEBputsINL("LocalOUT:");
		GEBLIB_print_BOOL(self->v_LocalOUT);
		GEBputsINL("LocalVar0:");
		dt_ARR__g575_2_print(&(self->v_LocalVar0), indent+1);
		GEBputsINL("LocalVar1:");
		GEBLIB_print_UINT(self->v_LocalVar1);
		GEBputsINL("func_block:");
		dt_FB_ARRAY_SHUFFLE2_print(&(self->v_func_block), indent+1);
	}
}
#endif

void dt_PR_program0_exec(dt_PR_program0_P self) {
/* codeExecAutomaticVars begin */
#ifdef GEB_DEBUG_MODE
	DEBUG_PUSH_STACK(13,575,self,NULL,&dt_PR_program0_dump2, &dt_PR_program0_wv,POU_FLAG_TYPE_PROGRAM);
#endif
/* codeExecAutomaticVars end */
beginPouExec:
	DEBUG_ST(235,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:235 	func_block(PT := LocalVar0, SIZE := LocalVar1); */
	/* beginFB call */
	self->v_func_block.v_PT = &(self->v_LocalVar0);
	self->v_func_block.v_SIZE = self->v_LocalVar1;
	dt_FB_ARRAY_SHUFFLE2_exec(&(self->v_func_block) );
	DEBUG_ST(236,0); /* basic__ARRAY_SHUFFLE/_ARRAY_SHUFFLE.ST:236 	LocalOUT := func_block.ARRAY_SHUFFLE; */
	self->v_LocalOUT = self->v_func_block.v_ARRAY_SHUFFLE;
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

/* simple digest (code hash) : dsvcgwgos9gq */
const char * getDigest(void) { return "dsvcgwgos9gq"; }

/* ----------- serialize/deserialize retain data ----------- */
#define RETAIN_DATA_HEADER_LEN  12
#define RETAIN_DATA_HEADER_LEN_CRIT 8
static unsigned char retainDataHeader[RETAIN_DATA_HEADER_LEN]={'G','E','B','r',0xd7,0x48,0x14,0xc4,0x7c,0x72,0x77,0xf8};

#include <gebprogs_f.c>

/* ---------- end of automatically generated code ---------- */
