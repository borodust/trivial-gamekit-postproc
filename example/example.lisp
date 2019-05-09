(cl:defpackage :trivial-gamekit.postproc.example
  (:use :cl)
  (:export #:run))
(cl:in-package :trivial-gamekit.postproc.example)


(defparameter *background* (gamekit:vec4 0.2 0.2 0.2 1))
(defparameter *foreground* (gamekit:vec4 0.8 0.8 0.8 1))
(defvar +origin+ (gamekit:vec2 0 0))

(gamekit:defgame postproc-example (gamekit.postproc:postproc
                                   gamekit.postproc.blur:blur-postproc)
  ()
  (:viewport-width 480)
  (:viewport-height 640)
  (:canvas-width 240)
  (:canvas-height 320)
  (:viewport-title "Post-processed example")
  (:default-initargs :postproc-pipelines '(gamekit.postproc.blur:blur-pipeline)
                     :postproc-indirect-width 240
                     :postproc-indirect-height 320))


(defmethod gamekit.postproc.blur:blur-passes ((this postproc-example))
  0)

(gamekit:define-image :ship
    (asdf:system-relative-pathname :trivial-gamekit-postproc/example "./example/forthebenefitormrkite.png"))

(defmethod gamekit:draw ((this postproc-example))
  (bodge-canvas:antialias-shapes nil)
  (let* ((current-time (/ (bodge-util:real-time-seconds) 2))
         (x (+ (* (cos current-time) 50) 80))
         (y 20 #++ (+ (* (sin current-time) 100) 100)))
    (bodge-canvas:antialias-shapes nil)
    (gamekit:draw-rect +origin+
                       240 320
                       :fill-paint *background*)
    (gamekit:draw-image (gamekit:vec2 (floor x) (floor y)) :ship)))


(defun run ()
  (gamekit:start 'postproc-example :swap-interval 0))
