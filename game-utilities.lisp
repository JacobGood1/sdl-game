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

(def-class game :slots (running? t window (sdl:create-window "lame-game" 640 480)))
(var *game* (game))



(set-slots *game* running? nil)

(defun-fast handle-events ((game game))
  (handle-events-macro :quit (print "quiting")))

(defun-fast update ((game game)))
(defun-fast render ((game game)))

(defun main
    ()
  (sdl:init)
  (let* ((frame-start 0)
	 (frame-time 0)
	 (game *game*)
	 (window (sdl:create-window "lame-game" 640 480)))
    (loop
       while (running? game)
       do (progn
	    (setf frame-start (sdl:get-ticks))
	    (handle-events game)
	    (update game)
	    (render game)
	    (setf frame-time [(sdl:get-ticks) - frame-start])
	    (if (< frame-time *delay-time*)
		(sdl:delay (round [*delay-time* - frame-time])))))))

;(main)
(in-package #:timer)

(def-class timer :slots (started? nil
			 paused? nil
			 paused-ticks 0
			 start-ticks 0))

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
