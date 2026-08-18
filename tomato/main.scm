#|
LambdaNative - a cross-platform Scheme framework
Copyright (c) 2025, John Agoe
All rights reserved.

Redistribution and use in source and binary forms, with or
without modification, are permitted provided that the
following conditions are met:

* Redistributions of source code must retain the above
copyright notice, this list of conditions and the following
disclaimer.

* Redistributions in binary form must reproduce the above
copyright notice, this list of conditions and the following
disclaimer in the documentation and/or other materials
provided with the distribution.

* Neither the name of the University of British Columbia nor
the names of its contributors may be used to endorse or
promote products derived from this software without specific
prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
|#


(c-declare "#include \"main.c\"")
(define gui #f)
(define text #f)
(define img-box #f)
(define width 402)
(define height 874)
(define padding 20)

(define camera-image (string-append (system-directory) (system-pathseparator) "leaf.jpg"))
(define camera-image2 (string-append (system-directory) (system-pathseparator) "leaf.png"))

(define tomato-classes
  '#(
    "Bacterial Spot"
    "Early Blight"
    "Late Blight"
    "Leaf Mold"
    "Septoria Leaf Spot"
    "Spider Mites"
    "Target Spot"
    "Yellow Leaf Curl Virus"
    "Mosaic Virus"
    "Healthy"
    "Powdery Mildew"
))

(define lastmodtime 0.)
(define get-class 
    (c-lambda () int "getMaxClass")
)

(define get-max
    (c-lambda () double "getMax")
)

;;(define go
;;    (c-lambda () double "go")
;;)

(define classify
    (c-lambda ((pointer void)) int "classify")
)

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
    (glgui-box gui (center (- width padding)) (vh p) (- width padding) (vh 7) Black)
    (glgui-box gui (+ (center (- width padding)) 1) (+ (vh p) 1) (- (- width padding) 2) (- (vh 7) 2) White)
    (set! text (glgui-label gui (+ (center (- width padding)) (vh 10)) (vh p) (- width padding) (vh 7) t dejavu_16.fnt Black))
))

;;(display (go))

(define (autoload)
  (let* ((fileinfo (if (file-exists? camera-image) (file-info camera-image) #f))
         (modtime  (if fileinfo (time->seconds (file-info-last-modification-time fileinfo)) #f)))
    (if (and gui img-box text modtime (> modtime lastmodtime))
        (let* ((gdf (gdFileOpen camera-image "r"))
               (gd  (gdImageCreateFromJpeg gdf))
               (w   (gdImageSX gd))
               (h   (gdImageSY gd))
               (w2  260)
               (h2  260)
               (offset (/ (- h w) 2))
               (gdf2 (gdFileOpen camera-image2 "w"))
               (gd2 (gdImageCreateTrueColor w2 h2)))
         (gdImageCopyResampled gd2 gd 0 0 0 offset w2 h2 w w)
         (classify gd2)
         (glgui-widget-set! gui text 'label
            (string-append
                (vector-ref tomato-classes (get-class))
                " ("
                (number->string (get-max))
                "%)"
            ))
         (gdImagePng gd2 gdf2)
         (gdImageDestroy gd)
         (gdImageDestroy gd2)
         (gdFileClose gdf)
         (gdFileClose gdf2)
         (let ((img (if (file-exists? camera-image2) (png->img camera-image2) #f)))
           (glgui-widget-set! gui img-box 'image (if img img splash.img)))
         (set! lastmodtime modtime)
      ))))

(main
    (lambda (w h)
        (make-window width height)
        (glgui-orientation-set! GUI_PORTRAIT)

        (set! gui (make-glgui))
        (glgui-box gui 0 0 width height White)
        ;;(glgui-box gui (center 100) (vh 5) 100 100 Green)
        (glgui-button gui (center 100) (vh 5) 100 100 default.img (lambda (un . used) 
            (camera-start camera-image)
        ))
        (result " Unclassified (0%)" 40)
        ;;(result " Bacterial Spot (73%)" 30) 
        ;;(result " Early Blight (54%)" 20)
        (glgui-label gui (center (- width 20)) (vh 50) width (vh 10) "Results" dejavubold_32.fnt Black)
        (glgui-box gui (center (vh 30)) (vh 65) (vh 30) (vh 30) Black)
        (set! img-box (glgui-image gui (center (vh 30)) (vh 65) (vh 30) (vh 30) splash.img White))
        (if (file-exists? camera-image) (delete-file camera-image))
        (if (file-exists? camera-image2) (delete-file camera-image2))
        (let ((logdir (string-append (system-directory) "/log")))
        (if (not (file-exists? logdir)) (create-directory logdir)))
    )

    (lambda (t x y)
        (autoload)
        (if (= t EVENT_KEYPRESS) (begin
        (if (= x EVENT_KEYESCAPE) (terminate))))
        (glgui-event gui t x y)
    )

    (lambda () #t)

    (lambda () (glgui-suspend))

    (lambda () (glgui-resume))
)