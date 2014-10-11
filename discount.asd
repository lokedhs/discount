(asdf:defsystem #:discount
  :description "Common Lisp interface to the Discount markup library"
  :author "Elias Martenson <lokedhs@gmail.com>"
  :license "MIT"
  :serial t
  :depends-on (:alexandria
               :cffi)
  :components ((:file "package")
               (:file "functions")
               (:file "discount")))
