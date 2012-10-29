SDCOAM ;ALB/RMO - Appt Mgmt Actions - Check Out; 10/12/2012
 ;;5.3;Scheduling;**1,20,27,66,132,260003**;08/13/93
 ;
CO(SDCOACT,SDCOACTD) ;Check Out Classification, Provider and Diagnosis
 ;                Actions on Appt Mgmt
 N DFN,SDCL,SDCOAP,SDDA,SDOE,SDT,VALMY
 S VALMBCK=""
 D EN^VALM2(XQORNOD(0))
 D FULL^VALM1
 S SDCOAP=0
 F  S SDCOAP=$O(VALMY(SDCOAP)) Q:'SDCOAP  D
 .I $D(^TMP("SDAMIDX",$J,SDCOAP)) K SDAT S SDAT=^(SDCOAP) D
 ..W !!,^TMP("SDAM",$J,+SDAT,0)
 ..S DFN=+$P(SDAT,"^",2),SDT=+$P(SDAT,"^",3),SDCL=+$P(SDAT,"^",4)
 ..N PAPT,CAPT
 ..S %=$$GETSCAP^SDMAPI1(.CAPT,SDCL,DFN,SDT)
 ..S SDDA=$G(CAPT("IFN"))
 ..S %=$$GETPAPT^SDMAPI4(.PAPT,DFN,SDT)
 ..S SDOE=$G(PAPT("OE","I"))
 ..I 'SDOE!('$G(CAPT("CHECKOUT"))) W !!,*7,">>> "_$$EZBLD^DIALOG(480000.029),SDCOACTD,"." D PAUSE^VALM1 Q
 ..D ACT(SDCOACT,SDOE,DFN,SDT,SDCL,SDDA,+SDAT)
 S VALMBCK="R"
 K SDAT
COQ Q
 ;
ACT(SDCOACT,SDOE,DFN,SDT,SDCL,SDDA,SDLNE) ; -- Check Out Actions
 N SDCOMF,SDCOQUIT,SDHL,SDVISIT,SDATA,SDHDL,OE
 ;
 S %=$$GETOE^SDMAPI4(.OE,SDOE)
 S SDVISIT=$G(OE("VISIT"))
 ;
 ; -- quit if not ok to edit
 IF '$$EDITOK^SDCO3($G(SDOE),1) G ACTQ
 ;
 ; -- set pce action parameter
 S SDPXACT=""
 I $G(SDCOACT)="CL" S SDPXACT="SCC"
 I $G(SDCOACT)="PR" S SDPXACT="PRV"
 I $G(SDCOACT)="DX" S SDPXACT="POV"
 I $G(SDCOACT)="CPT" S SDPXACT="CPT"
 ;
 ; -- quit if no action set
 IF SDPXACT="" G ACTQ
 ;
 ; -- do pce interview then rebuild appt list
 S X=$$INTV^PXAPI(SDPXACT,"SD","PIMS",.SDVISIT,.SDHL,DFN)
 D BLD^SDAM
ACTQ Q
 ;
PD ;Entry point for SDAM PATIENT DEMOGRAPHICS protocol
 N SDCOAP,VALMY
 S VALMBCK=""
 D FULL^VALM1
 I SDAMTYP="P" W !!,VALMHDR(1),! D DEM(SDFN)
 I SDAMTYP="C" D
 .D EN^VALM2(XQORNOD(0))
 .S SDCOAP=0 F  S SDCOAP=$O(VALMY(SDCOAP)) Q:'SDCOAP  D
 ..I $D(^TMP("SDAMIDX",$J,SDCOAP)) K SDAT S SDAT=^(SDCOAP) D
 ...W !!,^TMP("SDAM",$J,+SDAT,0),!
 ...D DEM(+$P(SDAT,"^",2))
 S VALMBCK="R"
PDQ Q
 ;
DEM(DFN) ;Demographics
 D QUES^DGRPU1(DFN,"ADD")
 Q
 ;
DC ;Entry point for SDAM DISCHARGE CLINIC protocol
 N SDCOAP,VALMY
 S VALMBCK=""
 D FULL^VALM1
 I SDAMTYP="P" W !!,VALMHDR(1),! D DIS(SDFN)
 I SDAMTYP="C" D
 .D EN^VALM2(XQORNOD(0))
 .S SDCOAP=0 F  S SDCOAP=$O(VALMY(SDCOAP)) Q:'SDCOAP  D
 ..I $D(^TMP("SDAMIDX",$J,SDCOAP)) K SDAT S SDAT=^(SDCOAP) D
 ...W !!,^TMP("SDAM",$J,+SDAT,0),!
 ...D DIS(+$P(SDAT,"^",2),$P(SDAT,"^",4))
 S VALMBCK="R"
DCQ Q
 ;
DIS(SDFN,SDCLN) ;Discharge from Clinic
 N SDAMERR
 D ^SDCD
 I $D(SDAMERR) D PAUSE^VALM1
 Q
 ;
DEL ;Entry point for SDAM DELETE CHECK OUT protocol
 N ERR
 I '$$CANDELCO^SDMAPI4(.ERR) W !!,*7,">>> "_$P($G(ERR(0)),U,2) D PAUSE^VALM1 S VALMBCK="R" G DELQ
 N DFN,SDCL,SDCOAP,SDDA,SDOE,SDT,VALMY,VALSTP
 S VALMBCK="",VALSTP="" ;VALSTP is used in scdxhldr to identify deletes
 D EN^VALM2(XQORNOD(0))
 D FULL^VALM1
 S SDCOAP=0
 F  S SDCOAP=$O(VALMY(SDCOAP)) Q:'SDCOAP  D
 .I $D(^TMP("SDAMIDX",$J,SDCOAP)) K SDAT S SDAT=^(SDCOAP) D
 ..W !!,^TMP("SDAM",$J,+SDAT,0)
 ..S DFN=+$P(SDAT,"^",2),SDT=+$P(SDAT,"^",3),SDCL=+$P(SDAT,"^",4)
 ..S %=$$CHKDCO^SDMAPI4(.RETURN,DFN,SDT)
 ..S DEQ=0
 ..I RETURN>0 D  Q:DEQ=1
 ...I '$$ASK S DEQ=1 Q
 ...S %=$$DELCOSD^SDMAPI4(.RETURN,DFN,SDT,1)
 ...W !!,">>> Deleting check out information..."
 ...W !?3,"...deleting check out date/time"
 ...W !,">>> done."
 ..E  W !!,$P(RETURN(0),U,2)
 ..D PAUSE^VALM1
 ..D BLD^SDAM
 S VALMBCK="R"
 K SDAT
DELQ Q
 ;
ASK() ;Ask if user is sure they want to delete the check out
 N DIR,DTOUT,DUOUT,Y
 W !!,*7,">>> Deleting the appointment check out will also delete any check out related",!?4,"information.  This information may include classifications, procedures,",!?4,"providers and diagnoses."
 S DIR("A")="Are you sure you want to delete the appointment check out"
 S DIR("B")="NO",DIR(0)="Y" W ! D ^DIR
 Q +$G(Y)
