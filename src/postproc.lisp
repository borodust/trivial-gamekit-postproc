(cl:in-package :trivial-gamekit.postproc)


(defclass postproc ()
  ((width :initform nil :initarg :postproc-indirect-width)
   (height :initform nil :initarg :postproc-indirect-height)
   (filter :initform :nearest :initarg :postproc-indirect-filter)
   (pipeline-classes :initform nil :initarg :postproc-pipelines)
   (pipeline-chain :initform nil)
   (banner-pipeline :initform nil)
   (banner :initform nil)
   (framebuffer-size :initform (vec2 0 0))))


(defmethod enabling-flow list ((this postproc))
  (with-slots (width height filter
               banner banner-array-buffer banner-pipeline
               pipeline-classes pipeline-chain)
      this
    (>> (ge.host:for-host ()
          (ge.host:with-framebuffer-dimensions (width height)
            (list width height)))
        (ge.gx:for-graphics ((framebuffer-width framebuffer-height))
          (setf width (or width framebuffer-width)
                height (or height framebuffer-height)
                banner-pipeline (ge.gx:make-shader-pipeline 'banner-pipeline)
                banner (make-banner)
                pipeline-chain (make-pipeline-chain pipeline-classes
                                                    width height filter))))))


(defmethod disabling-flow list ((this postproc))
  (with-slots (banner banner-pipeline pipeline-chain) this
    (instantly ()
      (dispose banner-pipeline)
      (destroy-banner banner)
      (destroy-pipeline-chain pipeline-chain))))


(defun update-indirect-canvas (&key filter width height)
  (ge.app:when-app (postproc)
    (when (subtypep (class-of postproc) 'postproc)
      (with-slots (pipeline-chain
                   (this-width width)
                   (this-height height)
                   (this-filter filter))
          postproc
        (run (ge.gx:for-graphics ()
               (setf this-width (or width this-width)
                     this-height (or height this-height)
                     this-filter (or filter this-filter))
               (update-pipeline-textures pipeline-chain
                                         this-width
                                         this-height
                                         this-filter)))))))


(define-event-handler on-framebuffer-change
    ((event ge.host:framebuffer-size-change-event) width height)
  (when (subtypep (class-of (ge.app:app)) 'postproc)
    (with-slots (framebuffer-size (this-width width) (this-height height)) (ge.app:app)
      (setf (x framebuffer-size) width
            (y framebuffer-size) height)
      (update-indirect-canvas :width (or this-width width)
                              :height (or this-height height)))))


(defmethod ge.app:handle-drawing ((this postproc) canvas ui)
  (with-slots (banner-pipeline banner pipeline-chain framebuffer-size) this
    (flet ((render-canvas (output)
             (ge.app:render-app-canvas this output)))
      (let* ((*postproc-instance* this)
             (*banner* banner)
             (texture (render-pipeline-chain pipeline-chain #'render-canvas)))
        (ge.gx:clear-rendering-output t)
        (render-banner t banner-pipeline banner texture
                       (x framebuffer-size) (y framebuffer-size))
        (ge.ui:compose-ui ui)))
    t))
