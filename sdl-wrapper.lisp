(in-package #:sdl)

(define-condition continue-compiling
    (error)
  ())

(defun pause-till-compile
    ()
  (error 'continue-compiling))


(cffi:define-foreign-library SDL
  (:windows (:or "c:\\users\\jacobgood1\\documents\\visual studio 2015\\Projects\\SDL_Common_Lisp\\x64\\Release\\SDL_Common_Lisp"
                 "TRAVIS YOUR DLL LOCATION GOES HERE!!11")))
(cffi:use-foreign-library SDL)

(cffi:define-foreign-library SDL-RELOAD 
   (:windows (:or "c:\\users\\jacobgood1\\documents\\visual studio 2015\\Projects\\SDL_Common_Lisp_Reloadable\\x64\\Release\\SDL_Common_Lisp_Reloadable.dll"
                  "TRAVIS PUT DLL HERERERER")))
(cffi:use-foreign-library SDL-RELOAD)

(defun reload-sdl 
  ()
   
     (handler-case
   (cffi:close-foreign-library 'SDL-RELOAD)
 (CFFI::FOREIGN-LIBRARY-UNDEFINED-ERROR () "skipping for now"))
     (restart-case (pause-till-compile) (continue-compiling () "...done"))
     (cffi:use-foreign-library SDL-RELOAD))


(cffi:defcenum sdl-event-type
  (:sdl-quit 256)
  (:sdl-key-down 768)
  :sdl-key-up)

(cffi:defcfun "create_window" :pointer (title :string) (screen-width :int) (screen-height :int))
(cffi:defcfun "get_window_surface" :pointer (sdl-window :pointer))
(cffi:defcfun "fill_rect" :int (sdl-surface :pointer))
(cffi:defcfun "update_window_surface" :int (sdl-window :pointer))
(cffi:defcfun "hide_window" :void (sdl-window :pointer))
(cffi:defcfun "show_window" :void (sdl-window :pointer))
(cffi:defcfun "poll_event" :int)
(cffi:defcfun "get_event_type" :int)

(defun setup-events-for-cond
    (events)
  (declare (type list events) (type fixnum event))
  `(let ((event (sdl-get-event-type))) 
     ,(attach 
       (cons 'cond 
	     (loop for (event-type code) in (partition events 2) 
		collect `((= event (foreign-enum-value 'sdl-event-type ,event-type)) ,code)))
       :value 
       '(t nil))))

(defmacro handle-events
	 (&rest events)
       (setup-events-for-cond events));