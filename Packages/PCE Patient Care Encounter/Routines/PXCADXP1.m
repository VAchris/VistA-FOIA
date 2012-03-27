PXCADXP1 ;ISL/dee & LEA/Chylton,SCK - Validates & Translates data from the PCE Device Interface into a call to V POV & update Problem List ;3/20/97
 ;;1.0;PCE PATIENT CARE ENCOUNTER;**24,33,194**;Aug 12, 1996;Build 2
 Q
 ;
PART1 ;
 N PXCACLEX,VALID,PAT
 S (PXCADIAG,PXCAPROB)=0
 I "^^^"'[$P(PXCADXPL,"^",5,8) S PXCAPROB=1
 ;Note
 S PXCAITEM=$P($G(PXCA("DIAGNOSIS/PROBLEM",PXCAPRV,PXCAINDX,"NOTE")),"^",1),PXCAITM2=$L(PXCAITEM)
 I PXCAITEM]"" D
 . I PXCAITM2<3!(PXCAITM2>60) S PXCA("ERROR","DIAGNOSIS/PROBLEM",PXCAPRV,PXCAINDX,"NOTE",1)="PROBLEM Note must be 1-60 Characters^"_PXCAITEM
 . S PXCAPROB=1
 ;
 ;Diagnosis Code
 S PXCAITEM=$P(PXCADXPL,"^",1)
 I PXCAITEM>0 D
 . S PXCADIQ1=$$ICDDX^ICDCODE(PXCAITEM)
 . I PXCADIQ1<0 S PXCA("ERROR","DIAGNOSIS/PROBLEM",PXCAPRV,PXCAINDX,1)="ICD9 Code not in file 80^"_PXCAITEM
 . E  I $P(PXCADIQ1,U,12),$P(PXCADIQ1,U,12)'>+PXCADT S PXCA("ERROR","DIAGNOSIS/PROBLEM",PXCAPRV,PXCAINDX,1)="ICD9 Code is INACTIVE^"_PXCAITEM
 . ;N DIC,DR,DA,DIQ,PXCADIQ1
 . ;S DIC=80
 . ;S DR=".01;102"
 . ;S DA=PXCAITEM
 . ;S DIQ="PXCADIQ1("
 . ;S DIQ(0)="I"
 . ;D EN^DIQ1
 . ;I $G(PXCADIQ1(80,DA,.01,"I"))="" S PXCA("ERROR","DIAGNOSIS/PROBLEM",PXCAPRV,PXCAINDX,1)="ICD9 Code not in file 80^"_PXCAITEM
 . ;E  I $G(PXCADIQ1(80,DA,102,"I")),PXCADIQ1(80,DA,102,"I")'>+PXCADT S PXCA("ERROR","DIAGNOSIS/PROBLEM",PXCAPRV,PXCAINDX,1)="ICD9 Code is INACTIVE^"_PXCAITEM
 ;
 ;Diagnosis Specification Code
 S PXCAITM2=$P(PXCADXPL,"^",2)
 I PXCAITM2'="" D
 . S PXCADIAG=1
 . I '((PXCAITM2="P")!(PXCAITM2="S")!(PXCAITM2="PS")!(PXCAITM2="SP")) S PXCA("ERROR","DIAGNOSIS/PROBLEM",PXCAPRV,PXCAINDX,2)="Diagnosis specification code must be P|S^"_PXCAITM2
 . E  I PXCAITM2["P",PXCAITEM>0 D
 .. I 'PXCAPDX S PXCAPDX=PXCAITEM
 .. E  I $P($G(^PX(815,1,"DI")),"^",2) S PXCA("ERROR","DIAGNOSIS/PROBLEM",PXCAPRV,PXCAINDX,2)="There is already a Primary Diagnosis for this encounter^"_PXCAITM2
 .. E  D
 ... S PXCA("WARNING","DIAGNOSIS/PROBLEM",PXCAPRV,PXCAINDX,2)="There is already a Primary Diagnosis. This one is changed to Secondary^"_PXCAITM2
 ... S $P(PXCADXPL,"^",2)="S"
 . I PXCAITEM'>0 S PXCA("ERROR","DIAGNOSIS/PROBLEM",PXCAPRV,PXCAINDX,1)="ICD9 Code is required for DIAGNOSIS^"_PXCAITEM
 ;
 ;Clinical Lexicon Term
 S PXCAITEM=$P(PXCADXPL,"^",3)
 I PXCAITEM]"" D
 . I $D(^LEX(757.01)) D
 .. I $D(^LEX(757.01,PXCAITEM,0))#2'=1 S PXCA("ERROR","DIAGNOSIS/PROBLEM",PXCAPRV,PXCAINDX,3)="Lexicon Utility term is not in file 757.01^"_PXCAITEM
 .. E  S PXCACLEX=PXCAITEM
 . E  I $D(^GMP(757.01)) D
 .. I $D(^GMP(757.01,PXCAITEM,0))#2'=1 S PXCA("ERROR","DIAGNOSIS/PROBLEM",PXCAPRV,PXCAINDX,3)="Clinical Lexicon Utility term is not in file 757.01^"_PXCAITEM
 .. E  S PXCACLEX=PXCAITEM
 . E  S PXCA("ERROR","DIAGNOSIS/PROBLEM",PXCAPRV,PXCAINDX,3)="Lexicon Utility is not installed^"_PXCAITEM
 ;
 ;Problem List IEN
 S PXCAITEM=$P(PXCADXPL,"^",4)
 ;Add to Problem List
 S PXCAITM2=$P(PXCADXPL,"^",5)
 I PXCAITEM]"" D
 . D VALID^GMPLAPI4(.VALID,PXCAITEM)
 . D PATIENT^GMPLAPI4(.PAT,PXCAITEM)
 . I 'VALID S PXCA("ERROR","DIAGNOSIS/PROBLEM",PXCAPRV,PXCAINDX,4)="Problem not in file 9000011^"_PXCAITEM
 . E  I PXCAPAT'=PAT S PXCA("ERROR","DIAGNOSIS/PROBLEM",PXCAPRV,PXCAINDX,4)="Problem in file 9000011 is for a different Patient^"_PXCAITEM
 . I PXCAITM2=1 S PXCA("ERROR","DIAGNOSIS/PROBLEM",PXCAPRV,PXCAINDX,5)="Cannot ADD existing Problem to file 9000011^"_PXCAITM2
 E  I PXCAPROB,PXCAITM2'=1 S PXCA("ERROR","DIAGNOSIS/PROBLEM",PXCAPRV,PXCAINDX,4)="Cannot update an existing Problem with out an IEN to file 9000011^"_PXCAITEM
 I '(PXCAITM2=1!(PXCAITM2=0)!(PXCAITM2="")) S PXCA("ERROR","DIAGNOSIS/PROBLEM",PXCAPRV,PXCAINDX,5)="Add to Problem List flag bad^"_PXCAITM2
 I PXCAITM2=1,PXCAPRV'>0 S PXCA("ERROR","DIAGNOSIS/PROBLEM",PXCAPRV,PXCAINDX,0)="Provider is required to add a new Problem^"_PXCAPRV
 ;
 Q
 ;
