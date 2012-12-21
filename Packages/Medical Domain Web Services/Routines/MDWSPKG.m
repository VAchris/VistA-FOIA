MDWSPKG ;MTZ/CKU - PACKAGING TOOLS; 12/19/2012
 ;;1.0;MDWS;**1**;Dec 21, 2012;
EN
 ; This sub-routine will allow a programmer to import routines from a Git repo.
 ; It is made for the MDWS team to quickly absorb the changes made without 
 ; the use of a KID build available.
 ;
 ; Algorithm summary: Select a build that was previously installed, identify those
 ; routines which were originally included in the last build and import them from
 ; the Git repo.
 N DIC S DIC="^XPD(9.6," S DIC(0)="AE" D ^DIC Q:Y<0
 N BUILDIEN S BUILDIEN=+Y 
 N % S %=2 W !,"Continue using BUILD: "_$P(Y,U,2)_" " D YN^DICN I %=-1 Q
 I (%=2)!(%=0) G EN
 W ! N RESULT,ERRORS D LIST^DIC(9.68,",9.8,"_BUILDIEN_",","@;.01","P",,,,,,,"RESULT","ERRORS")
 I $D(ERRORS) ZW ERRORS Q
 N I S I=0 F  S I=$O(RESULT("DILIST",I)) Q:I=""  D
 . N ROUTINE,X S (ROUTINE,X)=$P(RESULT("DILIST",I,0),U,2)
 . K ^TMP($J,ROUTINE)
 . N PATH,FILE,GLOBAL,INDEX S PATH="C:\github\VistA-FOIA\Routines\"
 . S FILE=ROUTINE_".m",GLOBAL=$NA(^TMP($J,ROUTINE,1,0)),INDEX=3
 . ; LOAD FILE
 . I '$$FTG^%ZISH(PATH,FILE,GLOBAL,3) W "Failed to load: "_FILE,! Q
 . ; DELETE OLD ROUTINE IF LOAD SUCCESSFUL
 . X ^%ZOSF("DEL")
 . ; SAVE ROUTINE
 . N DIE,XCN S DIE="^TMP($J,"""_ROUTINE_""",",XCN=0 X ^%ZOSF("SAVE")
 . W "Loaded "_ROUTINE,!
 . K ^TMP($J,ROUTINE)
 Q
