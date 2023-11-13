;;;; net.bardcode.literals.lisp

(in-package #:net.bardcode.literals)


;;; lists
;;; ---------------------------------------------------------------------
;;; enables us to write literal lists like [1 2 3 [4 5] 6]

(set-macro-character #\[
                     (lambda (stream char)
                       (declare (ignore char))
                       (let ((elts (read-delimited-list #\] stream t)))
                         ` (cl:list ,@elts))))

(set-macro-character #\] (get-macro-character #\)))

;;; hash-tables
;;; ---------------------------------------------------------------------
;;; enables us to write literal hash-tables like #H:eql{:a 1 :b 2 :c {:d 4 :e 5}}
;;; or, if the testname is EQUALP, {:a 1 :b 2 :c {:d 4 :e 5}}

(set-syntax-from-char #\{ #\()
(set-syntax-from-char #\} #\))

(defmacro hash ((&key (test #'eql) (size 16)
                      (rehash-size 2) (rehash-threshold 1))
                &rest keys-vals-plist)
  (let ((h (gensym "new-hash-table")))
    `(let ((,h (make-hash-table :test ,test :size ,size
                                :rehash-size ,rehash-size
                                :rehash-threshold ,rehash-threshold)))
       ,@(loop
               :with tmp = nil
               :for e :in keys-vals-plist
               :for i :from 0
               :if (evenp i) :do (setf tmp e)
               :collect `(setf (gethash ,tmp ,h) ,e))
       ,h)))

(defun hash-reader (stream char n)
  (declare (ignore char n))
  (let* ((args (read stream t nil t)))
    (cons 'quote args)))

(set-macro-character #\{
                     (lambda (stream char)
                       (declare (ignore char))
                       (let ((elts (read-delimited-list #\} stream t)))
                         `(hash (:test 'equalp) ,@elts))))

;;; print-object

(defmethod print-object ((object hash-table) stream)
  (let ((testname (hash-table-test object)))
    (if (equalp (symbol-name testname) "EQUALP")
        (if (= (hash-table-count object) 0)
            (format stream "{}" testname)
            (let ((data (loop for k being the hash-keys of object
                           collect k
                           collect (gethash k object))))
              (format stream "{~{~s~^ ~}}" data)))
        (print-unreadable-object (object stream :type t)
          (format stream "<~S>" testname)
          (if (= (hash-table-count object) 0)
              (format stream "{}" testname)
              (let ((data (loop for k being the hash-keys of object
                             collect k
                             collect (gethash k object))))
                (format stream "{~{~s~^ ~}}" data)))))))


