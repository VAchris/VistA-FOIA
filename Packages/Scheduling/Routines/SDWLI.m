SDWLI ;BPOI/TEH - DISPLAY PENDING APPOINTMENTS;08/01/12
 ;;5.3;scheduling;**263,327,394,446,524,505,260003**;08/13/93;Build 20
 ;
 ;
 ;******************************************************************
 ;                             CHANGE LOG
 ;                                               
 ;   DATE               PATCH          DESCRIPTION
 ;   ----             -----             -----------
 ;   04/22/2005      SD*5.3*327  DISPLAY APPOINTMENT INFORMATION
 ;   04/22/2005      SD*5.3*327  UNDEFINED ERROR HD+1
 ;   08/07/2006      SD*5.3*446  proceed only when DFN defined
 ;   04/14/2006      SD*5.3*446  INTER-FACILITY TRANSFER
 ;
 ;
EN ;NEW AND INITIALIZE VARIABLES
 N %DT,DD,SDWLBDT,SDWLEDT
 S SDWLERR=0,SDWLBDT="",SDWLEDT=""
 I $D(SDWLLIST),SDWLLIST D  Q:SDWLERR
 .I '$G(DFN) S SDWLERR=1 Q
 . N HASENTRY
 . S %=$$HASENTRY^SDWLAPI1(.HASENTRY,DFN)
 . I 'HASENTRY D  Q
 .. D HD
 .. W *7,!,"This Patient has NO entries on the Electronic Wait List."
 .. N DIR S DIR(0)="E" D ^DIR
 .. S DUOUT=1
 I $D(DUOUT) G END
 I 'SDWLERR,$D(SDWLLIST),SDWLLIST D  G END:$D(DUOUT) G EN1
 . D 1^VADPT,DEM^VADPT
 . S SDWLDFN=DFN
 . D HD,SEL
 . Q:$D(DUOUT)
 . K DIR,DIC,DR,DIE,VADM
 K DIR,DIC,DR,DIE,VADM
 ;
 ;OPTION HEADER
 ;
 D HD
 ;
 ;PATIENT LOOK-UP FROM WAIT LIST PATIENT FILE (^SDWL(409.3,IEN,0).
 ;
 D SEL G EN:$D(DUOUT)
 D PAT Q:'$D(SDWLDFN)
 G END:SDWLDFN<0,END:SDWLDFN=""
 Q:$D(DUOUT)
EN1 K DIR,DIC,DR,DIE,SDWLDRG
 D DISPLAY
 G EN:'$D(DUOUT)
 D END
 Q
PAT ;PATIENT LOOK-UP
 N STATUS
 I $D(SDWLY),SDWLY S STATUS="O"
 S (SDWLDFN,DFN)=$$SELPAT^SDWLUI($G(STATUS))
 Q:SDWLDFN<0
 D 1^VADPT
 Q
 ;
 ;PROMPT FOR DISPLAY 'OPEN' WAITING LIST ONLY OR PROMPT FOR BEGINNING AND ENDING DATES
 ;
SEL K SDWLDRG S DIR(0)="Y" S DIR("A")="Do You Want to View Only 'OPEN' Wait Lists",DIR("B")="YES"
 S DIR("?")="'Yes' for 'Open' and these Patient Record have not been dispositioned and 'No' for all Records."
 W ! D ^DIR S SDWLY=Y W !
 I X["^" S DUOUT=1 Q
 I SDWLY=0,'$$SELDATE^SDWLUI(.SDWLBDT,.SDWLEDT) G SEL
 Q
DISPLAY ;SHOW EWL DETAILS
 N LIST,I,REC,STAT
 S STAT=$S(SDWLY:"O",1:"")
 S %=$$LIST^SDWLAPI1(.LIST,DFN,STAT,SDWLBDT,SDWLEDT)
 I '%!'LIST D  Q
 . W !!,"No 'OPEN' Wait List Records to Display.",!!
 . K DIR
 . S DIR(0)="E"
 . D ^DIR
 . S DUOUT=""
 F I=1:1:LIST D  I $D(DUOUT) Q
 . S %=$$DETAIL^SDWLAPI1(.REC,LIST(I,"IEN"))
 . W !,"# ",$J(I,3),!
 . W !,"Wait List - ",$P(REC("WLTYPE"),U,2),?55,"Date Entered - ",$$FMTE^XLFDT($P(REC("ORIGDT"),U),"2DZ")
 . W !,?15,$P(REC("WAITFOR"),U,2)
 . S SDWLP=0 I $P(REC("PRIORITY"),U) W !,"Priority - ",$P(REC("PRIORITY"),U,2) S SDWLP=1 ;Left like this to keep the existing functionality intact
 . W !,"Service Connected Priority - ",$P(REC("SCPRIORITY"),U,2)
 . W:SDWLP ?15 W:'SDWLP ! W "Institution - ",$P(REC("INSTITUTION"),U,2)
 . W !,"Entered by - ",$P(REC("ENTEREDBY"),U,2) ;S X=$$EXTERNAL^DILFD(409.3,9,,SDWLDUZ) W X
 . S SDWRB=0 I $P(REC("REQBY"),U) W !,"Requested By - ",$P(REC("REQBY"),U,2),?55,"Date Desired - ",$P(REC("DSRDDT"),U,2)
 . I $P(REC("REQBY"),U)=1 W !,"Provider - ",$P(REC("PROVIDER"),U,2)
 . I $P(REC("CMNTS"),U)'="" W !,"Comments - ",$P(REC("CMNTS"),U)
 . I $P(REC("REOPENRSN"),U)'="" D
 .. W !,"Reopen Reason: ",$P(REC("REOPENRSN"),U,2)
 .. I $P(REC("REOPENCMT"),U,2)'="" W !,"Reopen comment: ",$P(REC("REOPENCMT"),U,2)
 . I $P(REC("DNRRSN"),U)'="" D
 .. W !,"Non Removal Reason - ",$P(REC("DNRRSN"),U,2)
 .. W !,"Non Remove Reason entered by - ",$P(REC("DNRUSR"),U,2)
 .. I $L($P(REC("DNRCMT"),U,2))>0 W !,"Non Removal Comment - ",$P(REC("DNRCMT"),U,2)
 .. W !,"Non Removal entry date - ",SDREMDD
 . I $P(REC("DISPTYPE"),U)'="" D
 .. W !,"Disposition - ",$P(REC("DISPTYPE"),U,2),?51,"Disposition Date - ",$$FMTE^XLFDT($P(REC("DISPDT"),U),"2DZ")
 .. W !,"Dispositioned by - ",$P(REC("DISPBY"),U,2)
 . I $P(REC("APPTSCHED"),U)'="" D
 .. W !,"Appointment scheduled for ",$$FMTE^XLFDT($P(REC("APPTSCHED"),U),"2DZ")
 .. W !?3,"Made on: ",$$FMTE^XLFDT($P(REC("APPTDATE"),U),"2DZ")
 .. W ?30,"For clinic: ",$P(REC("APPTCLIN"),U,2)
 .. W !?3,"Appt Institution: ",$P(REC("APPTINST"),U,2)
 .. W ?40,"Appt Specialty: ",$P(REC("APPTSC"),U,2)
 .. I $P(REC("APPTSTATUS"),U)="CC" W !,"Appointment Status: Canceled by Clinic"
 . I +$P(REC("CHDCLINP"),U) D  ;SD*5.3*446
 .. N REC1
 .. Q:'$$DETAIL^SDWLAPI1(.REC1,$P(REC("CHDCLINP"),U))
 .. W !,"Clinic changed from: ",$P(REC1("WAITFOR"),U,2)
 .. W:$P(REC("INSTITUTION"),U)'=$P(REC1("INSTITUTION"),U) " (",$P(REC1("INSTITUTION"),U,2),")"
 .; Inter-facility Transfer. SD*5.3*446
 . N TRF
 . I $$TRNDET^SDWLAPI1(.TRF,LIST(I,"IEN")),TRF("ACTIVE") D
 .. D ENS^%ZISS
 .. W !,IOINHI,"In transfer to ",TRF("INSTITUTION")," (",TRF("STATION"),")",IOINORM
 .. D KILL^%ZISS
 . W !,"*****",! D
 .. N DIR
 .. S DIR(0)="E"
 .. D ^DIR
 .. I X["^" S DUOUT=1 Q
 .. I 'Y S DUOUT=1 Q
 Q
 ;
HD ;Header
 W:$D(IOF) @IOF W !!,?80-$L("Wait List - Inquiry")\2,"Wait List - Inquiry ",!
 ;SD*5.3*327 - Correct undefined.
 I '$D(SDWLDFN) W !! Q 
 N DFN S DFN=SDWLDFN D DEM^VADPT
 W:$D(VADM) !,VADM(1),?40 I $D(VA("PID")) W VA("PID")
 W !!
 K DUOUT
 Q
END ;
 K DIR,DIC,DR,DIE,SDWLDFN,DUOUT,VA
 Q
 ;
