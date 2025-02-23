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

/* ---- module samplerpi datatypes ----- */
/* ------------------- POUS HEADERS ----------------------*/
/* ---- module=samplerpi----- */
/* ---- pou=leds pouId=2 begin header --- */
 /* samplerpi/leds.fbd:1 	 */
typedef struct dt_PR_leds {
	dt_FB_TP v__fbTP_2;
	dt_FB_TP v__fbTP_3;
} dt_PR_leds;
typedef dt_PR_leds *dt_PR_leds_P;

void dt_PR_leds_copy(dt_PR_leds_P self,dt_PR_leds_P o);
void dt_PR_leds_init(dt_PR_leds_P self);
#ifdef GEB_DEBUG_MODE
#define dt_PR_leds_dump(s) dt_PR_leds_dump2(s,NULL,VARS_REPORT_WHAT_OUTPUT)
void dt_PR_leds_dump2(dt_PR_leds_P self,void *  aut, int mode);
#endif

#ifdef GEB_DEBUG_MODE
int dt_PR_leds_wv(dt_PR_leds_P self, void *  aut, int vnum, DEBUG_WV_VAL VAL);
#endif

#ifndef SUPPRESS_FORMATTED_OUTPUT
void dt_PR_leds_printVars(dt_PR_leds_P self, int indent, int detail);
#define dt_PR_leds_print(s,indent) dt_PR_leds_printVars(s,indent,1)
#endif
void dt_PR_leds_exec(dt_PR_leds_P self);
/* ---- leds end header --- */
/* ------------------- AT VARS ----------------------*/
#ifndef ATVARS_ALLOCATED_BY_DEVICE
/* ATVARS_ALLOCATED_BY_DEVICE (see gebdrv.h) signals that AT variables are allocated not here 
 but by the device implementation */ 
typedef struct {
	BOOL_t vat_IX0_23;
	BOOL_t vat_QX0_17;
	BOOL_t vat_QX0_27;
} ATvars;
ATvars v_ATvars; /* Create atvars allocation */
#endif

