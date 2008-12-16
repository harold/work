! Copyright (C) 2008 _hrrld.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel sequences io io.files io.encodings.ascii accessors combinators
  printf arrays ;
IN: svg

TUPLE: svg elements ;
C: <svg> svg

TUPLE: svg-line x1 x2 y1 y2 ;
C: <svg-line> svg-line

: qqq ( -- path svg ) 
  "foo.svg" 
  100 0 0 100 <svg-line> 1array <svg> ;

: (svg-element-write) ( svg-element -- )
  { [ x1>> ] [ y1>> ] [ x2>> ] [ y2>> ] } cleave
  "<line x1='%.3f' y1='%.3f' x2='%.3f' y2='%.3f' stroke='black' stroke-width='2' />" 
  printf ;

: (svg-write) ( svg -- ) 
  "<svg xmlns='http://www.w3.org/2000/svg'>" print
  elements>> [ (svg-element-write) ] each
  "</svg>" print ;
  
: svg>file ( path svg -- )
  ascii swap [ (svg-write) ] curry with-file-writer ;

! "<circle cx='50' cy='50' r='50' fill='red' />" 