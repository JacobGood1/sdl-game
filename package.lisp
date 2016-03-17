;;;; package.lisp

(defpackage :sdl
  (:use #:cl :utilities)
  (:export :init))

(defpackage :game-utilities
  (:use #:cl :sdl :utilities))

(defpackage :timer
  (:use #:cl :sdl :utilities))

(defpackage :game
  (:use #:cl :sdl :utilities)
  (:export :render))

(defpackage :travis-test
  (:use #:cl :sdl :utilities))
;main package contains the # all others should not have it
(defpackage #:sdl-game
  (:use #:cl :utilities))




