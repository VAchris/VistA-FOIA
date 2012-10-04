GMPLAPI7 ; RGI/VSL -- Problem List - REPORTS ; 09/14/12
 ;;2.0;Problem List;**260002**;Aug 25, 1994
 Q
 ;
 ; Finds patients with active and inactive problems.
 ;   TARGET: Root of the target local or global.
 ; Results stored as TARGET(PATIENT_NAME)=<# Active Problems>_"^"_<# Inactive Problems>
 ; Returns number of patients.
PPROBCNT(TARGET) ;
 Q $$PPROBCNT^GMPLDAL4(TARGET)
 ;
 ; Finds patients with specified active or inactive problems
 ;   TARGET: Root of the target local or global.
 ;   GMPTERM: Problem code
 ;   GMPTEXT: Problem text
 ;   STATUS: Problem status
PPRBSPEC(TARGET,GMPTERM,GMPTEXT,STATUS) ;
 Q $$PPRBSPEC^GMPLDAL4(TARGET,GMPTERM,GMPTEXT,STATUS)
 ;
