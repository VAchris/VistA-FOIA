GMPLBLD1 ; SLC/MKB -- Bld PL Selection Lists cont ;;3/12/03 13:48
 ;;2.0;Problem List;**3,28**;Aug 25, 1994
 ;
 ; This routine invokes IA #3991,#10082
 ;
SEL() ; Select item(s) from list
 N DIR,X,Y,MAX,GRP S GRP=$D(GMPLGRP) ; =1 if editing groups, 0 if lists
 S MAX=$P($G(^TMP("GMPLST",$J,0)),U,1) I MAX'>0 Q "^"
 S DIR(0)="LAO^1:"_MAX,DIR("A")=$$EZBLD^DIALOG(1250000.050,$S('GRP:$$EZBLD^DIALOG(1250000.051),1:$$EZBLD^DIALOG(1250000.052)))
 S:MAX>1 DIR("A")=DIR("A")_" (1-"_MAX_"): "
 S:MAX'>1 DIR("A")=DIR("A")_": ",DIR("B")=1
 S DIR("?")=$$EZBLD^DIALOG(1250000.053,$S('GRP:$$EZBLD^DIALOG(1250000.054),1:$$EZBLD^DIALOG(1250000.055)))
 D ^DIR S:$D(DTOUT)!(X="") Y="^"
 Q Y
 ;
SEL1() ; Select item from list
 N DIR,X,Y,MAX,GRP S GRP=$D(GMPLGRP) ; =1 if editing groups, 0 if lists
 S MAX=$P($G(^TMP("GMPLST",$J,0)),U,1) I MAX'>0 Q "^"
 S DIR(0)="NAO^1:"_MAX_":0"
 D BLD^DIALOG(1250000.058,$S('GRP:$$EZBLD^DIALOG(1250000.051),1:$$EZBLD^DIALOG(1250000.052)),,"DIR(""A"")")
 S:MAX>1 DIR("A")=DIR("A")_" (1-"_MAX_"): "
 S:MAX'>1 DIR("A")=DIR("A")_": ",DIR("B")=1
 D BLD^DIALOG(1250000.059,$S('GRP:$$EZBLD^DIALOG(1250000.056),1:$$EZBLD^DIALOG(1250000.057)),,"DIR(""?"")")
 D ^DIR I $D(DTOUT)!(X="") S Y="^"
 Q Y
 ;
SEQ(NUM) ; Enter/edit seq #, returns new #
 N DIR,X,Y,GRP,MSG S GRP=$D(GMPLGRP) ; =1 if editing groups, 0 if lists
 S DIR(0)="NA^.01:999.99:2"
 S:NUM DIR("B")=NUM
 D BLD^DIALOG(1250000.061,,,"DIR(""A"")")
 D BLD^DIALOG(1250000.060,$S('GRP:$$EZBLD^DIALOG(1250000.072),1:$$EZBLD^DIALOG(1250000.056)),,"DIR(""?"")")
SQ D ^DIR I $D(DTOUT)!(X="^") Q "^"
 I X?1"^".E W $C(7),$$NOJUMP G SQ
 I Y=NUM Q NUM
 I $D(^TMP("GMPLIST",$J,"SEQ",Y)) D  G SQ
 . D EN^DDIOL($C(7),"","!")
 . D BLD^DIALOG(1250000.062,,,"MSG")
 . D EN^DDIOL(.MSG)
 Q Y
 ;
HDR(TEXT) ; Enter/edit group subheader text in list
 N DIR,X,Y S:$L(TEXT) DIR("B")=TEXT
 S DIR(0)="FAO^2:30"
 D BLD^DIALOG(1250000.063,,,"DIR(""A"")")
 D BLD^DIALOG(1250000.064,,,"DIR(""?"")")
 S:$D(DIR("B")) DIR("?",1)=DIR("?")_";",DIR("?")=$$EZBLD^DIALOG(1250000.065)
H1 D ^DIR I $D(DTOUT)!(X="^") Q "^"
 I X?1"^".E W $C(7),$$NOJUMP G H1
 I X="@" Q:$$SURE^GMPLX "" G H1
 Q Y
 ;
TEXT(TEXT) ; Edit problem text
 N DIR,X,Y S:$L(TEXT) DIR("B")=TEXT
 S DIR(0)="FAO^2:80"
 D BLD^DIALOG(1250000.066,,,"DIR(""A"")")
 D BLD^DIALOG(1250000.067,,,"DIR(""?"")")
T1 D ^DIR I $D(DTOUT)!("^"[X) S Y="^" G TQ
 I X?1"^".E W $C(7),$$NOJUMP G T1
 I X="@" G:'$$SURE^GMPLX T1 S Y="@" G TQ
TQ Q Y
 ;
CODE(CODE) ; Enter/edit problem code
 N DIR,X,Y
 S DIR(0)="PAO^ICD9(:QEMZ"
 S:$L(CODE) DIR("B")=CODE
 D BLD^DIALOG(1250000.068,,,"DIR(""A"")")
 D BLD^DIALOG(1250000.069,,,"DIR(""?"")")
 S DIR("S")="I $$STATCHK^ICDAPIU($P(^(0),U),DT)"
C1 D ^DIR I $D(DTOUT)!(X="^") S Y="^" G CQ
 I X?1"^".E W $C(7),$$NOJUMP G C1
 I X="@" G:'$$SURE^GMPLX C1 S Y=""
 S:+Y'>0 Y="" S:+Y>0 Y=Y(0,0)
CQ Q Y
 ;
FLAG(DFLT) ; Edit category flag
 N DIR,X,Y S DIR(0)="YAO",DIR("B")=$S(+DFLT:"YES",1:"NO")
 D BLD^DIALOG(1250000.070,,,"DIR(""A"")")
 D BLD^DIALOG(1250000.071,,,"DIR(""?"")")
F1 D ^DIR I $D(DTOUT)!(X="^") Q "^"
 I X?1"^".E W $C(7),$$NOJUMP G F1
 Q Y
 ;
NOJUMP() ; Message
 Q "   ^-jumping not allowed!"
 ;
RETURN() ; End of page prompt
 N DIR,X,Y
 S DIR(0)="E" D ^DIR
 Q +Y
 ;
TMPIFN() ; Get temporary IFN ("#N") for ^TMP("GMPLIST",$J,)
 N I,LAST S (I,LAST)=0
 F  S I=$O(^TMP("GMPLIST",$J,I)) Q:+I'>0  S:I?1.N1"N" LAST=+I
 S I=LAST+1,I=$E("0000",1,4-$L(I))_I
TMPQ Q I_"N"
 ;
DELETE(IFN) ; Kill entry in ^TMP("GMPLIST",$J,)
 N SEQ,ITEM S ^TMP("GMPLIST",$J,0)=^TMP("GMPLIST",$J,0)-1
 S SEQ=+^TMP("GMPLIST",$J,IFN),ITEM=$P(^TMP("GMPLIST",$J,IFN),U,2),^TMP("GMPLIST",$J,IFN)="@"
 K ^TMP("GMPLIST",$J,"SEQ",SEQ),^TMP("GMPLIST",$J,"PROB",ITEM),^TMP("GMPLIST",$J,"GRP",ITEM)
 K:IFN?1.N1"N" ^TMP("GMPLIST",$J,IFN)
 Q
 ;
RESEQ ; Resequence items
 N SEL,NUM,SEQ,NSEQ,PIECE,IFN,GMPQUIT S VALMBCK=""
 S SEL=$$SEL G:SEL="^" RSQ
 F PIECE=1:1:$L(SEL,",") D  Q:$D(GMPQUIT)  W !
 . S NUM=$P(SEL,",",PIECE) Q:NUM'>0
 . S IFN=$P($G(^TMP("GMPLST",$J,"B",NUM)),U,1) Q:+IFN'>0  S SEQ=$P(^TMP("GMPLIST",$J,IFN),U,1)
 . W !!,$P(^TMP("GMPLIST",$J,IFN),U,3)
 . S NSEQ=$$SEQ(SEQ) I NSEQ="^" S GMPQUIT=1 Q 
 .I SEQ'=NSEQ S ^TMP("GMPLIST",$J,IFN)=NSEQ_U_$P(^TMP("GMPLIST",$J,IFN),U,2,$L(^TMP("GMPLIST",$J,IFN),U)),^TMP("GMPLIST",$J,"SEQ",NSEQ)=IFN,GMPREBLD=1 K ^TMP("GMPLIST",$J,"SEQ",SEQ)
 I $D(GMPREBLD) S VALMBCK="R",GMPLSAVE=1 ; D BUILD in exit action
RSQ S:'VALMCC VALMBCK="R" S VALMSG=$$MSG^GMPLX
 Q
 ;
EDIT ; Edit category display
 N GRPS,NUM,IFN,HDR,FLG,PIECE,GMPQUIT,GMPREBLD S VALMBCK=""
 S GRPS=$$SEL G:GRPS="^" EDQ
 F PIECE=1:1:$L(GRPS,",") D  Q:$D(GMPQUIT)  W !
 . S NUM=$P(GRPS,",",PIECE) Q:NUM'>0
 .S IFN=$P($G(^TMP("GMPLST",$J,"B",NUM)),U,1) Q:+IFN'>0
 . S HDR=$P(^TMP("GMPLIST",$J,IFN),U,3),FLG=$P(^TMP("GMPLIST",$J,IFN),U,4)
 . S HDR=$$HDR(HDR) I HDR="^" S GMPQUIT=1 Q
 . S FLG=$$FLAG(FLG) I FLG="^" S GMPQUIT=1 Q
 . S $P(^TMP("GMPLIST",$J,IFN),U,3,4)=HDR_U_FLG,GMPREBLD=1
 I $D(GMPREBLD) S VALMBCK="R",GMPLSAVE=1 D BUILD^GMPLBLD("^TMP(""GMPLIST"",$J)",GMPLMODE)
EDQ S:'VALMCC VALMBCK="R" S VALMSG=$$MSG^GMPLX
 Q
