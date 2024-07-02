;;;; ***********************************************************************
;;;;
;;;; Name:          net.bardcode.literals.asd
;;;; Project:       Delectusweb
;;;; Purpose:       convenient lteral syntax for some CL data
;;;; Author:        mikel evins
;;;; Copyright:     2021 by mikel evins
;;;;
;;;; ***********************************************************************

(asdf:defsystem #:net.bardcode.literals
  :description "Describe net.bardcode.literals here"
  :author "Your Name <your.name@example.com>"
  :license "Apache 2.0"
  :version (:read-file-form "version.lisp")
  :serial t
  :depends-on (:net.bardcode.dict)
  :components ((:file "package")
               (:file "literals")))

;;; (asdf:load-system :net.bardcode.literals)
;;; (ql:quickload :net.bardcode.literals)
