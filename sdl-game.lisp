;;;; sdl-game.lisp

(in-package #:sdl-game)

;;; "sdl-game" goes here. Hacks and glory await!

(defparameter window
  (sdl:create-window "pixel-pyratez"
		     640
		     480))

(defparameter renderer (sdl:create-renderer window -1 0))

(
