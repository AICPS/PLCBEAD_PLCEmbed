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

/* ---- module basic__ARRAY_MUL datatypes ----- */
/* array (anonymous) type definition */
typedef struct {
	REAL_t a[100]; /* flat array */ 
} dt_ARR__g574_2;
typedef dt_ARR__g574_2 *dt_ARR__g574_2_P;
void dt_ARR__g574_2_copy(dt_ARR__g574_2_P self,dt_ARR__g574_2_P o) {
	*self=*o; }
#define dt_ARR__g574_2_IDX(i0) GEB_BOUNDS_CHECK(100, __LINE__ ,(i0 - 1))
void dt_ARR__g574_2_init(dt_ARR__g574_2_P self) {
	int i;
	for( i=0;i<100;i++) {
		self->a[i] = (REAL_t)0.0;
	}
}

#ifndef SUPPRESS_FORMATTED_OUTPUT
void dt_ARR__g574_2_print(dt_ARR__g574_2_P self, int indent) {
	int i;
	for( i=0;i<100;i++) {
		GEBputsINL("[");	GEBLIB_print_REAL(self->a[i]);
	}
} /* end show variables */
#endif

#ifdef GEB_DEBUG_MODE
void dt_ARR__g574_2_dump(dt_ARR__g574_2_P self) {
	int i;
	writeGcbor_arrayBegin();
	for( i=0;i<100;i++) {
		GEBLIB_dump_REAL(self->a[i]);
	}
	writeGcbor_arrayEnd();
}
#endif

typedef dt_ARR__g574_2 dt_Der_oscat_PT_ARRAY; /* derived type oscat_PT_ARRAY*/
typedef dt_Der_oscat_PT_ARRAY *dt_Der_oscat_PT_ARRAY_P;
void dt_Der_oscat_PT_ARRAY_init(dt_Der_oscat_PT_ARRAY_P self) {
	dt_ARR__g574_2_init(self); /* codeDataTypeDefDerived */
}
/* ------------------- POUS HEADERS ----------------------*/
/* ---- module=basic__ARRAY_MUL----- */
/* ---- pou=ARRAY_MUL2 pouId=2 begin header --- */
 /* basic__ARRAY_MUL/_ARRAY_MUL.ST:5 	FUNCTION_BLOCK ARRAY_MUL2 */
typedef struct dt_FB_ARRAY_MUL2 {
	dt_Der_oscat_PT_ARRAY_P v_PT;
	REAL_t v_X;
	UINT_t v_SIZE;
	INT_t v_i;
	INT_t v_stop;
	BOOL_t v_ARRAY_MUL;
	BOOL_t v_EN;
	BOOL_t v_ENO;
} dt_FB_ARRAY_MUL2;
typedef dt_FB_ARRAY_MUL2 *dt_FB_ARRAY_MUL2_P;

void dt_FB_ARRAY_MUL2_copy(dt_FB_ARRAY_MUL2_P self,dt_FB_ARRAY_MUL2_P o);
void dt_FB_ARRAY_MUL2_init(dt_FB_ARRAY_MUL2_P self);
#ifdef GEB_DEBUG_MODE
#define dt_FB_ARRAY_MUL2_dump(s) dt_FB_ARRAY_MUL2_dump2(s,NULL,VARS_REPORT_WHAT_OUTPUT)
void dt_FB_ARRAY_MUL2_dump2(dt_FB_ARRAY_MUL2_P self,void *  aut, int mode);
#endif

#ifdef GEB_DEBUG_MODE
int dt_FB_ARRAY_MUL2_wv(dt_FB_ARRAY_MUL2_P self, void *  aut, int vnum, DEBUG_WV_VAL VAL);
#endif

#ifndef SUPPRESS_FORMATTED_OUTPUT
void dt_FB_ARRAY_MUL2_printVars(dt_FB_ARRAY_MUL2_P self, int indent, int detail);
#define dt_FB_ARRAY_MUL2_print(s,indent) dt_FB_ARRAY_MUL2_printVars(s,indent,1)
#endif
void dt_FB_ARRAY_MUL2_exec(dt_FB_ARRAY_MUL2_P self);
/* ---- ARRAY_MUL2 end header --- */
/* ---- pou=program0 pouId=3 begin header --- */
 /* basic__ARRAY_MUL/_ARRAY_MUL.ST:30 	PROGRAM program0 */
