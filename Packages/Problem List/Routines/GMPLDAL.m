GMPLDAL ; / DATA ACCESS LAYER - DIRECT GLOBALS ACCESS ;02/27/12  12:00
 ;;TBD;Problem List;;02/27/2012
CREATE(GMPDFN,GMPVAMC,GMPFLD,ERT) ; Create new problem
 N GMPIFN,NUM,DATA,I,DA
 S GMPIFN=$$NEWPROB^GMPLSAVE(+GMPFLD(.01),+GMPDFN) Q:GMPIFN'>0 0
 S NUM=$$NEXTNMBR^GMPLSAVE(+GMPDFN,+GMPVAMC)
 S:'NUM NUM=""
 ;   Set Node 0
 S DATA=^AUPNPROB(GMPIFN,0)_U_DT_"^^"_$P(GMPFLD(.05),U)_U_+GMPVAMC_U_+NUM_U_DT_"^^^^"_$P(GMPFLD(.12),U)_U_$P(GMPFLD(.13),U)
 S ^AUPNPROB(GMPIFN,0)=DATA
 ;   Set Node 1
 S DATA=$P(GMPFLD(1.01),U) 
 F I=1.02:.01:1.18 S DATA=DATA_U_$P($G(GMPFLD(+I)),U)
 S ^AUPNPROB(GMPIFN,1)=DATA
 ;   Set X-Refs
 S DIK="^AUPNPROB(",DA=GMPIFN D IX1^DIK
 Q GMPIFN
 ;
DELETE(GMPIFN,GMPROV,ERT) ; Delete a problem
 Q:'$$LOCK(GMPIFN,0,ERT) 0
 D CHGCOND(GMPIFN,"H",GMPROV)
 D UNLOCK(GMPIFN,0)
 Q 1
 ;
DETAIL(GMPIFN,GMPFLD,ERT) ; Return problem details
 ;                
 ; Input   GMPIFN  Pointer to Problem file #9000011
 ;                
 ; Output  GMPFLD Array, passed by reference
 ;
 Q:'$D(^AUPNPROB(GMPIFN,0)) 0
 N GMPL0,GMPL1
 S GMPL0=$G(^AUPNPROB(GMPIFN,0))
 S GMPL1=$G(^(1))
 S GMPFLD(.01)=+$P(GMPL0,U)
 S GMPFLD(.02)=+$P(GMPL0,U,2)
 S GMPFLD(.03)=$P(GMPL0,U,3)
 ;S GMPFLD(.05)=$$PROBTEXT^GMPLX(GMPIFN)
 S GMPFLD(.08)=$P(GMPL0,U,8) ;_U_$P($G(^VA(200,+$P(GMPL1,U,3),0)),U)
 S GMPFLD(.12)=$P(GMPL0,U,12) ;,GMPL("STATUS")=$S(X="A":"ACTIVE",1:"INACTIVE")
 ;S X=$S(X'="A":"",1:$P(GMPL1,U,14)),GMPL("PRIORITY")=$S(X="A":"ACUTE",X="C":"CHRONIC",1:"")
 S GMPFLD(.13)=$P(GMPL0,U,13)
 S GMPFLD(1.03)=+$P(GMPL1,U,3)
 S GMPFLD(1.04)=+$P(GMPL1,U,4)
 S GMPFLD(1.05)=+$P(GMPL1,U,5)
 S GMPFLD(1.08)=+$P(GMPL1,U,8)
 S GMPFLD(1.09)=$P(GMPL1,U,9)
 S GMPFLD(1.10)=$P(GMPL1,U,10)
 S GMPFLD(1.11)=$P(GMPL1,U,11) ;S X=GMPL("EXPOSURE")+1,GMPL("EXPOSURE",X)="AGENT ORANGE",GMPL("EXPOSURE")=X
 S GMPFLD(1.12)=$P(GMPL1,U,12) ;S X=GMPL("EXPOSURE")+1,GMPL("EXPOSURE",X)="RADIATION",GMPL("EXPOSURE")=X
 S GMPFLD(1.13)=$P(GMPL1,U,13) ;S X=GMPL("EXPOSURE")+1,GMPL("EXPOSURE",X)="ENV CONTAMINANTS",GMPL("EXPOSURE")=X
 S GMPFLD(1.14)=$P(GMPL1,U,14)
 S GMPFLD(1.15)=$P(GMPL1,U,15) ;S X=GMPL("EXPOSURE")+1,GMPL("EXPOSURE",X)="HEAD AND/OR NECK CANCER",GMPL("EXPOSURE")=X
 S GMPFLD(1.16)=$P(GMPL1,U,16) ;S X=GMPL("EXPOSURE")+1,GMPL("EXPOSURE",X)="MILITARY SEXUAL TRAUMA",GMPL("EXPOSURE")=X
 S GMPFLD(1.17)=$P(GMPL1,U,17) ;S X=GMPL("EXPOSURE")+1,GMPL("EXPOSURE",X)="COMBAT VET",GMPL("EXPOSURE")=X
 S GMPFLD(1.18)=$P(GMPL1,U,18) ;&(GMPLP'>0) S X=GMPL("EXPOSURE")+1,GMPL("EXPOSURE",X)="SHAD",GMPL("EXPOSURE")=X
 Q 1
 ;
VERIFIED(GMPIFN) ; True if problem already verified
 Q $P(^AUPNPROB(GMPIFN,1),U,2)'="T"
 ;
MKPERM(GMPIFN) ; Make a problem PERMANENT
 D CHGCOND(GMPIFN,"P")
 Q
 ;
CHGCOND(GMPIFN,GMPCOND,GMPROV) ; Change condition flag
 N AUDMSG
 S GMPROV=$G(GMPROV,DUZ)
 S $P(^AUPNPROB(GMPIFN,1),U,2)=GMPCOND
 S AUDMSG=$S(GMPCOND="H":"^P^H^Deleted^",GMPCOND="P":"^T^P^Verified^",1:"^T^")
 S CHNGE=GMPIFN_"^1.02^"_$$HTFM^XLFDT($H)_U_DUZ_AUDMSG_+GMPROV
 D AUDIT^GMPLX(CHNGE,"")
 D DTMOD^GMPLX(GMPIFN)
 Q
 ;
LOCK(GMPIFN,SUB,ERT)
 S SUB=+$G(SUB)
 L +^AUPNPROB(GMPIFN,SUB):1
 I '$T D ERR^GMPLAPIE(ERT,"FILELOCKED") Q 0
 Q 1
 ;
UNLOCK(GMPIFN,SUB)
 L -^AUPNPROB(GMPIFN,SUB)
 Q
 ;
 