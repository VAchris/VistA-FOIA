ONCIPC4 ;Hines OIFO/GWB - Primary Intracranial/CNS Tumors PCE Study ;03/10/00
 ;;2.11;ONCOLOGY;**26**;Mar 07, 1995
 ;Recurrence/Progession
 K TABLE,HTABLE
 S TABLE("70. DATE OF FIRST RECURRENCE")="DFR"
 S TABLE("71. TYPE OF FIRST RECURRENCE")="TFR"
 S TABLE("72. DATE OF PROGRESSION")="DP"
 S TABLE("73. TYPE OF PROGRESSION")="TP"
 S TABLE("74. RECURRENCE/PROGRESSION DOCUMENTATION")="RPD"
 S TABLE("75. KARNOFSKY'S RATING AT TIME OF RECURRENCE/PROGRESSION")="KRTRP"
 S HTABLE(1)="70. TYPE OF FIRST RECURRENCE"
 S HTABLE(2)="71. DATE OF FIRST RECURRENCE"
 S HTABLE(3)="72. DATE OF PROGRESSION"
 S HTABLE(4)="73. TYPE OF PROGRESSION"
 S HTABLE(5)="74. RECURRENCE/PROGRESSION DOCUMENTATION"
 S HTABLE(6)="75. KARNOFSKY'S RATING AT TIME OF RECURRENCE/PROGRESSION"
 S CHOICES=6
 S IE=ONCONUM
 S TFR=$$GET1^DIQ(165.5,IE,1372,"I")
 S TP=$$GET1^DIQ(165.5,IE,1369,"I")
 W @IOF D HEAD^ONCIPC0
 W !," RECURRENCE/PROGESSION"
 W !," ---------------------"
 S DIE="^ONCO(165.5,",DA=ONCONUM
DFR S DR="70 70. DATE OF FIRST RECURRENCE......" D ^DIE G:$D(Y) JUMP
TFR S DR="1372 71. TYPE OF FIRST RECURRENCE......" D ^DIE G:$D(Y) JUMP
DP S DR="1368 72. DATE OF PROGRESSION..........." D ^DIE G:$D(Y) JUMP
TP S DR="1369 73. TYPE OF PROGRESSION..........." D ^DIE G:$D(Y) JUMP
RPD I (TFR=0)&((TP=0)!(TP=8)) D  G KRTRP
 .S $P(^ONCO(165.5,IE,"CNS2"),U,85)=0
 .W !," 74. RECURRENCE/PROGRESSION                                                           DOCUMENTATION................: No recurrence/progession"
 I (TFR=9)&(TP=9) D  G KRTRP
 .S $P(^ONCO(165.5,IE,"CNS2"),U,85)=9
 .W !," 74. RECURRENCE/PROGRESSION                                                           DOCUMENTATION................: Unknown"
 S DR="1370 74. RECURRENCE/PROGRESSION                                                           DOCUMENTATION................" D ^DIE G:$D(Y) JUMP
KRTRP I (TFR=0)&((TP=0)!(TP=8)) D  G PRTC
 .S $P(^ONCO(165.5,IE,"CNS2"),U,86)=13
 .W !," 75. KARNOFSKY'S RATING AT TIME OF                                                    RECURRENCE/PROGRESSION.......: 888"
 I (TFR=9)&(TP=9) D  G PRTC
 .S $P(^ONCO(165.5,IE,"CNS2"),U,86)=12
 .W !," 75. KARNOFSKY'S RATING AT TIME OF                                                    RECURRENCE/PROGRESSION.......: 999"
 S DR="1371 75. KARNOFSKY'S RATING AT TIME OF                                                    RECURRENCE/PROGRESSION......." D ^DIE G:$D(Y) JUMP
PRTC W ! K DIR S DIR(0)="E" D ^DIR S:$D(DIRUT) OUT="Y"
 G EXIT
JUMP ;Jump to prompts
 S XX="" R !!," GO TO ITEM NUMBER: ",X:DTIME
 I (X="")!(X[U) S OUT="Y" G EXIT
 I X["?" D  G JUMP
 .W !," CHOOSE FROM:" F I=1:1:CHOICES W !,?5,HTABLE(I)
 I '$D(TABLE(X)) S:X?1.2N X=X_"." S XX=X,X=$O(TABLE(X)) I ($P(X,XX,1)'="")!(X="") W *7,"??" D  G JUMP
 .W !," CHOOSE FROM:" F I=1:1:CHOICES W !,?5,HTABLE(I)
 S X=TABLE(X)
 G @X
EXIT K CHOICES,HTABLE,TABLE
 K TFR,TP
 K DA,DIE,DIR,DIROUT,DIRUT,DR,DTOUT,DUOUT,X,XX,Y
 Q