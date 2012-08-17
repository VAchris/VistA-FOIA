SDCNP0 ;ALB/LDB - CANCEL APPT. FOR A PATIENT ; 08/01/2012
 ;;5.3;Scheduling;**132,167,478,517,260003**;Aug 13, 1993;Build 4
EN2 D WAIT^DICD S NDT=HDT/1,L=0 
 F J=1:1 S NDT=$O(APTS("APT",NDT)) Q:NDT'>0!(SDPV&(NDT'<SDTM))  D
 . I APTS("APT",NDT,"STATUS")'["C" D
 . . S SC=+APTS("APT",NDT,"CLINIC"),L=L\1+1,APL="" 
 . . D FLEN^SDCNP1A S ^UTILITY($J,"SDCNP",L)=NDT_"^"_SC_"^"_COV_"^"_APL_"^^"_APL D CHKSO
WH1 G:L'>0 NO S (SDCTRL,SDCTR)=0,APP="" N SDITEM W:'SDERR @IOF
 W ! F Z=0:0 S Z=$O(^UTILITY($J,"SDCNP",Z)) Q:Z'>0  S SDITEM=$J($S(Z\1=Z:"("_$J(Z,2)_") ",1:""),5) D  Q:SDCTRL
 .I SDITEM["(" W !,SDITEM S HLDCSND=""
 .I SDITEM'["(" W SDITEM
 .S AT=$S($P(^(Z),"^",2)'?.N:1,1:0),Y=$P($P(^(Z),"^"),".") D DT^SDM0 S X=$P(^(Z),"^"),^(Z,"CNT")="" X ^DD("FUNC",2,1) W " ",$J(X,8) D MORE W:AT ! Q:SDCTRL
 S:SDERR SDCTRL=1 I Z>0 G:SDCTRL&(APP']"") NOPE^SDCNP1 G:SDCTRL DEL
 D WH G NOPE^SDCNP1:APP']"",DEL
WH W !!,"SELECT APPOINTMENTS TO BE CANCELLED" W:Z>0 " OR HIT RETURN TO CONTINUE DISPLAY" R ": ",APP:DTIME I '$T!(APP="^") S SDCTRL=1,APP="" Q
 S SDMSG="W !,""Enter appt. numbers separated by commas and/or a range separated"",!,""by dashes (ie 2,4,6-9)"" H 2" I APP["?" X SDMSG G WH
 S SDCTRL=$S(APP']"":0,1:1) Q
DEL S SDERR=0 F J=1:1 S SDDH=$P(APP,",",J) Q:SDDH']""  D MTCH^SDCNP1
 G:SDERR WH1
DEL1 F J=1:1 S SDDH=$P(APP,",",J) Q:SDDH']""  S SDDI=$P(SDDH,"-"),SDDM=$P(SDDH,"-",2) D CKK^SDCNP1A Q:SDERR  D CKK1^SDCNP1A Q:SDERR  Q:'SDDI  F A1=SDDI:1:$S(SDDM:SDDM,1:SDDI) D BEGD
 G:SDERR WH1 G NOPE^SDCNP1
BEGD S (SD,S)=$P(^UTILITY($J,"SDCNP",A1),"^",1),I=$P(^UTILITY($J,"SDCNP",A1),"^",2)
 S %=$$CANCEL^SDMAPI2(.ERR,DFN,I,SD,SDWH,SDSCR,SDREM)
 I ERR=0,$P(ERR(0),U)="APTCCHO" W !,*7,">>> Appointment #",A1," has a check out date and cannot be cancelled." Q
 I ERR=0 W !,*7,$P(ERR(0),U,2) Q
 S $P(^UTILITY($J,"SDCNP",A1),"^",4)="*** JUST CANCELLED ***" Q
 S CNT=CNT+1
 Q
 ;
NO W !,"NO ",$S('SDPV:"PENDING",1:"PREVIOUS")," APPOINTMENTS",*7,*7,*7
 D END^SDCNP G RD^SDCNP
 Q
CHKSO(APTS) ;
 N A,B,CNT S A="",B="",CNT=0
 S COV=$S($P($G(APTS("APP",NDT,"COLLATERAL VISIT")),U)=1:" (COLLATERAL) ",1:"")
 I $G(APTS("APT",NDT,"LAB DATE/TIME"))>0  D
 . S A=$P(APTS("APT",NDT,"LAB DATE/TIME"),U),B="LAB"
 . S L=L+.1,^UTILITY($J,"SDCNP",L)=A_"^"_B_"^0^0"
 I $G(APTS("APT",NDT,"X-RAY DATE/TIME"))>0  D
 . S A=$P(APTS("APT",NDT,"X-RAY DATE/TIME"),U),B="XRAY"
 . S L=L+.1,^UTILITY($J,"SDCNP",L)=A_"^"_B_"^0^0"
 I $G(APTS("APT",NDT,"EKG DATE/TIME"))>0  D
 . S A=$P(APTS("APT",NDT,"EKG DATE/TIME"),U),B="EKG"
 . S L=L+.1,^UTILITY($J,"SDCNP",L)=A_"^"_B_"^0^0"
 Q
MORE S SDCTR=SDCTR+2 I AT W ?41,$P(^UTILITY($J,"SDCNP",Z),"^",2) G OVR
 W " ",$S($P(^UTILITY($J,"SDCNP",Z),"^",4)?.N:"("_$P(^(Z),"^",4)_" MIN) ",1:$P(^(Z),"^",4))," ",$S($D(^SC($P(^(Z),"^",2),0)):$P(^(0),"^",1),1:"DELETED CLINIC"),$P(^UTILITY($J,"SDCNP",Z),"^",3) ;SD/478
 N CSND,CSDT,CSSD,CONSULT,Y
 S CSND=^UTILITY($J,"SDCNP",Z),CSDT=$P(CSND,U),CSSD=$P(CSND,U,2),HLDCSND=CSND S CONSULT=$$CONSULT(CSSD,CSDT) I +$G(CONSULT) S Y=$P(^GMR(123,CONSULT,0),U) D DD^%DT W !?5,"CONSULT ",Y,"/ ",CONSULT
 D STATUS($X>55)
OVR ;Following code added SD/517
 I '$D(CSND) I $G(HLDCSND) I (($P(HLDCSND,U,4)="")!($P(HLDCSND,U,6)="")) D
 .W !!,"**********************************************************************"
 .W !,"* WARNING: There is a data inconsistency or data corruption problem  *"
 .W !,"* with the above appointment.  Corrective action needs to be taken.  *"
 .W !,"* Please cancel the appointment above.  If it is a valid appointment,*"
 .W !,"* it will have to be re-entered via Appointment Management.          *"
 .W !,"**********************************************************************"
 .S SDCTR=21
 .K HLDCSND
 ;
 I SDCTR>20,$O(^UTILITY($J,"SDCNP",Z)) S (SDCTRL,SDCTR)=0 W *7 D WH W:'SDCTRL @IOF
 Q
 ;
CONSULT(CSSD,CSDT) ;
 N CSI S CONSULT=""
 S CSI=0 F  S CSI=$O(^SC(CSSD,"S",CSDT,1,CSI)) Q:'+CSI  I $P($G(^SC(CSSD,"S",CSDT,1,CSI,0)),U)=DFN S CONSULT=$P($G(^SC(CSSD,"S",CSDT,1,CSI,"CONS")),U) Q  ;SD/478
 Q CONSULT
STATUS(LF) ;
 W:LF !
 W ?55,"(",$E($$LOWER^VALM1($P($$STATUS^SDAM1(DFN,+^UTILITY($J,"SDCNP",Z),+$P(^(Z),U,2),$G(^DPT(DFN,"S",+^(Z),0))),";",3)),1,23),")"
 W:'LF !
 Q
 ;
EVT ; -- separate tag if need to NEW vars
 N I,STR,SS,SL,SD,SB,SI,HSI,J,APP,S,A1,STARTDAY,CNT,DIV,SDERR,SDDIF
 D CANCEL^SDAMEVT(.SDATA,DFN,SDTTM,SDSC,SDPL,0,SDCPHDL)
 Q
