GMPLDAL3 ; RGI/CBR DATA ACCESS LAYER - DIRECT GLOBALS ACCESS ; 09/13/12
 ;;2.0;Problem List;**260002**;Aug 25, 1994
NOTES(RETURN,GMPIFN,GMPFMT,GMPACT,GMPVAMC,GMPROV) ;Returns Problem notes
 ;.RETURN    (R) Data array
 ;           RETURN=number of notes returned
 ;           RETURN(#)=data (formatted according to GMPFMT)
 ;GMPIFN     (R) Problem IFN
 ;GMPFMT     (R) Format
 ;           1 -- RETURN(#)=note_narrative
 ;           2 -- RETURN(#)=date_note_added^author^note_narrative
 ;           3 -- RETURN(#)=note_nmbr^facility^note_narrative^status^date_note_added^author
 ;           4 -- RETURN(facility,note_nmbr)=note_nmbr^^note_narrative^status^date_note_added^author
 ;GMPACT     (O) 1=Active only, Default=ALL
 ;GMPVAMC    (O) Only notes from that facility, Default=Multi_divisional
 ;GMPROV     (O) Only notes from that provider, Default=ALL
 K RETURN S RETURN=0
 Q:$D(^AUPNPROB(GMPIFN,11))'>0
 S GMPFMT=$G(GMPFMT,1)
 I (GMPFMT<1)!(GMPFMT>4) S GMPFMT=1
 N FAC,CNT,NIFN,X
 S (FAC,CNT)=0
 F  S FAC=$O(^AUPNPROB(GMPIFN,11,FAC)) Q:+FAC'>0  D
 . I +$G(GMPVAMC)'=0,FAC'=$O(^AUPNPROB(GMPIFN,11,"B",GMPVAMC,0)) Q
 . S NIFN=0
 . F  S NIFN=$O(^AUPNPROB(GMPIFN,11,FAC,11,NIFN)) Q:NIFN'>0  D
 . . S X=$G(^AUPNPROB(GMPIFN,11,FAC,11,NIFN,0))
 . . I +$G(GMPACT),$P(X,U,4)'="A" Q
 . . I +$G(GMPROV)>0,$P(X,U,6)'=+GMPROV Q
 . . S CNT=CNT+1
 . . S:GMPFMT=1 RETURN(CNT)=$P(X,U,3)
 . . S:GMPFMT=2 RETURN(CNT)=$$EXTDT^GMPLX($P(X,U,5))_U_$$PROVNAME^GMPLEXT($P(X,U,6))_U_$P(X,U,3)
 . . S:GMPFMT=4 RETURN(+$G(^AUPNPROB(GMPIFN,11,FAC,0)),$P(X,U))=X
 . . I GMPFMT=3 S $P(X,U,2)=FAC,RETURN(CNT)=X
 S RETURN=CNT
 Q
 ;
NEWNOTE(GMPIFN,GMPVAMC,GMPROV,NOTES) ;
 N FAC,HDR,LAST,TOTAL,NIFN
 S FAC=+$O(^AUPNPROB(GMPIFN,11,"B",GMPVAMC,0))
 I 'FAC D
 . S:'$D(^AUPNPROB(GMPIFN,11,0)) ^(0)="^9000011.11PA^^"
 . S HDR=^AUPNPROB(GMPIFN,11,0)
 . S LAST=$P(HDR,"^",3)
 . S TOTAL=$P(HDR,"^",4)
 . F I=(LAST+1):1 Q:'$D(^AUPNPROB(GMPIFN,11,I,0))
 . S ^AUPNPROB(GMPIFN,11,I,0)=GMPVAMC
 . S ^AUPNPROB(GMPIFN,11,"B",GMPVAMC,I)=""
 . S FAC=I
 . S $P(^AUPNPROB(GMPIFN,11,0),U,3,4)=FAC_"^"_(TOTAL+1)
 I FAC>0 D
 . S:'$D(^AUPNPROB(GMPIFN,11,FAC,11,0)) ^(0)="^9000011.1111IA^^"
 . S HDR=^AUPNPROB(GMPIFN,11,FAC,11,0)
 . S LAST=$P(HDR,U,3)
 . S TOTAL=$P(HDR,U,4)
 . F I=(LAST+1):1 Q:'$D(^AUPNPROB(GMPIFN,11,FAC,11,I,0))
 . S NIFN=I
 . F I=0:0 S I=$O(NOTES(I)) Q:I'>0  D
 . . S ^AUPNPROB(GMPIFN,11,FAC,11,NIFN,0)=NIFN_"^^"_NOTES(I)_"^A^"_DT_U_+$G(GMPROV)
 . . S ^AUPNPROB(GMPIFN,11,FAC,11,"B",NIFN,NIFN)=""
 . . S TOTAL=TOTAL+1,LAST=NIFN,NIFN=NIFN+1
 . S $P(^AUPNPROB(GMPIFN,11,FAC,11,0),U,3,4)=LAST_U_TOTAL
 Q
 ;
HASNOTE(GMPIFN) ;
 Q $D(^AUPNPROB(GMPIFN,11,0))>0
MODIFIED(GMPDFN) ; Return the Date the Patients Problem List was Last Modified
 Q +$O(^AUPNPROB("MODIFIED",GMPDFN,0))
LASTMOD(GMPIFN) ; last modified date
 Q $P(^AUPNPROB(GMPIFN,0),U,3)
PRBCNT() ;Return number of entries in PROBLEM LIST.
 Q $P(^AUPNPROB(0),U,4)
HASPRBS(GMPDFN,GMPSTAT) ; Returns 1 if patient DFN has problems with status GMPSTAT
 I GMPSTAT["A",$D(^AUPNPROB("ACTIVE",GMPDFN,"A")) Q 1
 I GMPSTAT["I",$D(^AUPNPROB("ACTIVE",GMPDFN,"I")) Q 1
 Q 0
GETPARM(RETURN) ;Gets site parameters
 N X
 S X=$G(^GMPL(125.99,1,0))
 S RETURN("VER")=$P(X,"^",2)
 S RETURN("PRT")=$P(X,"^",3)
 S RETURN("CLU")=$P(X,"^",4)
 S RETURN("REV")=$P(X,"^",5)
 S RETURN("SDP")=$P(X,"^",6)
 Q 1
 ;
SETPARM(PARAMS) ;Sets site parameters
 N FDAROOT
 S:$D(PARAMS("VER")) FDAROOT(125.99,"1,",1)=PARAMS("VER")
 S:$D(PARAMS("PRT")) FDAROOT(125.99,"1,",2)=PARAMS("PRT")
 S:$D(PARAMS("CLU")) FDAROOT(125.99,"1,",3)=PARAMS("CLU")
 S:$D(PARAMS("REV")) FDAROOT(125.99,"1,",4)=PARAMS("REV")
 S:$D(PARAMS("SDP")) FDAROOT(125.99,"1,",6)=PARAMS("SDP")
 D FILE^DIE("K","FDAROOT")
 Q
 ;
