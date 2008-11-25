! Copyright (C) 2008
! See http://factorcode.org/license.txt for BSD license.
USING: ui image ;
IN: image-test

: <image-test-window> ( -- gadget )
    "UV-Checker2.png" <image> ;

: image-test-window ( -- )
    [ <image-test-window> "image-test" open-window ] with-ui ;

MAIN: image-test-window
