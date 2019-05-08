(cl:in-package :trivial-gamekit.postproc)


(ge.gx:defshader (banner-vertex
                  (:sources "banner.v.glsl")
                  (:base-path :system-relative :trivial-gamekit-postproc))
  (canvas-position :location 0))


(ge.gx:defshader (banner-fragment
                  (:sources "banner.f.glsl")
                  (:base-path :system-relative :trivial-gamekit-postproc))
  (canvas-texture :name "banner")
  (canvas-width :name "width")
  (canvas-height :name "height"))


(ge.gx:defpipeline banner-pipeline
  :vertex banner-vertex
  :fragment banner-fragment)


(defclass banner ()
  ((position-buffer :initform (ge.gx:make-array-buffer #2a((1f0 -1f0)
                                                           (1f0 1f0)
                                                           (-1f0 -1f0)
                                                           (-1f0 1f0))))))


(defun make-banner ()
  (make-instance 'banner))


(defun destroy-banner (banner)
  (with-slots (position-buffer) banner
    (dispose position-buffer)))


(defun render-banner (output pipeline banner texture width height &rest pipeline-args)
  (with-slots (position-buffer) banner
    (apply #'ge.gx:render output pipeline
           :vertex-count 4
           :primitive :triangle-strip
           'canvas-position position-buffer
           'canvas-texture texture
           'canvas-width (float width 0f0)
           'canvas-height (float height 0f0)
           pipeline-args)))
