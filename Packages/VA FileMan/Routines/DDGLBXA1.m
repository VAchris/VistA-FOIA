DDGLBXA1 ;SFISC/MKO-SINGLE SELECTION LIST BOX ;11:33 AM  26 Apr 1996
 ;;22.0;VA FileMan;;Mar 30, 1999
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
 N DDGLQT,Y
 D CUP(DDGLLINE,1)
 ;
 S DDGLQT=0
 F  S Y=$$READ D  Q:DDGLQT
 . I Y'[U,$T(@Y)="" W $C(7) Q
 . D @Y
 . D:$G(DDGLKEY("KMAP","KD"))]"" @DDGLKEY("KMAP","KD")
 ;
 S:$P(DDGLQT,U,2,999)]"" DDGLOUT("C")=$P(DDGLQT,U,2,999)
 Q
 ;
UP ;Move up
 I DDGLLINE>1 D
 . D CUP(DDGLLINE,1)
 . W $E(DDGLSEL,1,DDGLNC)
 . S DDGLLINE=DDGLLINE-1
 . S DDGLSEL=DDGLITEM(DDGLLINE)
 . ;
 . D CUP(DDGLLINE,1)
 . W $P(DDGLVID,DDGLDEL,6)_$E(DDGLSEL,1,DDGLNC)_$P(DDGLVID,DDGLDEL,10)
 ;
 E  D
 . N DDGLE
 . D SHIFTDN(1,.DDGLE) Q:$G(DDGLE)
 . S DDGLSEL=DDGLITEM(1)
 . D DISP(DDGLSEL)
 Q
 ;
DN ;Move down
 I DDGLLINE<DDGLNL D
 . Q:DDGLITEM(DDGLLINE+1)=""
 . D CUP(DDGLLINE,1)
 . W $E(DDGLSEL,1,DDGLNC)
 . S DDGLLINE=DDGLLINE+1
 . S DDGLSEL=DDGLITEM(DDGLLINE)
 . ;
 . D CUP(DDGLLINE,1)
 . W $P(DDGLVID,DDGLDEL,6)_$E(DDGLSEL,1,DDGLNC)_$P(DDGLVID,DDGLDEL,10)
 ;
 E  D
 . N DDGLE
 . D SHIFTUP(1,.DDGLE) Q:$G(DDGLE)
 . S DDGLSEL=DDGLITEM(DDGLNL)
 . D DISP(DDGLSEL)
 Q
 ;
PUP ;Page up in list
 I DDGLLINE>1 D
 . D CUP(DDGLLINE,1)
 . W $E(DDGLSEL,1,DDGLNC)
 . S DDGLLINE=1,DDGLSEL=DDGLITEM(1)
 . D CUP(1,1)
 . W $P(DDGLVID,DDGLDEL,6)_$E(DDGLSEL,1,DDGLNC)_$P(DDGLVID,DDGLDEL,10)
 ;
 E  D
 . N DDGLE
 . D SHIFTDN(DDGLNL,.DDGLE) Q:$G(DDGLE)
 . S DDGLSEL=DDGLITEM(1)
 . D DISP(DDGLSEL)
 Q
 ;
PDN ;Page down in list
 I DDGLLINE<DDGLNL D
 . D CUP(DDGLLINE,1)
 . W $E(DDGLSEL,1,DDGLNC)
 . F DDGLLINE=DDGLNL:-1:1 Q:DDGLITEM(DDGLLINE)]""
 . S DDGLSEL=DDGLITEM(DDGLLINE)
 . D CUP(DDGLLINE,1)
 . W $P(DDGLVID,DDGLDEL,6)_$E(DDGLSEL,1,DDGLNC)_$P(DDGLVID,DDGLDEL,10)
 ;
 E  D
 . N DDGLE
 . D SHIFTUP(DDGLNL,.DDGLE) Q:$G(DDGLE)
 . S DDGLSEL=DDGLITEM(DDGLNL)
 . D DISP(DDGLSEL)
 Q
 ;
TOP ;Move to top of list
 N DDGLFRST,DDGLI,DDGLT
 ;
 ;Check whether first item in list is the first displayed
 S DDGLFRST=$O(@DDGLGLO@(""))
 I DDGLFRST=DDGLITEM(1) D:DDGLLINE>1 PUP Q
 ;
 ;Fill DDGLITEM array
 S DDGLT=DDGLFRST
 F DDGLI=1:1:DDGLNL D
 . S DDGLITEM(DDGLI)=DDGLT
 . S:DDGLT]"" DDGLT=$O(@DDGLGLO@(DDGLT))
 ;
 S DDGLLINE=1,DDGLSEL=DDGLITEM(1)
 D DISP(DDGLSEL)
 Q
 ;
