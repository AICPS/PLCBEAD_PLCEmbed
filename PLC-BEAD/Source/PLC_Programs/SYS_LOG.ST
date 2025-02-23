FUNCTION_BLOCK SYS_LOG

  VAR_EXTERNAL

  END_VAR


  VAR

  END_VAR

  VAR_IN_OUT
    IP_C :	oscat_IP_C;
    S_BUF :	oscat_NETWORK_BUFFER;
    R_BUF :	oscat_NETWORK_BUFFER;
  END_VAR


  VAR_INPUT
    ACTIVATE :	BOOL;
    LDT :	UDINT;
    SERVER_IP4 :	DWORD;
    PORT :	WORD;
    FACILITY :	BYTE;
    SEVERITY :	BYTE;
    TAG :	oscat_STRING32;
    HOSTNAME :	STRING;
    MESSAGE :	oscat_STRING250;
    OPTION :	BYTE;
  END_VAR


  VAR_OUTPUT
    DONE_P :	BOOL;
    ERROR :	DWORD;
  END_VAR


  VAR
    IP_FIFO :	IP_FIFO;
    _STRING_TO_BUFFER :	_STRING_TO_BUFFER_NW;
    DT_TO_STRF :	DT_TO_STRF;
    ip_state :	BYTE;
    ip_id :	BYTE;
    activate_last :	BOOL;
    state :	INT;
    s1 :	oscat_STRING20;
    i :	INT;
  END_VAR

  CASE state OF 
  00: 
    IF ACTIVATE AND NOT activate_last THEN
      state := 10;
      ERROR := DWORD#0;
      ip_state := BYTE#1; 
    END_IF;
    DONE_P := FALSE;

  10: 
    IF ip_state = BYTE#3 THEN 
      i := 0;

      IF (OPTION AND BYTE#0000_0001) = BYTE#00 THEN 
        s1:=REPLACE('<P>',BYTE_TO_STRING(SHL_BYTE(FACILITY,3) OR (SEVERITY AND BYTE#0000_0111),'%u'),1,2);
      ELSE
        s1 := '';
      END_IF;

      IF (OPTION AND BYTE#0000_0010) = BYTE#00 THEN 
        DT_TO_STRF(DTI:=LDT,MS:=0,FMT:='#E #W #N:#R:#T ',LANG:=1);
        s1 := CONCAT(s1,DT_TO_STRF.DT_TO_STRF);

        _STRING_TO_BUFFER(str:=s1,pos:=i,size:=UINT#1024,pt:=S_BUF.BUFFER);
        S_BUF.BUFFER:=_STRING_TO_BUFFER.pt;

        i := i + LEN(s1);

        _STRING_TO_BUFFER(str:=HOSTNAME,pos:=i,size:=UINT#1024,pt:=S_BUF.BUFFER);
        S_BUF.BUFFER:=_STRING_TO_BUFFER.pt;

        i := i + LEN(HOSTNAME);
        S_BUF.BUFFER[i] := BYTE#32; 
        i := i + 1;
      
        _STRING_TO_BUFFER(str:=TAG,pos:=i,size:=UINT#1024,pt:=S_BUF.BUFFER);
        S_BUF.BUFFER:=_STRING_TO_BUFFER.pt;

        i := i + LEN(TAG);
        S_BUF.BUFFER[i] := BYTE#32; 
        i := i + 1;
      END_IF;

      _STRING_TO_BUFFER(str:=MESSAGE,pos:=i,size:=UINT#1024,pt:=S_BUF.BUFFER);
      S_BUF.BUFFER:=_STRING_TO_BUFFER.pt;

      i := i + LEN(MESSAGE);

      IF (OPTION AND BYTE#0000_0100) > BYTE#00 THEN 
        S_BUF.BUFFER[i] := BYTE#13;
        i := i + 1;
        S_BUF.BUFFER[i] := BYTE#10; 
        i := i + 1;
      END_IF;   

      state := 30;

      IF (OPTION AND BYTE#2#0000_1000) > BYTE#00 THEN
        IP_C.C_MODE := BYTE#0;             
      ELSE
        IP_C.C_MODE := BYTE#1;             
      END_IF;    

      IF PORT = WORD#0 THEN                 
        IF IP_C.C_MODE = BYTE#0 THEN        
          IP_C.C_PORT := WORD#1468;         
      ELSE
          IP_C.C_PORT := WORD#514;        
        END_IF;    
      ELSE
        IP_C.C_PORT := PORT;             
    END_IF;

      IP_C.C_IP       := SERVER_IP4;       
      IP_C.C_ENABLE   := TRUE;             
      IP_C.TIME_RESET := TRUE;           
      IP_C.R_OBSERVE  := FALSE;            
      S_BUF.SIZE      := INT_TO_UINT(i);    
      R_BUF.SIZE      := UINT#0;            
    END_IF;

  30:
    IF IP_C.ERROR <> DWORD#00 THEN
      ERROR := IP_C.ERROR;
      state := 0;
    

    ELSIF S_BUF.SIZE = UINT#0 THEN 
      DONE_P := TRUE;
      state := 0;
    END_IF;  

    IF state = 0 THEN 
      ip_state := BYTE#4;
    END_IF;

  END_CASE;

  activate_last := ACTIVATE; 

  IP_FIFO(FIFO:=IP_C.FIFO,state:=IP_STATE,ID:=ip_id);
  IP_C.FIFO := IP_FIFO.FIFO;
  ip_state := IP_FIFO.STATE;
  ip_id := IP_FIFO.ID;

END_FUNCTION_BLOCK
