GMPLBLCK ;SLC/JFR - check selection list ICD9 codes; 04/12/12
 ;;2.0;Problem List;**28,260002**;Aug 25, 1994
 ;
 ; This routine invokes IA #3990
 Q
CSVPEP ;called from protocol GMPL SELECTION LIST CSV EVENT
 N CAT,LN,LST,LIST,XMSUB,XMTEXT,XMDUZ,XMY
 D CKLISTS,CKCODES
 K ^TMP("GMPLMSG",$J)
 S LN=1
 I $D(^TMP("GMPLSL",$J,"I")) D
 . D BLD^DIALOG(1250000.020,,,"^TMP(""GMPLMSG"","_$J_")")
 . S LN=$O(^TMP("GMPLMSG",$J,999999),-1)+1
 . S LST=0
 . F  S LST=$O(^TMP("GMPLSL",$J,"I",LST)) Q:'LST  D
 .. S ^TMP("GMPLMSG",$J,LN)="   "_^TMP("GMPLSL",$J,"I",LST)
 .. S LN=LN+1
 ;
 I $D(^TMP("GMPLSL",$J,"F")) D  ;no future inact. dates
 . S ^TMP("GMPLMSG",$J,LN)="",LN=LN+1
 . S ^TMP("GMPLMSG",$J,LN)="",LN=LN+1
 . D BLD^DIALOG(1250000.021,,,"^TMP(""GMPLMSG"","_$J_")")
 . S LN=$O(^TMP("GMPLMSG",$J,999999),-1)+1
 . S ^TMP("GMPLMSG",$J,LN)="",LN=LN+1
 . S CAT=0
 . F  S CAT=$O(^TMP("GMPLSL",$J,"F",CAT)) Q:'CAT  D
 .. S ^TMP("GMPLMSG",$J,LN)=$$EZBLD^DIALOG(1250000.022)_$$GET1^DIQ(125.11,CAT,.01)
 .. S LN=LN+1
 .. S ^TMP("GMPLMSG",$J,LN)="",LN=LN+1
 .. S ^TMP("GMPLMSG",$J,LN)=$$EZBLD^DIALOG(1250000.023),LN=LN+1
 .. S ^TMP("GMPLMSG",$J,LN)="",LN=LN+1
 .. N PROB,TXT
 .. S PROB=0
 .. F  S PROB=$O(^TMP("GMPLSL",$J,"F",CAT,PROB)) Q:'PROB  D
 ... S TXT=^TMP("GMPLSL",$J,"F",CAT,PROB)
 ... S ^TMP("GMPLMSG",$J,LN)=$$EZBLD^DIALOG(1250000.024)_$P(TXT,U),LN=LN+1
 ... S ^TMP("GMPLMSG",$J,LN)=$$EZBLD^DIALOG(1250000.025)_$P(TXT,U,2),LN=LN+1
 ... S ^TMP("GMPLMSG",$J,LN)=$$EZBLD^DIALOG(1250000.026)_$P(TXT,U,3),LN=LN+1
 ... S ^TMP("GMPLMSG",$J,LN)=$$EZBLD^DIALOG(1250000.027)_$$FMTE^XLFDT($P(TXT,U,4),2),LN=LN+1
 ... S ^TMP("GMPLMSG",$J,LN)="",LN=LN+1
 .. I '$D(^TMP("GMPLSL",$J,"F",CAT,"L")) Q  ; category not part of lists
 .. S ^TMP("GMPLMSG",$J,LN)="",LN=LN+1
 .. S ^TMP("GMPLMSG",$J,LN)=$$EZBLD^DIALOG(1250000.028),LN=LN+1
 .. S LIST=0
 .. F  S LIST=$O(^TMP("GMPLSL",$J,"F",CAT,"L",LIST)) Q:'LIST  D
 ... S ^TMP("GMPLMSG",$J,LN)="     "_^TMP("GMPLSL",$J,"F",CAT,"L",LIST)
 ... S LN=LN+1
 .. S ^TMP("GMPLMSG",$J,LN)="",LN=LN+1
 .. S ^TMP("GMPLMSG",$J,LN)="",LN=LN+1
 .. Q
 I '$D(^TMP("GMPLSL",$J)) D  ; no problems found
 . S ^TMP("GMPLMSG",$J,LN)=$$EZBLD^DIALOG(1250000.029)
 . S LN=LN+1
 S XMY("G.GMPL CODE SET VERSION UPDATES")=""
 S XMSUB=$$EZBLD^DIALOG(1250000.030)
 S XMDUZ="Code Set Version Install"
 S XMTEXT="^TMP(""GMPLMSG"",$J,"
 D ^XMD
 K ^TMP("GMPLSL",$J),^TMP("GMPLMSG",$J)
 Q
 ;
CSVOPT ; called from option GMPL SELECTION LIST CSV CHECK
 ;
 N %ZIS,POP
 S %ZIS="QM" D ^%ZIS Q:POP
 I $D(IO("Q")) D  D ^%ZISC,HOME^%ZIS Q
 . N ZTRTN,ZTDESC,ZTIO,ZTDTH,ZTSK
 . S ZTDESC=$$EZBLD^DIALOG(1250000.031)
 . S ZTRTN="QUEUE^GMPLBLCK",ZTIO=ION,ZTDTH=$H
 . D ^%ZTLOAD
 . I '$G(ZTSK) D EN^DDIOL($$EZBLD^DIALOG(1250000.032))
 . Q
 ;
