/* --------------------------------------------------
 * This code has been automatically generated using 
 * GEB Automation IDE   https://www.gebautomation.com/
 * Version 3.2.15.107 	2022-06-30
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

/* ---- module basic__ARRAY_ABS datatypes ----- */
/* array (anonymous) type definition */
typedef struct {
	REAL_t a[100]; /* flat array */ 
} dt_ARR__g569_2;
typedef dt_ARR__g569_2 *dt_ARR__g569_2_P;
void dt_ARR__g569_2_copy(dt_ARR__g569_2_P self,dt_ARR__g569_2_P o) {
	*self=*o; }
#define dt_ARR__g569_2_IDX(i0) GEB_BOUNDS_CHECK(100, __LINE__ ,(i0 - 1))
void dt_ARR__g569_2_init(dt_ARR__g569_2_P self) {
	int i;
	for( i=0;i<100;i++) {
		self->a[i] = (REAL_t)0.0;
	}
}

#ifndef SUPPRESS_FORMATTED_OUTPUT
void dt_ARR__g569_2_print(dt_ARR__g569_2_P self, int indent) {
	int i;
	for( i=0;i<100;i++) {
		GEBputsINL("[");	GEBLIB_print_REAL(self->a[i]);
	}
} /* end show variables */
#endif

#ifdef GEB_DEBUG_MODE
void dt_ARR__g569_2_dump(dt_ARR__g569_2_P self) {
	int i;
	writeGcbor_arrayBegin();
	for( i=0;i<100;i++) {
		GEBLIB_dump_REAL(self->a[i]);
	}
	writeGcbor_arrayEnd();
}
#endif

typedef dt_ARR__g569_2 dt_Der_oscat_PT_ARRAY; /* derived type oscat_PT_ARRAY*/
typedef dt_Der_oscat_PT_ARRAY *dt_Der_oscat_PT_ARRAY_P;
void dt_Der_oscat_PT_ARRAY_init(dt_Der_oscat_PT_ARRAY_P self) {
	dt_ARR__g569_2_init(self); /* codeDataTypeDefDerived */
}
/* ------------------- POUS HEADERS ----------------------*/
/* ---- module=basic__ARRAY_ABS----- */
/* ---- pou=_ARRAY_ABS pouId=2 begin header --- */
 /* basic__ARRAY_ABS/_ARRAY_ABS.ST:5 	FUNCTION _ARRAY_ABS : BOOL */
typedef struct adt_FN__ARRAY_ABS {
	dt_Der_oscat_PT_ARRAY_P v_PT;
	UINT_t_P v_SIZE;
	INT_t_P v_STOP;
	INT_t_P v_i;
	BOOL_t_P v__ARRAY_ABS;
} adt_FN__ARRAY_ABS;
typedef adt_FN__ARRAY_ABS *adt_FN__ARRAY_ABS_P;

#ifdef GEB_DEBUG_MODE
#define dt_FN__ARRAY_ABS_dump(s)  /* nop */
void dt_FN__ARRAY_ABS_dump2(void *  self,adt_FN__ARRAY_ABS_P aut, int mode);
#endif

#ifdef GEB_DEBUG_MODE
int dt_FN__ARRAY_ABS_wv(void *  self, adt_FN__ARRAY_ABS_P aut, int vnum, DEBUG_WV_VAL VAL);
#endif

BOOL_t dt_FN__ARRAY_ABS_exec( dt_Der_oscat_PT_ARRAY_P v_PT ,UINT_t v_SIZE );
/* ---- _ARRAY_ABS end header --- */
/* ---- pou=program0 pouId=3 begin header --- */
 /* basic__ARRAY_ABS/_ARRAY_ABS.ST:28 	PROGRAM program0 */
