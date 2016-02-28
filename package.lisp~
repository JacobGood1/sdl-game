;;;; package.lisp

(defpackage :sdl
  (:use #:cl :utilities)
  (:export :create-window
  		   :get-window-surface
           :fill-rect
           :update-window-surface
           :hide-window
           :show-window
           :poll-event
           :get-event-type
           :handle-events
           :create-renderer
		   :set-render-draw-color
		   :render-clear
		   :render-present))

;main package contains the # all others should not have it
(defpackage #:sdl-game
  (:use #:cl :sdl))

