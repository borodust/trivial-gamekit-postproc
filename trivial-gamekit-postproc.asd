(asdf:defsystem :trivial-gamekit-postproc
  :description "Post-processing for trivial-gamekit"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (bodge-utilities trivial-gamekit cl-bodge/graphics cl-bodge/canvas)
  :serial t
  :pathname "src/"
  :components ((:file "packages")
               (:file "banner")
               (:file "pipeline")
               (:file "postproc")))


(asdf:defsystem :trivial-gamekit-postproc/blur
  :description "Gaussian blur trivial-gamekit-postproc"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (:trivial-gamekit-postproc)
  :serial t
  :pathname "blur/"
  :components ((:file "blur")))


(asdf:defsystem :trivial-gamekit-postproc/example
  :description "Post-processing for trivial-gamekit"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (:trivial-gamekit-postproc :trivial-gamekit-postproc/blur)
  :serial t
  :pathname "example/"
  :components ((:file "example")))
