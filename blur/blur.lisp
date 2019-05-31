(cl:defpackage :trivial-gamekit.postproc.blur
  (:nicknames :gamekit.postproc.blur)
  (:use :cl :gamekit.postproc)
  (:export #:blur-postproc
           #:blur-pipeline
           #:blur-passes
           #:blur-offset-coefficient))
(cl:in-package :trivial-gamekit.postproc.blur)


(gamekit.postproc::define-postprocessing-pipeline
    (blur-pipeline
     (:sources "blur.f.glsl")
     (:base-path :system-relative :trivial-gamekit-postproc/blur))
  (vertical :name "isVertical" :type :bool)
  (offset-coefficient :name "offsetCoef"))


(defclass blur-postproc () ())


(defgeneric blur-passes (blur-postproc)
  (:method ((this blur-postproc))
    (declare (ignore this))
    1))


(defgeneric blur-offset-coefficient (blur-postproc)
  (:method ((this blur-postproc))
    (declare (ignore this))
    1f0))


(defmethod handle-pipeline-rendering ((this blur-postproc)
                                      (pipeline-class (eql 'blur-pipeline)))
  (loop repeat (blur-passes this)
        do (render-pipeline 'vertical t
                            'offset-coefficient (float (blur-offset-coefficient this) 0f0))
           (render-pipeline 'vertical nil
                            'offset-coefficient (float (blur-offset-coefficient this) 0f0))))
