SDCNP ;ALB/LDB - CANCEL SINGLE OR MULTIPLE APPOINTMENTS FOR PATIENT ; 10/18/2012
 ;;5.3;Scheduling;**32,116,478,260003**;Aug 13, 1993
 K ORACTION
RD G END:$D(ORACTION)!($D(SDAMTYP)) 
 N ROU,PRMPT,FILE,FIELDS,FLDOR
 S Y=$$SELECT^SDMUTL("Patient")
 I Y<0 W !,*7,*7,"PATIENT NOT FOUND",*7,*7 G RD
 S (DA,DFN)=+Y,NAME=$P(Y,"^",2)
EN D DT^SDUTL:'$D(DT) S HDT=DT,APL="" D NOW^%DTC S (SDTM,HDT)=$J(%,".",4),(SDERR,CNT)=0
SEL R !,"DO YOU WANT TO CANCEL (P)AST OR (F)UTURE APPOINTMENTS? F// ",X9:DTIME G:X9["^"!('$T) END S:X9="" X9="F" S X9=$$UP^XLFSTR(X9) I "FP"'[X9!(X9["?") W !,"Enter a P to cancel past appointments or F to cancel future appointments" G SEL
 S SDPV=$S(X9=""!(X9["F"):"",1:1)
 N APTS,SDT
 S SDT=$P(SDTM,"."),SDT(0)=$S(SDPV="":1,1:0)
 S %=$$GETAPTS^SDMAPI1(.APTS,DFN,.SDT)
 S SDERR=0 W ! I '$D(APTS) G NO^SDCNP0
STAT R !,"APPOINTMENTS CANCELLED BY (P)ATIENT OR BY (C)LINIC? P// ",SDWH:DTIME G:SDWH="^"!('$T) END S SDWH=$$UP^XLFSTR(SDWH) I SDWH'="",SDWH'["P",SDWH'["C" W !,"Enter a P for by Patient or a C for by Clinic" G STAT
 S SDWH=$S(SDWH["P":"PC",SDWH="":"PC",1:"C"),SDCP=$S(SDWH="C":0,1:1)
RSN ;
 S SDSCRPC=$S(SDWH["P":"P",1:"C")
 S SDSCR=$$GETRSN(SDSCRPC)
REM R !,"CANCELLATION REMARKS: ",SDREM:DTIME G:SDREM["^"!('$T) END G:SDREM="" W  ;SD/478
 S TMPD=SDREM ;SD/478
 I $L(SDREM)<3!($L(SDREM)>160)!(SDREM?."?") W !,*7,"Must be 3 to 160 characters in length" G REM
 I SDREM'?.ANP W !,*7,"NO CONTROL CHARACTERS" G REM
W K Z,Z1,ZX W !!,"READY TO CANCEL ",$S('SDPV:"PENDING",1:"PREVIOUS")," APPTS",!
DATE I SDPV S %DT="AEXP",%DT("A")="DISPLAY APPTS STARTING WITH DATE: FIRST// " S %DT(0)="-NOW" D ^%DT G:X["^" END S HDT=$S(Y>0:Y,1:0) K %DT
 G ^SDCNP0
END D END^SDAUT2 K %,%DT,%H,%I,%Y,A,A1,A2,A8,A9,B,ADDR,DTOUT,ANS,APL,APP,APPZ,AT,CNT,C,CDATE,CHAR,CLIN,CNN,COMMENT,COV,D0,DA,DATE,DGPGM,DGVAR,DI,DIC,DIE,DIPGM,DIV,DK,DL,DOW,DR,DUPE,ENDATE,GDATE,HDT,HSI,I,J,L,L1,L5,LL,NAME,NDT,NDATE,M1,M8,MAX
 K PDAT,POP,Q,Q1,S,S1,S2,S3,S5,S9,SD0,SD2,SB,SC,SD,SDA,SDAP,SD1,SDCL,SDCP,SDCNT,SDCNT1,SDCTR,SDCTRL,SDDH,SDDI,SDDIF,SDDK,SDDM,SDDT,SDDT1,SDEND,SDERR,SDFOR,SDINP,SDIO,SDJ,SDJ1,SDLET,SDLN,SDLN1,SDLN2,SDMSG,SDMDT,SDNODE,SDP,SDP1,SDPV,SDPT,SDPRT,SDR
 K A0,A1,A3,A5,ALL,SDREM,SDS,SDRT,SDTADE,SDTADB,SDPRT,SDSCR,SDSOH,SDA,SDT,SDTH,SDT1,SDTTM,SDX,SDX1,SDV,SDV2,SL,SM,STARTDAY,STIME,STR,TIME,SDTM,SDWH,SDXX,X1,X3,X8,X9,SI,SS,ST,SDSTRTDT,X,Y,Z,Z0,Z1,Z5,Z6,Z7,Z9,ZL,ZX,^UTILITY($J)
 K MESS,MIN,DIW,DIWF,DIWL,DIWR,DIWT,DN,DQ,L0,SDADD,SDC,SDDAT,SDHX,SDT0,SD20,TST,TMPD Q
OERR S XQORQUIT=1 Q:'$D(ORVP)  S (DA,DFN)=+ORVP,NAME=$S($D(^DPT(DFN,0)):$P(^(0),"^",1),1:"") D EN N PAUSE W !,"Press Return to continue: " R PAUSE:DTIME K PAUSE Q
GETRSN(SDSCRPC) ;
GETRSN1 ;
 N ROU,PRMPT,FILE,FIELDS,FLDOR
 S ROU="LSTCRSNS^SDMLST",PRMPT="Select CANCELLATION REASONS NAME: "
 S FILE="CANCELLATION REASON"
 S LSTS("TYPE")=SDSCRPC
 S Y=$$SELECT^SDMUTL(ROU,PRMPT,FILE)
 G:Y=0 GETRSN1
 Q Y
 ;
