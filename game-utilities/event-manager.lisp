(in-package :game-utilities/event-manager)

;;NOTE:
;;event-manager holds a quit state to check whether the GUI-X was clicked on the window.
;;event manager does NOT handle quitting the app directly and should NOT call (sdl::quit)!

(def-class key-state
    :slots ((pressed-locked nil)
	    (released-locked nil)
	    (current-frame-state (make-vector nil nil nil))
	    (last-frame-state    (make-vector nil nil nil)))
    :with (printer-base))

(def-class event-manager
    :slots ((w (key-state))
	    (a (key-state))
	    (s (key-state))
	    (d (key-state))
	    (q (key-state))
	    (e (key-state))
	    (quit nil))
    :with (printer-base))

;;globally create event manager
(var event-manager (make-instance 'game-utilities/event-manager::event-manager))

(defun process-pressed-key
    (event-manager key)
  (let* ((key-state (funcall key event-manager)))
    ;;only process this state if pressed is UNLOCKED
    (if (not (:pressed-locked key-state))
	(setf
	 ;;set pressed last-frame to released state
	 
	 ;;set pressed state to true
	 (aref (:current-frame-state key-state) 0) t
	 ;;lock the pressed state
	 (:pressed-locked key-state) t)
	;;key state is currently locked which means it cannot be true
	(setf (aref (:current-frame-state key-state) 0) nil))))

(defun process-down-key
    (event-manager key)
  (let* ((key-state (funcall key event-manager)))
    (setf
     ;;set laste-frame-state to current-frame-state before any update!
     (aref (:last-frame-state key-state) 1) (aref (:current-frame-state key-state) 1)
     
     (aref (:current-frame-state (funcall key event-manager)) 1) t
     ;;because this key is currently down, we must unlock it's released state.
     (:released-locked key-state) nil)))

(defun process-released-key
    (event-manager key)
  (let* ((key-state (funcall key event-manager)))
    ;;only process this state if released is UNLOCKED
    (if (not (:released-locked key-state))
	(setf
	 ;;set released last-frame to released state
	 
	 ;;set released state to true
	 (aref (:current-frame-state key-state) 2) t
	 ;;lock the released state
	 (:released-locked key-state) t
	 ;;set down state to false
	 (aref (:current-frame-state key-state) 1) nil
	 ;;unlock pressed key
	 (:pressed-locked key-state) nil)
	
	;;key state is currently locked which means it cannot be true
	(setf (aref (:current-frame-state key-state) 2) nil))))

(defun process-history-key
    (event-manager key)
  (let* ((key-state (funcall key event-manager)))
    ;;reset pressed key if it is currently true
    (if (aref (:current-frame-state key-state) 0)
	(setf (aref (:current-frame-state key-state) 0) nil))
    ;;reset released key if it is currently true
    (if (aref (:current-frame-state key-state) 2)
	(setf (aref (:current-frame-state key-state) 2) nil))))

(defun update
    ()
  ;;(loop while (> (sdl:poll-event) 0) do (progn t))
  ;;check for other non-keyboard type events
  (loop while (> (sdl::poll-event) 0)
     do (progn ;;(> (sdl::gui-quit) 0)
	  (if (= (sdl::get-event-type) (cffi:foreign-enum-value 'sdl:sdl-event-type :quit))
	      (progn (setf (:quit event-manager) t)
		     (return)))))
  (loop
     with event-type = (sdl:get-event-type)
     with int-ptr = (cffi:foreign-alloc :int)
     with keyboard-state = (sdl:sdl-getkeyboardstate int-ptr)
     for key in '(:w :a :s :d :q :e)
     do
       (let ((event-manager-key (funcall key event-manager)))
  	 ;;before doing anything we must process history of key
  	 (process-history-key event-manager key)
  
  	 ;;handle key state ;keyboard-state lookup returns either 0 or 1, which both mean t in the land of lisp.
  	 ;;so instead, we check if the return is greater than 0 for t.
  	 (if (> (cffi:mem-aref keyboard-state :uint8 (cffi:foreign-enum-value 'sdl:keyboard-scancode key)) 0)
  	     (progn
  	       ;;(print (to-string key ": down"))
  	       (process-pressed-key event-manager key)
  	       (process-down-key event-manager key))
  	     
  	     (progn
  	       ;;(print (to-string key ": up"))
  	       (process-released-key event-manager key)))))
  (sdl:sdl-pumpevents)
  )

(defun key-pressed?
    (key)
  (aref (:current-frame-state (funcall key event-manager)) 0))

(defun key-down?
    (key)
  (aref (:current-frame-state (funcall key event-manager)) 1))

(defun key-released?
    (key)
  (aref (:current-frame-state (funcall key event-manager)) 2))

(defun mouse-coordinate
    ()
  (cffi:with-foreign-pointer (x 1)
    (cffi:with-foreign-pointer (y 1)
      (sdl::sdl-getmousestate x y)
      `(,(cffi:mem-ref x :int)
	 ,(cffi:mem-ref y :int)))))

(defun mouse-relative-coordinate
    ()
  (cffi:with-foreign-pointer (x 1)
    (cffi:with-foreign-pointer (y 1)
      (sdl::sdl-getrelativemousestate x y)
      `(,(cffi:mem-ref x :int)
	 ,(cffi:mem-ref y :int)))))

(defun LMB?
    ()
  (if (> (sdl::mouse-lmb) 0)
      t nil))
(defun MMB?
    ()
  (if (> (sdl::mouse-mmb) 0)
      t nil))
(defun RMB?
    ()
  (if (> (sdl::mouse-rmb) 0)
      t nil))
(defun MMB-scroll-up?
    ()
  (if (> (sdl::mouse-scroll-up) 0)
      t nil))
(defun MMB-scroll-down?
    ()
  (if (> (sdl::mouse-scroll-down) 0)
      t nil))

(defun gui-quit?
    ()
  (:quit event-manager))

;;(export-all-symbols-except nil)
