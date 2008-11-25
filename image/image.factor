! Copyright (C) 2008 _hrrld.
! See http://factorcode.org/license.txt for BSD license.
USING: accessors byte-arrays combinators fry kernel math opengl
opengl.gl ui.gadgets ui.render freeimage combinators.cleave prettyprint 
ui.gadgets.worlds arrays sequences alien.c-types ;
IN: image

TUPLE: image < gadget width height bytes id ;

: (set-default-image-sampling) ( -- )
    GL_TEXTURE_2D GL_TEXTURE_MAG_FILTER GL_LINEAR glTexParameteri
    GL_TEXTURE_2D GL_TEXTURE_MIN_FILTER GL_LINEAR glTexParameteri
    GL_TEXTURE_2D GL_TEXTURE_WRAP_S GL_REPEAT glTexParameteri
    GL_TEXTURE_2D GL_TEXTURE_WRAP_T GL_REPEAT glTexParameteri ;

: <image> ( path -- image )
    image new-gadget
    
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
    ] 3keep drop nip >>bytes ;
    
M: image pref-dim* ( gadget -- dim )
    { [ width>> ] [ height>> ] } 1arr ;

M: image graft* ( gadget -- ) 
    dup find-gl-context
    GL_TEXTURE_2D glEnable
    GL_TEXTURE_2D gen-texture [ glBindTexture ] keep >>id
    
    (set-default-image-sampling)

    [ width>> ] [ height>> ] [ bytes>> ] tri
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
    
M: image ungraft* ( gadget -- ) id>> 1array [ length ] [ >c-int-array ] bi glDeleteTextures ;

M: image draw-gadget* ( gadget -- )
    GL_TEXTURE_2D glEnable
    GL_TEXTURE_2D over id>> glBindTexture

    1 1 1 1 glColor4d
    GL_QUADS glBegin
    { [ height>> ] [ width>> ] [ height>> ] [ width>> ] } cleave
    '[
        0   0   glTexCoord2i
        0   0   glVertex2d 
        0   1   glTexCoord2i
        0   _   glVertex2d 
        1   1   glTexCoord2i
        _   _   glVertex2d 
        1   0   glTexCoord2i
        _   0   glVertex2d 
    ] call glEnd ;
