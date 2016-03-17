;;;;TODO Installer must handle glew libs when released on steam.
;;;;Install glew.dll on windows system32

(in-package #:sdl)

(define-condition continue-compiling
    (error)
  ())

(defun pause-till-compile
    ()
  (error 'continue-compiling))

(cffi:define-foreign-library SDL
  (:windows (:or "c:\\users\\jacobgood1\\documents\\visual studio 2015\\Projects\\SDL_Common_Lisp\\x64\\Release\\SDL_Common_Lisp"
                 "c:\\home\\SDL_Common_Lisp")))
;"c:\\users\\travis\\documents\\visual studio 2015\\Projects\\SDL_Common_Lisp\\x64\\Release\\SDL_Common_Lisp.dll"
(cffi:use-foreign-library SDL)

(cffi:define-foreign-library SDL-RELOAD 
  (:windows (:or "c:\\users\\jacobgood1\\documents\\visual studio 2015\\Projects\\SDL_Common_Lisp_Reloadable\\x64\\Release\\SDL_Common_Lisp_Reloadable.dll"
		 "C:\\home\\quicklisp\\local-projects\\SDL_Common_Lisp_Reloadable\\x64\\Release\\SDL_Common_Lisp_Reloadable.dll")))
(cffi:use-foreign-library SDL-RELOAD)

(defun reload-sdl 
  ()
  (handler-case
      (cffi:close-foreign-library 'SDL-RELOAD)
      (CFFI::FOREIGN-LIBRARY-UNDEFINED-ERROR () "skipping for now"))
  (restart-case (pause-till-compile) (continue-compiling () "...done"))
  (cffi:use-foreign-library SDL-RELOAD))


(cffi:defcenum sdl-event-type
  (:quit 256)
  (:key-down 768)
  (:a 97)
  (:b 1)
  (:c 2)
  :key-up)

; a bug exists where the window is not viewable until calling hide-window show-window 
; so this create window will exist inside of another inlined wrapper

;SDL_Common_List.cpp
(cffi:defcfun "init_sdl" :int)
(cffi:defcfun "init_glew" :int)
(cffi:defcfun "quit" :void)
(cffi:defcfun "get_error" :string)
;event.h
(cffi:defcfun "poll_event" :int)
(cffi:defcfun "get_event_type" :int)
(cffi:defcfun "get_event_key" :int)
;render.h
(cffi:defcfun "create_renderer" :pointer (window :pointer) (index :int) (flags :int))
(cffi:defcfun "set_render_draw_color" :void (renderer :pointer) (red :int) (green :int) (blue :int) (alpha :int))
(cffi:defcfun "render_clear" :void (renderer :pointer))
(cffi:defcfun "render_present" :void (renderer :pointer))
(cffi:defcfun "destroy_renderer" :void (renderer :pointer))
;window.h
(cffi:defcfun "create_window_internal" :pointer (title :string) (screen-width :int) (screen-height :int))
(cffi:defcfun "destroy_window" :void (window :pointer))
(cffi:defcfun "hide_window" :void (sdl-window :pointer))
(cffi:defcfun "show_window" :void (sdl-window :pointer))
(cffi:defcfun "update_window_surface" :int (sdl-window :pointer))
(cffi:defcfun "get_window_surface" :pointer (sdl-window :pointer))
;surface.h
(cffi:defcfun "fill_rect" :int (sdl-surface :pointer))

;time.h
(cffi:defcfun "get_ticks" :int)
(cffi:defcfun "blit_surface" :void (source :pointer) (destination :pointer))
(cffi:defcfun "free_surface" :void (surface :pointer))
;media.h
(cffi:defcfun "load_bmp" :pointer (bmp-path :string))
;misc.h
(cffi:defcfun "delay" :void (delay :int))

(defun init
    ()
  (if [(init-sdl) >= 0]
      (Print "sdl init success")
      (error "sdl init failed"))
  (if [(init-glew) >= 0]
      (print "glew init success") 
      (error "glew init failed"))
  (print "init finished"))

(declaim (inline create-window))
(defun create-window
  (title screen-width screen-height)
  
  (let ((window (create-window-internal title screen-width screen-height)))
    
    ;hide and show the window so to circumvent the bug
    (hide-window window)
    (show-window window)
    window))





(utilities:export-all-symbols-except nil)




