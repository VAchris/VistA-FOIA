SDWLD ;;IOFO BAY PINES/TEH - DISPLAY PENDING APPOINTMENTS;08/01/12
 ;;5.3;scheduling;**263,454,417,446,260003**;AUG 13 1993
 ;
 ;
 ;*********************************************************
 ;                                               CHANGE LOG
 ;                                               
 ;   DATE                        PATCH                   DESCRIPTION
 ;   ----                        -----                   -----------
 ;   
 ;   
 ;   ;ENTRY POINT FOR OPTION CALL
 ;
 ;       SDWLDFN = PATIENT IEN
 ;       SDWLSSN = PATIENT SSN
 ;       SDWLNAM = PATIENT NAME
 ;       
 ;    ;Patch SD*5.3*417 Display Team when displaying Position.   
 ;       
EN(SDWLDFN,SDWLSSN,SDWLNAM,SDTP,SDWLDISC,SDWLHDR,SDWLOP,SDWLIST) ;ENTRY POINT - INTIALIZE VARIABLES
 ;SDTP (optional) - EWL ENTRY STATUS
 ;SDWLDISC - DISPLAY CLOSED ENTRIES
 ;SDWLHDR - HEADER TEXT
 ;SDWLOP - HEADER OPTIONAL TEXT
 ;SDWLIST (output) - EWL ENTRIES LIST
 N SDBEG,SDEND,HASENTRY
 K SDWLIST
 S SDWLOP=$G(SDWLOP),SDWLHDR=$G(SDWLHDR),SDWLDISC=+$G(SDWLDISC)
 S SDWLIST=0
 S (SDBEG,SDEND)=""
 I $G(SDTP)="" S SDTP="O"
 I SDTP'="O"&(SDTP'="C") Q  ;
 K ^TMP("SDWLD",$J)
 I $$HASENTRY^SDWLAPI1(.HASENTRY,SDWLDFN),HASENTRY D
 .I SDTP="C",'$$SELDATE^SDWLUI(.SDBEG,.SDEND) D  Q
 ..W !,"Entry Date range required for closed EWL selection"
 .Q:'$$LIST^SDWLAPI1(.SDWLIST,SDWLDFN,SDTP,SDBEG,SDEND)
 .Q:SDWLIST=0
 .D HD1(SDWLHDR,SDWLOP)
 .D DISPPAT(SDTP,SDWLNAM,SDWLSSN)
 .D HD2(SDWLDISC)
 .D DISPWLD(.SDWLIST,SDWLDISC)
 Q
 ;
DISPPAT(SDTP,SDWLNAM,SDWLSSN) ;DISPLAY PATIENT DATA
 W !,?5,SDWLNAM,?35,SDWLSSN,!
 I $G(SDTP)'="C" W !,"Patient Currently is on Waiting List for the Following",!
 E  W !,"Patient is on closed Waiting List for the Following",!
 Q
 ;
DISPWLD(LIST,SDWLDISC) ;DISPLAY WAIT LIST DATA  
 N I
 F I=1:1:LIST D
 .W !,$J(I,2)_"."
 .W ?5,$E($P(LIST(I,"WLTYPE"),U,2),1,14)
 .W ?22,$P(LIST(I,"PRIORITY"),U)
 .W ?25,$E($P(LIST(I,"WAITFOR"),U,2),1,19)
 .W ?51,$E($P(LIST(I,"INSTITUTION"),U,2),1,14)
 .W:SDWLDISC ?67,$P(LIST(I,"STATUS"),U)
 .W ?73,$$MMDDYY^SDWLUI($P(LIST(I,"ORIGDT"),U))
 Q
 ;
HD1(SDWLHDR,SDWLOP) ;TOF HEADER INFORMATION
 S:SDWLHDR="" SDWLHDR="Wait List Display"
 W !!,?80-$L(SDWLHDR_$S($D(SDWLOP):" - "_SDWLOP,1:""))\2,SDWLHDR
 W:$G(SDWLOP)'="" " - ",SDWLOP  ;SD*5.3*454 removed page feed
 W !
 Q
HD2(SDWLDISC) ;DATA HEADER
 W !," #",?4,"Wait List Type",?22,"P",?26,"Waiting",?51,"Institution" W:+SDWLDISC ?65,"Status"
 W ?74,"Date"
 W !,?28,"For",?73,"Entered"
 Q
 ;
