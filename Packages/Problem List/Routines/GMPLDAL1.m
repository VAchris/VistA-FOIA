GMPLDAL1 ; RGI/VSL -- DATA ACCESS LAYER - DIRECT GLOBALS ACCESS ; 05/21/12
 ;;2.0;Problem List;**260002**;Aug 25, 1994
GETCATS(RETURN,SEARCH,START,NUMBER) ;
 S:$D(START)=0 START="" S:$D(SEARCH)=0 SEARCH=""
 D LIST^DIC("125.11","","","",NUMBER,START,SEARCH,"","","","RETURN")
 I $L(SEARCH)>0,$P(RETURN("DILIST",0),U,1)'>0 D
 . D LIST^DIC("125.11","","","",NUMBER,START,$$UP^XLFSTR(SEARCH),"","","","RETURN")
 Q
 ;
DELLST(GMPLLST) ; Delete problem selection list
 N CNT,DA,DIK
 S DIK="^GMPL(125.1,",DA=0,CNT=0
 F  S CNT=CNT+1,DA=$O(^GMPL(125.1,"B",+GMPLLST,DA)) Q:DA'>0  D ^DIK
 S DA=+GMPLLST,DIK="^GMPL(125," D ^DIK
 Q CNT
 ;
DELCAT(GMPLGRP) ; Delete problem category
 N IFN,DA,DIK,CNT S CNT=0
 F IFN=0:0 S IFN=$O(^GMPL(125.12,"B",+GMPLGRP,IFN)) Q:IFN'>0  D
 . Q:IFN'>0  S CNT=CNT+1,DA=IFN,DIK="^GMPL(125.12," D ^DIK
 S DA=+GMPLGRP,DIK="^GMPL(125.11," D ^DIK
 Q 1
 ;
GETLSTS(RETURN,SEARCH,START,NUMBER) ;
 N FILE,FIELDS
 S FILE="125",FIELDS="@;.01"
 S:$D(START)=0 START="" S:$D(SEARCH)=0 SEARCH=""
 D LIST^DIC(FILE,"",FIELDS,"",NUMBER,.START,SEARCH,"B","","","RETURN")
 I $L(SEARCH)>0,$P(RETURN("DILIST",0),U,1)'>0 D
 . D LIST^DIC(FILE,"",FIELDS,"",NUMBER,.START,$$UP^XLFSTR(SEARCH),"B","","","RETURN")
 I $P(RETURN("DILIST",0),U,1)'>0 D
 . S FIELDS="@;.01;.03"
 . D LIST^DIC(FILE,"",FIELDS,"",NUMBER,.START,SEARCH,"C","","","RETURN")
 Q
 ;
LOCKLST(GMPLLST) ; Lock the list
 L +^GMPL(125,+GMPLLST,0):1
 I '$T D ERRX^GMPLAPIE(.RETURN,"FILELOCK") Q 0
 Q 1
 ;
UNLCKLST(GMPLLST) ; Unlock the list
 L -^GMPL(125,+GMPLLST,0)
 Q
 ;
LOCKCAT(GMPLCAT) ; Lock the category
 L +^GMPL(125.11,+GMPLCAT,0):1
 I '$T D ERRX^GMPLAPIE(.RETURN,"FILELOCK") Q 0
 Q 1
 ;
UNLCKCAT(GMPLCAT) ; Unlock the category
 L -^GMPL(125.11,+GMPLCAT,0)
 Q
 ;
FINDLST(NAMEIFN) ; Search for problem selection list
 Q $$FIND("125",NAMEIFN)
 ;
FINDCAT(NAMEIFN) ; Search for problem category
 Q $$FIND("125.11",NAMEIFN)
 ;
FINDCATM(NAMEIFN) ; Search for problem category
 Q $$FINDM("125.11",NAMEIFN)
 ;
GETLSTGR(IFN) ; Search for problem selection category
 Q $G(^GMPL(125.1,IFN,0))
 ;
