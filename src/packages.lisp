(bodge-util:define-package :trivial-gamekit.postproc
  (:nicknames :gamekit.postproc)
  (:use :cl :cl-bodge.engine)
  (:export #:postproc

           #:define-postprocessing-pipeline
           #:handle-pipeline-rendering
           #:render-pipeline))
