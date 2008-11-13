! Copyright (C) 2008 _hrrld
! See http://factorcode.org/license.txt for BSD license.
!
USING: system combinators alien alien.syntax ;
IN: freeimage

<<
"freeimage" {
    { [ os winnt? ]  [ "freeimage.dll" ] }
    { [ os macosx? ] [ "" ] }
    { [ os unix? ]   [ "" ] }
} cond "stdcall" add-library
>>

LIBRARY: freeimage

FUNCTION: char* _FreeImage_GetVersion ( ) ;
FUNCTION: int   _FreeImage_GetFIFFromFilename ( char* path ) ;
FUNCTION: void* _FreeImage_Load ( int FIF, char* path, int flags ) ;
FUNCTION: void  _FreeImage_Unload ( void* image ) ;
FUNCTION: void* _FreeImage_ConvertTo32Bits ( void* image ) ;
FUNCTION: int   _FreeImage_GetWidth  ( void* 32BitImage ) ;
FUNCTION: int   _FreeImage_GetHeight ( void* 32BitImage ) ;
FUNCTION: int   _FreeImage_GetPitch  ( void* 32BitImage ) ;
FUNCTION: void  _FreeImage_ConvertToRawBits ( char* bits, void* image, int scanwidth, int bpp, int FI_RGBA_RED_MASK, int FI_RGBA_GREEN_MASK, int FI_RGBA_BLUE_MASK, bool true ) ;
