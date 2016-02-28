;;;; sdl-game.lisp

(in-package #:sdl-game)

;;; "sdl-game" goes here. Hacks and glory await!

(defparameter *window* nil)
(defparameter *renderer* nil)
(defparameter *running?* t)

(defun init
    (title screen-width screen-height)
		  ;create the window
  (utilities:set! *window*
		  (sdl:create-window title
				     screen-width
				     screen-height)
		  ;create the renderer
		  *renderer*
		  (sdl:create-renderer *window* -1 0)))

(defun render
    ()
  ;set the screen to black
  (sdl:set-render-draw-color *renderer* 0 0 0 255)
  ;clear the screen with a black background
  (sdl:render-clear *renderer*)
  ;swap the back buffer
  (sdl:render-present *renderer*))

;(defun main
;    ()
;  (init "pixel pirates" 640 480)
;  (loop
;     while (eq t *running?*)
;     do (progn
;	  (handle-events)
;	  (update)
;	  (render)))
; (clean))


