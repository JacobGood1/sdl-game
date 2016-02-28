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

;main package contains the # all others should not have it
(defpackage #:sdl-game
  (:use #:cl :sdl))

(defpackage :game
  (:use #:cl :sdl)
  (:import-from :utilities
		make
		def-method
		def-class
		def-generic
		set!)
  (:export :game :render ))


