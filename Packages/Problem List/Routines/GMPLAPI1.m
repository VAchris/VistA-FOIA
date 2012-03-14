GMPLAPI1 ;; Build Problem Selection Lists ; 02/21/12 10:23
 ;;;Problem List;;02/21/12
NEWLST(RETURN,GMPLLST,GMPLLOC) ; Add new Problem Selection List
 ; Input
 ;  GMPLLST  Problem Selection List name
 ;  GMPLLOC  Location IEN
 ; Output:  IEN of Problem Selection List  
 N LOCERR S LOCERR=0,RETURN=0
 I $D(GMPLLST)'>0!$L(GMPLLST)=0 D ERRX^GMPLAPIE(.RETURN,"INVPARAM","GMPLLST") Q 0
 I $L($G(GMPLLOC))>0 D
 . I +$G(GMPLLOC)'>0 D ERRX^GMPLAPIE(.RETURN,"INVPARAM","GMPLLOC")
 . S:+$G(GMPLLOC)'>0 LOCERR=1
 Q:LOCERR=1 0
 N EXLST,NEWLST,LOCQ
 S EXLST=$$FIND^GMPLAPI5("125",GMPLLST),LOCQ=0
 I EXLST>0 D ERRX^GMPLAPIE(.RETURN,"LISTXST") S RETURN=EXLST Q 0
 I $G(GMPLLOC) D
 . I '$$FIND^GMPLAPI5(44,GMPLLOC) D ERRX^GMPLAPIE(.RETURN,"LOCNFND") S LOCQ=1
 Q:LOCQ=1 0
 S NEWLST=$$CREATE^GMPLAPI5(GMPLLST,"^GMPL(125,","125")
 I +NEWLST'>0 D ERRX^GMPLAPIE(.RETURN,"INVPARAM","GMPLLST") Q 0
 I $G(GMPLLOC) D ADDLOC^GMPLAPI5(.RETURN,NEWLST,GMPLLOC)
 S RETURN=NEWLST
 Q 1
 ;
ASSUSR(RETURN,GMPLLST,GMPLUSER) ; Assign Problem Selection List to users
 ; Input
 ;  GMPLLST   List IEN
 ;  GMPLUSER  List of users (^UserIEN^...)
 N DR
 S DR="125.1////"_+GMPLLST,RETURN=0
 S RETURN=$$USERLST^GMPLAPI5(.RETURN,GMPLLST,GMPLUSER,DR)
 Q RETURN
 ;
REMUSR(RETURN,GMPLLST,GMPLUSER) ; Remove Problem Selection List from users
 ; Input
 ;  GMPLLST   List IEN
 ;  GMPLUSER  List of users (^UserIEN^...)
 S RETURN=0
 S RETURN=$$USERLST^GMPLAPI5(.RETURN,GMPLLST,GMPLUSER,"125.1///@")
 Q RETURN
 ;
DELLST(RETURN,GMPLLST) ; Delete Problem Selection List
 ; Input
 ;  GMPLLST  Problem Selection List IEN
 S RETURN=0
 I '$G(GMPLLST) D ERRX^GMPLAPIE(.RETURN,"INVPARAM","GMPLLST") Q 0
 N U,USER,VIEW,GMPCOUNT,DIK,DA,CNT
 S GMPCOUNT=0,U="^",EXISTS=$$FIND^GMPLAPI5("125",GMPLLST),CNT=0
 I EXISTS'>0 D ERRX^GMPLAPIE(.RETURN,"LISTNFND") Q 0
 F USER=0:0 S USER=$O(^VA(200,USER)) Q:USER'>0  D
 . S VIEW=$P($G(^VA(200,USER,125)),U,2) Q:'VIEW  Q:VIEW'=+GMPLLST
 . S GMPCOUNT=GMPCOUNT+1
 D LSTUSED(.RETURN,GMPLLST)
 I $G(RETURN)>0 D ERRX^GMPLAPIE(.RETURN,"LISTUSED",GMPCOUNT_" user(s) are currently assigned this list!") Q
 Q:'$$LOCKLST(.RETURN,GMPLLST) 0
 S DIK="^GMPL(125.1,",DA=0
 F  S CNT=CNT+1,DA=$O(^GMPL(125.1,"B",+GMPLLST,DA)) Q:DA'>0  D ^DIK
 S DA=+GMPLLST,DIK="^GMPL(125," D ^DIK
 D UNLKLST(GMPLLST)
 S RETURN=CNT
 Q 1
 ;
