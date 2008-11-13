! Copyright (C) 2008 _hrrld
! See http://factorcode.org/license.txt for BSD license.
USING: accessors fry math math.functions math.trig kernel combinators combinators.cleave arrays sequences assocs ;
IN: la

TUPLE: float3x3 m11 m12 m13 m21 m22 m23 m31 m32 m33 ;
C: <float3x3> float3x3
: new-float3x3 ( -- float3x3 ) 1 0 0 0 1 0 0 0 1 <float3x3> ;

: rot-float3x3 ( theta -- float3x3 )
    deg>rad
    {
        [ cos    ] [ sin neg ] [ drop 0 ]
        [ sin    ] [ cos     ] [ drop 0 ]
        [ drop 0 ] [ drop 0  ] [ drop 1 ]
    } cleave <float3x3> ;

: translate-float3x3 ( x y -- float3x3 ) '[ 1 0 0 0 1 0 _ _ 1 ] call <float3x3> ;

GENERIC: transpose ( matrix -- matrix )

M: float3x3 transpose ( matrix -- matrix ) 
    { 
        [ m11>> ] [ m21>> ] [ m31>> ] 
        [ m12>> ] [ m22>> ] [ m32>> ] 
        [ m13>> ] [ m23>> ] [ m33>> ] 
    } cleave <float3x3> ;

GENERIC: columns ( matrix -- seq-columns )
GENERIC: column ( matrix n -- column )

M: float3x3 columns ( float3x3 -- seq-columns ) 
         dup { [ m11>> ] [ m21>> ] [ m31>> ] } 1arr 
    swap dup { [ m12>> ] [ m22>> ] [ m32>> ] } 1arr 
    swap     { [ m13>> ] [ m23>> ] [ m33>> ] } 1arr 3array ;

M: float3x3 column ( n matrix -- column ) columns nth ;

GENERIC: rows ( matrix -- seq-rows ) 
GENERIC: row ( n matrix -- row ) 

M: float3x3 rows ( matrix -- seq-rows ) transpose columns ;

M: float3x3 row ( n matrix -- row ) rows nth ;

GENERIC: mult ( matrix matrix -- matrix )

M: float3x3 mult ( matrix matrix -- matrix )
    { 
        [ 0 swap column ] [ 1 swap column ] [ 2 swap column ] 
        [ 0 swap column ] [ 1 swap column ] [ 2 swap column ] 
        [ 0 swap column ] [ 1 swap column ] [ 2 swap column ] 
    } 1arr
    swap
    { 
        [ 0 swap row ] [ 0 swap row ] [ 0 swap row ] 
        [ 1 swap row ] [ 1 swap row ] [ 1 swap row ] 
        [ 2 swap row ] [ 2 swap row ] [ 2 swap row ] 
    } 1arr
    zip [ first2 [ * ] [ + ] 2map-reduce ] map 
    { 
        [ 0 swap nth ] [ 1 swap nth ] [ 2 swap nth ] 
        [ 3 swap nth ] [ 4 swap nth ] [ 5 swap nth ] 
        [ 6 swap nth ] [ 7 swap nth ] [ 8 swap nth ] 
    } cleave <float3x3> ;
 