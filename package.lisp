;;;; package.lisp

(defpackage :sdl
  (:use #:cl)
  (:import-from :utilities 
		partition
		attach)
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
  (:use #:cl :sdl)
  (:import-from :utilities
		make
		def-method
		def-class
		def-generic
		set!)
  (:export :render))

(defpackage :travis-test
  (:use #:cl :sdl)
  (:import-from :utilities
    make
    def-method
    def-class
    def-generic
    set!))
;main package contains the # all others should not have it
(defpackage #:sdl-game
  (:use #:cl))




