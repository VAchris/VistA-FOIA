NURC ;HIRMFO/RM;JH-ROUTINE TO CHECK FOR VERSION NUMBER, AND RUN NURS. CLIN. MENU ;12/23/89
 ;;4.0;NURSING SERVICE;;Apr 25, 1997
 ;THIS ROUTINE IS BEING ADDED TO CHECK VERSION NUMBER OF NURSING CLINICAL MODULE
 ;BUT LATER WILL RUN A MENU TO DEMONSTRATE NURSING CLINICAL
 Q:'$D(^DIC(213.9,1,"OFF"))  Q:$P(^DIC(213.9,1,"OFF"),"^",1)=1
 S NURCVER=$$VERSION^XPDUTL("NURC") W:NURCVER'="" !!,"Version ",NURCVER," of the Nursing Clinical Module" K NURCVER
 Q