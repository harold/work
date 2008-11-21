! Copyright (C) 2008
! See http://factorcode.org/license.txt for BSD license.
USING: opengl opengl.gl opengl.demo-support ui ui.gadgets.cartesian kernel accessors math random freeimage byte-arrays fry texturecache ;
IN: tile

: tile-test ( -- )
    <texture-cache>
    0 0 0 1 glClearColor GL_COLOR_BUFFER_BIT glClear

    "UV-Checker2.png" load-texture GL_TEXTURE_2D swap glBindTexture
    
    GL_TEXTURE_2D glEnable
    1 1 1 1 glColor4d
    GL_QUADS
        [
             0    1   glTexCoord2i
            -200 -200 glVertex2d 
             0    0   glTexCoord2i
            -200  200 glVertex2d 
             1    0   glTexCoord2i
             200  200 glVertex2d 
             1    1   glTexCoord2i
             200 -200 glVertex2d 
        ] do-state ;

: <tile-window> ( -- gadget )
    <cartesian>
        {  600 600 } >>pdim
        { -300 300 } x-range
        { -300 300 } y-range
        [ tile-test ] >>action ;

: tile-window ( -- )
    [ <tile-window> "tile" open-window ] with-ui ;

MAIN: tile-window
