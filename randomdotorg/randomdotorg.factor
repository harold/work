! Copyright (C) 2008 Harold Hausman
! See http://factorcode.org/license.txt for BSD license.
USING: http.client kernel sequences splitting accessors make math.parser combinators ;
IN: randomdotorg

! http://www.random.org/integers/?num=10&min=1&max=6&col=1&base=10&format=plain&rnd=new

TUPLE: randomdotorg num min max base ;
C: <randomdotorg> randomdotorg
GENERIC: get ( randomdotorg -- {num} )

: (get-clean) ( nums http-response -- {num} )
  [ 10 = ] trim-right "\n" split nip ; 

M: randomdotorg get ( randomdotorg -- {num} )
  { [ base>> ] [ max>> ] [ min>> ] [ num>> ] } cleave  
  [ "http://www.random.org/integers/?num=" , number>string , 
    "&min=" , number>string ,
    "&max=" , number>string ,
    "&col=1&base=" , number>string ,
    "&format=plain&rnd=new" ,
  ] { } make concat http-get (get-clean) ;
