SCMCU1 ;ALB/CMM - Team Information Display ;09/25/2012
 ;;5.3;Scheduling;**41,177,260003**;AUG 13, 1993
 ;
 ;action on Appointment Management
 ;
SEL ;selection - getting patient
 N ENT
 I '$D(@VALMAR@("IDX")) S TDFN=$$GETPT() Q
 ; ^ no selections available, prompt for patient?
 D EN^VALM2(XQORNOD(0),"S")
 S ENT=$O(VALMY(0))
 I ENT="" S TDFN=$$GETPT() Q
 I '$D(^TMP("SDAMIDX",$J,ENT)) S TDFN=0 Q
 S TDFN=+$P($G(^TMP("SDAMIDX",$J,ENT)),"^",2)
 Q
 ;
GETPT() ;function to get patient
 S Y=$$SELECT^SDMUTL("Patient")
 Q $S(Y="^":-1,(Y<0):-1,1:+Y)
 ;
INIT ;gather team data
 N GBL
 I TDFN=0 S VALMQUIT="" Q
 S GBL="^TMP(""SCTI"","_$J_")"
 K @GBL
 S SDLN=1
 D CNTRL^VALM10(SDLN,15,45,IOINHI,IOINORM)
 D TDATA^SDPPTEM(TDFN,.VALMCNT)
 Q
 ;
HDR ;header code
 N PTNAME,PAT
 S %=$$GETPAT^SDMAPI3(.PAT,TDFN,1)
 S PTNAME=$P(PAT("NAME"),U,1)
 S VALMHDR(2)="Patient: "_PTNAME_"     SSN: "_$P(PAT("SOCIAL SECURITY NUMBER"),U,1)
 S VALMPGE=1 ;start at page 1
 Q
