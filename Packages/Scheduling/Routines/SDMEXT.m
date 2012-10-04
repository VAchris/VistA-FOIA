SDMEXT ;RGI/CBR - EXTERNAL API; 10/01/2012
 ;;5.3;scheduling;**260003**;08/13/93
CNSSTAT(IFN) ; Get consult status
 Q $P($G(^GMR(123,IFN,0)),U,12)
 ;
GETMOVDT(IFN) ; Get patient movement
 Q +$G(^DGPM(IFN,0))
 ;
HASMOV(DFN) ; Has movement?
 Q $D(^DGPM("C",DFN))
 ;
LSTSADM(RETURN,DFN,SD,CAN) ; Get scheduled admissions
 N LST,FLDS
 D LSTSADM1(.LST,5,.SD,.CAN)
 S FLDS(13)="CANCEL DT",FLDS(2)="DATE"
 D BLDLST^SDMAPI(.RETURN,.LST,.FLDS)
 Q 1
LSTSADM1(RETURN,DFN,SD,CAN) ; Get scheduled admissions
 N FILE,FIELDS,RET,SCR
 S FILE="41.1",FIELDS="@;.01;2IE;3IE;4IE;5IE;13IE"
 S:$D(START)=0 START="" S:$D(SEARCH)=0 SEARCH=""
 S ST="I ",SEP=""
 I $D(SD(0)) S SCR="$P(^(0),U,2)'<SD(0)",SEP=","
 I $D(SD(1)) S SCR=SCR_SEP_"$P(^(0),U,2)'>SD(1)",SEP=","
 I $D(CAN) S SCR=SCR_SEP_"$S(CAN=0:'$P(^(0),U,13),1:$P(^(0),U,13))",SEP=","
 S:$L(SEP)>0 SCR=ST_SCR
 D LIST^DIC(FILE,"",FIELDS,"",$G(NUMBER),.START,SEARCH,"B",.SCR,"","RETURN")
 Q
