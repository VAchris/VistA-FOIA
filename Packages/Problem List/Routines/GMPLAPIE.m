GMPLAPIE ; RGI -- Problem List Error provider; 03/20/12
 ;;2.0;Problem List;**260002**;Aug 25, 1994
ERR(ERT,ERRNO,TEXT) ; Adds error to array
 Q:$G(ERRNO)=""
 N I
 S TEXT=$G(TEXT)
 S:$G(ERT)="" ERT="^TMP(""GMPLERR"",$J)"
 S I=+$G(@ERT)+1
 S @ERT=I
 S @ERT@(I)=ERRNO_U_$$EZBLD^DIALOG($P($T(@ERRNO),";;",2))_TEXT
 Q
 ;
ERRX(RETURN,ERRNO,TEXT) ; adds error to RETURN
 Q:'$D(RETURN)
 Q:'$D(ERRNO)
 S TEXT=$G(TEXT)
 N I
 F I=0:1 Q:$O(RETURN(I))=""
 S RETURN(I)=ERRNO_U_$$EZBLD^DIALOG($P($T(@ERRNO),";;",2))_TEXT
 Q
 ;
ERRTXT(RETURN) ;
 Q $P($G(RETURN(0)),U,2)
 ; 
FIRSTERR(ERT) ; Returns first error text
 S:$G(ERT)="" ERT="^TMP(""GMPLERR"",$J)"
 Q $P($G(@ERT@(1)),U,2)
 ;
ERRTABLE ; Error table
INVPARAM ;;1250000.601;;Invalid parameter value - 
FILELOCK ;;1250000.602;;Record in use. Try again in a few moments.
PRBNFND ;;1250000.603;;Problem not found
PRBDLTD ;;1250000.604;;Problem already deleted
PROVNFND ;;1250000.605;;Provider not found
FACNFND ;;1250000.606;;Facility not found
PRBVRFD ;;1250000.607;;Problem Already Verified
LISTXST ;;1250000.608;;List already exists
LISTNFND ;;1250000.609;;Problem selection list not found
INACTICD ;;1250000.610;;This Selection List contains problems with inactive ICD9 codes associated with them.
LISTUSED ;;1250000.611;;List could not be deleted, 
LOCNFND ;;1250000.612;;Clinic not found
CTGEXIST ;;1250000.613;;Category already exists
PRBINACT ;;1250000.614;;Problem is already inactive!
ICDINACT ;;1250000.615;;Inactive ICD9 code. Edit the problem before adding comments.
CTGNFND ;;1250000.616;;Category not found
CATUSED ;;1250000.617;;Category in use. Could not delete.
INVREC ;;1250000.618;;Invalid record
