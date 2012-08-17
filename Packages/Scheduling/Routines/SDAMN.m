SDAMN ;ALB/MJK - No-Show Appt Action ; 07/19/2012
 ;;5.3;Scheduling;**478,260003**;Aug 13, 1993
 ;
EN ; -- protocol SDAM APPT NO-SHOW entry pt
 ; input:  VALMY := array entries
 ;
 N VALMY,SDI,SDAT,SDTIME,SDNSACT,DFN,SDCL,SDT,SDSTB,SDSTA,SDSTOP
 S VALMBCK="",(SDNSACT,SDSTOP)=0
 D SEL^VALM2 G ENQ:'$O(VALMY(0))
 D FULL^VALM1 S VALMBCK="R",SDI=0
 F  S SDI=$O(VALMY(SDI)) Q:'SDI  I $D(^TMP("SDAMIDX",$J,SDI)) K SDAT S SDAT=^(SDI) D  Q:SDSTOP
 . D NOW^%DTC S SDTIME=%
 . W !,^TMP("SDAM",$J,+SDAT,0),!
 . S DFN=+$P(SDAT,U,2),SDT=+$P(SDAT,U,3),SDCL=+$P(SDAT,U,4)
 . S SDSTOP=$$NOSHOW(.RETURN,DFN,SDT,SDCL)
 . S SDSTB=RETURN("BEFORE") ; before status
 . S SDSTA=RETURN("AFTER") ; after status
 . I 'SDNSACT,'$$UPD(SDSTB,SDSTA,SDAT,$G(CNSTLNK)) S SDNSACT=2
 ; values for SDNSACT :   0 = no re-build
 ;                        1 = re-build because of re-book
 ;                        2 = re-build because after not for list
 I SDNSACT,SDAMTYP="P" D BLD^SDAM1
 I SDNSACT,SDAMTYP="C" D BLD^SDAM3
ENQ Q
 ;
NOSHOW(ERR,DFN,SD,SC,LVL) ; No-show appointment
 S %=$$NOSHOW^SDMAPI2(.ERR,DFN,SC,SD,.LVL)
 I ERR=1 D PAUSE^VALM1  Q 'Y
 I $P(ERR(0),U,3)=1 W !!,$P(ERR(0),U,2),! Q 1
 I $P(ERR(0),U,3)>1 D
 . S OV=$$ALNS($P(ERR(0),U,2)) I OV=2 Q
 . I OV=1 D NOSHOW(.ERR,DFN,SD,SC,$P(ERR(0),U,3)-1)
 Q 'Y
ALNS(TXT) ;
ALNS1 ;
 S %=2 W *7,!,TXT D YN^DICN
 I '% W !,"RESPOND YES OR NO" G ALNS1
 Q %
 ;
UPD(BEFORE,AFTER,SDAT,CNST) ; can just the 1 display line be changed w/o re-build
 ; input:   BEFORE := before status info in $$STATUS format
 ;           AFTER := after     "     "   "     "      "
 ;            SDAT := selected VALMY entry's data
 ;            CNST := consult status (null, consult link ien)
 N Y S Y=0
 I +BEFORE=+AFTER S Y=1 G UPDQ
 I $D(SDAMLIST(+AFTER)) S Y=1 I $D(SDAMLIST("SCR")) X SDAMLIST("SCR") S Y=$T
 I 'Y,$P(SDAMLIST,U)="ALL" S Y=1
 I Y D
 . S ^TMP("SDAM",$J,+SDAT,0)=$$SETFLD^VALM1($P(AFTER,";",3),^TMP("SDAM",$J,+SDAT,0),"STAT")
 . I '$G(CNST) S ^TMP("SDAM",$J,+SDAT,0)=$$SETFLD^VALM1("    ",^TMP("SDAM",$J,+SDAT,0),"CONSULT")
UPDQ Q Y
