PRSEEMP1 ;HISC/JH-INDIVIDUAL INSERVICE ATTENDANCE REPORT ;9/17/1998
 ;;4.0;PAID;**20,44**;Sep 21, 1995
EN1 ; INDIVIDUAL STUDENT TRAINING REPORT
 S X=$G(^PRSE(452.7,1,"OFF")) I X=""!(X=1) D MSG6^PRSEMSG Q
 S (POUT,NPC,NQ,NSW1)=0,HOLD=1 D EN2^PRSEUTL3($G(DUZ)) I '(PRSESER>0) D MSG3^PRSEMSG G QUIT
 W ! S DATSEL="N+" D DATSEL^PRSEUTL G:$G(POUT) QUIT D INS^PRSEUTL G QUIT:$G(POUT)
 D:'(PRSESEL="A") EN5^PRSEUTL2 G Q:$G(POUT)
 S DIC("S")="I +$$EN4^PRSEUTL3($G(DUZ))!(+$$EN6^PRSEUTL3($G(DUZ))&(+$$EN3^PRSEUTL3(+$G(Y))=PRSESER))!(DUZ(0)[""@"")"
 I +$$EN4^PRSEUTL3($G(DUZ))!(+$$EN6^PRSEUTL3($G(DUZ)))!(DUZ(0)["@") W ! D EN6^PRSEUTL2 G:$G(POUT)!'(+Y>0) QUIT  S PRDA=+Y
 S:$G(PRDA)'>0 PRDA=DUZ
 W ! S ZTRTN="START^PRSEEMP1",ZTDESC="INDIVIDUAL EMPLOYEE TRAINING REPORT" D L,DEV^PRSEUTL G:POP!($D(ZTSK)) QUIT
START ;
 S (PHRS,PHRS("CEU"),PHRS("CON"),PCOUNT)=0,PRSE132=$S(IOM'<132:132,1:0) D SORT U IO
 N PRHLOC
 S X=$O(^TMP("PRSE",$J,"L","")) I X="" D NHDR W !,"THERE IS NO DATA FOR THIS REPORT" W !,"EMPLOYEE: ",$P($G(^VA(200,PRDA,0)),U) W:$G(PRSECLS)]"" !,"CLASS: ",PRSECLS W ! G QUIT
 S PRSELOC="" F  S PRSELOC=$O(^TMP("PRSE",$J,"L",PRSELOC)) Q:PRSELOC=""!POUT  S NIC="" F  S NIC=$O(^TMP("PRSE",$J,"L",PRSELOC,NIC)) Q:NIC=""!POUT  S NSORT=$G(^TMP("PRSE",$J,"L",PRSELOC,NIC)),HOLD=1 D:NSORT
 .S N1="" F  S N1=$O(^TMP("PRSE",$J,"L1",NSORT,N1)) Q:N1=""!POUT  S PRSETL="" F  S PRSETL=$O(^TMP("PRSE",$J,"L1",NSORT,N1,PRSETL)) Q:PRSETL=""!POUT  D
 ..S NCD="" F  S NCD=$O(^TMP("PRSE",$J,"L1",NSORT,N1,PRSETL,NCD)) Q:NCD=""!POUT  S DA=$O(^TMP("PRSE",$J,"L1",NSORT,N1,PRSETL,NCD,0)) Q:DA'>0  D
 ...I '(NSW1>0)!($Y>(IOSL-5)) D NHDR Q:POUT
 ...I $G(PRHLOC)'=PRSELOC D SERV S PRHLOC=PRSELOC W !
 ...S PCOUNT=PCOUNT+1,PRDATA=$G(^TMP("PRSE",$J,"L1",NSORT,N1,PRSETL,NCD,DA)),PHRS=(PHRS+$P(PRDATA,U)) I $P(PRDATA,U,4)="C" S PHRS("CEU")=(PHRS("CEU")+$P(PRDATA,U,2)),PHRS("CON")=(PHRS("CON")+$P(PRDATA,U,3))
 ...I HOLD=1 W !,$S(PRSE132:NIC,1:$E(NIC,1,25)) W:$P($G(^PRSE(452,DA,6)),U,2)'="" ?$S(PRSE132:55,1:27),$E($P(^(6),U,2),1,25) W ?$S(PRSE132:93,1:47),"Length: ",$S($P(PRDATA,U)>0:$J($P(PRDATA,U),4,2),1:"") S HOLD=0
 ...S Y=$E(NCD,1,7) D:+Y D^DIQ W ?$S(PRSE132:114,1:67),$P(Y,"@"),!
 ...I $P(PRDATA,U,4)="C" W ?1,"CEUs: ",+$P(PRDATA,U,2),?$S(PRSE132:88,1:42),"Contact HRS: ",$J($P(PRDATA,U,3),4,2) W !
 ...Q
 .S HOLD=1 Q
 G QUIT:$G(POUT)
 W !,$$REPEAT^XLFSTR("-",$G(IOM))
 W !,?1,"Total Classes: ",PCOUNT,?$S(PRSE132:78,1:35),"Total Length/Hours:",$J(PHRS,7,2) I PRSESEL="C"!(PRSESEL="A") W !,?4,"Total CEUs:",$J(PHRS("CEU"),6,2),?$S(PRSE132:77,1:34),"Total Contact Hours:",$J(PHRS("CON"),7,2),!
QUIT ;
Q K ^TMP("PRSE",$J) D CLOSE^PRSEUTL,^PRSEKILL
 Q
NHDR I 'NQ,NSW1,$E(IOST,1,2)="C-" W ! D ENDPG^PRSEUTL Q:POUT
 S NPC=NPC+1
 W:$E(IOST,1,2)="C-"!(NPC>1) @IOF W !,"INDIVIDUAL "
 W $S(PRSESEL="C":"C.E.",PRSESEL="M":"M.I.",PRSESEL="O":"OTHER",PRSESEL="W":"WARD",1:"COMPLETE")_" TRAINING REPORT FOR "_$S(TYP="C":"CY ",TYP="F":"FY ",1:" ")_$S(TYP="C"!(TYP="F"):$G(PYR),1:$G(YRST(1))_" - "_$G(YREND(1)))
 S X="T" D ^%DT D:+Y D^DIQ
 I PRSE132 D
 .W ?101,Y,?121,"PAGE: ",NPC
 .W !,"Class Name",?55,"Class Presenter",?114,"Date"
 E  D
 .W ?55,Y,?71,"PAGE: ",NPC
 .W !,"Class Name",?30,"Class Presenter",?67,"Date"
 S NI="",$P(NI,"-",$S(PRSE132:133,1:81))="" W !,NI Q:$O(^TMP("PRSE",$J,"L",""))=""
 S (HOLD,NSW1)=1
 W !
 Q
L F X="PHRS*","PCOUNT","PSPC","PSP","PYR","PRDA","HOLD","PRSECLS","PRSESEL","PRSESER","NSW2","POUT","REQWRD","NQ","NSP*","NSPC*","NPC","POUT","NSW1","NSP","NSPC","PRSECORD","TYP" S ZTSAVE(X)=""
 Q
SORT ;
 W:$E(IOST,1,2)="C-"&('$R(100)) "."
 S N1=$S($D(^VA(200,PRDA,0))&($P(^(0),"^")'=""):$P(^(0),"^"),1:"  BLANK")
 S PRSETL="",SSN=$P($G(^VA(200,+PRDA,1)),U,9) Q:SSN=""  S PRDA(1)=+$O(^PRSPC("SSN",SSN,0)) S PRCOD=$S($P($G(^PRSPC(PRDA(1),0)),U,17)'="":$P($G(^(0)),U,17),1:0),PRSETL=$$EN12^PRSEUTL2($G(PRCOD)) S:PRSETL="" PRSETL="  BLANK"
 S PRSE="" F  S PRSE=$O(^PRSE(452,"AA",PRSE)) Q:PRSE=""  S NIC1="" F  S NIC1=$O(^PRSE(452,"AA",PRSE,PRDA,NIC1)) Q:NIC1=""  D
 .I $S('(PRSESEL="A")&($D(^PRSE(452,"AA",PRSESEL,PRDA,NIC1))):0,PRSESEL="A":0,1:1) Q
 .F NCD1=0:0 S NCD1=$O(^PRSE(452,"AA",PRSE,PRDA,NIC1,NCD1)) Q:NCD1'>0  S NCD=(9999999.0000-NCD1) F DA(2)=0:0 S DA(2)=$O(^PRSE(452,"AA",PRSE,PRDA,NIC1,NCD1,DA(2))) Q:DA(2)'>0  D
 ..S:$G(NSORT)="" NSORT=1
 ..I $D(NSPC)#2,'(NSPC=NIC1) Q
 ..I (NCD>YREND)!(NCD<YRST) Q
 ..N X S PRDATA=$G(^PRSE(452,DA(2),0)),PRSELOC=$S($P(PRDATA,U,13)'="":$P(PRDATA,U,13),1:"  BLANK"),X=$G(^TMP("PRSE",$J,"L",PRSELOC,NIC1))
 ..I X="" S X=NSORT,NSORT=NSORT+1,^TMP("PRSE",$J,"L",PRSELOC,NIC1)=X
 ..S PRSECLS(0)=+$O(^PRSE(452.1,"B",NIC1,0))
 ..S ^TMP("PRSE",$J,"L1",X,N1,PRSETL,NCD,DA(2))=$S(+$G(PRSECLS(0))>0:$P($G(^PRSE(452.1,PRSECLS(0),0)),U,3),1:$P(PRDATA,U,16))_U_$P(PRDATA,U,6)_U_$P(PRDATA,U,10)_U_$P(PRDATA,U,21)
 ..Q
 .Q
 Q
 ;
SERV W !
 I $G(PRHLOC)'=$G(PRSELOC) W "Sponsoring",!?2,"Service: "_$S(PRSELOC="  BLANK":"<Unknown>",1:$S(PRSE132:PRSELOC,1:$E(PRSELOC,1,16)))
 W ?$S(PRSE132:46,1:28),"Name: ",$S(PRSE132:N1,1:$E(N1,1,20)),?$S(PRSE132:92,1:52),"Title: ",$S(PRSETL="  BLANK":"<Unknown>",+PRSETL=PRSETL:"<Unknown>",1:$S(PRSE132:$E(PRSETL,1,40),1:$E(PRSETL,1,20)))
 Q