typedef struct dt_PR_program0 {
	dt_Der_oscat_PT_ARRAY v_LocalVar0;
	dt_FB_ARRAY_MUL2 v_func_block;
	REAL_t v_LocalVar2;
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

/* ---- ARRAY_MUL2 begin body  ---- */
/* ==== POU: ARRAY_MUL2 (num:2 module:574) */
/* === vars:  0:ARRAY_MUL 1:PT 2:SIZE 3:X 4:i 5:stop */

void dt_FB_ARRAY_MUL2_copy(dt_FB_ARRAY_MUL2_P self,dt_FB_ARRAY_MUL2_P o){ *self=*o; }
void dt_FB_ARRAY_MUL2_init(dt_FB_ARRAY_MUL2_P self){
	ZERO_STRUCT(self);
	self->v_EN = true;
	BOOL_t_init(&(self->v_ENO));
	UINT_t_init(&(self->v_SIZE));
	REAL_t_init(&(self->v_X));
	BOOL_t_init(&(self->v_ARRAY_MUL));
	INT_t_init(&(self->v_i));
	INT_t_init(&(self->v_stop));
}

#ifdef GEB_DEBUG_MODE
void dt_FB_ARRAY_MUL2_dump2(dt_FB_ARRAY_MUL2_P self,void *  aut, int mode) {
	writeGcbor_mapBegin();
	if((mode & VARS_REPORT_WHAT_STATIC) != 0 ) {
		DUMP_VAR( 2,	GEBLIB_dump_UINT( self->v_SIZE) );
		DUMP_VAR( 3,	GEBLIB_dump_REAL( self->v_X) );
		DUMP_VAR( 4,	GEBLIB_dump_INT( self->v_i) );
		DUMP_VAR( 5,	GEBLIB_dump_INT( self->v_stop) );
	}
	if((mode & VARS_REPORT_WHAT_OUTPUT) != 0 ) {
		DUMP_VAR( 0,	GEBLIB_dump_BOOL( self->v_ARRAY_MUL) );
	}
	writeGcbor_mapEnd();
}
#endif

#ifdef GEB_DEBUG_MODE
int dt_FB_ARRAY_MUL2_wv(dt_FB_ARRAY_MUL2_P self, void *  aut, int vnum, DEBUG_WV_VAL VAL) {
	int ret;
	ret=0;
	switch(vnum) {
		case 0 : self->v_ARRAY_MUL = GEBLIB_WV_BOOL(VAL,&ret,self->v_ARRAY_MUL); break;
		case 1 : ret=GEB_WV_ERR_MULTI; break;
		case 2 : self->v_SIZE = GEBLIB_WV_UINT(VAL,&ret,self->v_SIZE); break;
		case 3 : self->v_X = GEBLIB_WV_REAL(VAL,&ret,self->v_X); break;
		case 4 : self->v_i = GEBLIB_WV_INT(VAL,&ret,self->v_i); break;
		case 5 : self->v_stop = GEBLIB_WV_INT(VAL,&ret,self->v_stop); break;
		default : ret=GEB_WV_ERR_BADVAR; /* no apt var found */
	}
	return ret;
}
#endif

#ifndef SUPPRESS_FORMATTED_OUTPUT
void dt_FB_ARRAY_MUL2_printVars(dt_FB_ARRAY_MUL2_P self, int indent, int detail) {
	if(detail>=1) {
		GEBputsINL("ARRAY_MUL:");
		GEBLIB_print_BOOL(self->v_ARRAY_MUL);
		GEBputsINL("SIZE:");
		GEBLIB_print_UINT(self->v_SIZE);
		GEBputsINL("X:");
		GEBLIB_print_REAL(self->v_X);
	}
	if(detail>=2) {
		GEBputsINL("i:");
		GEBLIB_print_INT(self->v_i);
		GEBputsINL("stop:");
		GEBLIB_print_INT(self->v_stop);
	}
}
#endif

void dt_FB_ARRAY_MUL2_exec(dt_FB_ARRAY_MUL2_P self) {
/* codeExecAutomaticVars begin */
#ifdef GEB_DEBUG_MODE
	DEBUG_PUSH_STACK(2,574,self,NULL,&dt_FB_ARRAY_MUL2_dump2, &dt_FB_ARRAY_MUL2_wv,POU_FLAG_TYPE_FUNCTION_BLOCK);
#endif
/* codeExecAutomaticVars end */
	EN_ENO_CHECK {
beginPouExec:
		DEBUG_ST(21,0); /* basic__ARRAY_MUL/_ARRAY_MUL.ST:21 	stop :=LIMIT_INT(1,UINT_TO_INT(SIZE),1000); */
		self->v_stop = gebx_LIMIT_INT(((INT_t)1),gebx_MOVE_INT(self->v_SIZE),((INT_t)1000));
		DEBUG_ST(22,0); /* basic__ARRAY_MUL/_ARRAY_MUL.ST:22 	FOR i := 1 TO stop DO */
		for( self->v_i = ((INT_t)1) ; self->v_i <= self->v_stop ; self->v_i += 1 )	{
			DEBUG_ST(23,0); /* basic__ARRAY_MUL/_ARRAY_MUL.ST:23 	PT[i] := PT[i] * X; */
			(*self->v_PT).a[dt_ARR__g574_2_IDX(self->v_i)] =  GEBLIB_MUL_REAL((*self->v_PT).a[dt_ARR__g574_2_IDX(self->v_i)],self->v_X) ;
		}
		DEBUG_ST(25,0); /* basic__ARRAY_MUL/_ARRAY_MUL.ST:25 	ARRAY_MUL := TRUE; */
		self->v_ARRAY_MUL = true;
endPouExec: ;
		geb_hook(GEB_WHERE_END_OF_FUNC_FB,DEBUGGING_MODE);
	}
	DEBUG_POP_STACK();
	return ;
}
/* ---- end ARRAY_MUL2 end body  --- */
/* ---- program0 begin body  ---- */
/* ==== POU: program0 (num:3 module:574) */
/* === vars:  0:LocalOUT 1:LocalVar0 2:LocalVar1 3:LocalVar2 4:func_block */

void dt_PR_program0_copy(dt_PR_program0_P self,dt_PR_program0_P o){ *self=*o; }
void dt_PR_program0_init(dt_PR_program0_P self){
	ZERO_STRUCT(self);
	dt_Der_oscat_PT_ARRAY_init(&(self->v_LocalVar0));
	UINT_t_init(&(self->v_LocalVar1));
	REAL_t_init(&(self->v_LocalVar2));
	BOOL_t_init(&(self->v_LocalOUT));
	dt_FB_ARRAY_MUL2_init(&(self->v_func_block));
}

int dt_PR_program0_nRetainBytes(dt_PR_program0_P self) {
	return 0; /* no retain data */
}

#ifdef GEB_DEBUG_MODE
void dt_PR_program0_dump2(dt_PR_program0_P self,void *  aut, int mode) {
	writeGcbor_mapBegin();
	if((mode & VARS_REPORT_WHAT_STATIC) != 0 ) {
		DUMP_VAR( 0,	GEBLIB_dump_BOOL( self->v_LocalOUT) );
		DUMP_VAR( 1,	dt_ARR__g574_2_dump( &(self->v_LocalVar0)) );
		DUMP_VAR( 2,	GEBLIB_dump_UINT( self->v_LocalVar1) );
		DUMP_VAR( 3,	GEBLIB_dump_REAL( self->v_LocalVar2) );
		DUMP_VAR( 4,	dt_FB_ARRAY_MUL2_dump( &(self->v_func_block)) );
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
		case 3 : self->v_LocalVar2 = GEBLIB_WV_REAL(VAL,&ret,self->v_LocalVar2); break;
		case 4 : ret=GEB_WV_ERR_MULTI; break;
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
		dt_ARR__g574_2_print(&(self->v_LocalVar0), indent+1);
		GEBputsINL("LocalVar1:");
		GEBLIB_print_UINT(self->v_LocalVar1);
		GEBputsINL("LocalVar2:");
		GEBLIB_print_REAL(self->v_LocalVar2);
		GEBputsINL("func_block:");
		dt_FB_ARRAY_MUL2_print(&(self->v_func_block), indent+1);
	}
}
#endif

void dt_PR_program0_exec(dt_PR_program0_P self) {
/* codeExecAutomaticVars begin */
#ifdef GEB_DEBUG_MODE
	DEBUG_PUSH_STACK(3,574,self,NULL,&dt_PR_program0_dump2, &dt_PR_program0_wv,POU_FLAG_TYPE_PROGRAM);
#endif
/* codeExecAutomaticVars end */
beginPouExec:
	DEBUG_ST(38,0); /* basic__ARRAY_MUL/_ARRAY_MUL.ST:38 	func_block(PT := LocalVar0, SIZE := LocalVar1, X:= LocalVar2); */
	/* beginFB call */
	self->v_func_block.v_PT = &(self->v_LocalVar0);
	self->v_func_block.v_SIZE = self->v_LocalVar1;
	self->v_func_block.v_X = self->v_LocalVar2;
	dt_FB_ARRAY_MUL2_exec(&(self->v_func_block) );
	DEBUG_ST(39,0); /* basic__ARRAY_MUL/_ARRAY_MUL.ST:39 	LocalOUT := func_block.ARRAY_MUL; */
	self->v_LocalOUT = self->v_func_block.v_ARRAY_MUL;
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

/* simple digest (code hash) : b8ojgimucfrz */
const char * getDigest(void) { return "b8ojgimucfrz"; }

/* ----------- serialize/deserialize retain data ----------- */
#define RETAIN_DATA_HEADER_LEN  12
#define RETAIN_DATA_HEADER_LEN_CRIT 8
static unsigned char retainDataHeader[RETAIN_DATA_HEADER_LEN]={'G','E','B','r',0x9d,0x7e,0xd0,0xcb,0x55,0x6a,0x46,0xa9};

#include <gebprogs_f.c>

/* ---------- end of automatically generated code ---------- */
