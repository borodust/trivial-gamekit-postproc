(cl:in-package :trivial-gamekit.postproc)


(ge.gx:defshader (postproc-fragment
                  (:name "gamekit/postproc")
                  (:headers "postproc.h")
                  (:sources "postproc.f.glsl")
                  (:base-path :system-relative :trivial-gamekit-postproc))
  (canvas-texture :name "_bodge_image")
  (canvas-width :name "_bodge_width")
  (canvas-height :name "_bodge_height"))


(defmacro define-postprocessing-pipeline (name-and-opts &body input)
  (destructuring-bind (name &rest opts) (bodge-util:ensure-list name-and-opts)
    (destructuring-bind (&key sources
                           (base-path (list (bodge-util:current-file-truename)))
                           options)
        (bodge-util:alist-plist opts)
      (let ((shader-name (bodge-util:symbolicate name '-%fragment%)))
        `(progn
           (ge.gx:defshader (,shader-name
                             (:sources ,@sources)
                             (:base-path ,@base-path)
                             (:options ,@options))
             ,@input)
           (ge.gx:defpipeline ,name
             :vertex banner-vertex
             :fragment ,shader-name))))))