BOT ;Move to bottom of list
 N DDGLAST,DDGLI,DDGLT,DDGLIND
 ;
 ;Set DDGLIND = index of last non-null DDGLITEM
 F DDGLIND=DDGLNL:-1:1 Q:DDGLITEM(DDGLIND)]""
 ;
 S DDGLAST=$O(@DDGLGLO@(""),-1)
 I DDGLAST=DDGLITEM(DDGLIND) D:DDGLLINE<DDGLIND PDN Q
 ;
 ;Fill DDGLITEM array
 S DDGLT=DDGLAST
 F DDGLI=DDGLNL:-1:1 D
 . S DDGLITEM(DDGLI)=DDGLT
 . S DDGLT=$O(@DDGLGLO@(DDGLT),-1)
 ;
 S DDGLLINE=DDGLNL,DDGLSEL=DDGLITEM(DDGLNL)
 D DISP(DDGLSEL)
 Q
 ;
SEL ;Select item
 K DDGLOUT
 S DDGLOUT=$O(@DDGLGLO@(DDGLSEL,"")),DDGLOUT(0)=DDGLSEL
 S DDGLOUT("C")="SEL"
 S DDGLQT=1
 Q
 ;
QT ;Quit
 K DDGLOUT
 S DDGLOUT=-1,DDGLOUT(0)="",DDGLOUT("C")="QT"
 S DDGLQT=1
 Q
 ;
TO ;Timeout
 D:$G(DDGLKEY("KMAP","TO"))]"" @DDGLKEY("KMAP","TO")
 K DDGLOUT
 S DDGLOUT=-1,DDGLOUT(0)="",DDGLOUT("C")="TO"
 S DDGLQT=1
 Q
 ;
READ() ;Read next key and return mnemonic
 N S,Y
 F  R *Y:DTIME D C Q:Y'=-1
 Q Y
 ;
C I Y<0 S Y="TO" Q
 S S=""
C1 S S=S_$C(Y)
 I DDGLKEY("KMAP","IN")'[(U_S) D  I Y=-1 W $C(7) D FLUSH Q
 . I $C(Y)'?1L S Y=-1 Q
 . S S=$E(S,1,$L(S)-1)_$C(Y-32) S:DDGLKEY("KMAP","IN")'[(U_S_U) Y=-1
 ;
 I DDGLKEY("KMAP","IN")[(U_S_U),S'=$C(27) S Y=$P(DDGLKEY("KMAP","OUT"),";",$L($P(DDGLKEY("KMAP","IN"),U_S_U),U)) Q
 R *Y:5 G:Y'=-1 C1
 W $C(7)
 Q
 ;
SHIFTDN(DDGLN,DDGLE) ;Shift DDGLITEM array down DDGLN times
 ;Out:  DDGLE = 1, if no more items above
 ;
 N DDGLI,DDGLT,DDGLA
 S DDGLE=0
 S DDGLT=DDGLITEM(1) I DDGLT="" S DDGLE=1 Q
 ;
 F DDGLI=-1:-1:-DDGLN S DDGLT=$O(@DDGLGLO@(DDGLT),-1) Q:DDGLT=""  D
 . S DDGLA(DDGLI)=DDGLT
 S:DDGLT="" DDGLI=DDGLI+1
 I DDGLI=0 S DDGLE=1 Q
 S DDGLN=-DDGLI
 ;
 F DDGLI=DDGLNL:-1:DDGLN+1 S DDGLITEM(DDGLI)=DDGLITEM(DDGLI-DDGLN)
 F DDGLI=DDGLN:-1:1 S DDGLITEM(DDGLI)=DDGLA(DDGLI-DDGLN-1)
 Q
 ;
SHIFTUP(DDGLN,DDGLE) ;Shift DDGLITEM array down DDGLN times
 ;Out:  DDGLE = 1, if no more items above
 ;
 N DDGLI,DDGLT,DDGLA
 S DDGLE=0
 S DDGLT=DDGLITEM(DDGLNL) I DDGLT="" S DDGLE=1 Q
 ;
 F DDGLI=1:1:DDGLN S DDGLT=$O(@DDGLGLO@(DDGLT)) Q:DDGLT=""  D
 . S DDGLA(DDGLI)=DDGLT
 S:DDGLT="" DDGLI=DDGLI-1
 I DDGLI=0 S DDGLE=1 Q
 S DDGLN=DDGLI
 ;
 F DDGLI=1:1:DDGLNL-DDGLN S DDGLITEM(DDGLI)=DDGLITEM(DDGLI+DDGLN)
 F DDGLI=DDGLNL-DDGLN+1:1:DDGLNL S DDGLITEM(DDGLI)=DDGLA(DDGLI-DDGLNL+DDGLN)
 Q
 ;
DISP(DDGLSEL) ;Display the list
 ;In: DDGLSEL = text of selected item
 ;
 N DDGLI,DDGLT
 F DDGLI=1:1:DDGLNL D
 . D CUP(DDGLI,1)
 . S DDGLT=$E(DDGLITEM(DDGLI),1,DDGLNC)
 . S DDGLT=$S(DDGLT=DDGLSEL:$P(DDGLVID,DDGLDEL,6)_DDGLT_$P(DDGLVID,DDGLDEL,10),1:DDGLT)_$J("",DDGLNC-$L(DDGLT))
 . W DDGLT
 Q
 ;
FLUSH ;Flush read buffer
 N DDGLX
 F  R *DDGLX:0 E  Q
 Q
 ;
CUP(Y,X) ;Position cursor relative to list coords
 S DY=DDGLROW+Y,DX=DDGLCOL+X+1 X IOXY
 Q
