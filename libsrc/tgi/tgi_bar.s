;
; Ullrich von Bassewitz, 21.06.2002
;
; void __fastcall__ tgi_bar (int x1, int y1, int x2, int y2);
; /* Draw a bar (a filled rectangle) using the current color */


        .include        "tgi-kernel.inc"

        .importzp       ptr1, ptr2, ptr3, ptr4
        .import         popax
        .import         _tgi_getmaxx, _tgi_getmaxy
        .export         _tgi_bar

_tgi_bar:
        sta     ptr4            ; Y2
        stx     ptr4+1

        jsr     popax
        sta     ptr3            ; X2
        stx     ptr3+1

        jsr     popax
        sta     ptr2            ; Y1
        stx     ptr2+1

        jsr     popax
        sta     ptr1            ; X1
        stx     ptr1+1

; Make sure X1 is less than X2. Swap both if not.

        lda     ptr3
        cmp     ptr1
        lda     ptr3+1
        sbc     ptr1+1
        bpl     @L1
        lda     ptr3
        ldy     ptr1
        sta     ptr1
        sty     ptr3
        lda     ptr3+1
        ldy     ptr1+1
        sta     ptr1+1
        sty     ptr3+1

; Make sure Y1 is less than Y2. Swap both if not.

@L1:    lda     ptr4
        cmp     ptr2
        lda     ptr4+1
        sbc     ptr2+1
        bpl     @L2
        lda     ptr4
        ldy     ptr2
        sta     ptr2
        sty     ptr4
        lda     ptr4+1
        ldy     ptr2+1
        sta     ptr2+1
        sty     ptr4+1

; Check if X2 or Y2 are negative. If so, the bar is completely out of screen.

@L2:    lda     ptr4+1
        ora     ptr3+1
        bmi     @L9             ; Bail out

; Check if X1 is negative. If so, clip it to the left border (zero).

        lda     #$00
        bit     ptr1+1
        bpl     @L3
        sta     ptr1
        sta     ptr1+1

; Dito for Y1

@L3:    bit     ptr2+1
        bpl     @L4
        sta     ptr2
        sta     ptr2+1

; Check if X2 is larger than the maximum x coord. If so, clip it.

@L4:    lda     ptr3
        cmp     _tgi_xres
        lda     ptr3+1
        sbc     _tgi_xres+1
        bcs     @L5
        jsr     _tgi_getmaxx
        sta     ptr3
        stx     ptr3+1

; Check if Y2 is larger than the maximum y coord. If so, clip it.

@L5:    lda     ptr4
        cmp     _tgi_yres
        lda     ptr4+1
        sbc     _tgi_yres+1
        bcs     @L6
        jsr     _tgi_getmaxy
        sta     ptr4
        stx     ptr4+1

; The coordinates are now valid. Call the driver.

@L6:    jmp     tgi_bar

; Error exit

@L9:    rts


