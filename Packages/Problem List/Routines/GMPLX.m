GMPLX ; SLC/MKB/AJB -- Problem List Problem Utilities ;09/14/12
 ;;2.0;Problem List;**7,23,26,28,27,260002**;Aug 25, 1994
 ;
 ; External References
 ;   DBIA   446  ^AUTNPOV(
 ;   DBIA 10082  ^ICD9("BA"
 ;   DBIA 10060  ^VA(200
 ;   DBIA 10006  ^DIC
 ;   DBIA 10009  FILE^DICN
 ;   DBIA 10013  EN^DIK
 ;   DBIA 10013  IX1^DIK
 ;   DBIA 10026  ^DIR
 ;   DBIA  1609  CONFIG^LEXSET
 ;   DBIA 10103  $$FMTE^XLFDT
 ;   DBIA 10104  $$UP^XLFSTR
 ;   DBIA  2742  GMPLX
 ;   DBIA  3991  $$STATCHK^ICDAPIU
 ;
SEARCH(X,Y,PROMPT,UNRES,VIEW) ; Search Lexicon for Problem X
 N DIC
 S:'$L($G(VIEW)) VIEW="PL1"
 D CONFIG^LEXSET("GMPL",VIEW,DT)
 S DIC("A")=$S($L($G(PROMPT)):PROMPT,1:"Select PROBLEM: ")
 S DIC="^LEX(757.01,",DIC(0)=$S('$L($G(X)):"A",1:"")_"EQM"
 S:'$G(UNRES) LEXUN=0 D ^DIC S:+Y>1 X=$P(Y,U,2)
 Q
 ;
PROBTEXT(IFN) ; Returns Display Text
 N X,Y,GMPLEXP,GMPLPOV,GMPLSO,GMPLTXT,%,PRB
 S %=$$DETAIL^GMPLAPI2(.PRB,+IFN)
 S Y=$P($G(PRB(.05)),U),X=$P($G(PRB(.05)),U,2)
 S GMPLEXP=$$EP(IFN),GMPLSO=$$CS(X),GMPLPOV=$$PT(X,GMPLSO)
 S GMPLTXT=GMPLPOV S:$L(GMPLEXP) GMPLTXT=GMPLTXT_" ("_GMPLEXP_")"
 S:$L(GMPLSO) GMPLTXT=GMPLTXT_" "_GMPLSO
 S:GMPLTXT["*" GMPLTXT=$TR(GMPLTXT,"*","")
 ;S:$L(GMPLTXT) GMPLTXT=GMPLTXT_" ("_$$HFP^GMPLUTL4_","_$$PTR^GMPLUTL4_")"
 S:$L(GMPLTXT) X=GMPLTXT Q X
CS(X) ; Problem Codes
 N GMPLSAB,GMPLSO S GMPLSO="" S X=$G(X) Q:X'["(" ""
 F GMPLSAB="ICD-","CPT-","DSM-","HCPCS","NANDA","NIC","NOC","LOINC","SNOMED","OMAHA" S:$G(X)[("("_GMPLSAB) GMPLSO="("_GMPLSAB_$P(X,("("_GMPLSAB),2,299) Q:$L(GMPLSO)
 I $L(GMPLSO) S X=GMPLSO Q X
 F GMPLSAB="ACR","AI/RHEUM","CONGRESS","COSTAR","COSTART","CRISP","DODFAC" S:$G(X)[("("_GMPLSAB) GMPLSO="("_GMPLSAB_$P(X,("("_GMPLSAB),2,299) Q:$L(GMPLSO)
 I $L(GMPLSO) S X=GMPLSO Q X
 F GMPLSAB="DORLAND","DXPLAIN","HHCC","MCMASTER","META","MTF","MeSH","RVC","TITLE 38","UMDNS","UWA" S:$G(X)[("("_GMPLSAB) GMPLSO="("_GMPLSAB_$P(X,("("_GMPLSAB),2,299) Q:$L(GMPLSO)
 I $L(GMPLSO) S X=GMPLSO Q X
 Q ""
EP(X) ; Exposures
 N GMPLSC S X=+($G(X)) D SCS^GMPLX1(+X,.GMPLSC) S X=$G(GMPLSC(1)) Q X
PT(X,C) ; Problem Text (only)
 N GMPLTERM,GMPLSO S GMPLTERM=$G(X),GMPLSO=$G(C)
 S:$L(GMPLSO)&(GMPLTERM[GMPLSO) GMPLTERM=$P(GMPLTERM,GMPLSO,1) S GMPLTERM=$$TRIM(GMPLTERM)
 S:$L(GMPLTERM) X=GMPLTERM Q X
TRIM(X) ; Trim Spaces and "*"
 S X=$G(X) F  Q:$E(X,$L(X))'=" "  S X=$E(X,1,($L(X)-1))
 F  Q:$E(X,$L(X))'="*"  S X=$E(X,1,($L(X)-1))
 F  Q:$E(X,$L(X))'=" "  S X=$E(X,1,($L(X)-1))
 F  Q:$E(X,1)'=" "  S X=$E(X,2,$L(X))
 Q X
WRAP(PROB,MAX,TEXT) ; Splits Text into TEXT array
 N I,J S J=0 K TEXT I $L(PROB)'>MAX S J=J+1,TEXT(J)=PROB G WRQ
WR0 ;   Loop for Remaining Text
 S I=$F(PROB," ") I ('I)!(I>(MAX+2)) S J=J+1,TEXT(J)=$E(PROB,1,MAX),PROB=$E(PROB,MAX+1,999)
 I $L(PROB)>MAX F I=(MAX+1):-1:1 I $E(PROB,I)=" " S J=J+1,TEXT(J)=$E(PROB,1,I-1),PROB=$E(PROB,I+1,999) Q
 G:$L(PROB)>MAX WR0
 S:$L(PROB) J=J+1,TEXT(J)=PROB
WRQ ;   Quit Wrap
 S TEXT=J
 Q
 ;
SEL(HELP) ; Select List of Problems
 N X,Y,DIR,MAX S MAX=+$G(^TMP("GMPL",$J,0)) I MAX'>0 Q "^"
 S DIR(0)="LAO^1:"_MAX,DIR("A")="Select Problem(s)"
 S:MAX>1 DIR("A")=DIR("A")_" (1-"_MAX_"): "
 S:MAX'>1 DIR("A")=DIR("A")_": ",DIR("B")=1
 S DIR("?")="Enter the problems you wish to "
 S DIR("?")=DIR("?")_$S($L(HELP):HELP,1:"act on")_", as a range or list of numbers"
 D ^DIR I $D(DTOUT)!(X="") S Y="^"
 Q Y
 ;
SEL1(HELP) ; Select 1 Problem
 N X,Y,DIR,MAX S MAX=+$G(^TMP("GMPL",$J,0)) I MAX'>0 Q "^"
 S DIR(0)="NAO^1:"_MAX_":0",DIR("A")="Select Problem"
 S:MAX>1 DIR("A")=DIR("A")_" (1-"_MAX_"): "
 S:MAX'>1 DIR("A")=DIR("A")_": ",DIR("B")=1
 S DIR("?")="Enter the number of the problem you wish to "
 S DIR("?")=DIR("?")_$S($L(HELP):HELP,1:"act on")
 D ^DIR I $D(DTOUT)!(X="") S Y="^"
 Q Y
 ;
DUPLOK(IFN) ; Ask to Duplicate Problem
 N DIR,X,Y,DATE,PRB,%,PROV
 S DIR(0)="YA"
 S %=$$DETAIL^GMPLAPI2(.PRB,IFN)
 S DIR("A")="Are you sure you want to continue? ",DIR("B")="NO"
 S DIR("?",1)="Enter YES if you want to duplicate this problem on this patient's list;",DIR("?")="press <return> to re-enter the problem name."
 W $C(7),!!,">>>  "_$$PROBTEXT(IFN),!?5,"is already an "
 W $S($P(PRB(.12),U)="I":"IN",1:"")_"ACTIVE problem on this patient's list!",!
 S PROV=+PRB(1.05) W:PROV !?5,"Provider: "_$P(PRB(1.05),U,2)_" ("_$P($$SERVICE^GMPLEXT(PROV),U,2)_")"
 I $P(PRB(.12),U)="A" W !?8,"Onset: " S DATE=$P(PRB(.13),U)
 I $P(PRB(.12),U)="I" W !?5,"Resolved: " S DATE=$P(PRB(1.07),U)
 W $S(DATE>0:$$FMTE^XLFDT(DATE),1:"unspecified"),!
 D ^DIR W !
 Q +Y
 ;
LOCKED() ; Returns Message that Problem is Locked
 Q "This problem is currently being edited by another user!"
 ;
SURE() ; Ask to Delete 
 ;   Returns 1 if YES, else 0
 N DIR,X,Y S DIR(0)="YA",DIR("B")="NO"
 S DIR("?")="Enter YES to remove this value or NO to leave it unchanged."
 S DIR("A")="Are you sure you want to remove this value? " D ^DIR
 Q +Y
 ;
EXTDT(DATE) ; Formats Date into MM/DD/YY
 N X,MM,DD,YY,YYY S X="",DATE=$P(DATE,".") Q:'DATE ""
 S MM=+$E(DATE,4,5),DD=+$E(DATE,6,7),YY=$E(DATE,2,3),YYY=$E(DATE,1,3)
 S:MM X=MM_"/" S:DD X=X_DD_"/" S X=$S($L(X):X_YY,1:1700+YYY)
 Q X
 ;
MSG() ; List Manager Message Bar
 Q "+ Next Screen  - Prev Screen  ?? More actions"
 ;
KILL ; Clean-Up Variables
 K X,Y,DIC,DIE,DR,DA,DUOUT,DTOUT,GMPQUIT,GMPRT,GMPSAVED,GMPIFN,GMPLNO,GMPLNUM,GMPLSEL,GMPREBLD,GMPI,GMPLSLST,GMPLJUMP
 Q
 ;
CODESTS(PROB,ADATE) ;check status of code associated with a problem
 ; Input:
 ;    PROB  = pointer to the PROBLEM (#9000011) file
 ;    ADATE = FM date on which to check the status of ICD9 code  (opt.) 
 ;
 ; Output:
 ;   1  = ACTIVE on the date passed or current date if not passed
 ;   0  = INACTIVE on the date passed or current date if not passed
 ;
 N %,RET
 S %=$$CODESTS^GMPLAPI2(.RET,PROB,ADATE)
 Q RET
