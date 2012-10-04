GMPLP37I ; SLC/MKB/KER -- Save Problem List data ;09/21/12
 ;;2.0;Problem List;**37,260002**;Aug 25, 1994;Build 1
 ;
 ; External References
 ;
FIND(ACTION) ;
 N ARRAY
 D LISTPXRM^GMPLEXT(.ARRAY,ACTION)
 I ACTION=1 D UPD(.ARRAY)
 Q ARRAY
 ;
POST ;
 N ZTDESC,ZTDTH,ZTRTN,ZTSAVE,ZTIO,TEXT,ZTSK
 S ZTDESC="Correction to the Priority field in the PROBLEM file"
 S TEXT=ZTDESC_" has been queued, task number "
 S ZTRTN="QUEUED^GMPLP37I"
 S ZTIO=""
 S ZTDTH=$$NOW^XLFDT
 S ZTREQ="@"
 D ^%ZTLOAD
 I $D(ZTSK) S TEXT=TEXT_ZTSK D MES^XPDUTL(.TEXT)
 Q
QUEUED ;
 N ARRAY,AFTER,BEFORE,CHANGE,CNT
 S CNT=0
 S BEFORE=$$FIND(0)
 I BEFORE=0 D  G SEND
 .S CNT=CNT+1,ARRAY(CNT,0)="No invalid entries found in the PROBLEM file."
 S CNT=CNT+1,ARRAY(CNT,0)="Initial count of invalid entries in the PROBLEM file."
 S CNT=CNT+1,ARRAY(CNT,0)="   "_BEFORE_" Invalid entries in the PROBLEM file."
 S CNT=CNT+1,ARRAY(CNT,0)=" "
 S CHANGE=$$FIND(1)
 S CNT=CNT+1,ARRAY(CNT,0)="Number of entries that were change."
 S CNT=CNT+1,ARRAY(CNT,0)="  "_CHANGE_" entries in the PROBLEM file corrected."
 S CNT=CNT+1,ARRAY(CNT,0)=" "
 S AFTER=$$FIND(0)
 S CNT=CNT+1,ARRAY(CNT,0)="Count of entries that are still invalid."
 S CNT=CNT+1,ARRAY(CNT,0)="  "_AFTER_" Invalid entries in the PROBLEM file."
 ;
SEND ;mailman
 N NL,XMDUZ,XMY,XMZ
 S XMSUB="Correction of invalid entries in the PROBLEM file"
 S XMDUZ=0.5
 ;
RETRY ;Get the message number.
 D XMZ^XMA2
 I XMZ<1 G RETRY
 ;
 ;Load the message
 D LDMSG^GMPLEXT(XMZ,.ARRAY)
 ;
 ;Send message to USER
 S XMY(DUZ)="" D ENT1^XMD Q
 Q
 ;
UPD(ARRAY) ;
 N CNT,DA,DIE,DR
 S DIE="^AUPNPROB(",DR="1.14///@"
 S CNT=0 F  S CNT=$O(ARRAY(CNT)) Q:CNT'>0  D
 .S DA=ARRAY(CNT)
 .D ^DIE
 Q
