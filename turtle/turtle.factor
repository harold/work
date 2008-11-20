! Copyright (C) 2008
! See http://factorcode.org/license.txt for BSD license.
USING: la sequences opengl opengl.gl opengl.demo-support kernel ui ui.gadgets.cartesian accessors combinators math math.functions combinators.cleave arrays ;
IN: turtle

TUPLE: turtle loc path ;
C: <turtle> turtle
: new-turtle ( -- turtle ) new-float3x3 new-float3x3 1array <turtle> ;

: rt ( turtle theta -- turtle ) rot-float3x3 over loc>> mult >>loc ;
: lt ( turtle theta -- turtle ) neg rt ;

: fd ( turtle dist -- turtle ) 
    0 swap translate-float3x3 over loc>> mult >>loc 
    dup path>> over loc>> 1array append >>path ;

: generate-path ( turtle -- turtle )
    12 [ 60 [ 6 rt 2  fd ] times 30 lt ] times 
    12 [ 60 [ 6 rt 4  fd ] times 30 lt ] times 
    12 [ 60 [ 6 rt 6  fd ] times 30 lt ] times 
    12 [ 60 [ 6 rt 8  fd ] times 30 lt ] times 
    12 [ 60 [ 6 rt 10 fd ] times 30 lt ] times 
    12 [ 60 [ 6 rt 12 fd ] times 30 lt ] times ;

: turtle-run ( -- )
    1.0 12 / dup dup 1 glClearColor GL_COLOR_BUFFER_BIT glClear
    ! 2 glLineWidth
    0.5 0.5 1 1.0 glColor4d
    new-turtle
    generate-path
    GL_LINE_STRIP 
        [ path>> [ [ m31>> ] [ m32>> ] bi glVertex2d ] each ] do-state ;

: <turtle-window> ( -- gadget )
    <cartesian>
        {  600 600 } >>pdim
        { -250 250 } x-range
        { -250 250 } y-range
        [ turtle-run ] >>action ;

: turtle-window ( -- )
    [ <turtle-window> "turtle" open-window ] with-ui ;

MAIN: turtle-window
