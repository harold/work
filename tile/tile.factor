! Copyright (C) 2008
! See http://factorcode.org/license.txt for BSD license.
USING: opengl opengl.gl ui ui.gadgets.cartesian kernel accessors math random freeimage byte-arrays fry ;
IN: tile

: (get-image) ( path -- width height bits )
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
    ] keep ;
    
!  void glTexImage2D( GLenum target,
!     GLint level,
!     GLint internalformat,
!     GLsizei width,
!     GLsizei height,
!     GLint border,
!     GLenum format,
!     GLenum type,
!     const GLvoid *pixels )

: tile-test ( -- )
    0 0 0 1 glClearColor GL_COLOR_BUFFER_BIT glClear

    GL_TEXTURE_2D glEnable
    GL_TEXTURE_2D gen-texture glBindTexture
    GL_TEXTURE_2D GL_TEXTURE_MAG_FILTER GL_LINEAR glTexParameteri
    GL_TEXTURE_2D GL_TEXTURE_MIN_FILTER GL_LINEAR glTexParameteri
    GL_TEXTURE_2D GL_TEXTURE_WRAP_S GL_CLAMP glTexParameterf
    GL_TEXTURE_2D GL_TEXTURE_WRAP_T GL_CLAMP glTexParameterf
    
    "castle.png"
    (get-image)
    '[
        GL_TEXTURE_2D
        0
        GL_RGBA8
        _
        _
        0
        GL_RGBA
        GL_UNSIGNED_BYTE
        _
    ] call
    glTexImage2D
    
    1 1 1 1 glColor4d
    GL_QUADS
        [
             0    1   glTexCoord2i
            -100 -100 glVertex2d 
             0    0   glTexCoord2i
            -100  100 glVertex2d 
             1    0   glTexCoord2i
             100  100 glVertex2d 
             1    1   glTexCoord2i
             100 -100 glVertex2d 
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