typedef struct dt_PR_program0 {
	dt_Der_oscat_PT_ARRAY v_LocalVar0;
	UINT_t v_LocalVaR1;
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

/* ---- _ARRAY_ABS begin body  ---- */
/* ==== POU: _ARRAY_ABS (num:2 module:569) */
/* === vars:  0:PT 1:SIZE 2:STOP 3:_ARRAY_ABS 4:i */

#ifdef GEB_DEBUG_MODE
void dt_FN__ARRAY_ABS_dump2(void *  self,adt_FN__ARRAY_ABS_P aut, int mode) {
	writeGcbor_mapBegin();
	if((mode & VARS_REPORT_WHAT_AUTO) != 0  && aut != NULL) {
		DUMP_VAR( 1,	GEBLIB_dump_UINT( *(aut->v_SIZE)) );
		DUMP_VAR( 2,	GEBLIB_dump_INT( *(aut->v_STOP)) );
		DUMP_VAR( 3,	GEBLIB_dump_BOOL( *(aut->v__ARRAY_ABS)) );
		DUMP_VAR( 4,	GEBLIB_dump_INT( *(aut->v_i)) );
	}
	writeGcbor_mapEnd();
}
#endif

#ifdef GEB_DEBUG_MODE
int dt_FN__ARRAY_ABS_wv(void *  self, adt_FN__ARRAY_ABS_P aut, int vnum, DEBUG_WV_VAL VAL) {
	int ret;
	ret=0;
	switch(vnum) {
		case 1 : if(aut!=NULL){ *(aut->v_SIZE) = GEBLIB_WV_UINT(VAL,&ret,*(aut->v_SIZE)); } else {ret=GEB_WV_ERR_NOAUTO;} break;
		case 2 : if(aut!=NULL){ *(aut->v_STOP) = GEBLIB_WV_INT(VAL,&ret,*(aut->v_STOP)); } else {ret=GEB_WV_ERR_NOAUTO;} break;
		case 3 : if(aut!=NULL){ *(aut->v__ARRAY_ABS) = GEBLIB_WV_BOOL(VAL,&ret,*(aut->v__ARRAY_ABS)); } else {ret=GEB_WV_ERR_NOAUTO;} break;
		case 4 : if(aut!=NULL){ *(aut->v_i) = GEBLIB_WV_INT(VAL,&ret,*(aut->v_i)); } else {ret=GEB_WV_ERR_NOAUTO;} break;
		default : ret=GEB_WV_ERR_BADVAR; /* no apt var found */
	}
	return ret;
}
#endif

BOOL_t dt_FN__ARRAY_ABS_exec( dt_Der_oscat_PT_ARRAY_P v_PT ,UINT_t v_SIZE ) {
/* codeExecAutomaticVars begin */
#ifdef GEB_DEBUG_MODE
	adt_FN__ARRAY_ABS aut;
#endif
	INT_t v_STOP;
	INT_t v_i;
	BOOL_t v__ARRAY_ABS;
	/* automatic vars initialization */
	INT_t_init(&(v_STOP));
	INT_t_init(&(v_i));
#ifdef GEB_DEBUG_MODE
	DEBUG_PUSH_STACK(2,569,NULL,&aut,&dt_FN__ARRAY_ABS_dump2, &dt_FN__ARRAY_ABS_wv,POU_FLAG_TYPE_FUNCTION);
	aut.v_PT=  v_PT;
	aut.v_SIZE=  &(v_SIZE);
	aut.v_STOP=  &(v_STOP);
	aut.v_i=  &(v_i);
	aut.v__ARRAY_ABS=  &(v__ARRAY_ABS);
#endif
/* codeExecAutomaticVars end */
beginPouExec:
	DEBUG_ST(19,0); /* basic__ARRAY_ABS/_ARRAY_ABS.ST:19 	STOP := SHR(SIZE,2)-1; */
	v_STOP =  GEBLIB_SUB_UINT(gebx_SHR_WORD(v_SIZE,((INT_t)2)),((UINT_t)1)) ;
	DEBUG_ST(20,0); /* basic__ARRAY_ABS/_ARRAY_ABS.ST:20 	FOR i := 1 TO STOP DO */
	for( v_i = ((INT_t)1) ; v_i <= v_STOP ; v_i += 1 )	{
		DEBUG_ST(21,0); /* basic__ARRAY_ABS/_ARRAY_ABS.ST:21 	PT[i] := ABS(PT[i]); */
		(*v_PT).a[dt_ARR__g569_2_IDX(v_i)] = gebx_ABS_REAL((*v_PT).a[dt_ARR__g569_2_IDX(v_i)]);
	}
	DEBUG_ST(24,0); /* basic__ARRAY_ABS/_ARRAY_ABS.ST:24 	_ARRAY_ABS := TRUE; */
	v__ARRAY_ABS = true;
endPouExec: ;
	geb_hook(GEB_WHERE_END_OF_FUNC_FB,DEBUGGING_MODE);
	DEBUG_POP_STACK();
	return v__ARRAY_ABS;
}
/* ---- end _ARRAY_ABS end body  --- */
/* ---- program0 begin body  ---- */
/* ==== POU: program0 (num:3 module:569) */
/* === vars:  0:LocalOUT 1:LocalVaR1 2:LocalVar0 */

void dt_PR_program0_copy(dt_PR_program0_P self,dt_PR_program0_P o){ *self=*o; }
void dt_PR_program0_init(dt_PR_program0_P self){
	ZERO_STRUCT(self);
	dt_Der_oscat_PT_ARRAY_init(&(self->v_LocalVar0));
	UINT_t_init(&(self->v_LocalVaR1));
	BOOL_t_init(&(self->v_LocalOUT));
}

int dt_PR_program0_nRetainBytes(dt_PR_program0_P self) {
	return 0; /* no retain data */
}

#ifdef GEB_DEBUG_MODE
void dt_PR_program0_dump2(dt_PR_program0_P self,void *  aut, int mode) {
	writeGcbor_mapBegin();
	if((mode & VARS_REPORT_WHAT_STATIC) != 0 ) {
		DUMP_VAR( 0,	GEBLIB_dump_BOOL( self->v_LocalOUT) );
		DUMP_VAR( 1,	GEBLIB_dump_UINT( self->v_LocalVaR1) );
		DUMP_VAR( 2,	dt_ARR__g569_2_dump( &(self->v_LocalVar0)) );
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
		case 1 : self->v_LocalVaR1 = GEBLIB_WV_UINT(VAL,&ret,self->v_LocalVaR1); break;
		case 2 : ret=GEB_WV_ERR_MULTI; break;
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
		GEBputsINL("LocalVaR1:");
		GEBLIB_print_UINT(self->v_LocalVaR1);
		GEBputsINL("LocalVar0:");
		dt_ARR__g569_2_print(&(self->v_LocalVar0), indent+1);
	}
}
#endif

void dt_PR_program0_exec(dt_PR_program0_P self) {
/* codeExecAutomaticVars begin */
#ifdef GEB_DEBUG_MODE
	DEBUG_PUSH_STACK(3,569,self,NULL,&dt_PR_program0_dump2, &dt_PR_program0_wv,POU_FLAG_TYPE_PROGRAM);
#endif
/* codeExecAutomaticVars end */
beginPouExec:
	DEBUG_ST(35,0); /* basic__ARRAY_ABS/_ARRAY_ABS.ST:35 	LocalOUT := _ARRAY_ABS(LocalVar0, LocalVaR1 ); */
	self->v_LocalOUT = dt_FN__ARRAY_ABS_exec(&(self->v_LocalVar0),self->v_LocalVaR1);
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

/* simple digest (code hash) : 3xkjd60yh6nr */
const char * getDigest(void) { return "3xkjd60yh6nr"; }

/* ----------- serialize/deserialize retain data ----------- */
#define RETAIN_DATA_HEADER_LEN  12
#define RETAIN_DATA_HEADER_LEN_CRIT 8
static unsigned char retainDataHeader[RETAIN_DATA_HEADER_LEN]={'G','E','B','r',0x43,0x0f,0x1a,0xf4,0x10,0x36,0x0f,0x18};

#include <gebprogs_f.c>

/* ---------- end of automatically generated code ---------- */
