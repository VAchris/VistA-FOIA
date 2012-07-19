SDAPIE ; / Scheduling Error provider;06/06/2012
 ;;;Scheduling;;06/06/2012
ERRX(RETURN,ERRNO,TEXT,LVL) ; adds error to RETURN
 Q:'$D(RETURN)
 Q:'$D(ERRNO)
 S:$G(LVL)="" LVL=1
 S TEXT=$G(TEXT)
 N I
 F I=0:1 Q:$O(RETURN(I))=""!('+$O(RETURN(I)))
 S ERRTXT=$P($T(@ERRNO),";;",2)
 S IND=1,TXT=1,STR=""
 F  Q:IND=0  D
 . S ST=$P(ERRTXT,"^",IND)
 . I ST=""&(IND>1) S IND=0 Q
 . I ST["$TXT" D  S:$D(TEXT(TXT)) STR=STR_TEXT(TXT),TXT=TXT+1
 . E  S STR=STR_ST
 . S IND=IND+1
 S RETURN(I)=ERRNO_U_STR_U_LVL
 Q
 ;
ERRTXT(RETURN) ;
 Q $P($G(RETURN(0)),U,2)
 ; 
ERRTABLE ; Error table
INVPARAM ;;Invalid parameter value - ^$TXT1^.
CLNINV ;;Invalid Clinic.
CLNNDFN ;;Clinic not define or has no zero node.
CLNSCIN ;;Invalid Clinic Stop Code ^$TXT1^.
CLNSCRD ;;Clinic's Stop Code ^$TXT1^ cannot be used. Restriction date is ^$TXT2^ ^$TXT3^.
CLNSCPS ;;Clinic's Stop Code ^$TXT1^ cannot be ^$TXT2^.
CLNSCNR ;;Clinic's Stop Code ^$TXT1^ has no restriction type ^$TXT2^.
CLNURGT ;;Access to ^$TXT1^ is prohibited!^$TXT2^Only users with a special code may access this clinic.
CLNNOSL ;;No 'SL' node defined - cannot proceed with this clinic.
PATDIED ;;PATIENT HAS DIED.
PATNFND ;;Patient not found.
NOAVSLO ;;No available slots found on the same day in all the selected clinics for this date range
APTCRGT ;;Appt. in ^$TXT1^ NOT CANCELLED^$TXT2^Access to this clinic is restricted to only privileged users!
APTCCHO ;;>>> Appointment has a check out date and cannot be cancelled.
APTCAND ;;Appointment already cancelled
APTCNPE ;;You cannot cancel this appointment.
APTCIPE ;;You cannot check in this appointment.
APTCITS ;;It is too soon to check in this appointment.
APTPPAB ;;That date is prior to the patient's date of birth.
APTPCLA ;;That date is prior to the clinic's availability date.
APTCLUV ;;There is no availability for this date/time.
APTEXCD ;;EXCEEDS MAXIMUM DAYS FOR FUTURE APPOINTMENT!!
APTSHOL ;;^$TXT1^??
APTPAHA ;;PATIENT ALREADY HAS APPOINTMENT ^$TXT1^ THEN.
APTPHSD ;;PATIENT ALREADY HAS APPOINTMENT ON THE SAME DAY ^$TXT1^
APTPPCP ;;THIS TIME WAS PREVIOUSLY CANCELLED BY THE PATIENT
APTOVBK ;;OVERBOOK!
APTOVOS ;;THAT TIME IS NOT WITHIN SCHEDULED PERIOD!
APTOAPD ;;ONLY ^$TXT1^ OVERBOOK^$TXT2^ PER DAY!!
APTCBCP ;;CAN'T BOOK WITHIN A CANCELLED TIME PERIOD
APTNOST ;;NO OPEN SLOTS THEN
APTEXOB ;;WILL EXCEED MAXIMUM ALLOWABLE OVERBOOKS,
APTLOCK ;;Another user is editing this record.  Trying again.
APTCINV ;;*** Note: Clinic is scheduled to be inactivated on ^$TXT1^$TXT2^
APTNSCE ;;You cannot execute no-show processing for this appointment.
APTNSTS ;;It is too soon to no-show this appointment.
APTNSAL ;;ALREADY RECORDED AS NO-SHOW... WANT TO ERASE
APTNSAR ;;THIS APPOINTMENT ALREADY A NO-SHOW AND REBOOKED... ARE YOU SURE YOU WANT TO ERASE
APTNSIA ;;Inpatient Appointments cannot reflect No-Show status!
