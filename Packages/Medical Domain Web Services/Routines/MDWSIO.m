MDWSIO ; MTZ/CKU - MDWS IO 11/05/12
 ;;1.0;MDWS;**1**;Nov 5, 2012;
 Q
S(XWBY) ; SERIALIZE ENTIRE SYMBOL TABLE IN LOCATION SPECIFIED
 N %IGNORE S %IGNORE=1,Y="%"
 F  Q:Y=""  D
 . ;I ((Y'="XWBP")&(Y'="XWBR")&(Y'="XWBY")&(Y'="%IGNORE")) D ; XWBP,XWBR,XWBY M references
 . I (("XWB"'=$E(Y,1,3))&(Y'="%IGNORE")) D
 . . I ($D(@Y)=1)!($D(@Y)=11) D
 . . . I @Y=+@Y S %IGNORE(%IGNORE)=Y_$C(30)_+@Y_$C(31)
 . . . E  I @Y'=+@Y S %IGNORE(%IGNORE)=Y_$C(30)_""_@Y_""_$C(31)
 . . . S %IGNORE=%IGNORE+1
 . . . I $D(@Y)=11 N YY S YY=Y S YY=$Q(@YY) D
 . . . . F  Q:YY=""  D
 . . . . . I ($D(@YY)=1)!($D(@YY)=11) D
 . . . . . . I @YY=+@YY S %IGNORE(%IGNORE)=YY_$C(30)_+@YY_$C(31)
 . . . . . . E  I @YY'=+@YY S %IGNORE(%IGNORE)=YY_$C(30)_""_@YY_""_$C(31)
 . . . . . S YY=$Q(@YY)
 . . . . . S %IGNORE=%IGNORE+1
 . . I ($D(@Y)=10) D
 . . . N YY S YY=Y F  Q:YY=""  D
 . . . . I ($D(@YY)=1)!($D(@YY)=11) D
 . . . . . I @YY=+@YY S %IGNORE(%IGNORE)=YY_$C(30)_+@YY_$C(31)
 . . . . . E  I @YY'=+@YY S %IGNORE(%IGNORE)=YY_$C(30)_""_@YY_""_$C(31)
 . . . . S YY=$Q(@YY)
 . . . . S %IGNORE=%IGNORE+1
 . S Y=$O(@Y)
 M XWBY=%IGNORE
 Q
D(%XWBY,%IGNORE) ; DESERIALIZE THE %IGNORE ARRAY
 S %IGNORE="%"
 F  Q:%IGNORE=""  D ; KILL THE ENTIRE SYMBOL TABLE EXCEPT %IGNORE
 . I $D(@%IGNORE) D
 . . I (%IGNORE'="%IGNORE")&("XWB"'=$E(%IGNORE,1,3)) K @%IGNORE
 . S %IGNORE=$O(@%IGNORE)
 
 S %IGNORE=$Q(%IGNORE) F  Q:%IGNORE=""  D
 . I "^"'=$E(@%IGNORE,1) D ; DISABLE JOEL FROM DIRECT GLOBAL WRITES ;)
 . . N %X1,%Y1 S %X1=$P(@%IGNORE,$C(30),1),%Y1=$P(@%IGNORE,$C(30),2)
 . . S @%X1=%Y1
 . ; S:$E(%IGNORE,1)'="^" @@%IGNORE 
 . S %IGNORE=$Q(@%IGNORE)
 
 S %XWBY=1
 Q