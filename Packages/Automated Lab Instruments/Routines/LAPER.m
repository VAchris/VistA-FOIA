LAPER ;SLC/DLG - PERSPECTIVE ;7/20/90  09:58 ;
 ;;5.2;AUTOMATED LAB INSTRUMENTS;;Sep 27, 1994
 ;CROSS LINK BY ID OR IDE ID=ACCESSION IDE=PATIENT SSN TRAY=TRAY CUP=CUP
 ;TESTS 1-14 ON FIRST RECORD; TESTS 15-39 ON SECOND RECORD; TESTS 40-64 ON THIRD RECORD; PARM1 NULL
LA1 S:$D(ZTQUEUED) ZTREQ="@" S LANM=$T(+0),TSK=$O(^LAB(62.4,"C",LANM,0)) Q:TSK<1
 Q:'$D(^LA(TSK,"I",0))
 K LATOP D ^LASET Q:'TSK  S X="TRAP^"_LANM,@^%ZOSF("TRAP")
LA2 K TV S (TOUT,A)=0 D IN G QUIT:TOUT,LA2:$L(IN)<5 D QC F I=1:1:2 D IN,QC
 S ID=+$E(Y(1),1,4),IDE=$E(Y(1),5,13),TRAY=$E(Y(1),14,16),CUP=$E(Y(1),17,18),Y(1)=$E(Y(1),19,256) S:ID=0 ID=CUP
 F I=1:1:14 S V=$P(Y(1),",",I) I V]"" S J=+$E(V,1,2) I I=J,$D(TC(I,1)) S V=+$E(V,3,9) S:V]"" @TC(I,1)=V
 F I=15:1:39 S V=$P(Y(2),",",(I-14)) I V]"" S J=+$E(V,1,2) I I=J,$D(TC(I,1)) S V=+$E(V,3,9) S:V]"" @TC(I,1)=V
 F I=40:1:64 S V=$P(Y(3),",",(I-39)) I V]"" S J=+$E(V,1,2) I I=J,$D(TC(I,1)) S V=+$E(V,3,9) S:V]"" @TC(I,1)=V
LA3 X LAGEN Q:'ISQN
 F I=0:0 S I=$O(TV(I)) Q:I<1  S:TV(I,1)]"" ^LAH(LWL,1,ISQN,I)=TV(I,1)
 G LA2
IN S CNT=^LA(TSK,"I",0)+1 IF '$D(^(CNT)) S TOUT=TOUT+1 Q:TOUT>9  H 5 G IN
 S ^LA(TSK,"I",0)=CNT,IN=^(CNT),TOUT=0
 S:IN["~" CTRL=$P(IN,"~",2),IN=$P(IN,"~",1)
 Q
QC S A=A+1,Y(A)=IN Q
QUIT LOCK ^LA(TSK) H 1 K ^LA(TSK),^LA("LOCK",TSK),^TMP($J),^TMP("LA",$J)
 Q
TRAP D ^LABERR S T=TSK D SET^LAB G @("LA2^"_LANM) ;ERROR TRAP
