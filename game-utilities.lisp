(in-package #:game-utilities)

(eval-when (:compile-toplevel :execute :load-toplevel)
   (defun setup-events-for-cond
       (events)
     (declare (type list events))
     `(let ((event (get-event-type))) 
	,(cons 'cond 
	       (loop for (event-type code) in (partition events 2) 
		  collect `((= event (cffi:foreign-enum-value 'sdl-event-type ,event-type)) ,code)))
	:value 
	'(t nil))))

(defmacro handle-events-macro
    (&rest events)
  " feed the events to this macro and it will 
  dispatch based on what is currently in the event que
  EXAMPLE-INPUT:
  :event-name-like-this (do-something)
   available code names: event"
  (setup-events-for-cond events))

(var *fps* 60
     *delay-time* [1000.0 / *fps*])

(def-class game :slots ((running? t)
			(window nil)))
(var *game* (game))

(set-slots *game* running? t)

(defun handle-events
    ()
  (sdl:poll-event)
  (handle-events-macro :quit (print "asdasd")))

(defun-fast update ((game game)))
;(defun-fast render ((game game)))
(defun render (game texture)
  (let*   ((renderer (renderer (window game)))
	   ;testing viewport and clipping
	   ;the dest-rect (viewport) will scale any image to FIT itself.
	   ;the src-rect (clip) is a rect that specifies what part of the image to render.
	   ;when using this with sprite sheets,
	   ;   the viewport and clip must have the same dimensions to avoid
	   ;   any image warping. the viewport will then dictate where to
	   ;   draw the image onto the screen.
	   (viewport (utilities:new-struct rect ((x 0) (y 0) (w 128) (h 128))))
	   (clip (utilities:new-struct rect ((x 160) (y 16) (w 16) (h 16)))))
    (render-clear renderer)
					;testing viewports
    ;(sdl:sdl-rendersetviewport renderer viewport)
					;global sample texture for testing
    (sdl-rendercopy renderer texture clip viewport)
    (render-present renderer)
    ))

(defun start
    ()
  (sdl:init)
  (set-slots *game* window (sdl:create-window "lame-game" 640 480))
  ;create renderer : hardware-accelerated = 2, vsyn = 4
  (set-slots (window *game*) 
	     renderer 
	     (sdl:sdl-createrenderer (address (window *game*)) 1 (logior 2 4)))
  ;set renderer draw color
  (set-render-draw-color (renderer (window *game*)) 0 0 0 255)
  ;init image : TODO : this should include multiple flags for all types of images.
  (img-init 4);I think 4 represents png
  (var texture (sdl:load-img "C:/sprite_sheet.png" (renderer (window *game*))))
)

(defun game-loop
    ()
  (start)
  (let* ((frame-start 0)
	 (frame-time 0)
	 (game *game*)
	 )
    (loop
       while (running? game)
       do (progn
	    (setf frame-start (sdl:get-ticks))
	    (handle-events)
	    (update game)
	    (render game texture)
	    (setf frame-time [(sdl:get-ticks) - frame-start])
	    (if (< frame-time *delay-time*)
		(sdl:delay (round [*delay-time* - frame-time])))))))

(defvar *game-loop-thread*)
(setq *game-loop-thread* (bt:make-thread #'game-loop))
;(game-loop)
(in-package #:timer)

(def-class timer :slots ((started? nil)
			 (paused? nil)
			 (paused-ticks 0)
			 (start-ticks 0)))

(defun-fast start
    ((timer timer))
  (set-slots timer
	     started? t
	     paused? nil
	     start-ticks (sdl:get-ticks)
	     paused-ticks 0)
  timer)

(defun-fast stop
    ((timer timer))
  (set-slots timer
	     started? nil
	     paused? nil
	     start-ticks 0
	     paused-ticks 0)
  timer)

(defun-fast pause
    ((timer timer))
  (if (and timer-started?
	   (not timer-paused?))
      (set-slots timer
	     paused? t
	     paused-ticks [(sdl:get-ticks) - (start-ticks timer)]
	     start-ticks 0))
  timer)

(defun-fast unpause
    ((timer timer))
  (if (and timer-started? timer-paused?)
      (set-slots timer
		 paused? nil
		 start-ticks [(sdl:get-ticks) - timer-paused-ticks]
		 paused-ticks 0))
  timer)


(defun-fast ticks
    ((timer timer))
  (let ((time 0))
    (if timer-started?
	(if timer-paused?
	    (setf time timer-paused-ticks)
	    (setf time [(sdl:get-ticks) - timer-start-ticks])))
    time))



;;;asset manager
(in-package :game-utilities)
(def-class asset-manager
    :slots ((load% 0.0) 
	    (path "C:/") 
	    (all-images '())
	    (all-audio '()) 
	    (images (make-hash-table)) 
	    (audio (make-hash-table))
	    (image-type ".png")
	    (audio-type ".ogg")
		       )
	 :constructor (lambda () 
			(let*
			    ((load-loop (lambda (element type) (loop 
								   for e in (map 'list #'identity element) 
								   do (attach images (to-keyword e) 
									      (load-img (concatenate 'string path e type)))
								   finally (return images) (return audio)))
			       ))
			  (if (not (nil? all-images))
			      (funcall load-loop all-images image-type))
			  (if (not (nil? all-audio))
			      (funcall load-loop all-audio audio-type))
			  )))


(export-all-symbols-except nil)
