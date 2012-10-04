GMPLUTL2 ; SLC/MKB/KER -- PL Utilities (OE/TIU)             ; 09/13/12
 ;;2.0;Problem List;**10,18,21,26,35,260002**;Aug 25, 1994
 ; External References
 ;   DBIA   348  ^DPT(  file #2
 ;   DBIA 10082  ^ICD9(  file #80
 ;   DBIA 10040  ^SC(  file #44
 ;   DBIA 10060  ^VA(200
 ;   DBIA  2716  $$GETSTAT^DGMSTAPI
 ;   DBIA  3457  $$GETCUR^DGNTAPI
 ;   DBIA 10062  7^VADPT
 ;   DBIA 10062  DEM^VADPT
 ;   DBIA 10118  EN^VALM
 ;   DBIA 10116  CLEAR^VALM1
 ;   DBIA 10103  $$HTFM^XLFDT
LIST(GMPL,GMPDFN,GMPSTAT,GMPCOMM) ; Returns list of Prob for Pt.           
 ;   Input   GMPDFN  Pointer to Patient file #2
 ;           GMPCOMP Display Comments 1/0
 ;           GMTSTAT Status A/I/""
 ;   Output  GMPL    Array, passed by reference
 ;           GMPL(#)
 ;             Piece 1:  Pointer to Problem #9000011
 ;                   2:  Status 
 ;                   3:  Description
 ;                   4:  ICD-9 code
 ;                   5:  Date of Onset
 ;                   6:  Date Last Modified
 ;                   7:  Service Connected
 ;                   8:  Special Exposures
 ;           GMPL(#,C#)  Comments
 ;           GMPL(0)     Number of Problems Returned
 N CNT,SCS,SP,ACT,TRAN,IFN,NCNT,NOTES
 D GET^GMPLSITE(.GMPARAM) S GMPARAM("QUIET")=1
 S %=$$LIST^GMPLAPI4(.GMPL,GMPDFN,GMPSTAT,0,"",GMPARAM("REV"))
 F CNT=1:1:GMPL(0) D
 . S IFN=$P(GMPL(CNT),U)
 . D SCS^GMPLX1(IFN,.SCS)
 . S SP=$G(SCS(3))
 . S ACT=$S($P(GMPL(CNT),U,14)="A":"*",1:"")
 . S TRAN=$S('GMPARAM("VER"):"",$P(GMPL(CNT),U,9)'="T":"",1:"$")
 . S GMPL(CNT)=$P(GMPL(CNT),U,1,7)_U_SP_U_ACT_U_TRAN
 . I $G(GMPCOMM) D
 . S %=$$NOTES^GMPLAPI3(.NOTES,IFN,0)
 . F NCNT=1:1:NOTES S GMPL(CNT,NCNT)=NOTES(NCNT)
 Q
 ;
DETAIL(IFN,GMPL) ; Returns Detailed Data for Problem
 ;                
 ; Input   IFN  Pointer to Problem file #9000011
 ;                
 ; Output  GMPL Array, passed by reference
 ;         GMPL("DATA NAME") = External Format of Value
 ;
 ;         GMPL("DIAGNOSIS")  ICD Code
 ;         GMPL("PATIENT")    Patient Name
 ;         GMPL("MODIFIED")   Date Last Modified
 ;         GMPL("NARRATIVE")  Provider Narrative 
 ;         GMPL("ENTERED")    Date Entered ^ Entered by
 ;         GMPL("STATUS")     Status
 ;         GMPL("PRIORITY")   Priority Acute/Chronic
 ;         GMPL("ONSET")      Date of Onset
 ;         GMPL("PROVIDER")   Responsible Provider
 ;         GMPL("RECORDED")   Date Recorded ^ Recorded by
 ;         GMPL("CLINIC")     Hospital Location
 ;         GMPL("SC")         Service Connected SC/NSC/""
 ;
 ;         GMPL("EXPOSURE") = #
 ;         GMPL("EXPOSURE",X)="AGENT ORANGE"
 ;         GMPL("EXPOSURE",X)="RADIATION"
 ;         GMPL("EXPOSURE",X)="ENV CONTAMINANTS"
 ;         GMPL("EXPOSURE",X)="HEAD AND/OR NECK CANCER"
 ;         GMPL("EXPOSURE",X)="MILITARY SEXUAL TRAUMA"
 ;         GMPL("EXPOSURE",X)="COMBAT VET"
 ;         GMPL("EXPOSURE",X)="SHAD"
 ;
 ;         GMPL("COMMENT") = #
 ;         GMPL("COMMENT",CNT) = Date ^ Author ^ Text of Note
 ;              
 N VALID
 S %=$$VALID^GMPLAPI4(.VALID,IFN)
 Q:'VALID
 S %=$$DETAILX^GMPLAPI2(.GMPL,IFN)
 K GMPL("HISTORY")
 D AUDIT
 Q
 ;
AUDIT ; 14 Sep 99 - MA - Add audit trail to OE Problem List.
 ; Called from DETAIL, requires IFN and sets GMPL("AUDIT")
 N IDT,RETURN
 S GMPL("AUDIT")=0
 D GETAUDIT^GMPLHIST(.RETURN,IFN)
 F IDT=0:0 S IDT=$O(RETURN(IDT)) Q:IDT'>0  D
 . S GMPL("AUDIT",IDT,0)=RETURN(IDT,0)
 . S:$D(RETURN(IDT,1)) GMPL("AUDIT",IDT,1)=RETURN(IDT,1)
 S GMPL("AUDIT")=RETURN
 Q
 ;
FLDNAME(NUM)    ; Returns field name for display
 N NAME,NM1,NM2,I,J S J=0,NAME=""
 S NM1=".01^.05^.12^.13^1.01^1.02^1.04^1.05^1.06^1.07^1.08^1.09^1.1^1.11^1.12^1.13^1.14^1.17^1.18^1101"
 F I=1:1:$L(NM1,U) I +$P(NM1,U,I)=+NUM S J=I Q
 G:J'>0 FNQ
 S NM2="DIAGNOSIS^PROVIDER NARRATIVE^STATUS^DATE OF ONSET^PROBLEM^CONDITION^RECORDING PROVIDER^RESPONSIBLE PROVIDER"
 S NM2=NM2_"^SERVICE^DATE RESOLVED^CLINIC^DATE RECORDED^SERVICE CONNECTED^AGENT ORANGE EXP^RADIATION EXP^ENV CONTAMINANTS EXP"
 S NM2=NM2_"^COMBAT VET^SHIPBOARD HAZARD EXP^PRIORITY^NOTE"
 S NAME=$P(NM2,U,J)
FNQ Q NAME
 ;
ADD(DFN,LOC,GMPROV) ; -- Interactive LMgr action to add new problem
 N X,Y,GMPDFN,GMPVA,GMPVAMC,GMPSC,GMPAGTOR,GMPION,GMPGULF,GMPHNC,GMPMST,GMPCV,GMPSHD
 N GMPARAM,GMPLVIEW,GMPLUSER,GMPCLIN,GMPLSLST,GMPQUIT,VALMCC,GMPSAVED
 Q:'DFN  Q:'LOC  D SETVARS
 S %=$$GETULST^GMPLAPI6(.RETURN,DUZ) S GMPLSLST=RETURN
 I 'GMPLSLST,GMPCLIN S %=$$GETCLST^GMPLAPI6(.RETURN,+GMPCLIN) S GMPLSLST=RETURN
 I GMPLSLST D  Q
 . D EN^VALM("GMPL LIST MENU")
 F  D ADD^GMPL1 Q:$D(GMPQUIT)  K DUOUT,DTOUT,GMPSAVED W !!,">>>  Please enter another problem, or press <return> to exit."
 Q
 ;
SETVARS ; -- Define GMP* variables used in ADD and EDIT
 N VA,VADM,VAEL,VASV,X,PD,%
 Q:'DFN  D DEM^VADPT,7^VADPT
 S GMPDFN=DFN_U_VADM(1)_U_$E(VADM(1))_VA("BID")_$S(VADM(6):U_+VADM(6),1:"")
 S AUPNSEX=$P(VADM(5),U),GMPVA=1,GMPSC=VAEL(3),GMPAGTOR=VASV(2),GMPION=VASV(3)
 S %=$$PATDET^GMPLEXT(.PD,DFN)
 S X=$P($G(PD("PGSVC")),U),GMPGULF=$S(X="Y":1,X="N":0,1:"")
 S GMPCV=0 I +$G(VASV(10)) S:DT'>$P($G(VASV(10,1)),U) GMPCV=1 ;CV
 S GMPSHD=+$G(VASV(14,1)) ;SHAD
 S X=$$GETCUR^DGNTAPI(DFN,"HNC"),X=+($G(HNC("STAT"))),GMPHNC=$S(X=4:1,X=5:1,X=1:0,X=6:0,1:"")
 S X=$P($$GETSTAT^DGMSTAPI(DFN),"^",2),GMPMST=$S(X="Y":1,X="N":0,1:"")
 S GMPLVIEW("VIEW")=$S($$LOCTYPE^GMPLEXT(+$G(LOC))="C":"C",1:"S")
 S GMPCLIN="" I $G(LOC),GMPLVIEW("VIEW")="C" S GMPCLIN=+LOC_U_$$CLINNAME^GMPLEXT(+LOC)
 D GET^GMPLSITE(.GMPARAM)
 S:+GMPROV=DUZ GMPLUSER=1 S GMPVAMC=+$G(DUZ(2)),GMPLIST(0)=0
 Q
 ;
EDIT(DFN,LOC,GMPROV,GMPIFN) ; Interactive LMgr action to edit a problem
 N GMPARAM,GMPDFN,GMPVA,GMPSC,GMPAGTOR,GMPION,GMPGULF,GMPHNC,GMPMST,GMPCV,GMPSHD
 N GMPLVIEW,GMPCLIN,GMPLJUMP,GMPQUIT,GMPLUSER,GMPLVAMC,AUPNSEX
 I '$$LOCK^GMPLDAL(GMPIFN,0) W $C(7),!!,$$LOCKED^GMPLX,! H 2 Q
 D SETVARS,EN^VALM("GMPL EDIT PROBLEM")
 D UNLOCK^GMPLDAL(GMPIFN,0)
 Q
 ;
REMOVE(GMPIFN,GMPROV,TEXT,PLY) ; -- Remove problem GMPIFN
 N GMPVAMC,CHANGE,VALID
 S GMPVAMC=+$G(DUZ(2)),PLY=-1,PLY(0)=""
 S %=$$VALID^GMPLAPI4(.VALID,GMPIFN)
 I 'VALID S PLY(0)="Invalid problem" Q
 I '$$PROVNAME^GMPLEXT(+$G(GMPROV),0) S PLY(0)="Invalid provider" Q
 S %=$$DELETE^GMPLAPI2(.PLY,GMPIFN,GMPROV,$G(TEXT))
 S:PLY PLY=GMPIFN
 Q
 ;
PARAM(GMPARAM) ; -- Returns parameter values from 125.99
 D GET^GMPLSITE(.GMPARAM)
 Q 1
 ;
VAF(DFN,SILENT) ; -- print PL VA Form chart copy
 ;
 N VA,VADM,VAERR,GMPDFN,GMPVAMC,GMPARAM,GMPRT,GMPQUIT,GMPLCURR
 Q:'$G(DFN)  D DEM^VADPT S GMPDFN=DFN_U_VADM(1)_U_$E(VADM(1))_VA("BID")
 S GMPVAMC=+$G(DUZ(2)),GMPARAM("QUIET")=1
 D PARAM(.GMPARAM)
 D VAF^GMPLPRNT I '$G(SILENT) D  Q:$G(GMPQUIT)
 . I GMPRT'>0 W !!,"No problems available." S GMPQUIT=1 Q
 . D DEVICE^GMPLPRNT Q:$G(GMPQUIT)  D CLEAR^VALM1
 D PRT^GMPLPRNT
 Q