LSTUSED(RETURN,GMPLLST) ; Return number of users assigned to this list
 S RETURN=0
 I '$G(GMPLLST) D ERRX^GMPLAPIE(.RETURN,"INVPARAM","GMPLLST") Q 0
 I $$FIND^GMPLAPI5("125",GMPLLST)'>0 D ERRX^GMPLAPIE(.RETURN,"LISTNFND") Q 0
 N USER,VIEW,GMPCOUNT
 S GMPCOUNT=0
 F USER=0:0 S USER=$O(^VA(200,USER)) Q:USER'>0  D
 . S VIEW=$P($G(^VA(200,USER,125)),U,2) Q:'VIEW  Q:VIEW'=+GMPLLST
 . S GMPCOUNT=GMPCOUNT+1
 S RETURN=GMPCOUNT
 Q 1
 ;
NEWCAT(RETURN,GMPLGRP) ; Add new Category
 ; Input
 ;  GMPLGRP  Category name
 S RETURN=0
 I $D(GMPLGRP)'>0!$L(GMPLGRP)=0 D ERRX^GMPLAPIE(.RETURN,"INVPARAM","GMPLGRP") Q 0
 N EXCAT,NEWCAT
 S EXCAT=$$FIND^GMPLAPI5("125.11",GMPLGRP)
 I EXCAT>0 D ERRX^GMPLAPIE(.RETURN,"CTGEXIST") S RETURN=EXCAT Q 0
 S NEWCAT=$$CREATE^GMPLAPI5(GMPLGRP,"^GMPL(125.11,","125.11")
 I +NEWCAT'>0 D ERRX^GMPLAPIE(.RETURN,"INVPARAM","GMPLGRP") Q 0
 S RETURN=NEWCAT
 Q 1
 ;
CATUSED(RETURN,GMPLGRP) ; Verify if category is used by a list
 ; Returns 0 if this category is not used by any list, 1 otherwise
 S RETURN=0
 I '$G(GMPLGRP) D ERRX^GMPLAPIE(.RETURN,"INVPARAM","GMPLGRP") Q 0
 I $$FIND^GMPLAPI5("125.11",GMPLGRP)'>0 D ERRX^GMPLAPIE(.RETURN,"CTGNFND") Q 0
 S RETURN=$D(^GMPL(125.1,"G",+GMPLGRP))
 Q 1
 ;
DELCAT(RETURN,GMPLGRP) ; Delete catagory
 S RETURN=0
 I '$G(GMPLGRP) D ERRX^GMPLAPIE(.RETURN,"INVPARAM","GMPLGRP") Q 0
 I $$FIND^GMPLAPI5("125.11",GMPLGRP)'>0 D ERRX^GMPLAPIE(.RETURN,"CTGNFND") Q 0
 D CATUSED(.RETURN,GMPLGRP)
 I RETURN D ERRX^GMPLAPIE(.RETURN,"CATUSED") Q 0
 N IFN,DA,DIK,CNT S CNT=0
 F IFN=0:0 S IFN=$O(^GMPL(125.12,"B",+GMPLGRP,IFN)) Q:IFN'>0  D
 . Q:IFN'>0  S CNT=CNT+1,DA=IFN,DIK="^GMPL(125.12," D ^DIK
 S DA=+GMPLGRP,DIK="^GMPL(125.11," D ^DIK
 S RETURN=1
 Q 1
 ;
LOCKLST(RETURN,GMPLLST) ; Lock speciefied list
 ; Returns 0 if list is already locked by another process, 1 otherwise
 S RETURN=0
 I '$G(GMPLLST) D ERRX^GMPLAPIE(.RETURN,"INVPARAM","GMPLLST") Q 0
 I $$FIND^GMPLAPI5("125",GMPLLST)'>0 D ERRX^GMPLAPIE(.RETURN,"LISTNFND") Q 0
 S RETURN=$$LOCK^GMPLAPI5(.RETURN,"^GMPL(125,"_+GMPLLST_",0)")
 Q RETURN
 ;
UNLKLST(GMPLLST) ; Unlock specified list
 ;
 D UNLOCK^GMPLAPI5("^GMPL(125,"_+GMPLLST_",0)")
 Q
 ;
LOCKCAT(RETURN,GMPLGRP) ; Lock speciefied category
 ; Returns 0 if category is already locked by another process, 1 otherwise
 S RETURN=0
 I '$G(GMPLGRP) D ERRX^GMPLAPIE(.RETURN,"INVPARAM","GMPLGRP") Q 0
 I $$FIND^GMPLAPI5("125.11",GMPLGRP)'>0 D ERRX^GMPLAPIE(.RETURN,"CTGNFND") Q 0
 S RETURN=$$LOCK^GMPLAPI5(.RETURN,"^GMPL(125.11,"_+GMPLGRP_",0)")
 Q RETURN
 ;
