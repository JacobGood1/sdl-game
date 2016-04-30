(in-package :game-utilities/game-utilities)

(var *fps* 60
     *delay-time* [1000.0 / *fps*])

(defun game-loop
    (scene)
  (let* ((frame-start 0)
	 (frame-time 0)
	 ;;(game *game*)
	 )

    (loop
       while (:running? scene)
       do (progn
	    (print "running...")
	    (setf frame-start (sdl:get-ticks))
	    (game-utilities/event-manager::update)
	    (funcall (:update        scene) scene)
	    (funcall (:render        scene) scene)
	    (setf frame-time [(sdl:get-ticks) - frame-start])
	    (if (< frame-time *delay-time*)
		(sdl:delay (round [*delay-time* - frame-time])))))))

;;(defun start (scene) (defvar *game-loop-thread*) (setq *game-loop-thread* (bt:make-thread (lambda () (game-loop scene)))))
			    ;;#'game-loop
(defun start (scene) (game-loop scene))

;;export all symbols before going into the :timer package
;;(export-all-symbols-except nil)

(in-package #:timer)

(def-class timer :slots ((started? nil)
			 (paused? nil)
			 (paused-ticks 0)
			 (start-ticks 0)))

(defun start
    (timer)
  (setf
   (started? timer) t
   (paused? timer) nil
   (start-ticks timer) (sdl:get-ticks)
   (paused-ticks timer) 0)
  timer)

(defun stop
    (timer)
  (setf
   (started? timer) nil
   (paused? timer) nil
   (start-ticks timer) 0
   (paused-ticks timer) 0)
  timer)

(defun pause
    (timer)
  (if (and timer-started?
	   (not timer-paused?))
      (setf
       (paused? timer) t
       (paused-ticks timer) [(sdl:get-ticks) - (start-ticks timer)]
       (start-ticks timer) 0))
  timer)

(defun unpause
    (timer)
  (if (and timer-started? timer-paused?)
      (setf 
       (paused? timer) nil
       (start-ticks timer) [(sdl:get-ticks) - timer-paused-ticks]
       (paused-ticks timer) 0))
  timer)


(defun ticks
    (timer)
  (let ((time 0))
    (if timer-started?
	(if timer-paused?
	    (setf time timer-paused-ticks)
	    (setf time [(sdl:get-ticks) - timer-start-ticks])))
    time))

;;(export-all-symbols-except nil)
