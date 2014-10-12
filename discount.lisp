(in-package #:discount)

(defun mkd-line (string)
  (cffi:with-foreign-string ((foreign-value-string foreign-value-length) string)
    (cffi:with-foreign-objects ((result '(:pointer :char)))
      (let ((n (%mkd-line foreign-value-string foreign-value-length result 0)))
        (when (minusp n)
          (error "Failed to parse line"))
        (let* ((string-pointer (cffi:mem-ref result '(:pointer :char)))
               (s (cffi:foreign-string-to-lisp string-pointer)))
          (%free string-pointer)
          s)))))

;;;
;;;  The following call ensures that the internal function mkd_initialize() has
;;   been called at least once in order to ensure that all further calls are
;;;  reentrant.
;;;

(defvar *initialised-p* nil)

(unless *initialised-p*
  (mkd-line "foo")
  (setq *initialised-p* t))
