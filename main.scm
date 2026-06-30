(define gui #f)
(define width 402)
(define height 874)
(define padding 20)

(define vh(lambda(h)
    (set! h (/ h 100))
    (set! h (* h height))
    (+ h 0)
))

(define center(lambda(w)
    (set! w (- width w))
    (set! w (/ w 2))
    (+ w 0)
))

(define result (lambda(t p)
    (glgui-box gui (center (- width padding)) (vh p) (- width padding) (vh 7) White)
    (glgui-box gui (+ (center (- width padding)) 1) (+ (vh p) 1) (- (- width padding) 2) (- (vh 7) 2) Black)
    (glgui-label gui (+ (center (- width padding)) (vh 10)) (vh p) (- width padding) (vh 7) t dejavu_16.fnt White)
))

(main
    (lambda (w h)
        (make-window width height)
        (glgui-orientation-set! GUI_PORTRAIT)

        (set! gui (make-glgui))
        (glgui-box gui 0 0 width height Black)
        (glgui-box gui (center (vh 30)) (vh 5) (vh 30) (vh 10) Green)
        (glgui-button-string gui (center (vh 30)) (vh 5) (vh 30) (vh 10) "Load Image" dejavu_18.fnt newline)
        (result " Leaf Mold (98%)" 20)
        (result " Bacterial Spot (73%)" 30)
        (result " Early Blight (54%)" 40)
        (glgui-label gui (center (- width 20)) (vh 50) width (vh 10) "Results" dejavubold_32.fnt White)
        (glgui-box gui (center (vh 30)) (vh 65) (vh 30) (vh 30) White)
    )

    (lambda(t x y)
        (glgui-event gui t x y)
    )

    (lambda () #t)

    (lambda () (glgui-suspend))

    (lambda () (glgui-resume))
)