/* read write at vars: these should be called before and after running pous (cycle) */
void ATvars_read(void) {
	GEB_DRV_PRE_READ
	GEB_DRV_HGET(BOOL,vat_IX0_23,'I','X',0,23,0,0);
	GEB_DRV_POST_READ
}
void ATvars_write(void) {
	GEB_DRV_PRE_WRITE
	GEB_DRV_HSET(BOOL,vat_QX0_17,'Q','X',0,17,0,0,v_ATvars.vat_QX0_17);
	GEB_DRV_HSET(BOOL,vat_QX0_27,'Q','X',0,27,0,0,v_ATvars.vat_QX0_27);
	GEB_DRV_POST_WRITE
}
void ATvars_dump(void) {
#ifdef GEB_DEBUG_MODE
	writeGcbor_mapBegin();
	DUMP_VAR(0,GEBLIB_dump_BOOL(GEB_DRV_PGET(BOOL,vat_IX0_23,'I','X',0,23,0,0)));
	DUMP_VAR(1,GEBLIB_dump_BOOL(GEB_DRV_PGET(BOOL,vat_QX0_17,'Q','X',0,17,0,0)));
	DUMP_VAR(2,GEBLIB_dump_BOOL(GEB_DRV_PGET(BOOL,vat_QX0_27,'Q','X',0,27,0,0)));
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

/* ---- leds begin body  ---- */
/* ==== POU: leds (num:2 module:646) */
/* === vars:  0:DISABLE 1:GREEN 2:RED 3:_fbTP_2 4:_fbTP_3 */

void dt_PR_leds_copy(dt_PR_leds_P self,dt_PR_leds_P o){ *self=*o; }
void dt_PR_leds_init(dt_PR_leds_P self){
	ZERO_STRUCT(self);
	dt_FB_TP_init(&(self->v__fbTP_2));
	dt_FB_TP_init(&(self->v__fbTP_3));
}

int dt_PR_leds_nRetainBytes(dt_PR_leds_P self) {
	return 0; /* no retain data */
}

#ifdef GEB_DEBUG_MODE
void dt_PR_leds_dump2(dt_PR_leds_P self,void *  aut, int mode) {
	writeGcbor_mapBegin();
	if((mode & VARS_REPORT_WHAT_EXTERN) != 0 ) {
		DUMP_VAR( 0,	GEBLIB_dump_BOOL( GEB_DRV_PGET(BOOL,vat_IX0_23,'I','X',0,23,0,0)) );
		DUMP_VAR( 1,	GEBLIB_dump_BOOL( GEB_DRV_PGET(BOOL,vat_QX0_17,'Q','X',0,17,0,0)) );
		DUMP_VAR( 2,	GEBLIB_dump_BOOL( GEB_DRV_PGET(BOOL,vat_QX0_27,'Q','X',0,27,0,0)) );
	}
	if((mode & VARS_REPORT_WHAT_STATIC) != 0 ) {
		DUMP_VAR( 3,	dt_FB_TP_dump( &(self->v__fbTP_2)) );
		DUMP_VAR( 4,	dt_FB_TP_dump( &(self->v__fbTP_3)) );
	}
	if((mode & VARS_REPORT_WHAT_LINKGS )!= 0 ) {
		DUMP_VAR( -1,	GEBLIB_dump_TIME( ((TIME_t)TIME_t_fromVal(2000L))) ); /* link group 1 */
		DUMP_VAR( -2,	GEBLIB_dump_BOOL( self->v__fbTP_2.v_Q) ); /* link group 2 */
		DUMP_VAR( -3,	GEBLIB_dump_BOOL( self->v__fbTP_3.v_Q) ); /* link group 3 */
		DUMP_VAR( -4,	GEBLIB_dump_TIME( ((TIME_t)TIME_t_fromVal(1000L))) ); /* link group 4 */
		DUMP_VAR( -5,	GEBLIB_dump_BOOL( GEB_DRV_PGET(BOOL,vat_IX0_23,'I','X',0,23,0,0)) ); /* link group 5 */
		DUMP_VAR( -6,	GEBLIB_dump_BOOL( GEB_DRV_PGET(BOOL,vat_QX0_27,'Q','X',0,27,0,0)) ); /* link group 6 */
	}
	writeGcbor_mapEnd();
}
#endif

#ifdef GEB_DEBUG_MODE
int dt_PR_leds_wv(dt_PR_leds_P self, void *  aut, int vnum, DEBUG_WV_VAL VAL) {
	int ret;
	ret=0;
	switch(vnum) {
		case 0 : ret=GEB_WV_ERR_AT; break;
		case 1 : ret=GEB_WV_ERR_AT; break;
		case 2 : ret=GEB_WV_ERR_AT; break;
		case 3 : ret=GEB_WV_ERR_MULTI; break;
		case 4 : ret=GEB_WV_ERR_MULTI; break;
		default : ret=GEB_WV_ERR_BADVAR; /* no apt var found */
	}
	return ret;
}
#endif

#ifndef SUPPRESS_FORMATTED_OUTPUT
void dt_PR_leds_printVars(dt_PR_leds_P self, int indent, int detail) {
	if(detail>=1) {
		GEBputsINL("_fbTP_2:");
		dt_FB_TP_print(&(self->v__fbTP_2), indent+1);
		GEBputsINL("_fbTP_3:");
		dt_FB_TP_print(&(self->v__fbTP_3), indent+1);
	}
	if(detail>=2) {
		GEBputsINL("DISABLE:");
		GEBLIB_print_BOOL(GEB_DRV_PGET(BOOL,vat_IX0_23,'I','X',0,23,0,0));
		GEBputsINL("GREEN:");
		GEBLIB_print_BOOL(GEB_DRV_PGET(BOOL,vat_QX0_17,'Q','X',0,17,0,0));
		GEBputsINL("RED:");
		GEBLIB_print_BOOL(GEB_DRV_PGET(BOOL,vat_QX0_27,'Q','X',0,27,0,0));
	}
}
#endif

void dt_PR_leds_exec(dt_PR_leds_P self) {
/* codeExecAutomaticVars begin */
#ifdef GEB_DEBUG_MODE
	DEBUG_PUSH_STACK(2,646,self,NULL,&dt_PR_leds_dump2, &dt_PR_leds_wv,POU_FLAG_TYPE_PROGRAM | POU_FLAG_GRAPH_LANG);
#endif
/* codeExecAutomaticVars end */
beginPouExec:
	DEBUG_ST(2,0); /* samplerpi/leds.fbd:2 	 */
	/* beginFB call */
	self->v__fbTP_2.v_IN = !(self->v__fbTP_3.v_Q) ;
	self->v__fbTP_2.v_PT = ((TIME_t)TIME_t_fromVal(2000L));
	dt_FB_TP_exec(&(self->v__fbTP_2) );
	DEBUG_ST(3,0); /* samplerpi/leds.fbd:3 	 */
	/* beginFB call */
	self->v__fbTP_3.v_IN = !(self->v__fbTP_2.v_Q) ;
	self->v__fbTP_3.v_PT = ((TIME_t)TIME_t_fromVal(1000L));
	dt_FB_TP_exec(&(self->v__fbTP_3) );
	DEBUG_ST(9,0); /* samplerpi/leds.fbd:9 	 */
	GEB_DRV_PSET(BOOL,vat_QX0_27,'Q','X',0,27,0,0,gebx_AND_BOOL2(!(GEB_DRV_PGET(BOOL,vat_IX0_23,'I','X',0,23,0,0)) ,self->v__fbTP_2.v_Q));
	DEBUG_ST(8,0); /* samplerpi/leds.fbd:8 	 */
	GEB_DRV_PSET(BOOL,vat_QX0_17,'Q','X',0,17,0,0,self->v__fbTP_3.v_Q);
endPouExec: ;
	geb_hook(GEB_WHERE_END_OF_PROGRAM,DEBUGGING_MODE);
	DEBUG_POP_STACK();
	return ;
}
/* ---- end leds end body  --- */
/* ------------------- END POUS BODY ------------------*/
/* ----------- create one instance for each program and return them ----------- */
static GebRunnable dt_PR_leds_runnable;
static dt_PR_leds dt_PR_leds_inst;
void dt_PR_leds_runR(void) {
	dt_PR_leds_exec(&dt_PR_leds_inst);
}
void dt_PR_leds_initR(void) {
	dt_PR_leds_init(&dt_PR_leds_inst);
}
void dt_PR_leds_destroyR(void) {
	/* not necessary anymore */
}
const char * dt_PR_leds_getName(void) {
	return  "leds";
}
#ifndef SUPPRESS_FORMATTED_OUTPUT
void dt_PR_leds_showVarsR(int detail) {
	dt_PR_leds_printVars(&dt_PR_leds_inst,0,detail);
}
#endif


/* one instance for each program , null terminated - getter: gebInstanceAllPrograms() */
static	 GebRunnable_P _programs[1+1];
static void programs_init(void) {
	 int _nprograms = 1;
	 /* ----- dt_PR_leds -------- */
	 dt_PR_leds_runnable.getName = &dt_PR_leds_getName;
	 dt_PR_leds_runnable.data = (unsigned char*)&dt_PR_leds_inst;
	 dt_PR_leds_runnable.nBytesRetain = dt_PR_leds_nRetainBytes(&dt_PR_leds_inst);
	 dt_PR_leds_runnable.run = &dt_PR_leds_runR;
	 dt_PR_leds_runnable.init = &dt_PR_leds_initR;
	 dt_PR_leds_runnable.destroy = &dt_PR_leds_destroyR;
#ifndef SUPPRESS_FORMATTED_OUTPUT
	 dt_PR_leds_runnable.showVars = &dt_PR_leds_showVarsR;
#endif
	 _programs[0] = &dt_PR_leds_runnable;
	 dt_PR_leds_init(&dt_PR_leds_inst);

	 _programs[1] = NULL; /* NULL terminated list */
}

/* ----------- end of programs code ------------------------ */

static void afterInit(void) {
	_gebTestCase.enabled = false;
}

/* simple digest (code hash) : adi1jlzdjz9w */
const char * getDigest(void) { return "adi1jlzdjz9w"; }

/* ----------- serialize/deserialize retain data ----------- */
#define RETAIN_DATA_HEADER_LEN  12
#define RETAIN_DATA_HEADER_LEN_CRIT 8
static unsigned char retainDataHeader[RETAIN_DATA_HEADER_LEN]={'G','E','B','r',0xdf,0x13,0x3b,0x83,0xe5,0xb3,0xe8,0x51};

#include <gebprogs_f.c>

/* ---------- end of automatically generated code ---------- */