FIND(FILENO,EL) ; Lookup
 ; Input
 ;  EL      IEN or name of the record
 ;  FILENO  File number
 ; Output:
 ;  0   - if no exact matches are found
 ;  IEN - if a single match is found
 N PRE,TEXT S TEXT=EL,PRE=""
 I +EL>0 S TEXT=+EL,PRE="`"
 Q $$FIND1^DIC(FILENO,"","MX",PRE_TEXT,"","","ERR")
 ;
FINDM(FILENO,TEXT) ; Lookup
 ; Input
 ;  EL      IEN or name of the record
 ;  FILENO  File number
 ; Output:
 ;  0   - if no exact matches are found
 ;  IEN - if a single match is found
 ;N LST 
 D FIND^DIC(FILENO,,,"MX",TEXT,,,,,"LST")
 Q +LST("DILIST",0)
 ;
NEWLST(GMPLNAME) ; Create new problem selection list
 Q $$CREATE(GMPLNAME,"^GMPL(125,","125")
 ;
NEWCAT(GMPLNAME,DUPLIC) ; Create new problem category
 Q $$CREATE(GMPLNAME,"^GMPL(125.11,","125.11",$G(DUPLIC))
 ;
CREATE(GMPLNAME,GMPLFILE,GMPLFN,DUPLIC) ; Create simple record
 ; Input
 ;  GMPLNAME  Name of the new record
 ;  GMPLFILE  File name
 ;  GMPLFN    File number
 ; Output
 ;  IEN  New record IEN
 ;  -1   On error
 N DIC,X,Y,DLAYGO
 I $G(DUPLIC) D
 . S DIC=GMPLFILE,DIC(0)="L",DLAYGO=GMPLFILE,X=GMPLNAME
 . D FILE^DICN
 E  D
 . S DIC=GMPLFILE,DIC(0)="OMZLX",DLAYGO=GMPLFN,X=GMPLNAME
 . D ^DIC
 . S:Y>0 Y=+Y_U_Y(0)
 Q Y
 ;
CATUSED(GMPLGRP) ; Check if category is used by any selection list
 Q $D(^GMPL(125.1,"G",+GMPLGRP))
 ;
GETCATD(RETURN,GMPLGRP,CODLEN) ; Return Category details
 N PSEQ,IFN,ITEM,LINE,GROUP,DIAG
 S LINE=0,GROUP=+GMPLGRP
 F PSEQ=0:0 S PSEQ=$O(^GMPL(125.12,"C",+GROUP,PSEQ)) Q:PSEQ'>0  D
 . S IFN=$O(^GMPL(125.12,"C",+GROUP,PSEQ,0))
 . S ITEM=$G(^GMPL(125.12,IFN,0)),LINE=LINE+1
 . S DIAG=$P(ITEM,U,4)
 . I $G(CODLEN) S DIAG=$E(DIAG,1,CODLEN)
 . S RETURN("GRP",GROUP,LINE)=DIAG_"^"_$P(ITEM,U,5)_"^"_$P(ITEM,U,3)
 S RETURN=1
 Q 1
 ;
GETLIST(RETURN,GMPLLST,CODLEN,MINIM) ; Return Problem Selection list details
 N CNT,LIST,IFN,ITEM,SEQ,GRP
 S CNT=0,LIST=^GMPL(125,GMPLLST,0)
 S RETURN("LST","NAME")=$P(LIST,"^",1)
 S RETURN("LST","MODIFIED")=+$P(LIST,U,2)
 S RETURN("LST","CLINIC")=$P(LIST,U,3)
 Q:$G(MINIM)>0 1
 F IFN=0:0 S IFN=$O(^GMPL(125.1,"B",GMPLLST,IFN)) Q:IFN'>0  D
 . S ITEM=$G(^GMPL(125.1,IFN,0)),SEQ=$P(ITEM,U,2),GRP=$P(ITEM,U,3)
 . S RETURN(IFN)=$P(ITEM,U,2,5),CNT=CNT+1 ; seq ^ group ^ subhdr ^ probs
 . S (RETURN("GRP",GRP),RETURN("SEQ",SEQ))=IFN
 S RETURN(0)=CNT,RETURN=1
 Q 1
 ;
