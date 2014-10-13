(in-package #:discount)

(cffi:define-foreign-library libmarkdown
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

(cffi:defcfun ("mkd_document" %mkd-document) :int
  (doc :pointer)
  (out (:pointer (:pointer :char))))

(cffi:defcfun ("mkd_e_free" %mkd-e-free) :void
  (string (:pointer :char))
  (ptr :pointer))

(cffi:defcfun ("free" %free) :void
  (value :pointer))

(defconstant mkd-nolinks #x1)
(defconstant mkd-noimage #x2)
(defconstant mkd-nopants #x4)
(defconstant mkd-nohtml #x8)
(defconstant mkd-strict #x10)
(defconstant mkd-tagtext #x20)
(defconstant mkd-no-ext #x40)
(defconstant mkd-cdata #x80)
(defconstant mkd-nosuperscript #x100)
(defconstant mkd-norelaxed #x200)
(defconstant mkd-notables #x400)
(defconstant mkd-nostrikethrough #x800)
(defconstant mkd-toc #x1000)
(defconstant mkd-1-compat #x2000)
(defconstant mkd-autolink #x4000)
(defconstant mkd-safelink #x8000)
(defconstant mkd-noheader #x10000)
(defconstant mkd-tabstop #x20000)
(defconstant mkd-nodivquote #x40000)
(defconstant mkd-noalphalist #x80000)
(defconstant mkd-nodlist #x100000)
(defconstant mkd-extra-footnote #x200000)
(defconstant mkd-nostyle #x400000)

(defconstant mkd-embed (logior mkd-nolinks mkd-noimage mkd-tagtext))
