SDCNSLT ;ALB/HAG-LINK APPOINTMENTS TO CONSULTS; 10/18/2012
 ;;5.3;Scheduling;**478,496,260003**;Aug 13, 1993;Build 11
A ;===GET ACTIVE AND PENDING CONSULT
 N A,CNT,DTENTR,DTIN,DTLMT,DTR,NOS,NOSHOW,SENDER,SERVICE,SRV,P8,PROC,PT,PTNM,STATUS,CNS
 S %=$$GETAPCNS^SDCAPI1(.CNS,DFN,STPCOD)
 K TMP S NOSHOW="no-show",CNT=0,$P(DSH,"-",IOM-1)="",PT=DFN,X1=DT,X2=-365 D C^%DTC S DTLMT=X
 S A="" F  S A=$O(CNS(A)) Q:'+A  D
 . S CNT=CNT+1
 . S DTENTR=+CNS(A,"DATE"),Y=DTENTR D DD^%DT S DTIN=Y
 . S DTR=$E(DTENTR,4,5)_"/"_$E(DTENTR,6,7)_"/"_$E(DTENTR,2,3)_"@"_$P(Y,"@",2)
 . S PTNM=$P(CNS(A,"PATIENT"),U,2)
 . S SERVICE=$P(CNS(A,"SERVICE"),U,2)
 . S SENDER=$P(CNS(A,"SENDER"),U,2)
 . S STATUS=$P(CNS(A,"STATUS"),U,2)
 . S TYPE=$P(CNS(A,"TYPE"),U)
 . S PROC=CNS(A,"TEXT")
 . S TMP(CNT)=DFN_U_SERVICE_U_SENDER_U_STATUS_U_DTR_U_A_U_DTIN_U_TYPE_U_PROC
 Q:'$D(TMP)
QST N DIR,DTOUT,DUOUT,CNSULT
 S DIR(0)="Y",DIR("A")="Will this appointment be for a CONSULT/PROCEDURE",DIR("B")="YES",DIR("?")="Answer 'Y'es if appointment is for a Consult or Procedure." W ! D ^DIR S CNSULT=Y
 I CNSULT[U!(CNSULT=0)!(CNSULT="") K TMP Q
HDR W !!,"Please select from the list of consult(s), press 0 for none.",!
 W !,PTNM,!!,"#  Service",?27,"Sending Provider",?45,"Request Date",?60,"Cons #",?68,"Reqst Type",!,DSH
 S A=0 F  S A=$O(TMP(A)) Q:'+A  S ND=TMP(A),P8=$P(ND,U,8) W !,A,". ",$S(P8="P":$E($P(ND,U,9),1,23),1:$E($P(ND,U,2),1,23)),?27,$E($P(ND,U,3),1,17),?45,$E($P(ND,U,5),1,14)," ",$P(ND,U,6) W ?68,$S(P8="P":"Procedure",P8="C":"Consult",1:"")
 W !
READ R !,"Select Consult: ",CONS:DTIME G:CONS="" A
 I CONS=0!(CONS[U) W " ... NONE." K TMP Q
 I "? "[CONS W !," Select consult by number on the left side." G READ
 I '$D(TMP(CONS)) W *7," ?? Select consult by number on the left side." G READ
 S CNSLTLNK=$P(TMP(CONS),U,6)
 Q
CANCEL ;===appt was cancelled then mark consult as edit/resubmit, add comment.
 N RETURN
 S %=$$CANCEL^SDCAPI1(.RETURN,.SCLNK,SDSC,SDTTM,SDPL,.TMPD,.SDWH,.SDADM,.AUTO,.NSDIE,.NSDA)
 Q
AUTOREB(SC,NDATE,LNK,CY) ;===AUTO REBOOK
 N RETURN
 S %=$$AUTOREB^SDCAPI1(.RETURN,SC,NDATE,LNK,CY)
 Q
NOSHOW(SC,SDDTM,CNPAT,CNSTLNK,CN,AUTO,NSDIE,NSDA) ;
 ;Appt. was a NoShow, then mark Consult as Edit/Resubmit, add comment using silent call to notify user.
 ;Variables NSDIE and NSDA used in calling routine for NoShow letter printed comment in consult.
 N RETURN
 D NOSHOW^SDCAPI1(.RETURN,SC,SDDTM,CNPAT,CNSTLNK,CN,.AUTO,.NSDIE,.NSDA)
 Q
 ;