QUEUE ; entry point for tasked report
 I $D(ZTQUEUED) S ZTREQ="@"
 U IO
 N CAT,LN,LST,LIST,PAGE,MSG
 D CKLISTS,CKCODES
 S PAGE=1 D PAGE(.PAGE)
 I '$D(^TMP("GMPLSL",$J)) D  ; no problems found
 .  D EN^DDIOL($$EZBLD^DIALOG(1250000.029))
 . I $E(IOST,1,2)="C-" D
 .. N DIR,DTOUT,DIRUT,DUOUT,X,Y
 .. S DIR(0)="E" D ^DIR
 . Q
 ;
 I $D(^TMP("GMPLSL",$J,"I")) D  ; some inactive problem codes
 . D BLD^DIALOG(1250000.020,,,"MSG")
 . S MSG($O(MSG(999999),-1)+1)=""
 . D EN^DDIOL(.MSG)
 . S LST=0
 . F  S LST=$O(^TMP("GMPLSL",$J,"I",LST)) Q:'LST!(PAGE<1)  D
 .. I IOSL-$Y<3 D PAGE(.PAGE) Q:'PAGE
 .. D EN^DDIOL("   "_^TMP("GMPLSL",$J,"I",LST))
 ;
 I $D(^TMP("GMPLSL",$J,"F")) D  ; future inact. dates
 . D PAGE(.PAGE) Q:'PAGE
 . K MSG
 . D BLD^DIALOG(1250000.021,,,"MSG")
 . S MSG($O(MSG(999999),-1)+1)=""
 . D EN^DDIOL(.MSG)
 . S CAT=0
 . F  S CAT=$O(^TMP("GMPLSL",$J,"F",CAT)) Q:'CAT  D
 .. I IOSL-$Y<8 D PAGE(.PAGE) Q:'PAGE
 .. D EN^DDIOL($$EZBLD^DIALOG(1250000.022)_$$GET1^DIQ(125.11,CAT,.01),"","!!!")
 .. D EN^DDIOL($$EZBLD^DIALOG(1250000.033),"","!!")
 .. N PROB,TXT
 .. S PROB=0
 .. F  S PROB=$O(^TMP("GMPLSL",$J,"F",CAT,PROB)) Q:'PROB!(PAGE<1)  D
 ... S TXT=^TMP("GMPLSL",$J,"F",CAT,PROB)
 ... I IOSL-$Y<5 D PAGE(.PAGE) Q:'PAGE
 ... D EN^DDIOL($$EZBLD^DIALOG(1250000.024)_$P(TXT,U))
 ... D EN^DDIOL($$EZBLD^DIALOG(1250000.025)_$P(TXT,U,2))
 ... D EN^DDIOL($$EZBLD^DIALOG(1250000.026)_$P(TXT,U,3))
 ... D EN^DDIOL($$EZBLD^DIALOG(1250000.027)_$P(TXT,U,4))
 .. I '$D(^TMP("GMPLSL",$J,"F",CAT,"L")) Q  ; category not part of lists
 .. I IOSL-$Y<3 D PAGE(.PAGE) Q:'PAGE
 .. D EN^DDIOL($$EZBLD^DIALOG(1250000.028),"","!!")
 .. S LIST=0
 .. F  S LIST=$O(^TMP("GMPLSL",$J,"F",CAT,"L",LIST)) Q:'LIST!(PAGE<1)  D
 ... I IOSL-$Y<3 D PAGE(.PAGE) Q:'PAGE
 ... W !,"     "_^TMP("GMPLSL",$J,"F",CAT,"L",LIST)
 .. Q
 . Q
 D:$E(IOST,1,2)'="C-" ^%ZISC
 D HOME^%ZIS
 K ^TMP("GMPLSL",$J)
 Q
 ;
CKLISTS ; loop lists and see if any inactive problems
 ;
 ; returns ^TMP("GMPLSL",$J,"I"
 ;
 K ^TMP("GMPLSL",$J,"I")
 N LST,RETURN,RET
 S LST=0
 S %=$$GETLSTS^GMPLAPI5(.RETURN)
 F  S LST=$O(RETURN(LST)) Q:'LST  I '$$VALLIST^GMPLAPI6(.RET,RETURN(LST,"ID")) D
 . S ^TMP("GMPLSL",$J,"I",RETURN(LST,"ID"))=RETURN(LST,"NAME")
 . Q
 Q
 ;
CKCODES ; check probs on lists for future inactivation dates
 ;
 ; returns:
 ;   ^TMP("GMPLSL",$J,"F",category,problem)
 ;   ^TMP("GMPLSL",$J,"F",category,"L",list)
 ;
 N RETURN
 K ^TMP("GMPLSL",$J,"F")
 D GETFINC^GMPLAPI6(.RETURN)
 M ^TMP("GMPLSL",$J,"F")=RETURN
 Q
 ;
PAGE(NUM) ;print header and raise page number
 Q:'$G(NUM)
 I NUM'=1,$E(IOST,1,2)="C-" D  Q:'NUM
 . N DIR,DTOUT,DIRUT,DUOUT,X,Y
 . S DIR(0)="E" D ^DIR
 . I $D(DTOUT)!($D(DUOUT)) S NUM=0
 W @IOF
 D EN^DDIOL($$EZBLD^DIALOG(1250000.034))
 D EN^DDIOL($$EZBLD^DIALOG(1250000.035)_NUM,"","?70")
 D EN^DDIOL($$REPEAT^XLFSTR("-",78))
 S NUM=NUM+1
 Q
