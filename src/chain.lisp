(cl:in-package :trivial-gamekit.postproc)

(declaim (special *postproc-instance*
                  *current-pipeline*
                  *banner*
                  *pipeline-chain*
                  *banner-array-buffer*))

(defun make-postproc-indirect-buffer (width height filter)
  (ge.gx:make-empty-2d-texture width height :rgba :magnification-filter filter))


(defclass pipeline-chain ()
  ((destination-texture :initform nil :initarg :destination-texture)
   (source-texture :initform nil :initarg :source-texture)
   (pipelines :initform nil :initarg :pipelines)))


(defun make-pipeline-chain (pipeline-classes width height filter)
  (make-instance 'pipeline-chain
                 :pipelines (loop for pipeline in pipeline-classes
                                  collect (ge.gx:make-shader-pipeline pipeline))
                 :destination-texture (make-postproc-indirect-buffer width height filter)
                 :source-texture (make-postproc-indirect-buffer width height filter)))


(defun destroy-pipeline-chain (chain)
  (with-slots (destination-texture source-texture pipelines) chain
    (dispose destination-texture)
    (dispose source-texture)
    (mapc #'dispose pipelines)))


(defun %swap-chain-textures (chain)
  (with-slots (destination-texture source-texture) chain
    (rotatef destination-texture source-texture)))


(defun render-pipeline (&rest pipeline-args &key &allow-other-keys)
  (with-slots (source-texture destination-texture) *pipeline-chain*
    (destructuring-bind (width height) (ge.gx:texture-dimensions destination-texture)
      (apply #'render-banner destination-texture
             *current-pipeline* *banner*
             source-texture
             width height
             pipeline-args)))
  (%swap-chain-textures *pipeline-chain*))


(defgeneric handle-pipeline-rendering (postproc pipeline-class)
  (:method (postproc pipeline-class)
    (declare (ignore postproc pipeline-class))
    (render-pipeline)))


(defun render-pipeline-chain (chain initial-renderer)
  (with-slots (destination-texture source-texture pipelines) chain
    (ge.gx:clear-rendering-output destination-texture)
    (ge.gx:clear-rendering-output source-texture)

    (funcall initial-renderer source-texture)

    (loop for pipeline in pipelines
          do (let ((*current-pipeline* pipeline)
                   (*pipeline-chain* chain))
               (handle-pipeline-rendering *postproc-instance*
                                          (bodge-util:class-name-of pipeline))))
    source-texture))


(defun update-pipeline-textures (chain width height filter)
  (with-slots (source-texture destination-texture) chain
    (let ((old-texes (list source-texture destination-texture)))
      (setf source-texture (make-postproc-indirect-buffer width
                                                          height
                                                          filter)
            destination-texture (make-postproc-indirect-buffer width
                                                               height
                                                               filter))
      (loop for tex in old-texes
            when tex
              do (dispose tex)))))
