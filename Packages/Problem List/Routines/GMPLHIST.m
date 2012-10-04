GMPLHIST ; SLC/MKB/KER -- Problem List Historical data ; 09/13/12
 ;;2.0;Problem List;**7,26,,31,35,260002**;Aug 25, 1994
 ;
 ; External References
 ;   DBIA 10060  ^VA(200
 ;            
AUDET(RETURN,AIFN) ; Returns the audit entry details
 ; RETURN
 ; AIFN - Audit entry IFN
 N NODE,DATE,FLD,PROV,OLD,NEW,ROOT,CHNGE,REASON,LCNT,AUDIT,%
 S %=$$GETADATA^GMPLDAL2(.AUDIT,AIFN)
 Q:$D(AUDIT(0))'>0 0
 S RETURN("DATE")=$$EXTDT^GMPLX(AUDIT(0,2))
 S RETURN("FLD")=AUDIT(0,1),RETURN("FLD")=RETURN("FLD")_U_$$FLDNAME(+RETURN("FLD"))
 S RETURN("PROV")=AUDIT(0,7)
 S:'RETURN("PROV") RETURN("PROV")=AUDIT(0,3)
 S RETURN("PROV")=$$PROVNAME^GMPLEXT(RETURN("PROV"))
 S OLD=AUDIT(0,4)
 S NEW=AUDIT(0,5)
 S RETURN("OLD")=OLD
 S RETURN("NEW")=NEW
 I +RETURN("FLD")=1101 D  Q 1
 . S RETURN("OLDDATE")=$$EXTDT^GMPLX(AUDIT(1,.05))
 . S RETURN("OLDNOTE")=AUDIT(1,.03)
 I (+RETURN("FLD")=.13)!(+RETURN("FLD")=1.07) D  Q 1
 . S RETURN("OLD")=$$EXTDT^GMPLX(OLD)
 . S RETURN("NEW")=$$EXTDT^GMPLX(NEW)
 I +RETURN("FLD")=.01 D  Q 1
 . S RETURN("OLD")=$$ICDCODE^GMPLEXT(OLD)
 . S RETURN("NEW")=$$ICDCODE^GMPLEXT(NEW)
 I +RETURN("FLD")=.05 D  Q 1
 . S RETURN("OLD")=$$NARR^GMPLEXT(OLD)
 . S RETURN("NEW")=$$NARR^GMPLEXT(NEW)
 I +RETURN("FLD")=1.01 D  Q 1
 . S RETURN("OLD")=$$LEXICON^GMPLEXT1(OLD)
 . S RETURN("NEW")=$$LEXICON^GMPLEXT1(NEW)
 I (+RETURN("FLD")=1.04)!(+RETURN("FLD")=1.05) D  Q 1
 . S RETURN("OLD")=$$PROVNAME^GMPLEXT(OLD)
 . S RETURN("NEW")=$$PROVNAME^GMPLEXT(NEW)
 I +RETURN("FLD")=1.06 D  Q 1
 . S RETURN("OLD")=$$SVCNAME^GMPLEXT(OLD)
 . S RETURN("NEW")=$$SVCNAME^GMPLEXT(NEW)
 I +RETURN("FLD")=1.08 D  Q 1
 . S RETURN("OLD")=$$CLINNAME^GMPLEXT(OLD)
 . S RETURN("NEW")=$$CLINNAME^GMPLEXT(NEW)
 Q 1
 ;           
GETHIST(RETURN,GMPIFN) ; Returns all audit entries of the problem
 ; RETURN - By reference, problem history
 ;  RETURN(I)=Audit IFN
 ; GMIFN - Problem IFN
 N VALID,%
 S RETURN=0
 S %=$$VALID^GMPLAPI4(.VALID,GMPIFN)
 I 'VALID D ERRX^GMPLAPIE(.RETURN,"PRBNFND") Q 0
 D GETHIST^GMPLDAL2(.RETURN,GMPIFN)
 S RETURN=1
 Q 1
 ;
GETAUDIT(RETURN,GMPIFN,FIELD,VALUE) ; Returns all audit data of the problem
 ; (optional problem history can be filtered by modified field and his current value)
 ; RETURN - passed by reference
 ;  RETURN(I,0) - audit trail
 ; GMPIFN - Problem IFN
 ; Optional:
 ; FIELD - If is specified, will returns changes only made at this field
 ; VALUE - If both FIELD and VALUE is specified, will returns changes made at FIELD
 ;   and having current value equals with VALUE
 N IDT,PROB,RET,VALID,%
 S RETURN=0
 S %=$$VALID^GMPLAPI4(.VALID,GMPIFN)
 I 'VALID D ERRX^GMPLAPIE(.RETURN,"PRBNFND") Q 0
 D GETAUDIT^GMPLDAL2(.RET,GMPIFN,$G(FIELD),$G(VALUE))
 S IDT=0
 F  S IDT=$O(RET(IDT)) Q:IDT'>0  D
 . S PROB=RET(IDT,0)
 . S FLD=$$FLDNAME(+$P(PROB,U))
 . S RETURN(IDT,0)=+$P(PROB,U)_U_FLD_U_$P(PROB,U,2,7)
 . S:$D(RET(IDT,1)) RETURN(IDT,1)=RET(IDT,1)
 S RETURN=IDT
 Q
 ;
AUDITX(RETURN,GMPIFN,FIELD,VALUE) ; Returns all audit data of the problem
 ; RETURN - passed by reference
 ;  RETURN(I,"FIELD") - Modified field (Field no^Field name)
 ;  RETURN(I,"MODIFIED") - Date modified
 ;  RETURN(I,"MODIFIEDBY") - Who modified the problem (Provider name)
 ;  RETURN(I,"OLD") - Old value of the field
 ;  RETURN(I,"NEW") - New value of the field
 ;  RETURN(I,"REASON") - Reason for change
 ;  RETURN(I,"REQUESTINGBY") - Who requested the change
 ;  RETURN(I,"OLDPROBLEM") - Note details, if a note was changed
 ; GMPIFN - Problem IFN
 ; Optional:
 ; FIELD - If is specified, will returns changes only made at this field
 ; VALUE - If both FIELD and VALUE is specified, will returns changes made at FIELD
 ;   and having current value equals with VALUE
 N IDT,FLD,CNT,RET,%,VALID
 S CNT=0,RETURN=CNT,IDT=0
 S %=$$VALID^GMPLAPI4(.VALID,GMPIFN)
 I 'VALID D ERRX^GMPLAPIE(.RETURN,"PRBNFND") Q 0
 D AUDITX^GMPLDAL2(.RET,GMPIFN,$G(FIELD),$G(VALUE))
 F  S IDT=$O(RET(IDT)) Q:IDT'>0  D
 . S FLD=$$FLDNAME(RET(IDT,1))
 . S CNT=CNT+1
 . S RETURN(CNT,"FIELD")=RET(IDT,1)_U_FLD
 . S RETURN(CNT,"MODIFIED")=$$EXTDT^GMPLX(RET(IDT,2))
 . S RETURN(CNT,"MODIFIEDBY")=$$PROVNAME^GMPLEXT(RET(IDT,3))
 . S RETURN(CNT,"OLD")=RET(IDT,4)
 . S RETURN(CNT,"NEW")=RET(IDT,5)
 . S RETURN(CNT,"REASON")=RET(IDT,6)
 . S RETURN(CNT,"REQUESTINGBY")=$$PROVNAME^GMPLEXT(RET(IDT,7))
 . S:$D(RET(IDT,1101)) RETURN(CNT,"OLDPROBLEM")=RET(IDT,1101)
 S RETURN=CNT
 Q 1
 ;
FLDNAME(NUM) ; Returns Field Name for Display
 N NAME,NM1,NM2,I,J S J=0,NAME="" D NUM(.NM1),ALP(.NM2) S:+($G(NM1(+NUM)))=+NUM J=+NUM
 S:$L($G(NM2(+J))) NAME=$G(NM2(+J))
 Q NAME
ALP(X) ; Alpha Field Names
 S X(.01)="DIAGNOSIS",X(.02)="PATIENT NAME",X(.03)="DATE LAST MODIFIED",X(.04)="CLASS",X(.05)="PROVIDER NARRATIVE"
 S X(.06)="FACILITY",X(.07)="NUMBER",X(.08)="DATE ENTERED",X(.12)="STATUS",X(.13)="DATE OF ONSET",X(1.01)="PROBLEM",X(1.02)="CONDITION"
 S X(1.03)="ENTERED BY",X(1.04)="RECORDING PROVIDER",X(1.05)="RESPONSIBLE PROVIDER",X(1.06)="SERVICE",X(1.07)="DATE RESOLVED"
 S X(1.08)="CLINIC",X(1.09)="DATE RECORDED",X(1.1)="SERVICE CONNECTED",X(1.11)="AGENT ORANGE EXP",X(1.12)="RADIATION EXP",X(1.13)="ENV CONTAMINANTS EXP"
 S X(1.14)="PRIORITY",X(1.15)="HEAD/NECK CANCER",X(1.16)="MIL SEXUAL TRAUMA",X(1.17)="COMBAT VET",X(1.18)="SHAD",X(1101)="NOTE"
 Q
NUM(X) ; Numeric Field Designations
 N FN F FN=.01:.01:.08 S X(+FN)=+FN
 F FN=.12:.01:.13 S X(+FN)=+FN
 F FN=1.01:.01:1.18 S X(+FN)=+FN
 S X(1101)=1101
 Q
 ;
