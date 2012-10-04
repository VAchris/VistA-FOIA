GMPLDAL4 ; RGI/CBR DATA ACCESS LAYER - REPORTS ; 09/17/12
 ;;2.0;Problem List;**260002**;Aug 25, 1994
GETPROB(IFN,PROBLEM) ;
 N NODE0,NODE1
 S NODE0=^AUPNPROB(IFN,0)
 S NODE1=$G(^AUPNPROB(IFN,1))
 S PROBLEM("ACTFLAG")=$P(NODE0,"^",12)
 S PROBLEM("DFN")=$P(NODE0,"^",2)
 S PROBLEM("TEXT")=$P(NODE0,"^",5)
 S PROBLEM("DELETED")=($P(NODE1,"^",2)="H")
 Q
 ;
 ;
 ; Finds patients with active and inactive problems.
 ;   TARGET: Root of the target local or global.
 ; Results stored as TARGET(PATIENT_NAME)=<# Active Problems>_"^"_<# Inactive Problems>
 ; Returns number of patients.
PPROBCNT(TARGET) ;
 N DFN,IFN,CNT,PATCNT,ST,PROBLEM
 S PATCNT=0
 F DFN=0:0 S DFN=$O(^AUPNPROB("AC",DFN)) Q:DFN'>0  D
 . S (CNT("A"),CNT("I"),IFN)=0
 . F  S IFN=$O(^AUPNPROB("AC",DFN,IFN)) Q:IFN'>0  D
 . . K PROBLEM D GETPROB(IFN,.PROBLEM)
 . . Q:PROBLEM("DELETED")
 . . S ST=PROBLEM("ACTFLAG")
 . . S CNT(ST)=CNT(ST)+1
 . I (CNT("A")>0)!(CNT("I")>0) D
 . . S PATCNT=PATCNT+1
 . . S @TARGET@($$PATNAME^GMPLEXT(DFN))=CNT("A")_"^"_CNT("I")
 Q PATCNT
 ;
 ; Finds patients with specified active or inactive problems
 ;   TARGET: Root of the target local or global.
 ;   GMPTERM: Problem code
 ;   GMPTEXT: Problem text
 ;   STATUS: Problem status
PPRBSPEC(TARGET,GMPTERM,GMPTEXT,STATUS) ;
 N IFN,PROBLEM,ST,DFN,TXT,STWORD,PATCNT,NAME,LINE
 S PATCNT=0
 F IFN=0:0 S IFN=$O(^AUPNPROB("C",+GMPTERM,IFN)) Q:IFN'>0  D
 . K PROBLEM D GETPROB(IFN,.PROBLEM)
 . Q:PROBLEM("DELETED")
 . S ST=PROBLEM("ACTFLAG")
 . Q:STATUS'[ST
 . I GMPTERM'>1,GMPTEXT'=$$UP^XLFSTR($$NARR^GMPLEXT(+TXT)) Q
 . S DFN=PROBLEM("DFN"),TXT=PROBLEM("TEXT")
 . S NAME=$$PATNAME^GMPLEXT(DFN)
 . S STWORD=$S(ST="A":"active",1:"inactive")
 . I '$D(@TARGET@(NAME)) S PATCNT=PATCNT+1,@TARGET@(NAME)=STWORD Q
 . S LINE=@TARGET@(NAME)
 . Q:(" "_LINE)[(" "_STWORD)  ; already included
 . S:$E(STWORD)="a" @TARGET@(NAME)=STWORD_", "_LINE
 . S:$E(STWORD)="i" @TARGET@(NAME)=LINE_", "_STWORD
 Q PATCNT
 ;
