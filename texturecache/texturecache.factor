! Copyright (C) 2008 _hrrld.
! See http://factorcode.org/license.txt for BSD license.
USING: namespaces assocs kernel prettyprint freeimage opengl opengl.gl math byte-arrays fry ;
IN: texturecache

SYMBOL: texture-cache-variable
: <texture-cache> ( -- ) H{ } texture-cache-variable set-global ;
: texture-cache ( -- texture-cache ) texture-cache-variable get-global ;

: (load-texture) ( path -- )
    GL_TEXTURE_2D glEnable
    GL_TEXTURE_2D gen-texture [ glBindTexture ] keep over texture-cache set-at
    GL_TEXTURE_2D GL_TEXTURE_MAG_FILTER GL_LINEAR glTexParameteri
    GL_TEXTURE_2D GL_TEXTURE_MIN_FILTER GL_LINEAR glTexParameteri
    GL_TEXTURE_2D GL_TEXTURE_WRAP_S GL_CLAMP glTexParameterf
    GL_TEXTURE_2D GL_TEXTURE_WRAP_T GL_CLAMP glTexParameterf

    dup _FreeImage_GetFIFFromFilename
    swap 0 _FreeImage_Load
    _FreeImage_ConvertTo32Bits
    dup
    [ _FreeImage_GetWidth ] [ _FreeImage_GetHeight ] bi rot dup
    [ _FreeImage_GetWidth ] [ _FreeImage_GetHeight ] bi * 4 * <byte-array>
    [
        swap dup _FreeImage_GetPitch 
        32
        HEX: 00FF0000
        HEX: 0000FF00
        HEX: 000000FF 
        t
        _FreeImage_ConvertToRawBits 
    ] keep 

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

: load-texture ( path -- id ) 
    dup
    dup
    texture-cache at*
    [ nip nip ]
    [
        drop (load-texture)
        texture-cache at
    ]
    if ;
