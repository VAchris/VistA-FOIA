SDM1 ;SF/GFT - MAKE APPOINTMENT ; 09/27/2012  ; Compiled March 8, 2007 14:55:24  ; Compiled May 9, 2007 13:19:18  ; Compiled August 28, 2007 12:19:08
 ;;5.3;Scheduling;**32,167,168,80,223,263,273,408,327,478,490,446,547,260003**;Aug 13, 1993;Build 17
1 L  Q:$D(SDXXX)  S CCXN=0 K MXOK,COV,SDPROT Q:DFN<0  S SC=+SC
 S X1=DT S SDEDT=CLN("MAX # DAYS FOR FUTURE BOOKING")
 S:$L(SDEDT)'>0 SDEDT=365
 S X2=SDEDT D C^%DTC S SDEDT=X D WRT
 I $D(^SC(SC,"SI")),$O(^("SI",0))>0 W !,*7,?8,"**** SPECIAL INSTRUCTIONS ****",! S %I=0 F %=0:1 S %I=$O(^SC(SC,"SI",%I)) Q:%I'>0  W ^(%I,0) W:% ! I '%,$O(^SC(SC,"SI",%I))>0 S POP=0 D SPIN Q:POP
 G:SDMM RDTY^SDMM
 ;
ADT S:'$D(SDW) SDW=""
 S SDSOH=$S('$D(CLN("SCHEDULE ON HOLIDAYS?")):0,CLN("SCHEDULE ON HOLIDAYS?")']"":0,1:1),CCX=""
 S SDONCE=$G(SDONCE)+1  ;Prevent repetitive iteration
 ; Section introduced in 446.
 N SDDATE1,SDQT,Y  ; Do not allow progress if there is no availability > 120 days after the desired date.
 S SDDATE1=$S($G(SDDATE)="":DT,1:SDDATE)
 S Y="" D  Q:Y="^"
 .F  Q:Y="^"!$$WLCL120^SDM2A(SC,SDDATE1)  D
 ..S Y=$$WLCLASK^SDM2A() Q:Y="^"  ; Y=0: New date, Y=1: place on EWL, Y="^": quit
 ..I Y=0 D  Q
 ...N SDMAX,SDDMAX
 ...S SDMAX(1)=CLN("MAX # DAYS FOR FUTURE BOOKING") S:SDMAX(1)']"" SDMAX(1)=365
 ...S (SDMAX,SDDMAX)=$$FMADD^XLFDT(DT,SDMAX(1))
 ...S Y=$$DDATE^SDM0(.SDDATE,"0^0",.SDMAX) Q:'Y  ; Y=0: "^" entered, Y=1: date entered
 ...D D^SDM0
 ...S SDDATE1=SDDATE
 ...Q
 ..D WL^SDM2A(SC)
 ..S Y="^"  ; quit
 ..Q
 .Q
 ;
 S X=$S(SDONCE<2:$G(SDSDATE),1:"")  ;Use default date/time if specified as 'desired date'  
 I 'X R !,"DATE/TIME: ",X:DTIME Q:X="^"!'$$WLCL120A^SDM2A(X,SDDATE1,SC)  ;sd/327,446
 I X="" D WL(SC) Q  ;sd/446
 G:X="M"!(X="m") MORDIS^SDM0
 I X="D"!(X="d") S X=$$REDDT() G:X>0 MORD2^SDM0 S X="" W "  ??",! G ADT
 I X?1"?".E D  G ADT
 .W !,"Enter a date/time for the appointment - PAST dates must include the YEAR"  ;SD*547 added note about past dates
 .W:$D(SD) " or a space to choose the same date/time as the patient you have just previously scheduled into this clinic"
 .W ".",!,"You may also select 'M' to display the next month's availability or"
 .W !,"'D' to specify an earlier or later date to begin the availability display."
 I X=" ",$D(SD),SD S Y=SD D AT^SDUTL W Y S Y=SD
 I $E($P(X,"@",2),1,4)?1.4"0" K %DT S X=$P(X,"@"),X=$S($L(X):X,1:"T"),%DT="XF" D ^%DT G ADT:Y'>0 S X1=Y,X2=-1 D C^%DTC S X=X_.24
 K %DT S %DT="TXEF" D ^%DT
 I $P(Y,".",2)=24 S X1=$P(Y,"."),X2=1 D C^%DTC S Y=X_".000001"
 S SD=Y,SL=$P(CLN("LENGTH OF APP'T"),U)
 D MAKE(DFN,SC,SD,SDAPTYP,SDXSCAT,SL)
 Q
MAKE(DFN,SC,SD,TYP,STYP,SL,SRT,LVL) ; Make appointmemnt
 N ERR
 S %=$$CHKAPP^SDMAPI2(.ERR,SC,DFN,SD,SL,.LVL)
 I ERR=0 D
 . I $P(ERR(0),U,3)=1 W !!,$P(ERR(0),U,2),! G 1
 . I $P(ERR(0),U,3)>1 D
 . . S TXT1="...OK"
 . . S:$P(ERR(0),U)="APTPAHA" TXT1="DO YOU WANT TO CANCEL IT"
 . . S OV=$$OVB($P(ERR(0),U,2),TXT1) I OV=2 G 1
 . . I OV=1 D MAKE(DFN,SC,SD,TYP,STYP,SL,.SDSRTY,$P(ERR(0),U,3)-1)
 Q:ERR=0
 I $P(CLN("VARIABLE APP'NTMENT LENGTH"),U)="V" D LEN
 I $D(SDSRTY(0)) S SDX=$$CONF^SDM1A(.SDSRTY,.SDSRFU,DFN,SD,SC) W !
 D ORD
 S %=$$MAKE^SDMAPI2(.ERR,DFN,SC,SD,TYP,STYP,.SL,$P(SDX,U,2),.OTHR,.CIO,.LAB,.XRAY,.EKG,.LVL)
 D CHIO^SDAMEVT(SD,DFN,SC)
 Q
 ;
