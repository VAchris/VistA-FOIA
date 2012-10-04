GMPLX1 ; SLC/MKB/KER -- Problem List Person Utilities ;09/14/12
 ;;2.0;Problem List;**3,26,35,260002**;Aug 25, 1994
 ;
 ; External References
 ;   DBIA   348  ^DPT(
 ;   DBIA  3106  ^DIC(49
 ;   DBIA   872  ^ORD(101
 ;   DBIA 10060  ^VA(200
 ;   DBIA 10062  7^VADPT
 ;   DBIA 10062  DEM^VADPT
 ;   DBIA  2716  $$GETSTAT^DGMSTAPI
 ;   DBIA  3457  $$GETCUR^DGNTAPI
 ;   DBIA 10104  $$REPEAT^XLFSTR
 ;   DBIA 10006  ^DIC
 ;   DBIA 10018  ^DIE
 ;   DBIA 10026  ^DIR
 ;
PAT() ; Select patient -- returns DFN^NAME^BID
 N DIC,X,Y,DFN,VADM,VA,PAT
P1 S DIC="^AUPNPAT(",DIC(0)="AEQM" D ^DIC I +Y<1 Q -1
 I $P(Y,U,2)'=$$PATNAME^GMPLEXT(+Y) W $C(7),!!,"ERROR -- Please check your Patient Files #2 and #9000001 for inconsistencies.",! G P1
 S DFN=+Y,PAT=Y D DEM^VADPT
 S PAT=PAT_U_$E($P(PAT,U,2))_VA("BID"),AUPNSEX=$P(VADM(5),U)
 I VADM(6) S PAT=PAT_U_+VADM(6) ; date of death
 Q PAT
 ;          
VADPT(DFN) ; Get Service/Elig Flags
 ;          
 ; Returns = 1/0/"" if Y/N/unknown
 ;   GMPSC     Service Connected
 ;   GMPAGTOR  Agent Orange Exposure
 ;   GMPION    Ionizing Radiation Exposure
 ;   GMPGULF   Persian Gulf Exposure
 ;   GMPMST    Military Sexual Trauma
 ;   GMPHNC    Head and/or Neck Cancer
 ;   GMPCV     Combat Veteran
 ;   GMPSHD    Shipboard Hazard and Defense
 ;          
 N VAEL,VASV,VAERR,HNC,X,PD,% D 7^VADPT S GMPSC=VAEL(3),GMPAGTOR=VASV(2)
 S GMPION=VASV(3)
 S %=$$PATDET^GMPLEXT(.PD,DFN)
 S X=$P($G(PD("PGSVC")),U),GMPGULF=$S(X="Y":1,X="N":0,1:"")
 S GMPCV=0 I +$G(VASV(10)) S:DT'>$P($G(VASV(10,1)),U) GMPCV=1  ;CV
 S GMPSHD=+$G(VASV(14,1))  ;SHAD
 S X=$P($$GETSTAT^DGMSTAPI(DFN),"^",2),GMPMST=$S(X="Y":1,X="N":0,1:"")
 S X=$$GETCUR^DGNTAPI(DFN,"HNC"),X=+($G(HNC("STAT"))),GMPHNC=$S(X=4:1,X=5:1,X=1:0,X=6:0,1:"")
 Q
SCS(PROB,SC) ; Get Exposure/Conditions Strings
 ;                 
 ;   Input     PROB  Pointer to Problem #9000011
 ;               
 ;   Returns   SC Array passed by reference
 ;             SC(1)="AO/IR/EC/HNC/MST/CV/SHD"
 ;             SC(2)="A/I/E/H/M/C/S"
 ;             SC(3)="AIEHMCS"
 ;                     
 ;   NOTE:  Military Sexual Trauma (MST) is suppressed
 ;          if the current device is a printer.
 ;                     
 N DA,FL,AO,IR,EC,HNC,MST,PTR,%,PRB
 S DA=+($G(PROB)) Q:+DA=0
 S %=$$DETAIL^GMPLAPI2(.PRB,DA)
 S AO=+($P(PRB(1.11),U)),IR=+($P(PRB(1.12),U))
 S EC=+($P(PRB(1.13),U)),HNC=+($P(PRB(1.15),U)),MST=+($P(PRB(1.16),U))
 S CV=+($P(PRB(1.17),U)),SHD=+($P(PRB(1.18),U))
 S PTR=$$PTR^GMPLUTL4
 I +AO>0 D
 . S:$G(SC(1))'["AO" SC(1)=$G(SC(1))_"/AO" S:$G(SC(2))'["A" SC(2)=$G(SC(2))_"/A" S:$G(SC(3))'["A" SC(3)=$G(SC(3))_"A"
 I +IR>0 D
 . S:$G(SC(1))'["IR" SC(1)=$G(SC(1))_"/IR" S:$G(SC(2))'["I" SC(2)=$G(SC(2))_"/I" S:$G(SC(3))'["I" SC(3)=$G(SC(3))_"I"
 I +EC>0 D
 . S:$G(SC(1))'["EC" SC(1)=$G(SC(1))_"/EC" S:$G(SC(2))'["E" SC(2)=$G(SC(2))_"/E" S:$G(SC(3))'["E" SC(3)=$G(SC(3))_"E"
 I +HNC>0 D
 . S:$G(SC(1))'["HNC" SC(1)=$G(SC(1))_"/HNC" S:$G(SC(2))'["H" SC(2)=$G(SC(2))_"/H" S:$G(SC(3))'["H" SC(3)=$G(SC(3))_"H"
 I +MST>0 D
 . S:$G(SC(1))'["MST" SC(1)=$G(SC(1))_"/MST" S:$G(SC(2))'["M" SC(2)=$G(SC(2))_"/M" S:$G(SC(3))'["M" SC(3)=$G(SC(3))_"M"
 I +CV>0 D
 . S:$G(SC(1))'["CV" SC(1)=$G(SC(1))_"/CV" S:$G(SC(2))'["C" SC(2)=$G(SC(2))_"/C" S:$G(SC(3))'["C" SC(3)=$G(SC(3))_"C"
 I +PTR'>0 D
 . I +SHD>0 S:$G(SC(1))'["SHD" SC(1)=$G(SC(1))_"/SHD" S:$G(SC(2))'["D" SC(2)=$G(SC(2))_"/S" S:$G(SC(3))'["S" SC(3)=$G(SC(3))_"S"
 S:$D(SC(1)) SC(1)=$$RS(SC(1)) S:$D(SC(2)) SC(2)=$$RS(SC(2))
 Q
SCCOND(DFN,SC) ; Get Service/Elig Flags (array)
 ; Returns local array .SC passed by value
 N HNC,VAEL,VASV,VAERR,X,PD,% D 7^VADPT
 S SC("DFN")=$G(DFN),SC("SC")=$P(VAEL(3),"^",1)
 S SC("AO")=$P(VASV(2),"^",1)
 S SC("IR")=$P(VASV(3),"^",1)
 S %=$$PATDET^GMPLEXT(.PD,DFN)
 S X=$P($G(PD("PGSVC")),U),SC("PG")=$S(X="Y":1,X="N":0,1:"")
 S SC("CV")=0 I +$G(VASV(10)) S:DT'>$P($G(VASV(10,1)),U) SC("CV")=1  ;CV
 S SC("SHD")=+$G(VASV(14,1))  ;SHAD
 S X=$P($$GETSTAT^DGMSTAPI(DFN),"^",2),SC("MST")=$S(X="Y":1,X="N":0,1:"")
 S X=$$GETCUR^DGNTAPI(DFN,"HNC"),X=+($G(HNC("STAT"))),SC("HNC")=$S(X=4:1,X=5:1,X=1:0,X=6:0,1:"")
 Q
 ;
CKDEAD(DATE) ; Dead patient ... continue?  Returns 1 if YES, 0 otherwise
 N DIR,X,Y S DIR(0)="YA",DIR("B")="NO"
 S DIR("A")="Are you sure you want to continue? "
 S DIR("?",1)="   Enter YES to continue and add new problem(s) for this patient:",DIR("?")="   press <return> to select another action."
 W $C(7),!!,"DATE OF DEATH: "_$$EXTDT^GMPLX(DATE)
 D ^DIR
 Q +Y
 ;
REQPROV() ; Returns requesting provider
 N DIR,X,Y
 I $D(GMPLUSER) S Y=DUZ_U_$$PROVNAME^GMPLEXT(DUZ) Q Y
 S DIR("?")="Enter the name of the provider responsible for this data."
 S DIR(0)="PA^200:AEQM",DIR("A")="Provider: "
 S:$G(GMPROV) DIR("B")=$P(GMPROV,U,2) W ! D ^DIR
 I $D(DUOUT)!($D(DTOUT))!(+Y'>0) Q -1
 Q Y
 ;
NAME(USER) ; Formats user name into "Lastname,F"
 N NAME,LAST,FIRST
 S NAME=$$PROVNAME^GMPLEXT(+USER) I '$L(NAME) Q ""
 S LAST=$P(NAME,","),FIRST=$P(NAME,",",2)
 S:$E(FIRST)=" " FIRST=$E(FIRST,2,99)
 Q $E(LAST,1,15)_","_$E(FIRST)
 ;
SERV(X) ; Return service name abbreviation
 N NAME,ABBREV
 S NAME=$$SVCNAME^GMPLEXT(+X)
 I NAME="" Q ""
 S ABBREV=$$SVCABBV^GMPLEXT(+X)
 I ABBREV="" S ABBREV=$E($P(NAME,U),1,4)
 Q ABBREV_"/"
 ;
CLINIC(LAST) ; Returns clinic from file #44
 N X,Y,DIC,DIR S Y="" G:$E(GMPLVIEW("VIEW"))="S" CLINQ
 S DIR(0)="FAO^1:30",DIR("A")="Clinic: " S:$L(LAST) DIR("B")=$P(LAST,U,2)
 S DIR("?")="Enter the clinic to be associated with these problems, if available"
 S DIR("??")="^D LISTCLIN^GMPLMGR1 W !,DIR(""?"")_""."""
CLIN1 ; Ask Clinic
 D ^DIR S:$D(DUOUT)!($D(DTOUT)) Y="^" S:Y="@" Y="" G:("^"[Y) CLINQ
 S DIC="^SC(",DIC(0)="EMQ",DIC("S")="I $P(^(0),U,3)=""C"""
 D ^DIC I Y'>0 W !?5,"Only clinics are allowed!",! G CLIN1
CLINQ ; Quit Asking
 Q Y
 ;
VOCAB() ; Select search vocabulary
 N DIR,X,Y S DIR(0)="SAOM^N:NURSING;I:IMMUNOLOGIC;D:DENTAL;S:SOCIAL WORK;P:GENERAL PROBLEM"
 S DIR("A")="Select Specialty Subset: ",DIR("B")="GENERAL PROBLEM"
 S DIR("?",1)="Because many discipline-specific terms are synonyms to other terms,"
 S DIR("?",2)="they are not accessible unless you specify the appropriate subset of the"
 S DIR("?",3)="Clinical Lexicon to select from.  Choose from:  Nursing"
 S DIR("?",4)=$$REPEAT^XLFSTR(" ",48)_"Immunologic"
 S DIR("?",5)=$$REPEAT^XLFSTR(" ",48)_"Dental"
 S DIR("?",6)=$$REPEAT^XLFSTR(" ",48)_"Social Work"
 S DIR("?")=$$REPEAT^XLFSTR(" ",48)_"General Problem"
 D ^DIR S X=$S(Y="N":"NUR",Y="I":"IMM",Y="D":"DEN",Y="S":"SOC",Y="P":"PL1",1:"^")
 Q X
 ;
PARAMS ; Edit pkg parameters in file #125.99
 N OLDVERFY,VERFY,BLANK,MN,NAME
 S BLANK="       "
 S OLDVERFY=$$PARMS() Q:'OLDVERFY
 S DA(1)=$$PROTKEY^GMPLEXT("GMPL PROBLEM LIST") Q:'DA(1)
 S VERFY=$$PROTKEY^GMPLEXT("GMPL VERIFY") W "."
 S MN=$S(OLDVERFY:"@",1:"$")
 S NAME=$S(OLDVERFY:BLANK,1:"@")
 W "."
 D UPDITEM^GMPLEXT(DA(1),VERFY,MN,NAME)
 W "."
 Q
 ;
PARMS() ;
 N IND,OLDPAR,NEWPAR,RETURN,CHOICES,QUIT,SELVAL,SU
 N DIRTY,VERIFYC
 S CHOICES=",VER,PRT,CLU,REV,SDP,"
 S IND="",QUIT=0,DIRTY=0,VERIFYC=0
 S %=$$GETPAR^GMPLSITE(.OLDPAR)
 F IND=1:1:5 Q:QUIT>0  D
 . S PARAM=$P(CHOICES,",",IND+1)
 . S SELVAL=$$SELPAR^GMPLEDT5(PARAM,OLDPAR(PARAM))
 . I SELVAL?."^" S QUIT=1 Q
 . I SELVAL=OLDPAR(PARAM) Q
 . E  S:PARAM="VER" VERIFYC=1
 . S DIRTY=1
 . S NEWPAR(PARAM)=SELVAL
 Q:DIRTY'>0 0
 S SU=$$SET^GMPLSITE(.RETURN,.NEWPAR)
 I SU=0 W !,RETURN(1)
 Q VERIFYC
 ;
RS(X) ; Remove Slashes
 S X=$G(X) F  Q:$E(X,1)'="/"  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'="/"  S X=$E(X,1,($L(X)-1))
 Q X
 ;
FMTNAME(NAME) ; Formats name into "Lastname,F"
 N LAST,FIRST
 Q:$G(NAME)="" ""
 S LAST=$P(NAME,","),FIRST=$P(NAME,",",2)
 S:$E(FIRST)=" " FIRST=$E(FIRST,2,99)
 Q $E(LAST,1,15)_","_$E(FIRST)
