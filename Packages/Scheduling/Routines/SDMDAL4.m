SDMDAL4 ;RGI/CBR - APPOINTMENT API; 08/10/2012
 ;;5.3;scheduling;**260003**;08/13/93;
GETOE(RETURN,SDOE) ; Get outpatient encounter
 N IND
 F IND=0:0 S IND=$O(RETURN(IND)) Q:IND=""  D
 . S RETURN(IND)=$$GET1^DIQ(409.68,SDOE_",",IND,"I")
 S RETURN=1
 Q
 ;
GETCHLD(RETURN,SDOE) ; Get children encounters
 N SDOEC
 F SDOEC=0:0 S SDOEC=$O(^SCE("APAR",SDOE,SDOEC)) Q:'SDOEC  D
 . S RETURN(SDOEC)=""
 Q
DELOE(SDOE) ; Delete Outpatient Encounter
 N DA,DIK
 S DA=SDOE,DIK="^SCE(" D ^DIK
 Q
UPDPAPT(DATA,DFN,SD) ; Update patient appointment
 N IENS,I
 S IENS=SD_","_DFN_","
 N FDA
 F I=0:0 S I=$O(DATA(I)) Q:I=""  D
 . S FDA(2.98,IENS,I)=DATA(I)
 N ERR
 D UPDATE^DIE("","FDA","ERR")
 Q
 ;
UPDCAPT(DATA,SC,SD,IEN) ; Update clinic appointment
 N IENS,I
 S IENS=IEN_","_SD_","_SC_","
 N FDA
 F I=0:0 S I=$O(DATA(I)) Q:I=""  D
 . S FDA(44.003,IENS,I)=DATA(I)
 N ERR
 D UPDATE^DIE("","FDA","ERR")
 Q
 ;
DELCLS(SDOE) ;Delete Classification
 N DA,DIK,SDI,SDFL
 S SDFL=409.42
 S DIK="^SDD("_SDFL_",",SDI=0
 F SDI=0:0 S SDI=$O(^SDD(SDFL,"AO",SDOE,SDI)) Q:'SDI  S DA=+$O(^(SDI,0)) D ^DIK
 Q
 ;