GETCAT(RETURN,GMPLGRP) ; Return category details
 S RETURN=0
 N SEQ,IFN,ITEM,PROB,CNT,CODE,CAT S CNT=0
 S CAT=^GMPL("125.11",+GMPLGRP,0)
 S RETURN("CAT","NAME")=$P(CAT,"^",1)
 S RETURN("CAT","MODIFIED")=+$P(CAT,U,2)
 F IFN=0:0 S IFN=$O(^GMPL(125.12,"B",+GMPLGRP,IFN)) Q:IFN'>0  D
 . S ITEM=$G(^GMPL(125.12,IFN,0)),SEQ=$P(ITEM,U,2),PROB=$P(ITEM,U,3)
 . S RETURN(IFN)=$P(ITEM,U,2,5),CNT=CNT+1 ; seq ^ prob ^ text ^ code
 . S (RETURN("PROB",PROB),RETURN("SEQ",SEQ))=IFN,CODE=$P(ITEM,U,5) ; Xrefs
 . S RETURN(IFN,"CODE")=CODE
 S RETURN(0)=CNT,RETURN=1
 Q 1
 ;
SAVLST(RETURN,GMPLLST,SOURCE,DATE) ; Save changes to existing list
 S RETURN=0
 N DIK,DIE,DR,ITEM,TMPLST,DA,DT
 S DIE="^GMPL(125,",DA=+GMPLLST,DR=".02////"_DATE D ^DIE ; set modified date
 S DA=0
 F  S DA=$O(SOURCE(DA)) Q:+DA'>0  D
 .S DIK="^GMPL(125.1,"
 .I +DA'=DA D  Q  ; new link
 .. Q:"@"[$G(SOURCE(DA))  ; nothing to save
 .. S TMPLST=SOURCE(DA) D NEW(DIK,+GMPLLST,TMPLST)
 .I "@"[$G(SOURCE(DA)) D ^DIK Q
 .S ITEM=$P($G(^GMPL(125.1,DA,0)),U,2,5)
 .I ITEM'=SOURCE(DA) D
 .. S DR="",DIE=DIK
 .. F I=1,2,3,4 D
 ... S:$P(SOURCE(DA),U,I)'=$P(ITEM,U,I) DR=DR_";"_I_"////"_$S($P(SOURCE(DA),U,I)="":"@",1:$P(SOURCE(DA),U,I))
 .. S:$E(DR)=";" DR=$E(DR,2,999) D ^DIE
 S RETURN=1
 Q 1
 ;
SAVGRP(RETURN,GMPLGRP,SOURCE,DATE) ; Save changes to existing group
 S RETURN=0
 N DIK,DIE,DR,ITEM,TMPITEM,DT
 ;to do check SOURCE
 S DIE="^GMPL(125.11,",DA=+GMPLGRP,DR="1////"_DATE D ^DIE ; set modified date
 S DA=0
 F  S DA=$O(SOURCE(DA)) Q:+DA'>0  D
 .S DIK="^GMPL(125.12,"
 .I +DA'=DA D  Q
 .. Q:"@"[$G(SOURCE(DA))  ; nothing to save
 .. S TMPITEM=SOURCE(DA) D NEW(DIK,+GMPLGRP,TMPITEM)
 .I "@"[$G(SOURCE(DA)) D ^DIK Q
 .S ITEM=$P($G(^GMPL(125.12,DA,0)),U,2,5)
 .I ITEM'=SOURCE(DA) D
 .. S DR="",DIE=DIK
 .. F I=1:1:4 D
 ... S:$P(SOURCE(DA),U,I)'=$P(ITEM,U,I) DR=DR_";"_I_"////"_$S($P(SOURCE(DA),U,I)="":"@",1:$P(SOURCE(DA),U,I))
 .. S:$E(DR)=";" DR=$E(DR,2,999) D ^DIE
 S RETURN=1
 Q 1
 ;
NEW(DIK,LIST,ITEM) ; Create new entry in Contents file #125.1 or #125.12
 N I,HDR,LAST,TOTAL,DA
 S HDR=$G(@(DIK_"0)")),LAST=$P(HDR,U,3),TOTAL=$P(HDR,U,4)
 F I=(LAST+1):1 Q:'$D(@(DIK_"I,0)"))
 S DA=I,@(DIK_"DA,0)")=LIST_U_ITEM
 S $P(@(DIK_"0)"),U,3,4)=DA_U_(TOTAL+1)
 D IX1^DIK ; set Xrefs
 Q
 ;
ADDLOC(RETURN,GMPLLST,GMPLLOC) ; Add location to list
 S RETURN=0
 N DIE,DA,DR
 S DIE="^GMPL(125,",DA=+GMPLLST,DR=".03////"_+GMPLLOC D ^DIE
 S RETURN=1
 Q
 ;
GETCLST(GMPCLIN) ; Get first list assigned to the clinic
 ; RETURN - Passed by reference, List IFN^List name
 ; GMPCLIN - Location IFN
 N LST
 S:$D(^GMPL(125,"C",+GMPCLIN)) LST=$O(^GMPL(125,"C",+GMPCLIN,0))
 Q:'$G(LST) 0
 S $P(LST,U,2)=$P($G(^GMPL(125,+LST,0)),U)
 Q LST
 ;
GETGRPP(RETURN,GMPLCAT) ; get all problems in the category
 I '$G(GMPLCAT) Q 0
 N PROB,GMPLVALC,PCNT
 S PROB=0,PCNT=0
 F  S PROB=$O(^GMPL(125.12,"B",GMPLCAT,PROB)) Q:'PROB  D
 . N GMPLCOD
 . S GMPLCOD=$P(^GMPL(125.12,PROB,0),U,5)
 . Q:'$L(GMPLCOD)  ; no code there
 . S PCNT=PCNT+1
 . S RETURN(PCNT)=GMPLCOD
 . Q
 Q 1
 ;
GETLSTC(RETURN,LIST) ; get all categories in list
 N GMPLIEN,GMPLVAL,GCNT
 I '$G(LIST) Q 0
 S GMPLIEN=0,GMPLVAL=1,GCNT=0
 F  S GMPLIEN=$O(^GMPL(125.1,"B",LIST,GMPLIEN)) Q:'GMPLIEN!('GMPLVAL)  D
 . N GMPLCAT
 . S GCNT=GCNT+1
 . S GMPLCAT=$P(^GMPL(125.1,GMPLIEN,0),U,3) I 'GMPLCAT Q
 . S RETURN(GCNT)=GMPLCAT
 . Q
 Q 1
 ;
ALLPROB(RETURN) ;
 N PROB,CAT,LIST,CNT
 S PROB=0,CNT=0
 F  S PROB=$O(^GMPL(125.12,PROB)) Q:'PROB  I $L($P(^(PROB,0),U,5)) D
 . N PROB0,PROBTX,APIDATA,PROBCAT,ACTDT
 . S CNT=CNT+1
 . S PROB0=^GMPL(125.12,PROB,0)
 . S PROBCAT=$P(PROB0,U)
 . S RETURN(PROBCAT,PROB,"CODE")=$P(PROB0,U,5)
 . S RETURN(PROBCAT,PROB,"NEWTXT")=$P(PROB0,U,4)
 . S RETURN(PROBCAT,PROB,"TXT")=$$GET1^DIQ(125.12,PROB,2)
 . I '$D(^GMPL(125.1,"G",PROBCAT)) Q
 . N LIST S LIST=0
 . F  S LIST=$O(^GMPL(125.1,"G",PROBCAT,LIST)) Q:'LIST  D
 .. S RETURN(PROBCAT,"L",LIST)=$$GET1^DIQ(125.1,LIST,.01)
 .. Q
 . Q
 Q
 ;
