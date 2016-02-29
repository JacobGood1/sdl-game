(in-package #:game)


;(def-class game
;    :slots (window nil renderer nil running? t)
;    :constructor (lambda (title screen-width screen-height)
;		   (setf window
;			 (sdl:create-window title
;					    screen-width
;					    screen-height))
;		   (setf renderer (sdl:create-renderer window -1 0))
;		   ;set the screen to black
;		   (sdl:set-render-draw-color renderer 0 0 0 255)))


(declaim (inline update))
(defun update
    (game)
  (declare (type game game))
  (with-slots (game-renderer) game)
  )

(declaim (inline handle-events))
(defun handle-events
    (game)
  (declare (type game game-instance))
  (with-slots (game-renderer) game)
  )

(declaim (inline render))
(defun render
    (game)
  (declare (type game game))
  (with-slots ((renderer game-renderer)) game
    ;clear the screen with a black background
    (sdl:render-clear renderer)
    ;swap the back buffer
    (sdl:render-present renderer)))

;todo in clean might need to call sdl quit as well!
(declaim (inline clean))
(defun clean
    (game)
  (declare (type game game))
  (with-slots ((renderer game-renderer) (window game-window)) game
    (sdl:destroy-renderer renderer)
    (sdl:destroy-window window)))



;(let ((pack (find-package :game)))
;  (do-all-symbols (sym pack) (when (eql (symbol-package sym) pack) (export sym))))
