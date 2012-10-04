GMPLEXT ; RGI/CBR -- External functions mockup (to be deleted when the interfaces are fixed); 09/14/12
 ;;2.0;Problem List;**260002**;Aug 25, 1994
PROVNAME(GMPROV) ; Returns provider name
 Q $P($G(^VA(200,+GMPROV,0)),U)
 ;
CLINNAME(GMCLIN) ; Returns Clinic name
 Q $P($G(^SC(+GMCLIN,0)),U)
 ;
LOCTYPE(GMPLOC) ; Returns location type
 Q $P($G(^SC(GMPLOC,0)),U,3)
 ;
PATNAME(GMPDFN) ; Returns patient name
 Q $P($G(^DPT(+GMPDFN,0)),U)
 ;
ICDCODE(GMPICD) ;
 Q $P($G(^ICD9(+GMPICD,0)),U)
 ;
NOS() ; Return PTR ^ 799.9 ICD code
 N X
 S X=$O(^ICD9("BA",799.9,0))
 Q (+X_"^799.9")
 ;
PROVNARR(X,CL) ; Returns IFN ^ Text of Narrative (#9999999.27)
 N DIC,Y,DLAYGO,DD,DO,DA
 S:$L(X)>80 X=$E(X,1,80)
 S DIC="^AUTNPOV(",DIC(0)="L",DLAYGO=9999999.27,(DA,Y)=0
 F  S DA=$O(^AUTNPOV("B",$E(X,1,30),DA)) Q:DA'>0  D
 . I $P(^AUTNPOV(DA,0),U)=X S Y=DA_U_X Q
 I '(+Y) D
 . K DA,Y
 . D FILE^DICN
 . S:Y'>0 Y=U_X
 . I Y>0,CL>1 S ^AUTNPOV(+Y,757)=CL
 Q $P(Y,U,1,2)
 ;
LSTTEXT(GMPLSLST) ; Returns list name
 Q $P($G(^GMPL(125,+GMPLSLST,0)),U)
 ;
USERLST(GMPCLIN) ; Returns user list or clinic's
 N GMPLSLST
 S GMPLSLST=$P($G(^VA(200,DUZ,125)),U,2)
 I 'GMPLSLST,$G(GMPCLIN),$D(^GMPL(125,"C",+GMPCLIN)) S GMPLSLST=$O(^(+GMPCLIN,0)) ; if user has no list but clinic does, use clinic list
 Q GMPLSLST
 ;
UPUSRLST(PRIVW,SELLIST) ;Update user list
 S ^VA(200,DUZ,125)=PRIVW_U_SELLIST
 Q
 ;
ICD9KEY(GMPICD) ; Returns KEY IN icd9 File
 Q $O(^ICD9("AB",GMPICD_" ",0))
 ;
SERVICE(USER) ; Returns User's service/section from file #49
 S:$G(USER)="" USER=DUZ
 N X S X=+$P($G(^VA(200,USER,5)),U)
 I $P($G(^DIC(49,X,0)),U,9)'="C" S X=0
 S:X>0 X=X_U_$$SVCNAME(X) S:X'>0 X=""
 Q X
 ;
SVCNAME(SVC) ; Return service name
 Q $P($G(^DIC(49,SVC,0)),U)
 ;
SVCABBV(SVC) ;Service abbreviation
 Q $P($G(^DIC(49,SVC,0)),U,2)
 ;
USERVIEW(USER) ; Returns user's preferred view
 S USER=+$G(USER,DUZ)
 Q $P($G(^VA(200,USER,125)),U)
 ;
CLINUSER() ;is this a clinical user?
 N GMPLUSER
 S GMPLUSER=0
 I $$KCHK^XUSRB("PROVIDER") S GMPLUSER=1
 I $$KCHK^XUSRB("ORES") S GMPLUSER=1
 I $$KCHK^XUSRB("ORELSE") S GMPLUSER=1
 Q GMPLUSER
 ;
NARR(PRB) ; Returns problem narrative
 Q:'+$G(PRB) ""
 Q $P($G(^AUTNPOV(+PRB,0)),U)
PROTKEY(NAME) ;PROTOCOL IEN from name
 Q $O(^ORD(101,"B",NAME,0))
 ;
ENACT(KEY) ;PROTOCOL entry action
 Q $G(^ORD(101,KEY,20))
 ;
UPDITEM(KEY,ITEM,MN,NAME) ;Update protocol item details
 N DA,DR,DIE,X
 S DA=$O(^ORD(101,KEY,10,"B",ITEM,0)) Q:'DA
 S DR="2////"_MN_";6///^S X=NAME"
 S DIE="^ORD(101,"_KEY_",10,"
 D ^DIE
 Q
 ;
CONTEXT(LEXIEN) ;Returns concept displayable text
 Q $G(^LEX(757.01,LEXIEN,0))
 ;
PATDET(RETURN,DFN) ;RETURN PATIENT DETAILS
 Q:'+$G(DFN) 0
 N REC,ERT
 K RETURN
 D GETS^DIQ(2,DFN,".01;.351;.32201","IE","REC","ERT")
 S RETURN("NAME")=REC(2,DFN_",",.01,"I")_"^"_REC(2,DFN_",",.01,"E")
 S RETURN("DOD")=REC(2,DFN_",",.351,"I")_"^"_REC(2,DFN_",",.351,"E")
 S RETURN("PGSVC")=REC(2,DFN_",",.32201,"I")_"^"_REC(2,DFN_",",.32201,"E")
 Q 1
 ;
LEXINST() ;Is LEX package installed?
 Q $D(^LEX(757.01,0))
 ;
LDMSG(XMZ,MSG) ;Load message (MailMan)
 N NL
 M ^XMB(3.9,XMZ,2)=MSG
 S NL=$O(^XMB(3.9,XMZ,2,""),-1)
 S ^XMB(3.9,XMZ,2,0)="^3.92^"_+NL_U_+NL_U_DT
 Q
 ;
LISTPXRM(RETURN,ACTION) ;List ^PXRMINDX entries
 ;ACTION = 1 Return array of IEN's, otherwise return # of entries
 N CNT,DAT,IEN,PL,PRI,PT,STAT
 S CNT=0
 S RETURN=0
 S PT=0 F  S PT=$O(^PXRMINDX(9000011,"PSPI",PT)) Q:PT'>0  D
 .S STAT=""
 .F  S STAT=$O(^PXRMINDX(9000011,"PSPI",PT,STAT)) Q:STAT=""  D
 ..I '$D(^PXRMINDX(9000011,"PSPI",PT,STAT,0)) Q
 ..S PL=0
 ..F  S PL=$O(^PXRMINDX(9000011,"PSPI",PT,STAT,0,PL)) Q:PL'>0  D
 ...S DAT=0
 ...F  S DAT=$O(^PXRMINDX(9000011,"PSPI",PT,STAT,0,PL,DAT)) Q:DAT'>0  D
 ....S IEN=0
 ....F  S IEN=$O(^PXRMINDX(9000011,"PSPI",PT,STAT,0,PL,DAT,IEN)) Q:IEN'>0  D
 .....S CNT=CNT+1
 .....I ACTION=1 S RETURN(CNT)=IEN
 S RETURN=CNT
 Q
 ;
SVCCHLD(SVC,LIST) ;Return children
 N J
 K LIST
 S LIST=0
 Q:'$D(^DIC(49,"ACHLD",SVC))
 F J=0:0 S J=$O(^DIC(49,"ACHLD",SVC,J)) Q:J'>0  D
 . S LIST(J)=$P($G(^DIC(49,J,0)),U)
 Q
 ;
SVCLIST(LIST,TYPE) ;Get list of services
 N IEN,CNT
 K LIST
 S LIST=0
 F IEN=0:0 S IEN=$O(^DIC(49,"F",TYPE,IEN)) Q:IEN'>0  D
 . S LIST(IEN)=$P($G(^DIC(49,IEN,0)),U)
 . S LIST=LIST+1
 Q
 ;
SVCDET(RETURN,IEN) ;Service detail
 K RETURN
 S RETURN("NAME")=$P($G(^DIC(49,IEN,0)),U)
 S RETURN("PARENT")=+$P($G(^DIC(49,IEN,0)),U,4)
 S RETURN("TYPE")=+$P($G(^DIC(49,IEN,0)),U,9)
 Q
 ;
CLINLST(LIST) ;List clinics
 N IFN
 K LIST
 S LIST=0
 F IFN=0:0 S IFN=$O(^SC(IFN)) Q:IFN'>0  D
 . S LIST(IFN)=$P($G(^SC(IFN,0)),U)
 . S LIST=LIST+1
 Q
 ;
CLINDET(RETURN,IEN) ;Clinic details
 N NODE
 K RETURN
 S NODE=$G(^SC(IEN,0))
 S RETURN("NAME")=$P(NODE,U)
 S RETURN("TYPE")=$P(NODE,U,3)
 Q
 ;
