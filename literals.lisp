;;;; net.bardcode.literals.lisp

(in-package #:net.bardcode.literals)


;;; functions
;;; ---------------------------------------------------------------------
;;; enables us to write lambdas like (^ (x)(* x x))
;;; and funcalls like ($ fn arg1 arg2 arg3)

(defmacro ^ (args &body body)
  `(lambda ,args ,@body))

(defmacro $ (fn &rest args)
  `(funcall ,fn ,@args))


;;; lists
;;; ---------------------------------------------------------------------
;;; enables us to write literal lists like [1 2 3 [4 5] 6]

(set-macro-character #\[
                     (lambda (stream char)
                       (declare (ignore char))
                       (let ((elts (read-delimited-list #\] stream t)))
                         ` (cl:list ,@elts))))

(set-macro-character #\] (get-macro-character #\)))

;;; dicts
;;; ---------------------------------------------------------------------
;;; enables us to write literal dicts like {:a 1 :b 2 :c {:d 4 :e 5}}
;;; dicts created this way always use 'equal to test keys

(set-syntax-from-char #\{ #\()
(set-syntax-from-char #\} #\))

(set-macro-character #\{
                     (lambda (stream char)
                       (declare (ignore char))
                       (let ((elts (read-delimited-list #\} stream t)))
                         `(dict 'equal ,@elts))))