LEN S SL=$P(CLN("LENGTH OF APP'T"),U) I $P(CLN("LENGTH OF APP'T"),U)]"" W !,"LENGTH OF APPOINTMENT (IN MINUTES): ",$P(CLN("LENGTH OF APP'T"),U),"// " R S:DTIME I S]"" G:$L(S)>3 LEN Q:U[S  S POP=0 D L G LEN:POP S SL=S Q
OVB(TXT,TXT1) ;
OVB1 ;
 S %=2 W *7,!,TXT,TXT1 D YN^DICN
 I '% W !,"RESPOND YES OR NO" G OVB1
 Q %
 ;
ORD ;
 S %=2 W !,"WANT PATIENT NOTIFIED OF LAB,X-RAY, OR EKG STOPS"
 D YN^DICN I '% W !,"  Enter YES to notify patient on appt. letter of LAB, X-RAY, or EKG stops" G ORD
 I '(%-1) D ORDY^SDM3
OTHER ;
 R !,"  OTHER INFO: ",D:DTIME
 I D["^" W !,*7,"'^' not allowed - hit return if no 'OTHER INFO' is to be entered" G OTHER
 S TMPD=D I $L(D)>150 D MSG^SDMM G OTHER ;SD/478
 I D]"",D?."?"!(D'?.ANP) W "  ENTER LAB, SCAN, ETC." G OTHER
 ;S $P(^(0),"^",4)=D
 S OTHR=D
 D:$D(TMP) LINK^SDCNSLT(SC,SDY,SD,CNSLTLNK) ;SD/478
 D:$D(TMP) EDITCS^SDCNSLT(SD,TMPD,TMPYCLNC,CNSLTLNK) ;SD/478
 K TMP  ;SD/478
XR I $S('$D(^SC(SC,"RAD")):1,^("RAD")="Y":0,^("RAD")=1:0,1:1) S %=2 W !,"WANT PREVIOUS X-RAY RESULTS SENT TO CLINIC" D YN^DICN G:'% HXR I '(%-1) S ^SC("ARAD",SC,SD,DFN)=""
 Q
HXR W !,"  Enter YES to have previous XRAY results sent to the clinic" G XR
 Q
WRT W !,$P(CLN("LENGTH OF APP'T"),U)," MINUTE APPOINTMENTS "
 W $S($P(CLN("VARIABLE APP'NTMENT LENGTH"),U)["V":"(VARIABLE LENGTH)",1:"") Q
 ;
L S SDSL=$S($G(CLN("DISPLAY INCREMENTS PER HOUR"))]"":60/$G(CLN("DISPLAY INCREMENTS PER HOUR")),1:"") Q:'SDSL
 I S\(SDSL)*(SDSL)'=S W *7,!,"Appt. length must = or be a multiple of the increment minutes per hour (",SDSL,")",! S POP=1
 Q
 ;
SPIN W !,"There are more special instructions. Do you want to display them"
 S %=2 D YN^DICN
 I '% W !,"Enter Y to see the remaining special instructions, or N if you don't wish to see them" G SPIN
 I (%-1) S POP=1 Q
 W !,^SC(SC,"SI",%I,0),! Q
 ;
REDDT() ;Prompt for availability redisplay date
 N %DT,X,Y
 S %DT="AEX"
 S %DT("A")="DATE TO BEGIN THE RE-DISPLAY OF CLINIC AVAILABILITY: "
 W ! D ^%DT
 Q Y
WL(SC) ;Wait List Hook/teh patch 263 ;SD/327 passed 'SC'
 Q:$G(SC)'>0
 I '$D(^SC(SC)) Q
 I $D(SC) S SDWLFLG=0 D
 .I $D(^SDWL(409.32,"B",+SC)) S SDWLFLG=1
 .I 'SDWLFLG S SDWLDSS=$P($G(^SC(+SC,0)),U,7) I $D(^SDWL(409.31,"B",SDWLDSS)) S SDWLFLG=2 D
 ..I SDWLFLG=1 S SDWLSC=$O(^SDWL(409.32,"B",+SC,0)) I $P(^SDWL(409.32,SDWLSC,0),U,4) S SDWLFLG=0
 .I SDWLFLG=2 S SDWLDS=$O(^SDWL(409.31,"E",DUZ(2),0)) I $D(^SDWL(409.31,SDWLDSS,"I",+SDWLDS,0)),$P(^(0),U,4) S SDWLFLG=0
 .I SDWLFLG D
 ..K SDWLSC,SDWLDSS,SDWLDS,SDWLFLG
 ..S SDWLOPT=1,SDWLERR=0 D OPT^SDWLE D EN^SDWLKIL
 Q
