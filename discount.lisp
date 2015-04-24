(in-package #:discount)

(defvar *flags-mappings* `((:nolinks ,mkd-nolinks)
                           (:noimage ,mkd-noimage)
                           (:nopants ,mkd-nopants)
                           (:nohtml ,mkd-nohtml)
                           (:strict ,mkd-strict)
                           (:tagtext ,mkd-tagtext)
                           (:no-ext ,mkd-no-ext)
                           (:cdata ,mkd-cdata)
                           (:nosuperscript ,mkd-nosuperscript)
                           (:norelaxed ,mkd-norelaxed)
                           (:notables ,mkd-notables)
                           (:nostrikethrough ,mkd-nostrikethrough)
                           (:toc ,mkd-toc)
                           (:1-compat ,mkd-1-compat)
                           (:autolink ,mkd-autolink)
                           (:safelink ,mkd-safelink)
                           (:noheader ,mkd-noheader)
                           (:tabstop ,mkd-tabstop)
                           (:nodivquote ,mkd-nodivquote)
                           (:noalphalist ,mkd-noalphalist)
                           (:nodlist ,mkd-nodlist)
                           (:extra-footnote ,mkd-extra-footnote)
                           (:nostyle ,mkd-nostyle)))

(defun flags-to-bitmap (flags)
  (loop
     with result = 0
     for flag in flags
     for value = (find flag *flags-mappings* :key #'car)
     unless value
     do (error "Unknown flag: ~s" flag)
     do (setq result (logior result (cadr value)))
     finally (return result)))

(defun markdown (string &optional flags)
  (cffi:with-foreign-string ((foreign-value-string foreign-value-length) string)    
    (let ((result (%mkd-string foreign-value-string foreign-value-length (flags-to-bitmap flags))))
      (when (cffi-sys:null-pointer-p result)
        (error "Failed to parse document"))
      (unwind-protect
           (cffi:with-foreign-objects ((out '(:pointer :char)))
             (let ((gen-result (%mkd-document result out)))
               (when (minusp gen-result)
                 (error "Failed to generate output document. return value=~s" gen-result))
               (let ((string-pointer (cffi:mem-ref out '(:pointer :char))))
                 (unwind-protect
                      (cffi:foreign-string-to-lisp string-pointer)
                   (%free string-pointer)))))
        (%free result)))))

(defun mkd-line (string &optional flags)
  (cffi:with-foreign-string ((foreign-value-string foreign-value-length) string)
    (cffi:with-foreign-objects ((result '(:pointer :char)))
      (let ((n (%mkd-line foreign-value-string foreign-value-length result (flags-to-bitmap flags))))
        (when (minusp n)
          (error "Failed to parse line. return value=~s" n))
        (let ((string-pointer (cffi:mem-ref result '(:pointer :char))))
          (unwind-protect
               (cffi:foreign-string-to-lisp string-pointer)
            (%free string-pointer)))))))

;;;
;;;  The following call ensures that the internal function mkd_initialize() has
;;   been called at least once in order to ensure that all further calls are
;;;  reentrant.
;;;

(defvar *initialised-p* nil)

(unless *initialised-p*
  (mkd-line "foo")
  (setq *initialised-p* t))
