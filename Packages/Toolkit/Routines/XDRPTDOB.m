XDRPTDOB ;SF-IRMFO/IHS/OHPRD/JCM;COMPARES DATE OF BIRTHS; ;1/27/97  15:11
 ;;7.3;TOOLKIT;**23**;Apr 25, 1995
 ;;
START ;
 D INIT
EN ; EP - Entry point for comparing dates
 D COMPARE
END D EOJ
 Q
 ;
INIT ;
 K XDRDOB,XDRDOB2
 S XDRDOB=XDRCD(XDRFL,XDRCD,.03,"I"),XDRDOB2=XDRCD2(XDRFL,XDRCD2,.03,"I")
 S XDRDOB("MATCH")=$P(XDRDTEST(XDRDTO),U,6)
 S XDRDOB("NO MATCH")=$P(XDRDTEST(XDRDTO),U,7)
 Q
 ;
COMPARE ;
 S XDRD("TEST SCORE")=$$DATECOMP(XDRDOB,XDRDOB2,XDRDOB("MATCH"),XDRDOB("NO MATCH"),.8,.6)
 Q
 ;
DATECOMP(DATE1,DATE2,MATCH,NOMATCH,VAL1,VAL2) ;
 N Y
 S Y=$$NUMCOMP^XDRPTCLN(DATE1,DATE2,MATCH,NOMATCH,VAL1)
 I Y=NOMATCH D
 . I $E(DATE1,4,5)="00"!($E(DATE2,4,5)="00") S DATE1=$E(DATE1,1,3)_"0000",DATE2=$E(DATE2,1,3)_"0000" S MATCH=VAL2*MATCH
 . I $E(DATE1,4,5)'="00",$E(DATE1,6,7)="00"!($E(DATE2,6,7)="00") S DATE1=$E(DATE1,1,5)_"00",DATE2=$E(DATE2,1,5)_"00" S MATCH=VAL1*MATCH
 . S Y=$$NUMCOMP^XDRPTCLN(DATE1,DATE2,MATCH,NOMATCH,(NOMATCH/MATCH))
 Q Y
 ;
EOJ ;
 K XDRDOB,XDRDOB2
 Q