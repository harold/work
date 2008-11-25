! Copyright (C) 2008 _hrrld.
! See http://factorcode.org/license.txt for BSD license.
USING: assocs bake.fry random byte-arrays freeimage kernel math opengl
opengl.gl ui.gadgets accessors combinators.cleave ui.render opengl.demo-support ;
IN: image

TUPLE: image < gadget width height id ;

: (set-default-image-sampling) ( -- )
    GL_TEXTURE_2D GL_TEXTURE_MAG_FILTER GL_LINEAR glTexParameteri
    GL_TEXTURE_2D GL_TEXTURE_MIN_FILTER GL_LINEAR glTexParameteri
    GL_TEXTURE_2D GL_TEXTURE_WRAP_S GL_REPEAT glTexParameteri
    GL_TEXTURE_2D GL_TEXTURE_WRAP_T GL_REPEAT glTexParameteri ;

: <image> ( path -- image )
    image new-gadget
    GL_TEXTURE_2D glEnable
    GL_TEXTURE_2D gen-texture [ glBindTexture ] keep >>id
    
    (set-default-image-sampling)

    swap
    [ _FreeImage_GetFIFFromFilename ] keep 0 _FreeImage_Load
    _FreeImage_ConvertTo32Bits
    [ _FreeImage_GetWidth  >>width  ]
    [ _FreeImage_GetHeight >>height ]
    [ [ dup [ width>> ] [ height>> ] bi * 4 * <byte-array> ] dip ] tri
    [
        dup _FreeImage_GetPitch 
        32
        HEX: 00FF0000
        HEX: 0000FF00
        HEX: 000000FF 
        t
        _FreeImage_ConvertToRawBits 
    ] 3keep drop swap
    
    [ width>> ] [ height>> ] bi rot

    '[
        GL_TEXTURE_2D
        0
        GL_RGBA8
        _
        _
        0
        GL_BGRA
        GL_UNSIGNED_BYTE
        _
    ] call
    glTexImage2D ;

: <image2> ( path -- image )
    image new-gadget
    GL_TEXTURE_2D glEnable
    GL_TEXTURE_2D gen-texture [ glBindTexture ] keep >>id
    512 >>width 512 >>height
    
    (set-default-image-sampling)

    swap drop
    512 512 512 512 * 4 * random-bytes >byte-array
    '[
        GL_TEXTURE_2D
        0
        GL_RGBA8
        _
        _
        0
        GL_BGRA
        GL_UNSIGNED_BYTE
        _
    ] call
    glTexImage2D ;

M: image pref-dim* ( gadget -- dim )
    { [ width>> ] [ height>> ] } 1arr ;

M: image draw-gadget* ( gadget -- )
    id>> GL_TEXTURE_2D swap glBindTexture
    GL_TEXTURE_2D glEnable
    1 1 1 1 glColor4d
    GL_QUADS
        [
             0    1   glTexCoord2i
             0    0   glVertex2d 
             0    0   glTexCoord2i
             0    384 glVertex2d 
             1    0   glTexCoord2i
             384  384 glVertex2d 
             1    1   glTexCoord2i
             384  0   glVertex2d 
        ] do-state ;
