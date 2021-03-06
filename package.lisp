;;;; package.lisp

(defpackage :sdl
  (:use #:cl :utilities)
  (:export :init))

(defpackage :game-utilities/asset-manager
  (:use #:cl :sdl :utilities))

(defpackage :game-utilities/event-manager
  (:use #:cl :sdl :utilities)
  (:export :event-manager
	   
	   :key-pressed?
	   :key-down?
	   :key-released?
	   
	   :mouse-coordinate
	   :mouse-relative-coordinate
	   :LMB?
	   :MMB?
	   :RMB?
	   :MMB-scroll-up?
	   :MMB-scroll-down?))

(defpackage :game-utilities/game-utilities
  (:use #:cl :sdl :utilities :game-utilities/event-manager))

(defpackage :timer
  (:use #:cl :sdl :utilities))

(defpackage :game
  (:use #:cl :sdl :utilities)
  (:export :render))

(defpackage :jacob-test
  (:use #:cl :sdl :utilities))

(defpackage :travis-test
  (:use #:cl :sdl :utilities))
;main package contains the # all others should not have it
(defpackage :sdl-game
  (:use #:cl :utilities))

