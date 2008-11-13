
TUPLE: float3 x y z ;
C: <float3> float3

M: float3 length ( seq -- n ) drop 3 ;
M: float3 nth-unsafe ( n seq -- elt ) swap { { 0 [ x>> ] } { 1 [ y>> ] }  { 2 [ z>> ] } } case ;
INSTANCE: float3 sequence

GENERIC: + ( float3 float3 -- float3 )
GENERIC: * ( n float3 -- float3 )
GENERIC: dot ( float3 float3 -- n ) 

M: float3 + ( float3 float3 -- float3 ) [ math:+ ] 2map first3 <float3> ;
M: float3 * ( n float3 -- float3 ) swap dup dup 3array [ math:* ] 2map first3 <float3> ;
M: float3 dot ( float3 float3 -- n ) [ math:* ] 2map first3 math:+ math:+ ;

TUPLE: float2 < float3 ;
: <float2> ( x y -- float2 ) 1 float2 boa ;

M: float2 nth-unsafe ( n seq -- elt ) swap { { 0 [ x>> ] } { 1 [ y>> ] }  { 2 [ drop 1 ] } } case ;
    
M: float2 + ( float2 float2 -- float2 ) [ math:+ ] 2map first2 <float2> ;
M: float2 * ( n float2 -- float2 ) swap dup dup 3array [ math:* ] 2map first2 <float2> ;
M: float2 dot ( float3 float3 -- n ) [ math:* ] 2map first2 math:+ ;


: transform ( float2 float3x3 -- float2 ) 
    columns
    swap dup dup 3array
    [ dot ] 2map first2 <float2> ;