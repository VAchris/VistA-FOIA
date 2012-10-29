SDCODEL ;ALB/RMO,ESW - Delete - Check Out; 10/12/2012
 ;;5.3;Scheduling;**20,27,44,97,105,110,132,257,260003**;Aug 13, 1993
 ;
EN(SDOE,SDMOD,SDELHDL,SDELSRC) ;Delete Check Out
 ; Input  -- SDOE     Outpatient Encounter file IEN
 ;           SDMOD    1=Interactive and 0=Non-interactive
 ;           SDELHDL  Check Out Deletion Handle  [Optional]
 ;           SDELSRC  Source of delete
 ; Output -- Delete Check Out
 N RETURN
 S %=$$DELCOPC^SDMAPI4(.RETURN,SDOE,.SDELHDL,.SDELSRC)
ENQ Q
 ;
COMDT(SDOE,SDMOD) ;Delete Check Out Process Completion Date
 N RETURN
 I $G(SDMOD) W !?3,"...deleting check out process completion date"
 S %=$$DELCODT^SDMAPI4(.RETURN,SDOE)
 Q
