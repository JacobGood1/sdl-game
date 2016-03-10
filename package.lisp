;;;; package.lisp

(defpackage :sdl
  (:use #:cl)
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
	   :render-present
	   :destroy-renderer
	   :destroy-window))

(defpackage :game
  (:use #:cl :sdl :utilities)
  (:export :render))

(defpackage :travis-test
  (:use #:cl :sdl))
;main package contains the # all others should not have it
(defpackage #:sdl-game
  (:use #:cl :utilities))




