GMPLRPTR ; SLC/MKB/AJB -- Problem List Report of Removed Problems ; 09/17/12
 ;;2.0;Problem List;**28,260002**;Aug 25, 1994
EN ; -- main entry point
 N %
 S GMPDFN=$$PAT^GMPLX1 Q:+GMPDFN'>0
 D WAIT^DICD
 K GMPLIST
 S %=$$GETPLIST^GMPLAPI4(.GMPLIST,+GMPDFN,"R")
 I GMPLIST(0)'>0 W $C(7),!!?10,"No 'removed' problems found for this patient.",! Q
 D DISPLAY,REPLACE
 K GMPDFN,GMPLIST
 Q
 ;
DISPLAY ; -- show list on screen
 N PROBLEM,DATE,USER,NUM,PROV,IDT,AIFN,NODE,DONE,GMPQUIT D HDR
 F NUM=0:0 S NUM=$O(GMPLIST(NUM)) Q:NUM'>0  D  Q:$D(GMPQUIT)
 . S IFN=GMPLIST(NUM) Q:'IFN
 . S PROBLEM=$$PROBTEXT^GMPLX(IFN),(DATE,PROV)="" K DONE
 . ; added for Code Set Versioning (CSV)
 . I '$$CODESTS^GMPLX(IFN,DT) S PROBLEM="#"_PROBLEM
 . D AUDITX^GMPLHIST(.RETURN,IFN,1.02,"H")
 . I RETURN>0 D
 . . S DATE=RETURN(1,"MODIFIED")
 . . S PROV=RETURN(1,"REQUESTINGBY")
 . I $Y>(IOSL-4) S:'$$CONTINUE GMPQUIT=1 Q:$D(GMPQUIT)  D HDR
 . ; added for Code Set Versioning
 . N GMPLBUF S GMPLBUF=$S(PROBLEM["#":3,1:4)
 . W !,NUM,?GMPLBUF,PROBLEM,?51,DATE,?60,PROV
 Q
 ;
HDR ; -- header code
 W @IOF,"REMOVED PROBLEMS FOR "_$P(GMPDFN,U,2)_" ("_$P(GMPDFN,U,3)_"):"
 W !!,"    Problem",?51,"Removed  By Whom",!,$$REPEAT^XLFSTR("-",79)
 Q
 ;
CONTINUE() ; -- end of page prompt
 N DIR,X,Y
 S DIR(0)="E",DIR("A")="Press <return> to continue or ^ to exit ..."
 D ^DIR
 Q +Y
 ;
REPLACE ; -- replace problem on patient's list
 N GMPLSEL,GMPLNO,NUM,DA,%,RET
 W !!
 S GMPLSEL=$$SEL Q:GMPLSEL="^"  Q:'$$SURE
 W !!,"Replacing problem(s) on patient's list ..."
 S GMPLNO=$L(GMPLSEL,",")
 F I=1:1:GMPLNO S NUM=$P(GMPLSEL,",",I) I NUM D
 . ; added for Code Set Versioning (CSV)
 . I '$$CODESTS^GMPLX(GMPLIST(NUM),DT) W !!,$$PROBTEXT^GMPLX(GMPLIST(NUM)),!,"has an inactive ICD9 code and will not be replaced." Q
 . S DA=GMPLIST(NUM)
 . S %=$$UNDELETE^GMPLAPI4(.RET,DA)
 . W !,"  "_$$PROBTEXT^GMPLX(DA)
 D
 . N DIR S DIR(0)="E" W ! D ^DIR
 Q
 ;
SEL() ; -- select problem(s)
 N DIR,X,Y,MAX
 S MAX=+GMPLIST(0) I MAX'>0 Q "^"
 S DIR(0)="LAO^1:"_MAX,DIR("A")="Select the problem(s) you wish to replace on this patient's list: "
 S DIR("?",1)="Enter the problems you wish to add back on this patient's problem list,",DIR("?")="as a range or list of numbers."
 D ^DIR I $D(DTOUT)!(X="") S Y="^"
 Q Y
 ;
SURE() ; -- are you sure you want to do this?
 N DIR,X,Y
 S DIR(0)="Y",DIR("A")="Are you sure you want to do this",DIR("B")="NO"
 S DIR("?",1)="Enter YES if you are ready to have the selected problems put back on this",DIR("?")="patient's problem list; press <return> to exit without further action."
 W $C(7) D ^DIR
 Q +Y
