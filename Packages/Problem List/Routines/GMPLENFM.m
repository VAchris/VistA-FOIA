GMPLENFM ; SLC/MKB/KER -- Problem List Enc Form utilities ; 03/28/12
 ;;2.0;Problem List;**3,4,7,26,35,260002**;Aug 25, 1994
 ;
 ; External References
 ;   DBIA 10082  ^ICD9(
 ;   DBIA 10006  ^DIC
 ;   DBIA  1609  CONFIG^LEXSET
 ;                    
ACTIVE ; List of Active Problems for DFN
 ;   Sets Global Array:                   
 ;   ^TMP("IB",$J,"INTERFACES",DFN,"GMP PATIENT ACTIVE PROBLEMS",#) =
 ;                      
 ;   Piece 1:  Problem text
 ;         2:  ICD code
 ;         3:  Date of Onset     00/00/00 format
 ;         4:  SC/NSC/""         serv-conn/not sc/unknown
 ;         5:  Y/N/""            serv-conn/not sc/unknown
 ;         6:  A/I/E/H/M/C/S/""      If problem is flagged as:
 ;                               A - Agent Orange
 ;                               I - Ionizing Radiation
 ;                               E - Environmental Contaminants
 ;                               H - Head/Neck Cancer
 ;                               M - Mil Sexual Trauma
 ;                               C - Combat Vet
 ;                               S - SHAD
 ;                                 - None
 ;         7:  Special Exposure  Full text of piece 6
 ;                    
 N GMPL
 Q:'$$FILL(.GMPL,0)
 M ^TMP("IB",$J,"INTERFACES",+$G(DFN),"GMP PATIENT ACTIVE PROBLEMS")=GMPL
 Q
 ;
SELECT ; Select Common Problems
 ;   Sets Global Array:
 ;   ^TMP("IB",$J,"INTERFACES","GMP SELECT CLINIC COMMON PROBLEMS")
 ;   Piece 1:  Pointer to Clinical Lexicon
 ;         2:  Problem Text
 ;         3:  ICD Code (null if unknown)
 ;            
 N X,Y,DIC,PROB D CONFIG^LEXSET("ICD","ICD")
 K ^TMP("IB",$J,"INTERFACES","GMP SELECT CLINIC COMMON PROBLEMS")
 D BLD^DIALOG(1250000.301,,,"DIC(""A"")")
 S DIC(0)="AEQM",DIC="^LEX(757.01,"
 D ^DIC Q:+Y<0  S PROB=Y I +Y'>1 S PROB=+Y_U_X
 S PROB=PROB_U_$G(Y(1))
 S ^TMP("IB",$J,"INTERFACES","GMP SELECT CLINIC COMMON PROBLEMS")=PROB
 Q
 ;
DSELECT ; List of Active Problems for DFN
 ;   Sets Global Array"
 ;   ^TMP("IB",$J,"INTERFACES","GMP SELECT PATIENT ACTIVE PROBLEMS",#) =
 ;            
 ;   Piece 1:  Problem IEN
 ;         2:  Problem Text
 ;         3:  ICD code
 ;         4:  Date of Onset     00/00/00 format
 ;         5:  SC/NSC/""         serv-conn/not sc/unknown
 ;         6:  Y/N/""            serv-conn/not sc/unknown
 ;         7:  A/I/E/H/M/C/S/""      If problem is flagged as:
 ;                               A - Agent Orange
 ;                               I - Ionizing Radiation
 ;                               E - Environmental Contaminants
 ;                               H - Head/Neck Cancer
 ;                               M - Mil Sexual Trauma
 ;                               C - Combat Vet
 ;                               S - SHAD
 ;                                 - None
 ;         8:  Special Exposure  Full text of piece 6
 ;               
 N GMPL
 Q:'$$FILL(.GMPL,1)
 M ^TMP("IB",$J,"INTERFACES","GMP SELECT PATIENT ACTIVE PROBLEMS")=GMPL
 Q
 ;
FILL(GMPL,ADDIFN) ;
 N IFN,SC,NUM,GMPLIST,GMPARAM,GMPLVIEW,GMPTOTAL,GMPDFN,SCCOND,ONSET,PROB
 Q:$G(DFN)'>0 0
 S GMPDFN=DFN,CNT=0
 D GET^GMPLSITE(.GMPARAM) S GMPARAM("QUIET")=1
 S GMPLVIEW("ACT")="A",GMPLVIEW("PROV")=0,GMPLVIEW("VIEW")=""
 D GETPLIST^GMPLMGR1(.GMPLIST,.GMPTOTAL,.GMPLVIEW)
 D BUILDLST^GMPLAPI4(.GMPL,.GMPLIST)
 F NUM=1:1:GMPLIST(0) D
 . S SCCOND=$P(GMPL(NUM),U,17)
 . S SC=$P(SCCOND,"/")
 . S SC=SC_"^"_$S(SC="SC":"Y",SC="NSC":"N",1:"")
 . S ONSET=$$EXTDT^GMPLX($P(GMPL(NUM),U,5))
 . S PROB=$P(GMPL(NUM),U,3)
 . I GMPARAM("VER"),$P(GMPL(NUM),U,9)="T" S PROB="$"_PROB
 . S:ADDIFN PROB=$P(GMPL(NUM),U)_U_PROB
 . S GMPL(NUM)=PROB_U_$P(GMPL(NUM),U,4)_U_ONSET_U_SC_U_$$GMPL1(SCCOND)
 Q 1
 ;
GMPL1(SCCOND) ;Determine Treatment Factor, if any
 N SP
 S SP=$P(SCCOND,"/",2)
 Q:SP="AO" "A^Agent Orange"
 Q:SP="IR" "I^Ionizing Radiation"
 Q:SP="EC" "E^Env. Contaminants"
 Q:SP="HNC" "H^Head/Neck Cancer"
 Q:SP="MST" "M^Mil Sexual Trauma"
 Q:SP="CV" "C^Combat Vet"
 Q:SP="SHD" "S^SHAD"
 Q "^"
