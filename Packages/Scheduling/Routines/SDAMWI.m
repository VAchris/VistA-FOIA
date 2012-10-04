SDAMWI ;ALB/MJK - Unscheduled Appointments ; 9/24/2012
 ;;5.3;Scheduling;**63,94,241,250,296,380,327,260003**;Aug 13, 1993
 ;
EN(DFN,SC) ; -- main entry point
 ;    input: DFN ; SC := clinic#
 ; returned: success or fail := 1/0
 ;
 N SDY,SDAPTYP,SDRE,SDRE1,SDIN,SDSL,SDD,SDALLE,SDATD,SDDECOD,SDEC,SDEMP,SDOEL,SDPL,SDRT,SDSC,SDTTM,COLLAT,SDX,SDSTART,ORDER,SDREP,SDDA,SDCL
 S %=$$CHKAPTU^SDMAPI2(.RETURN,SC,DFN,DT)
 I RETURN=0 W !!?5,*7,$P(RETURN(0),U,2) D PAUSE^VALM1 S SDY=0 G ENQ
 I '$$TIME(.DFN,.SC,.SDT) D WL^SDM1(SC) S SDY=0 G ENQ ;SD/327
 S Y=SDT D ^SDM4 I X="^" S SDY=0 G ENQ
 ; ** SD*5.3*250 MT Blocking check removed
 ;S X="EASMTCHK" X ^%ZOSF("TEST") I $T N EASACT S EASACT="W" I $$MT^EASMTCHK(DFN,+$G(SDAPTYP),EASACT) D PAUSE^VALM1 S SDY=0 G ENQ
 ;-- get sub-category for appointment type
 S SDXSCAT=$$SUB^DGSAUTL(SDAPTYP,2,"")
 S SDY=$$MAKE^SDAMWI1(DFN,SC,SDT,SDAPTYP,SDXSCAT)
 K SDXSCAT
ENQ D KVAR^VADPT
 Q SDY
 ;
TIME(DFN,SC,SDT) ; -- get appt date/time
 ;    input: DFN ; SC := clinic#
 ;   output: SDT := date/time of wi appt
 ; returned: success or fail := 1/0
 ;
 N SDY,%DT
ASK R !!,"APPOINTMENT TIME: NOW// ",X:DTIME S X=$$UPPER^VALM1(X)
 I X["^"!('$T) S SDY=0 G TIMEQ
 I X?.E1"?" D  G ASK
 .W !,"  Enter a time or date@time for the appointment or return for 'NOW'."
 .W !,"The date must be today or earlier."
 S:X=""!(X="N")!(X="NO") X="NOW"
 I X'="NOW",X'["@" S X="T@"_X
 S %DT="TEP",%DT(0)=-(DT+1) D ^%DT G ASK:Y<0 S SDT=Y
 S %=$$CHKAPTU^SDMAPI2(.RETURN,SC,DFN,SDT)
 I RETURN=0 W !!?5,*7,$P(RETURN(0),U,2) D PAUSE^VALM1 G ASK
 S SDY=1
TIMEQ Q SDY
 ;
CL(DFN) ; -- make wi appt
 ;    input: DFN
 ; returned: success or fail := 1/0
 ;
 N Y
 S Y=$$SELCLN^SDMUTL("Clinic")
 I Y<0 S SDY=0 G CLQ
 S SC=+Y S SDY=$$EN(.DFN,.SC)
CLQ Q SDY
 ;
PT(SC) ;
 ;    input:  SC := clinic#
 ; returned: success or fail := 1/0
 ;
 N Y
 S Y=$$SELPAT^SDMUTL("Patient")
 I Y<0 S SDY=0 G PTQ
 S DFN=+Y S SDY=$$EN(.DFN,.SC)
PTQ Q SDY
 ;
