GMPL1 ; SLC/MKB/AJB -- Problem List actions ; 04/22/03
 ;;2.0;Problem List;**3,20,28**;Aug 25, 1994
 ; 10 MAR 2000 - MA - Added to the routine another user prompt
 ; to backup and refine Lexicon search if ICD code 799.9
ADD ;add new entry to list - Requires GMPDFN
 N GMPROB,GMPTERM,GMPICD,Y,DUP,GMPIFN,GMPFLD
 W !
 S GMPROB=$$TEXT^GMPLEDT4("") I GMPROB="^" S GMPQUIT=1 Q
 I 'GMPARAM("CLU")!('$D(GMPLUSER)&('$$HASKEY^GMPLEXT("GMPL ICD CODE"))) S GMPTERM="",GMPICD="799.9" G ADD1
 F  D  Q:$D(GMPQUIT)!(+$G(Y))
 . D SEARCH^GMPLX(.GMPROB,.Y,"PROBLEM: ","1")
 . I +Y'>0 S GMPQUIT=1 Q
 . D DUPL^GMPLAPI2(.DUP,+GMPDFN,+Y,GMPROB)
 . I DUP,'$$DUPLOK^GMPLX(DUP) S (Y,GMPROB)=""
 . I +Y=1 D ICDMSG
 Q:$D(GMPQUIT)
 S GMPTERM=$S(+$G(Y)>1:Y,1:""),GMPICD=$G(Y(1))
 S:'$L(GMPICD) GMPICD="799.9"
ADD1 ; set up default values
 ; -- May enter here with GMPROB=text,GMPICD=code,GMPTERM=#^term
 ; added for Code Set Versioning (CSV)
 N OK,GMPI,GMPFLD,GMPELIG
 D ELIG(.GMPELIG)
 I '$$DEFAULT^GMPLAPI4(.GMPFLD,GMPROB,GMPICD,GMPTERM,$G(GMPROV),$G(GMPCLIN),.GMPELIG) D  H 3 Q
 . W !,GMPROB,!,$$ERRTXT^GMPLAPIE(.GMPFLD)
 K GMPLJUMP
ADD2 ; prompt for values
 D FLDS^GMPLEDT3 ; set GMPFLD("FLD") of editable fields
 F GMPI=2:1:7 D @(GMPFLD("FLD",GMPI)_"^GMPLEDT1") Q:$D(GMPQUIT)  K GMPLJUMP ; cannot ^-jump here
 Q:$D(GMPQUIT)
ADD3 ; Ok to save?
 S OK=$$ACCEPT^GMPLDIS1(.GMPFLD),GMPLJUMP=0 ; ok to save values?
 I OK="^" W !!?10,"< Nothing Saved !! >",! S GMPQUIT=1 H 1 Q
 I OK D  Q  ; ck DA for error?
 . N I
 . W !!,"Saving ..."
 . I '$$NEW^GMPLAPI2(.GMPIFN,GMPDFN,GMPROV,.GMPFLD) W $$ERRTXT^GMPLAPIE(.GMPIFN) G ADD4
 . S I=$S(GMPLIST(0)'>0:1,GMPARAM("REV"):$O(GMPLIST(0))-.01,1:GMPLIST(0)+1)
 . S GMPLIST(I)=GMPIFN,GMPLIST("B",GMPIFN)=I,GMPLIST(0)=$G(GMPLIST(0))+1
 . S GMPSAVED=1
 . W " done."
ADD4 ; Not ok -- edit values, ask again
 F GMPI=1:1:GMPFLD("FLD",0) D @(GMPFLD("FLD",GMPI)_"^GMPLEDT1") Q:$D(GMPQUIT)!($D(GMPSAVED))  I $G(GMPLJUMP) S GMPI=GMPLJUMP-1 S GMPLJUMP=0 ; reset GMPI to desired fld
 Q:$D(DTOUT)  K GMPQUIT,DUOUT G ADD3
 Q
 ;
 ; *********************************************************************
 ; *  GMPIFN expected for the following calls:
 ;
STATUS(GMPIFN,GMPROV,GMPVAMC,GMPSAVED,ERT) ; -- inactivate problem
 N PROBTEXT,GMPFLD,PROMPT,DEFAULT,DELETED,ACTIVE,ONSET,RETURN
 S PROBTEXT=$$PROBTEXT^GMPLX(GMPIFN)
 D ACTIVE^GMPLAPI2(.ACTIVE,GMPIFN)
 I 'ACTIVE D ERR^GMPLAPIE(ERT,"PRBINACT"," ("_PROBTEXT_")") Q 0
 D DELETED^GMPLAPI2(.DELETED,GMPIFN)
 I DELETED D ERR^GMPLAPIE(ERT,"PRBDLTD"," ("_PROBTEXT_")") Q 0
 D ONSET^GMPLAPI2(.ONSET,GMPIFN)
 S GMPFLD(.13)=ONSET
 W !!,PROBTEXT
 D RESOLVED^GMPLEDT4 Q:$D(GMPQUIT) 0
 S PROMPT="COMMENT (<60 char): ",DEFAULT="" D EDNOTE^GMPLEDT4 Q:$D(GMPQUIT) 0
 W !
 D INACTV^GMPLAPI2(.RETURN,GMPIFN,$G(GMPROV),Y,$G(GMPFLD(1.07)))
 W "... inactivated!",!
 H 1
 S GMPSAVED=1
 Q 1
 ;
NEWNOTE(RETURN,GMPIFN,GMPROV) ; -- add a new comment
 N GMPFLD,NOTES,GMPQUIT,ICDACTV
 W !!,$$PROBTEXT^GMPLX(GMPIFN)
 D CODESTS^GMPLAPI2(.ICDACTV,GMPIFN,DT)
 I 'ICDACTV W !,"is inactive.  Edit the problem before adding comments.",! H 2 Q 0
 D NOTE^GMPLEDT1
 Q:$D(GMPQUIT)!($D(GMPFLD(10,"NEW"))'>9) 0
 M NOTES=GMPFLD(10,"NEW")
 Q $$NEWNOTE^GMPLAPI3(.RETURN,GMPIFN,GMPROV,.NOTES)
 ;
DELETE(RETURN,GMPIFN,GMPROV,GMPSAVED) ; -- delete a problem
 N PROMPT,DEFAULT,X,Y,SAVED,DELETED
 W !!,$$PROBTEXT^GMPLX(GMPIFN)
 D DELETED^GMPLAPI2(.DELETED,GMPIFN)
 I DELETED D ERRX^GMPLAPIE(.RETURN,"PRBDLTD") H 2 Q 0
 S PROMPT="REASON FOR REMOVAL: ",DEFAULT=""
 D EDNOTE^GMPLEDT4 Q:$D(GMPQUIT) 0 W !
 S SAVED=$$DELETE^GMPLAPI2(.RETURN,GMPIFN,GMPROV,Y)
 W:SAVED "...... removed!"
 W ! H 1
 S:SAVED GMPSAVED=1
 Q SAVED
 ;
VERIFY ; -- verify a transcribed problem, if parameter on
 N GMPERR
 W !!,$$PROBTEXT^GMPLX(GMPIFN),!
 S GMPSAVED=$$VERIFY^GMPLAPI2(.GMPERR,GMPIFN)
 W:GMPSAVED " verified.",!
 W:'GMPSAVED $$ERRTXT^GMPLAPIE(.GMPERR)
 Q
ICDMSG ; If Lexicon returns ICD code 799.9
 N DIR,DTOUT,DUOUT
 S DIR(0)="YAO"
 S DIR("A",1)="<< If you PROCEED WITH THIS NON SPECIFIC TERM, an ICD CODE OF 799.9 >>"
 S DIR("A",2)="<< OTHER UNKNOWN AND UNSPECIFIED CAUSE OF MORBIDITY OR MORTALITY    >>"
 S DIR("A",3)="<< will be assigned.  Adding more specificity to your diagnosis may >>"
 S DIR("A",4)="<< allow a more accurate ICD code.                                  >>"
 S DIR("A",5)=""
 S DIR("A")="Continue (YES/NO) ",DIR("B")="NO"
 S DIR("T")=DTIME
 D ^DIR
 I $D(DTOUT)!$D(DUOUT) S Y=0
 I +Y=0 S (GMPLY,GMPROB)=""
 Q
 ;
ELIG(RETURN) ; Returns array of eligibility status
 S:GMPSC RETURN("SC")=""
 S:GMPAGTOR RETURN("AO")=""
 S:GMPION RETURN("IR")=""
 S:GMPGULF RETURN("EC")=""
 Q
