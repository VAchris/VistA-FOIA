SDNOS1A ;ALB/LDB - NO SHOW REPORT CONT. ; 15 OCT 87@13:00
 ;;5.3;Scheduling;;Aug 13, 1993
DIV I $D(^DG(40.8,SDDIV,0)) S SDDIV2=$P(^(0),U,1)
 I $D(^DG(43,1,"GL")),$P(^("GL"),U,2),$D(^DG(40.8,SDDIV,0)) W !,?9,"FOR DIVISION: ",?30,SDDIV2
 I '$D(^UTILITY($J,"DGTC",SDC))&('SDTOT)&('SDTOT1) S ^UTILITY($J,"DGTC",SDC,P1)=""
 I '$D(^UTILITY($J,"DGTC",SDC_" TOTALS"))&(SDTOT) S ^UTILITY($J,"DGTC",SDC_" TOTALS",P1)=""
 I '$D(^UTILITY($J,"DGTC",SDDIV2))&('SDV1) S ^UTILITY($J,"DGTC",SDDIV2,P1)=""
 I '$D(^UTILITY($J,"DGTC",SDDIV2_" TOTALS"))&(SDTOT1) S ^UTILITY($J,"DGTC",SDDIV2_" TOTALS",P1)=""
 W:'SDTOT1!(SDTOT1&(SDC>0)) !,?11,"FOR CLINIC:",?30,SDC D LINE W ! Q
INAC I '$D(^SC(SDCL,"I")) S SDIN=0 Q
 I $P(^("I"),U),$P(^("I"),U)<SDBD,'$P(^("I"),U,2) S SDIN=1 Q  ;NAKED REFERENCE - ^SC(IFN,"I")
 I $P(^("I"),U)<SDBD,$D(SDED),$P(^("I"),U,2),$P(^("I"),U,2)>SDED S SDIN=1 Q  ;NAKED REFERENCE - ^SC(IFN,"I")
 Q
LINE S X="",$P(X,"=",IOM)="" W !,X Q