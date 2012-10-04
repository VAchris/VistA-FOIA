GMPLHS ; SLC/MKB/KER - Extract Prob List Health Summary ; 09/17/12
 ;;2.0;Problem List;**22,26,35,260002**;Aug 25, 1994
 ;
 ; External References
 ;   DBIA  3106  ^DIC(49
 ;   DBIA 10060  ^VA(200
 ;   DBIA 10015  EN^DIQ1
 ;                    
GETLIST(GMPDFN,STATUS) ; Define List 
 N GMPLIST,GMPLVIEW,GMPARAM,GMPTOTAL K ^TMP("GMPLHS",$J) Q:+GMPDFN'>0
 D GET^GMPLSITE(.GMPARAM) S GMPARAM("QUIET")=1
 S GMPLVIEW("ACT")=STATUS,GMPLVIEW("PROV")=0,GMPLVIEW("VIEW")=""
 D GETPLIST^GMPLMGR1(.GMPLIST,.GMPTOTAL,.GMPLVIEW)
BUILD ; Build list for selected patient
 ;   Sets Global Array:
 ;   ^TMP("GMPLHS",$J,STATUS,0)
 ;                  
 ;   Piece 1:  GMPCNT     # of entries extracted
 ;         2:  GMPTOTAL   # of entries that exist
 N IFN,GMPCNT,NUM S (NUM,GMPCNT)=0 F  S NUM=$O(GMPLIST(NUM)) Q:NUM'>0  D
 . S IFN=+GMPLIST(NUM) Q:IFN'>0  D GETPROB(IFN)
 I $G(GMPCNT)'>0 K ^TMP("GMPLHS",$J) Q
 S ^TMP("GMPLHS",$J,STATUS,0)=GMPCNT_U_GMPTOTAL
 Q
GETPROB(IFN) ; Get problem data and set it to ^TMP array
 ;   Sets Global Arrays:
 ;   ^TMP("GMPLHS",$J,CNT,0)
 ;   Piece 1:  Pointer to ICD9 file #80
 ;         2:  Internal Date Last Modified
 ;         3:  Facility Name
 ;         4:  Internal Date Entered
 ;         5:  Internal Status (A/I/"")
 ;         6:  Internal Date of Onset
 ;         7:  Responsible Provider Name
 ;         8:  Service Name
 ;         9:  Service Abbreviation
 ;        10:  Internal Date Resolved
 ;        11:  Clinic Name
 ;        12:  Internal Date Recorded
 ;        13:  Problem Term (from Lexicon)
 ;        14:  Exposure String (AO/IR/EC/HNC/MST/CV/SHD)
 ;                        
 ;   ^TMP("GMPLHS",$J,CNT,"N")
 ;   Piece 1:  Provider Narrative
 ;                   
 ;   ^TMP("GMPLHS",$J,CNT,"IEN")
 ;   Piece 1:  Pointer to Problem file 9000011
 ;                   
 N DIC,DIQ,DR,DA,REC,DIAG,LASTMDT,NARR,SITE,ENTDT,STAT,ONSETDT,RPROV
 N SERV,SERVABB,RESDT,CLIN,RECDT,LEXI,LEX,PG,AO,EXP,HNC,MST,CV,SHD,IR,SCS
 N %,PRB
 S %=$$DETAIL^GMPLAPI2(.PRB,IFN)
 S DIAG=$P(PRB(.01),U),LASTMDT=$P(PRB(.03),U)
 S NARR=$P(PRB(.05),U,2),SITE=$P(PRB(.06),U,2)
 S ENTDT=$P(PRB(.08),U),STAT=$P(PRB(.12),U)
 S ONSETDT=$P(PRB(.13),U)
 S LEXI=$P(PRB(1.01),U)
 S LEX=$P(PRB(1.01),U,2)
 S RPROV=$P(PRB(1.05),U,2)
 S SERV=$P(PRB(1.06),U,2)
 S SERVABB=$$SERV($P(PRB(1.06),U),SERV)
 S RESDT=$P(PRB(1.07),U)
 S CLIN=$P(PRB(1.08),U,2)
 S RECDT=$P(PRB(1.09),U)
 S AO=+$P(PRB(1.11),U)
 S IR=+$P(PRB(1.12),U)
 S PG=+$P(PRB(1.13),U)
 S HNC=+$P(PRB(1.15),U)
 S MST=+$P(PRB(1.16),U)
 S CV=+$P(PRB(1.17),U)
 S SHD=+$P(PRB(1.18),U)
 K SCS D SCS^GMPLX1(DA,.SCS) S EXP=$G(SCS(1))
 S GMPCNT=GMPCNT+1,^TMP("GMPLHS",$J,GMPCNT,0)=DIAG_U_LASTMDT_U_SITE_U_ENTDT_U_STAT_U_ONSETDT_U_RPROV_U_SERV_U_SERVABB_U_RESDT_U_CLIN_U_RECDT_U_LEX_U_EXP
 S ^TMP("GMPLHS",$J,GMPCNT,"N")=NARR,^TMP("GMPLHS",$J,GMPCNT,"IEN")=IFN
 S:+LEXI>0 ^TMP("GMPLHS",$J,GMPCNT,"L")=LEXI_"^"_LEX
 D GETCOMM(IFN,GMPCNT)
 Q
GETCOMM(IFN,CNT) ; Get Active Comments for a Note
 ;   Sets Global Array:
 ;   ^TMP("GMPLHS",$J,CNT,"C",LOCATION,NOTE NMBR,0)
 ;                     
 ;   Piece 1:  Note Narrative
 ;         2:  Internal Date Note Added 
 ;         3;  Name of Note's Author 
 ;                        
 N %,NTE,LOC,NIFN
 S %=$$NOTES^GMPLAPI3(.NTE,IFN,1,4)
 S LOC=0
 F  S LOC=$O(NTE(LOC)) Q:LOC'>0  D
 . S NIFN=0
 . F  S NIFN=$O(NTE(LOC,NIFN)) Q:NIFN'>0  D
 . . S ^TMP("GMPLHS",$J,CNT,"C",LOC,NIFN,0)=$P(NTE(LOC,NIFN),U,3)_U_$P(NTE(LOC,NIFN),U,5)_U_$P(NTE(LOC,NIFN),U,6)
 Q
SERV(X,SERV) ; Returns Service Name Abbreviation
 N ABBREV S ABBREV=$$SVCABBV^GMPLEXT(+X) S:ABBREV="" ABBREV=$E($G(SERV),1,5)
 Q ABBREV
