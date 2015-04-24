(in-package #:discount)

(cffi:define-foreign-library libmarkdown
  (:darwin "libmarkdown.dylib")
  (:unix "libmarkdown.so"))

(cffi:use-foreign-library libmarkdown)

(cffi:defcfun ("mkd_string" %mkd-string) :pointer
  (string :string)
  (size :int)
  (flags :int))

(cffi:defcfun ("markdown" %markdown) :int
  (doc :pointer))

(cffi:defcfun ("mkd_line" %mkd-line) :int
  (string :string)
  (size :int)
  (out (:pointer (:pointer :char)))
  (flags :int))

(cffi:defcfun ("mkd_e_free" %mkd-e-free) :void
  (string (:pointer :char))
  (ptr :pointer))

(cffi:defcfun ("free" %free) :void
  (value :pointer))
