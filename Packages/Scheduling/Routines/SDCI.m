SDCI ;SF/GFT,MAN/GRR - CHECK-IN/UNSCHEDULED APPOINTMENT ; 10/23/2012
 ;;5.3;Scheduling;**260003**;Aug 13, 1993
 ;
PT ;
 N DFN,APTS,SDD
 S DFN=$$SELPAT^SDMUTL("Patient") G PTQ:DFN<0
 S %=$$LSTDAYAP^SDMAPI4(.APTS,+DFN)
 S SDD=0
 F SDT=0:0 S SDT=$O(APTS(SDT)) Q:'SDT  D
 . W !!,"Appointment at "_$E(SDT_"000",9,12)_" on ",$$FDATE^VALM1(SDT)," in "_$P(APTS(SDT,"CLINIC"),U,2)
 . D ONE^SDAM2(+DFN,+APTS(SDT,"CLINIC"),SDT,APTS(SDT,"C","IFN"),1,"") S SDD=SDD+1
 W:'SDD *7,!,"This patient has no appointments scheduled today."
 W ! S DIR("A")="Do you want to add a new 'unscheduled' appointment'",DIR(0)="Y"
 D ^DIR K DIR G PTQ:Y'=1
 S SDY=$$CL^SDAMWI(DFN)
PTQ Q
