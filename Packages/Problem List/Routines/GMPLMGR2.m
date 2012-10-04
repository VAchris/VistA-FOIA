GMPLMGR2 ; SLC/MKB/KER/AJB -- Problem List VALM Utilities cont ; 09/14/12
 ;;2.0;Problem List;**26,28,260002**;Aug 25, 1994
 ;
 ; External References
 ;   DBIA 10082  ^ICD9(
 ;   DBIA   872  ^ORD(101
 ;   DBIA 10026  ^DIR
 ;   DBIA 10116  $$SETFLD^VALM1
 ;   DBIA 10116  CLEAR^VALM1
 ;   DBIA 10140  EN^XQORM
 ;                      
BLDPROB(IFN) ; Build Line for Problem in List
 ;   Input INF   Pointer to Problem file 9000011
 ;   Expects GMPCOUNT
 N GMPL,RESOLVED,TEXT,I,LINE,STR,SC,SP,ICD,ONSET,PROBLEM,STATUS,DELETED,ICDACTV
 Q:'$D(GMPCOUNT)
 S %=$$DETAILX^GMPLAPI2(.GMPL,IFN,"","")
 S DELETED=($E(GMPL("CONDITION"))="H")
 S STATUS=$E(GMPL("STATUS"))
 S PROBLEM=$S(DELETED:"< DELETED >",1:GMPL("NARRATIVE"))
 I 'DELETED,GMPL("ONSET") S PROBLEM=PROBLEM_", Onset "_GMPL("ONSET")
 S RESOLVED=GMPL("RESOLVED")
 S ICD=GMPL("DIAGNOSIS")
 S SC=GMPL("SC")
 S SP=$S(GMPL("EXPOSURE"):GMPL("EXPOSURE",1),1:"")
 S GMPCOUNT=GMPCOUNT+1
 D WRAP^GMPLX(PROBLEM,40,.TEXT)
 S LINE=$$SETFLD^VALM1(GMPCOUNT,"","NUMBER")
 S %=$$CODESTS^GMPLAPI2(.ICDACTV,IFN)
 I 'ICDACTV D
 . S:STATUS="A" LINE=$$SETFLD^VALM1(" #",LINE,"STATUS")
 . S:STATUS="I" LINE=$$SETFLD^VALM1(STATUS_"#",LINE,"STATUS")
 E  S:STATUS="I" LINE=$$SETFLD^VALM1(STATUS,LINE,"STATUS")
 S LINE=$$SETFLD^VALM1(TEXT(1),LINE,"PROBLEM")
 S LINE=$$SETFLD^VALM1(ICD,LINE,"ICD")
 S:$L(SC) LINE=$$SETFLD^VALM1(SC,LINE,"SERV CONNECTED")
 S:$L(SP) LINE=$$SETFLD^VALM1($$FMTSP(SP),LINE,"EXPOSURE")
 S LINE=$$SETFLD^VALM1(RESOLVED,LINE,"RESOLVED")
 S VALMCNT=VALMCNT+1
 S ^TMP("GMPL",$J,VALMCNT,0)=LINE
 S ^TMP("GMPLIDX",$J,GMPCOUNT)=VALMCNT_U_IFN
 I TEXT>1 F I=2:1:TEXT D
 . S LINE="",LINE=$$SETFLD^VALM1(TEXT(I),LINE,"PROBLEM")
 . S VALMCNT=VALMCNT+1,^TMP("GMPL",$J,VALMCNT,0)=LINE
 Q
 ;
HELP ; Help Code
 N X W !!?4,"You may take a variety of actions from this prompt.  To update"
 W !?4,"the problem list select from Add, Remove, Edit, Inactivate,"
 W !?4,"and Enter Comment; you will then be prompted for the problem"
 W !?4,"number.  To see all of this patient's problems, both active and"
 W !?4,"inactive, select Show All Problems; select Print to print the"
 W !?4,"same complete list in a chartable format.  To see a listing of"
 W !?4,"actions that facilitate navigating the list, enter '??'."
 W !!,"Press <return> to continue ... " R X:DTIME
 S VALMSG=$$MSG^GMPLX,VALMBCK=$S(VALMCC:"",1:"R")
 Q
 ;
EXIT ; Exit Code
 I GMPARAM("PRT"),$D(GMPRINT) D AUTO
 K ^TMP("GMPL",$J),^TMP("GMPLIDX",$J)
 K XQORM("KEY","="),XQORM("XLATE")
 K GMPDFN,GMPROV,GMPLVIEW,GMPARAM,VALMBCK,VALMHDR,VALMCNT,GMPCOUNT,GMPLUSER,GMPSC,VALMSG,GMPVAMC,GMPLIST,GMPAGTOR,GMPION,GMPGULF,GMPVA,GMPTOTAL,GMPRINT,AUPNSEX,GMPCLIN
 Q
 ;
AUTO ; Print Problem List when Exiting Patient?
 ;   Called from EXIT,NEWPAT^GMPLMGR1
 N DIR,X,Y Q:'GMPARAM("PRT")  Q:'$D(GMPRINT)
 S DIR(0)="YA",DIR("A")="Print a new problem list? ",DIR("B")="YES"
 S DIR("?",1)="Press <return> to generate a new complete problem list for this patient;",DIR("?")="enter NO to continue without printing."
 W $C(7),!!,">>>  THIS PATIENT'S PROBLEM LIST HAS CHANGED!"
 D ^DIR I $D(DTOUT)!($D(DTOUT)) S GMPQUIT=1 Q
 Q:'Y  D VAF^GMPLPRNT,DEVICE^GMPLPRNT G:$D(GMPQUIT) AUTQ
 D CLEAR^VALM1,PRT^GMPLPRNT
AUTQ ; Quit Auto-Print
 D KILL^GMPLX
 Q
 ;
SHOW ; Show Current View of List
 N VIEW,NUM,NAME S VIEW=$E(GMPLVIEW("VIEW")),NUM=$L(GMPLVIEW("VIEW"),"/")
 W !!,"CURRENT VIEW: "_$S(VIEW="S":"Inpatient, ",1:"Outpatient, ")
 I '((NUM>2)!($L(GMPLVIEW("ACT")))!(GMPLVIEW("PROV"))) W "all problems" Q
 W $S(GMPLVIEW("ACT")="A":"active",GMPLVIEW("ACT")="I":"inactive",1:"all")_" problems"
 I NUM>2 W " from "_$S(GMPLVIEW("VIEW")=$$USERVIEW^GMPLEXT(DUZ):"preferred",1:"selected")_$S(VIEW="S":" services",1:" clinics")
 I GMPLVIEW("PROV") S NAME=$$NAME^GMPLX1(GMPLVIEW("PROV")) W:($X+$L(NAME)+4>80) ! W " by "_NAME
 Q
 ;
ENVIEW ; Entry Action to Display Appropriate View Menu
 N XQORM,X,Y,GMPLX S GMPLX=0 D SHOW S X="GMPL VIEW "_$S($E(GMPLVIEW("VIEW"))="S":"INPAT",1:"OUTPAT")
 S XQORM=+$$PROTKEY^GMPLEXT(X)_";ORD(101,",XQORM(0)="3AD"
 W !,"You may change your view of this patient's problem list by selecting one or",!,"more of the following attributes to alter:",!
 D EN^XQORM F  S GMPLX=$O(Y(GMPLX)) Q:GMPLX'>0  X:$$ENACT^GMPLEXT(+$P(Y(GMPLX),U,2))'="" $$ENACT^GMPLEXT(+$P(Y(GMPLX),U,2))
 Q
 ;
EXVIEW ; Exit Action to Rebuild List w/New View
 S VALMBCK=$S(VALMCC:"",1:"R") I '$D(GMPQUIT),$G(GMPREBLD) D
 . S VALMBG=1,VALMBCK="R" D GETPLIST^GMPLMGR1(.GMPLIST,.GMPTOTAL,.GMPLVIEW)
 . D BUILD^GMPLMGR(.GMPLIST),HDR^GMPLMGR
 K GMPQUIT,GMPREBLD S VALMSG=$$MSG^GMPLX
 Q
 ;
FMTSP(STR) ; Formats SP for display
 Q:STR="AGENT ORANGE" "Agent Orange"
 Q:STR="RADIATION" "Radiation"
 Q:STR="ENV CONTAMINANTS" "Contaminants"
 Q:STR="HEAD/NECK CANCER" "Head/Neck Cancer"
 Q:STR="MIL SEXUAL TRAUMA" "Mil Sexual Trauma"
 Q ""
