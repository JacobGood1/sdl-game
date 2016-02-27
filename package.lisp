;;;; package.lisp

(defpackage :sdl
  (:use #:cl :utilities))

;main package contains the # all others should not have it
(defpackage #:sdl-game
  (:use #:cl))