UNLKCAT(GMPLGRP) ; Unlock specified category
 ;
 D UNLOCK^GMPLAPI5("^GMPL(125.11,"_+GMPLGRP_",0)")
 Q
 ;
GETLIST(RETURN,GMPLLST,CODLEN) ; Return Problem Selection list details
 ; Input
 ;  GMPLLST: Problem Selection list IEN
 ;  RETURN: Root of the target local or global.
 ;  CODLEN: MaxLength of the problem name
 ; Result:
 ;  RETURN("LST","NAME") - Selection List name
 ;  RETURN("LST","MODIFIED") - Date last modified
 ;  RETURN(0) - Number of categories
 ;  RETURN(List_Content_IEN)= seq ^ group ^ subhdr ^ probs
 ;  RETURN("GRP",Category_IEN)=List_Content_IEN
 ;  RETURN("SEQ",# Sequence)=List_Content_IEN
 ;  RETURN("GRP",Category_IEN,# Sequence)=Problem name^Problem code^Inactive flag 
 ;   (1 for inactive code, 0 for active)
 S @RETURN=0
 I '$G(GMPLLST) D ERRX^GMPLAPIE(.RETURN,"INVPARAM","GMPLLST") Q 0
 N IFN,SEQ,GRP,ITEM,CNT,LISTIFN,LIST
 S LISTIFN=$$FIND^GMPLAPI5("125",GMPLLST)
 I LISTIFN'>0 D ERRX^GMPLAPIE(.RETURN,"LISTNFND") Q 0
 S CNT=0,LIST=^GMPL(125,LISTIFN,0)
 S @RETURN@("LST","NAME")=$P(LIST,"^",1)
 S @RETURN@("LST","MODIFIED")=$S(+$P(LIST,U,2):$$FMTE^XLFDT($P(LIST,U,2)),1:"<new list>")
 F IFN=0:0 S IFN=$O(^GMPL(125.1,"B",LISTIFN,IFN)) Q:IFN'>0  D
 . S ITEM=$G(^GMPL(125.1,IFN,0)),SEQ=$P(ITEM,U,2),GRP=$P(ITEM,U,3)
 . S @RETURN@(IFN)=$P(ITEM,U,2,5),CNT=CNT+1 ; seq ^ group ^ subhdr ^ probs
 . S (@RETURN@("GRP",GRP),@RETURN@("SEQ",SEQ))=IFN
 . D GETCATD^GMPLAPI5(.RETURN,GRP,CODLEN)
 S @RETURN@(0)=CNT,@RETURN=1
 Q 1
 ;
GETCAT(RETURN,GMPLGRP) ; Return category details
 ; Input
 ;  GMPLGRP: Problem Selection list IEN
 ;  RETURN: Root of the target local or global.
 ; Result:
 ;  RETURN(Problem_IEN)=Sequence^Poiter_to_Problem(757.01)^Display_text^ICD_Code
 ;  RETURN(Problem_IEN,"CODE")=ICD_Code^Inactive_flag
 ;  RETURN("SEQ",Sequence #)=Problem_IEN
 ;  RETURN("PROB",Poiter_to_Problem(757.01))=Problem_IEN
 S @RETURN=0
 I '$G(GMPLGRP) D ERRX^GMPLAPIE(.RETURN,"INVPARAM","GMPLGRP") Q 0
 I $$FIND^GMPLAPI5("125.11",GMPLGRP)'>0 D ERRX^GMPLAPIE(.RETURN,"CTGNFND") Q 0
 N SEQ,IFN,ITEM,PROB,CNT,CODE S CNT=0
 F IFN=0:0 S IFN=$O(^GMPL(125.12,"B",+GMPLGRP,IFN)) Q:IFN'>0  D
 . S ITEM=$G(^GMPL(125.12,IFN,0)),SEQ=$P(ITEM,U,2),PROB=$P(ITEM,U,3)
 . S @RETURN@(IFN)=$P(ITEM,U,2,5),CNT=CNT+1 ; seq ^ prob ^ text ^ code
 . S (@RETURN@("PROB",PROB),@RETURN@("SEQ",SEQ))=IFN,CODE=$P(ITEM,U,5) ; Xrefs
 . I $L(CODE) D
 .. I $$STATCHK^ICDAPIU(CODE,DT) S FLAG=0  ; OK - code is active
 .. E  S FLAG=1
 .. S @RETURN@(IFN,"CODE")=CODE_"^"_FLAG
 S @RETURN@(0)=CNT,@RETURN=1
 Q 1
 ;
SAVLST(RETURN,GMPLLST,SOURCE) ; Save changes to existing list
 S RETURN=0
 I '$G(GMPLLST) D ERRX^GMPLAPIE(.RETURN,"INVPARAM","GMPLLST") Q 0
 I $$FIND^GMPLAPI5("125",GMPLLST)'>0 D ERRX^GMPLAPIE(.RETURN,"LISTNFND") Q 0
 N IFN,SEQ,GRP,ITEM,CNT,LISTIFN,LIST
 N DIK,DIE,DR,ITEM,TMPLST,DA,DT
 S DA=0,INV=1 ; check SOURCE param
 F  S DA=$O(@SOURCE@(DA)) Q:+DA'>0  D 
 . Q:INV=0
 . I $L($G(@SOURCE@(DA)))'>0 S INV=0 Q
 . I +DA=DA D  Q  ; new link
 . . I $L($G(^GMPL(125.1,DA,0)))'>0 S INV=0 Q
 . I "@"[$G(@SOURCE@(DA)) Q
 . S TMPLST=$P(@SOURCE@(DA),"^",2) I $L(TMPLST)'>0 S INV=0 Q
 . I $L($P(@SOURCE@(DA),"^",3))'>0 S INV=0 Q
 . S INV=$$FIND^GMPLAPI5("125.11",TMPLST)
 I INV=0 D ERRX^GMPLAPIE(.RETURN,"INVPARAM","SOURCE") Q 0
 S DT=$P($$HTFM^XLFDT($H),".")
 S DIE="^GMPL(125,",DA=+GMPLLST,DR=".02////"_DT D ^DIE ; set modified date
 S DA=0
 F  S DA=$O(@SOURCE@(DA)) Q:+DA'>0  D
 .S DIK="^GMPL(125.1,"
 .I +DA'=DA D  Q  ; new link
 .. Q:"@"[$G(@SOURCE@(DA))  ; nothing to save
 .. S TMPLST=@SOURCE@(DA) D NEW^GMPLAPI5(DIK,+GMPLLST,TMPLST)
 .I "@"[$G(@SOURCE@(DA)) D ^DIK Q
 .S ITEM=$P($G(^GMPL(125.1,DA,0)),U,2,5)
 .I ITEM'=@SOURCE@(DA) D
 .. S DR="",DIE=DIK
 .. F I=1,2,3,4 D
 ... S:$P(@SOURCE@(DA),U,I)'=$P(ITEM,U,I) DR=DR_";"_I_"////"_$S($P(@SOURCE@(DA),U,I)="":"@",1:$P(@SOURCE@(DA),U,I))
 .. S:$E(DR)=";" DR=$E(DR,2,999) D ^DIE
 S RETURN=1
 Q 1
 ;
SAVGRP(RETURN,GMPLGRP,SOURCE) ; Save changes to existing group
 S RETURN=0
 I '$G(GMPLGRP) D ERRX^GMPLAPIE(.RETURN,"INVPARAM","GMPLGRP") Q 0
 I $$FIND^GMPLAPI5("125.11",GMPLGRP)'>0 D ERRX^GMPLAPIE(.RETURN,"CTGNFND") Q 0
 N DIK,DIE,DR,ITEM,TMPITEM,DT
 ;to do check SOURCE
 S DT=$P($$HTFM^XLFDT($H),".")
 S DIE="^GMPL(125.11,",DA=+GMPLGRP,DR="1////"_DT D ^DIE ; set modified date
 F  S DA=$O(@SOURCE@(DA)) Q:+DA'>0  D
 .S DIK="^GMPL(125.12,"
 .I +DA'=DA D  Q
 .. Q:"@"[$G(@SOURCE@(DA))  ; nothing to save
 .. S TMPITEM=@SOURCE@(DA) D NEW^GMPLAPI5(DIK,+GMPLGRP,TMPITEM)
 .I "@"[$G(@SOURCE@(DA)) D ^DIK Q
 .S ITEM=$P($G(^GMPL(125.12,DA,0)),U,2,5)
 .I ITEM'=@SOURCE@(DA) D
 .. S DR="",DIE=DIK
 .. F I=1:1:4 D
 ... S:$P(@SOURCE@(DA),U,I)'=$P(ITEM,U,I) DR=DR_";"_I_"////"_$S($P(@SOURCE@(DA),U,I)="":"@",1:$P(@SOURCE@(DA),U,I))
 .. S:$E(DR)=";" DR=$E(DR,2,999) D ^DIE
 S RETURN=1
 Q 1
 ;
