GMPLPRF0 ; SLC/MKB -- Problem List User Prefs cont ;09/13/12
 ;;2.0;Problem List;**3,260002**;Aug 25, 1994
CURRENT(USER) ; Show user's current preference
 N VIEW,NUM,MSGID,MSG
 D EN^DDIOL($$EZBLD^DIALOG(1250000.370),,"!!")
 S VIEW=$$USERVIEW^GMPLEXT(USER),NUM=$S($L(VIEW,"/")<3:"all",1:$L(VIEW,"/")-2)
 S MSGID=$S(VIEW="S":1250000.371,VIEW="C":1250000.372,1:1250000.373)
 D BLD^DIALOG(MSGID,NUM,,"MSG")
 D EN^DDIOL(.MSG)
 Q
 ;
CHANGE() ; Want to change preferred view?
 N DIR,X,Y S DIR(0)="YA",DIR("B")="NO"
 S DIR("A")=$$EZBLD^DIALOG(1250000.374)
 D BLD^DIALOG(1250000.375,,,"DIR(""?"")")
 D ^DIR
 Q +Y
 ;
VIEW(MODE) ; Returns user's preferred view, by 'S'ervice or 'C'linic
 N DIR,X,Y S DIR("B")=$S(MODE="S":"INPATIENT",1:"OUTPATIENT")
 S DIR(0)="SAOM^C:OUTPATIENT;S:INPATIENT;",DIR("A")=$$EZBLD^DIALOG(1250000.376)
 D BLD^DIALOG(1250000.377,,,"DIR(""?"")")
 D ^DIR S:$D(DTOUT)!($D(DUOUT)) Y="^"
 Q Y
 ;
ALL(MODE,DEFLT) ; Include all problems, or select from clinics/services?
 N DIR,X,Y,MSG
 S DIR(0)="SAOM^A:ALL;S:SELECTED;",DIR("B")=$S(DEFLT<3:"ALL",1:"SELECTED")
 S MSG=$S(MODE="S":1250000.378,1:1250000.379)
 D BLD^DIALOG(MSG,,,"DIR(""A"")")
 S MSG=$S(MODE="S":1250000.380,1:1250000.381)
 D BLD^DIALOG(MSG,,,"DIR(""?"")")
 D ^DIR S:$D(DTOUT)!($D(DUOUT)) Y="^" S:Y="A" Y=1 S:Y="S" Y=0
 Q Y
