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
  (:viewport-width 800)
  (:viewport-height 600)
  (:viewport-title "Post-processed example")
  (:default-initargs :postproc-pipelines '(gamekit.postproc.blur:blur-pipeline)
                     :postproc-indirect-width 200
                     :postproc-indirect-height 150
                     :postproc-indirect-filter :linear))


(defmethod gamekit.postproc.blur:blur-passes ((this postproc-example))
  10)


(defmethod gamekit.postproc.blur:blur-offset-coefficient ((this postproc-example))
  (- 2 (* (abs (cos (* (bodge-util:real-time-seconds) 0.5))) 2)))


(defmethod gamekit:draw ((this postproc-example))
  (let* ((current-time (bodge-util:real-time-seconds))
         (x (+ (* (cos current-time) 100) (/ (gamekit:viewport-width) 2)))
         (y (+ (* (sin current-time) 100) (/ (gamekit:viewport-height) 2))))
    (gamekit:draw-rect +origin+
                       (gamekit:viewport-width) (gamekit:viewport-height)
                       :fill-paint *background*)
    (gamekit:draw-circle (gamekit:vec2 x y) 50 :fill-paint *foreground*)))


(defun run ()
  (gamekit:start 'postproc-example))
