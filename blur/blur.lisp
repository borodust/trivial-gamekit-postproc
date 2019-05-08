(cl:defpackage :trivial-gamekit.postproc.blur
  (:nicknames :gamekit.postproc.blur)
  (:use :cl :gamekit.postproc)
  (:export #:blur-postproc
           #:blur-pipeline
           #:blur-passes))
(cl:in-package :trivial-gamekit.postproc.blur)


(ge.gx:defshader (blur-vertex
                  (:sources "blur.v.glsl")
                  (:base-path :system-relative :trivial-gamekit-postproc/blur))
  (canvas-position :location 0))


(ge.gx:defshader (blur-fragment
                  (:sources "blur.f.glsl")
                  (:base-path :system-relative :trivial-gamekit-postproc/blur))
  (canvas-texture :name "image")
  (canvas-width :name "width")
  (canvas-height :name "height")
  (vertical :name "isVertical" :type :bool))


(ge.gx:defpipeline blur-pipeline
  :vertex blur-vertex
  :fragment blur-fragment)


(defclass blur-postproc () ())


(defgeneric blur-passes (blur-postproc)
  (:method ((this blur-postproc))
    (declare (ignore this))
    1))


(defmethod handle-pipeline-rendering ((this blur-postproc)
                                      (pipeline-class (eql 'blur-pipeline)))
  (loop repeat (blur-passes this)
        do (render-pipeline 'vertical t)
           (render-pipeline 'vertical nil)))
