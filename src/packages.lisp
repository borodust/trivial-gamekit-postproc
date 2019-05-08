(bodge-util:define-package :trivial-gamekit.postproc
  (:nicknames :gamekit.postproc)
  (:use :cl :cl-bodge.engine)
  (:export #:postproc

           #:handle-pipeline-rendering
           #:render-pipeline

           #:canvas-position
           #:canvas-texture
           #:canvas-width
           #:canvas-height))
