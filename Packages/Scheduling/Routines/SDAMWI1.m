SDAMWI1 ;ALB/MJK - Walk-Ins (cont.) ; 07/25/2012
 ;;5.3;Scheduling;**94,167,206,168,544,260003**;Aug 13, 1993;Build 11
 ;
MAKE(DFN,SDCL,SDT,TYP,STYP) ; -- set globals for appt
 ;    input:     DFN ; SDCL := clinic# ; SDT := appt d/t
 ; returned: success := 1
 ;
 N SD,SDINP,SC,DA,DIK
 S SC=SDCL,X=SDT
 S SD=SDT D EN1^SDM3
 S %=$$MAKEUS^SDMAPI2(.RETURN,DFN,SC,SDT,TYP,STYP)
 D RT,EVT,DUAL,ROUT(DFN)
 Q 1
 ;
RT ; -- request record
 S SDRT="A",SDTTM=SDT,SDPL=I,SDSC=SC D RT^SDUTL
 Q
 ;
ROUT(DFN) ; -- print routing slip
 S DIR("A")="DO YOU WANT TO PRINT A ROUTING SLIP NOW",DIR(0)="Y"
 W ! D ^DIR K DIR G ROUTQ:$D(DIRUT)!(Y=0)
 K IOP S (SDX,SDSTART,ORDER,SDREP)="" D EN^SDROUT1
ROUTQ Q
 ;
DUAL ; -- ask elig if pt has more than one
 I $O(VAEL(1,0))>0 S SDEMP="" D ELIG^SDM4:"369"[SDAPTYP S SDEMP=$S(SDDECOD:SDDECOD,1:SDEMP) I +SDEMP S $P(^SC(SC,"S",SDT,1,I,0),"^",10)=+SDEMP K SDEMP
 Q
 ;
EVT ; -- separate if need to NEW vars
 N I,DIV D MAKE^SDAMEVT(DFN,SDT,SDCL,SDDA,0)
 Q
