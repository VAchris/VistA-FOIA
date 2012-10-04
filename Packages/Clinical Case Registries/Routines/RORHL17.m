RORHL17 ;HOIFO/BH,SG - HL7 PROBLEM LIST: OBR,OBX ;09/20/12
 ;;1.5;CLINICAL CASE REGISTRIES;**10,260002**;Feb 17, 2006;Build 32
 ;
 ; This routine uses the following IAs:
 ;
 ; #2308         ^AUPNPROB - PROBLEM file #9000011 (controlled)
 ; #2644         $$MOD^GMPLUTL3 (controlled)
 ; #3990         $$CODEC^ICDCODE (supported)
 ; #2056         $$GET1^DIQ
 ; #10103        FMTHL7^XLFDT (supported)
 ;
 Q
 ;
 ;***** SEARCHES FOR Problem List DATA
 ;
 ; RORDFN        IEN of the patient in the PATIENT file (#2)
 ;
 ; .DXDTS        Reference to a local variable where the
 ;               data extraction time frames are stored.
 ;
 ; Return Values:
 ;       <0  Error code
 ;        0  Ok
 ;       >0  Non-fatal error(s)
 ;
 ;
EN1(RORDFN,DXDTS) ;
 N CS,DFN,GMRVSTR,IDX,PROBIEN,RC,RORARR,RORBUF,RORENDT,RORMSG,RORSTDT,RORTMP,TMP,PRBS,%,I
 S (ERRCNT,RC)=0
 D ECH^RORHL7(.CS)
 S RORTMP=$$ALLOC^RORTMP()
 ;
 S IDX=0
 F  S IDX=$O(DXDTS(16,IDX))  Q:IDX'>0  D  Q:RC<0
 . S RORSTDT=$P(DXDTS(16,IDX),U),RORENDT=$P(DXDTS(16,IDX),U,2)
 . ;--- Check to see is any problems have been entered/modified
 . ;--- during the data extraction time frame
 . S MDATE=$$MOD^GMPLUTL3(RORDFN)
 . Q:(MDATE<RORSTDT)!(MDATE'<RORENDT)
 . ;--- Find newly entered problems or modified problems
 . S PROBIEN=""
 . S %=$$GETPLIST^GMPLAPI4(.PRBS,RORDFN,"AIR")
 . F I=1:1:PRBS D
 . . S PROBIEN=PRBS(I)
 . . S TMP=$$LOAD(.RORARR,PROBIEN)  Q:TMP="S"
 . . S:TMP>0 ERRCNT=ERRCNT+TMP
 . . ;---
 . . S TMP=$$OBR(.RORARR)
 . . I TMP  Q:TMP<0  S ERRCNT=ERRCNT+TMP
 . . S TMP=$$OBX(.RORARR)
 . . I TMP  Q:TMP<0  S ERRCNT=ERRCNT+TMP
 ;
 D FREE^RORTMP(RORTMP)
 Q $S(RC<0:RC,1:ERRCNT)
 ;
 ;***** VALIDATES THE DATE
CHECK(DATE) ;
 Q:DATE'>0 ""
 Q:$E(DATE,1,3)>$E(DT,1,3) ""
 S:$E(DATE,4,5)="00" $E(DATE,4,5)="01"
 S:$E(DATE,6,7)="00" $E(DATE,6,7)="01"
 Q $$FM2HL^RORHL7(DATE)
 ;
 ;I $E(DATE,1,2)="20",$E(DATE,3,4)>$E(DT,2,3) Q ""
 ;
 ;*****
LOAD(RORARR,PROBIEN) ;
 N CNT,ERRCNT,IENS,MDATE,NOTE,SUB3,SUB5,STAT,%,PRB
 K RORARR,@RORTMP  S ERRCNT=0
 ;
 S %=$$DETAIL^GMPLAPI2(.PRB,PROBIEN)
 S MDATE=$P(PRB(.03),U)
 Q:(MDATE<RORSTDT)!(MDATE'<RORENDT) "S"
 ;
 S RORARR("OBR","FACIL")=$P(PRB(.06),U)
 S RORARR("OBR","NMBR")=$P(PRB(.07),U)
 S RORARR("OBR","COND")=$P(PRB(1.02),U)
 S RORARR("OBR","DE")=$$FMTHL7^XLFDT($P(PRB(.08),U))
 S RORARR("OBR","DOO")=$$CHECK($P(PRB(.13),U))
 S RORARR("OBR","DRES")=$$CHECK($P(PRB(1.07),U)) ;date resolved
 ;
 S DIAG=$$CODEC^ICDCODE(+$P(PRB(.01),U))
 S:DIAG<0 DIAG=""
 ;
 S RORARR("OBR","DIAG")=DIAG
 S RORARR("OBR","DREC")=$$FMTHL7^XLFDT($P(PRB(1.09),U)) ;date recorded
 S RORARR("OBR","RP")=$P(PRB(1.04),U)
 S RORARR("OBR","DLM")=$$FMTHL7^XLFDT(MDATE)
 S RORARR("OBR","ST")=$P(PRB(.12),U)
 ;
 S RORARR("OBX","PR")=$P(PRB(.05),U,2)
 S RORARR("OBX","PROB")=$P(PRB(1.01),U,2)
 ;
 I PRB(10)>0  D
 . S SUB3=0,CNT=0
 . F  S SUB3=$O(PRB(10,SUB3))  Q:'SUB3  D
 . . S SUB5=0
 . . F  S SUB5=$O(PRB(10,SUB3,SUB5))  Q:'SUB5  D
 . . . S CNT=CNT+1
 . . . S @RORTMP@(CNT)=$P(PRB(10,SUB3,SUB5),U,3)
 ;
 Q ERRCNT
 ;
 ;***** PROBLEM LIST OBR SEGMENT BUILDER
 ;
 ; Return Values:
 ;       <0  Error code
 ;        0  Ok
 ;       >0  Non-fatal error(s)
 ;
OBR(RORARR) ;
 N CLASS,CS,ERRCNT,PRV,RC,RORMSG,RORSEG,TMP,TMP1
 S (ERRCNT,RC)=0
 D ECH^RORHL7(.CS)
 ;
 ;--- Initialize the segment
 S RORSEG(0)="OBR"
 ;
 ;--- OBR-3 - Filler Order Number
 S RORSEG(3)=RORARR("OBR","FACIL")_RORARR("OBR","NMBR")
 ;
 ;--- OBR-4 - Problem List CPT Code
 S RORSEG(4)="90125"_CS_"HOSPITAL CARE,NEW, INTERMED."_CS_"C4"
 ;
 ;--- OBR-6 - Requested Date/time (Date Entered)
 S RORSEG(6)=RORARR("OBR","DE")
 ;
 ;--- OBR-7 - Observation Date/Time (Date Appeared)
 S RORSEG(7)=RORARR("OBR","DOO")
 ;
 ;--- OBR-8 - Observation End Date/Time (Date Resolved/Inactivated)
 S RORSEG(8)=RORARR("OBR","DRES")
 ;
 ;--- OBR-13 -  Relevant Clinical Info. (Diagnosis Code)
 S RORSEG(13)=RORARR("OBR","DIAG")
 ;
 ;--- OBR-14 - Specimen Received Date/time (Date Recorded)
 S RORSEG(14)=RORARR("OBR","DREC")
 ;
 ;--- OBR-16 - Ordering Provider
 S PRV=RORARR("OBR","RP")
 S TMP=$$GET1^DIQ(200,PRV_",",53.5,"E",,"RORMSG")
 I $G(DIERR)  D  S ERRCNT=ERRCNT+1
 . D DBS^RORERR("RORMSG",-99,,RORDFN,200,PRV_",")
 E  S $P(PRV,CS,13)=$$ESCAPE^RORHL7(TMP)
 S RORSEG(16)=PRV
 ;
 ;--- OBR-20 - Filler Field 1 (Condition of the Record)
 S RORSEG(20)=RORARR("OBR","COND")
 ;
 ;--- OBR-22 - Results Rpt/Status Change Date/time  (Last Modified)
 S RORSEG(22)=RORARR("OBR","DLM")
 ;
 ;--- OBR-24 - Diagnostic Service ID
 S RORSEG(24)="TX"
 ;
 ;--- OBR-25 - Result Status (Status of the Problem)
 S TMP1=RORARR("OBR","ST")
 S TMP=$S(TMP1="A":"F",TMP1="I":"R",1:"")
 S RORSEG(25)=TMP
 ;
 ;--- OBR-44 - Division
 S RORSEG(44)=$$SITE^RORUTL03(CS)
 ;
 ;--- Store the segment
 D ADDSEG^RORHL7(.RORSEG)
 Q ERRCNT
 ;
 ;***** PROBLEM LIST OBX SEGMENT(S) BUILDER
 ;
 ; Return Values:
 ;       <0  Error code
 ;        0  Ok
 ;       >0  Non-fatal error(s)
 ;
OBX(RORARR) ;
 N BR,CS,ERRCNT,NDX,OBX3,RC
 S (ERRCNT,RC)=0
 D ECH^RORHL7(.CS)
 S BR=$E(HLECH,3)_".br"_$E(HLECH,3)
 ;
 I $D(RORARR("OBX","PR")) D
 . S OBX3="PRVN"_CS_"Provider Narrative"_CS_"VA080"
 . D SETOBX(OBX3,"",$$ESCAPE^RORHL7(RORARR("OBX","PR")))
 ;
 I $D(RORARR("OBX","PROB")) D
 . S OBX3="EXPR"_CS_"Expression"_CS_"VA080"
 . D SETOBX(OBX3,"",$$ESCAPE^RORHL7(RORARR("OBX","PROB")))
 ;
 S OBX3="NOTE"_CS_"Note Narrative"_CS_"VA080"
 D SETOBXWP^RORHLUT1(RORTMP,OBX3)
 ;
 Q ERRCNT
 ;
 ;*** CREATES AND STORES THE OBX SEGMENT
SETOBX(OBX3,OBX4,OBX5) ;
 N RORSEG
 ;--- Initialize the segment
 S RORSEG(0)="OBX"
 ;--- OBX-2
 S RORSEG(2)="FT"
 ;--- OBX-3
 S RORSEG(3)=OBX3
 ;--- OBX-4
 S:$G(OBX4)'="" RORSEG(4)=OBX4
 ;--- OBX-5
 S RORSEG(5)=OBX5
 ;--- OBX-11
 S RORSEG(11)="F"
 ;--- Store the segment
 D ADDSEG^RORHL7(.RORSEG)
 Q
