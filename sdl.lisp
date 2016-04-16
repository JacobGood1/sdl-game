;;;;TODO Installer must handle glew libs when released on steam.
;;;;Install glew.dll on windows system32

(in-package :sdl)

(define-condition continue-compiling
    (error)
  ())

(defun pause-till-compile
    ()
  (error 'continue-compiling))


(cffi:define-foreign-library SDL
  (:windows (:or "C:\\Libs\\sdl\\lib\\x64\\SDL2.dll"
                 "C:\\libs\\sdl\\lib\\x64\\SDL2.dll")))
(cffi:use-foreign-library SDL)

(cffi:define-foreign-library SDL-IMAGE
  (:windows (:or "C:\\libs\\sdl\\lib\\x64\\SDL2_image.dll" 
		 "C:\\libs\\sdl\\lib\\x64\\SDL2_image.dll")))
(cffi:use-foreign-library SDL-IMAGE)



;;TODO possible remove the wrapper code dll completely, I(Jacob) will start calling into the dll directly ^

(cffi:define-foreign-library SDL-WRAPPER
  (:windows (:or "c:\\users\\jacobgood1\\documents\\visual studio 2015\\Projects\\SDL_Common_Lisp\\x64\\Release\\SDL_Common_Lisp"
                 "c:\\home\\SDL_Common_Lisp")))
;;"c:\\users\\travis\\documents\\visual studio 2015\\Projects\\SDL_Common_Lisp\\x64\\Release\\SDL_Common_Lisp.dll"
(cffi:use-foreign-library SDL-WRAPPER)

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
  (:quit       256)
  (:key-down-1 768)
  (:key-down-2 771)
  (:key-up     769)
  (:w          119)
  (:a          97)
  (:s          115)
  (:d          100))

(cffi:defcenum keyboard-scancode
  (:w 26)
  (:a 4)
  (:s 22)
  (:d 7))

(cffi:defcenum sdl-rendererflip
  (:sdl-flip-none       0)
  (:sdl-flip-horizontal 1)
  (:sdl-flip-vertical   2))

;; a bug exists where the window is not viewable until calling hide-window show-window 
;; so this create window will exist inside of another inlined wrapper

(defmacro get-address (pointer struct field) `(cffi:foreign-slot-value ,pointer '(:struct ,struct) ',field))

;;SDL_GL
(cffi:defcfun "SDL_GL_GetCurrentContext" :pointer)
;;SDL_Common_List.cpp
(cffi:defcfun "init_sdl" :int)
(cffi:defcfun "init_glew" :int)
(cffi:defcfun "quit" :void)
(cffi:defcfun "get_error" :string)
(cffi:defcfun "SDL_GetError" :string)
;;event.h
(cffi:defcfun "poll_event" :int)
(cffi:defcfun "get_event_type" :int)
(cffi:defcfun "get_event_key" :int)
(cffi:defcfun "SDL_GetKeyboardState" :pointer (numkeys :pointer))
(cffi:defcfun "SDL_GetMouseState" :void (x :pointer) (y :pointer))
(cffi:defcfun "SDL_GetRelativeMouseState" :void (x :pointer) (y :pointer))
;;(cffi:defcfun "SDL_Button" :int (button :int))
(cffi:defcfun "mouse_lmb" :int)
(cffi:defcfun "mouse_mmb" :int)
(cffi:defcfun "mouse_rmb" :int)
(cffi:defcfun "mouse_scroll_up" :int)
(cffi:defcfun "mouse_scroll_down" :int)
(cffi:defcfun "SDL_PumpEvents" :void)
;;render.h
(cffi:defcfun "create_renderer" :pointer (window :pointer))
(cffi:defcfun "SDL_CreateRenderer" :pointer (window :pointer) (index :int) (flags :uint32))
(cffi:defcfun "set_render_draw_color" :void (renderer :pointer) (red :int) (green :int) (blue :int) (alpha :int))
(cffi:defcfun "SDL_CreateTextureFromSurface" :pointer (renderer :pointer) (surface :pointer))
(cffi:defcfun "render_clear" :void (renderer :pointer))
(cffi:defcfun "SDL_RenderCopy" :void (renderer :pointer) (texture :pointer) (src-rect :pointer) (dest-rect :pointer))
(cffi:defcfun "SDL_RenderCopyEx" :void (renderer :pointer) (texture :pointer) (src-rect :pointer) (dest-rect :pointer) (angle :double) (center :pointer) (flip :int))
(cffi:defcfun "render_present" :void (renderer :pointer))
(cffi:defcfun "destroy_renderer" :void (renderer :pointer))
(cffi:defcfun "SDL_RenderSetViewport" :int (renderer :pointer) (rect :pointer))
;;window.h
(cffi:defcfun "create_window_internal" :pointer (title :string) (screen-width :int) (screen-height :int))
(cffi:defcfun "SDL_CreateWindow" :pointer (title :string) (x :int) (y :int) (w :int) (h :int) (flag :uint32))
(cffi:defcfun "destroy_window" :void (sdl-window :pointer))
(cffi:defcfun "hide_window" :void (sdl-window :pointer))
(cffi:defcfun "show_window" :void (sdl-window :pointer))
(cffi:defcfun "update_window_surface" :int (sdl-window :pointer))
(cffi:defcfun "get_window_surface" :pointer (sdl-window :pointer))
;;image
(cffi:defcfun "IMG_Init" :int (flag :int))
(cffi:defcfun "IMG_GetError" :string)
(cffi:defcfun "IMG_Load" :pointer (path :string))
(cffi:defcfun "IMG_Quit" :void)
;;display
(cffi:defcstruct display-mode
  (format :uint32)
  (w :int)
  (h :int)
  (refresh-rate :int)
  (driver-data :pointer))
(cffi:defcfun "SDL_GetDesktopDisplayMode" :int)

;;surface.h
;;; surface struct may have bugs! not all types are correct!!!
(cffi:defcstruct surface
  (flags :int)
  (format :pointer)
  (width :int)
  (height :int)
  (pitch :int)
  (pixels :pointer)
  (userdata :pointer)
  (locked :int)
  (locked-data :pointer)
  (clip-rect :pointer)
  (map :pointer)
  (refcount :int)
  )

;;point.h
(cffi:defcstruct point
  (x :int)
  (y :int))

(cffi:defcfun "fill_rect" :int (sdl-surface :pointer))
(cffi:defcfun "SDL_ConvertSurface" :pointer (raw-surface :pointer) (surface-format :pointer) (flag :int))
(cffi:defcfun "SDL_UpperBlitScaled" :int (src :pointer)(src-rect :pointer)(dest :pointer)(dest-rect :pointer))
;;(cffi:defcfun "get_format" :pointer (sdl-surface :pointer))
;;(defun get-pixel-format
;;    (surface)
;;  (get-format surface))



;;rect.h
(cffi:defcfun "new_rect" :pointer (x :int) (y :int) (w :int) (h :int))
(cffi:defcfun "delete_rect" :void (rect :pointer))
;;get slots
(cffi:defcfun "rect_get_x" :int (rect :pointer))
(cffi:defcfun "rect_get_y" :int (rect :pointer))
(cffi:defcfun "rect_get_w" :int (rect :pointer))
(cffi:defcfun "rect_get_h" :int (rect :pointer))
;;set slots
(cffi:defcfun "rect_set_x" :pointer (rect :pointer) (value :int))
(cffi:defcfun "rect_set_y" :pointer (rect :pointer) (value :int))
(cffi:defcfun "rect_set_w" :pointer (rect :pointer) (value :int))
(cffi:defcfun "rect_set_h" :pointer (rect :pointer) (value :int))

;;point.h
(cffi:defcfun "new_point" :pointer (x :int) (y :int))
(cffi:defcfun "delete_point" :void (point :pointer))


(defmacro new-struct
    (type slots-and-values)
  (let ((ptr (gensym)))
    `(let* ((,ptr (cffi:foreign-alloc '(:struct ,type))))
       ,(loop for (slot value) in slots-and-values
	   collect `(cffi:foreign-slot-value ,ptr '(:struct ,type) ',slot)
	   into foreign-slot-values
	   collect value
	   into values
	   finally (return (append '(setf) (interleave foreign-slot-values values))))
       ,ptr)))

;;time.h
(cffi:defcfun "SDL_GetTicks" :int)
(declaim (inline get-ticks))
(defun get-ticks
    ()
  (sdl-getticks))

(cffi:defcfun "blit_surface" :void (source :pointer) (destination :pointer))
(cffi:defcfun "free_surface" :void (surface :pointer))
;;media.h
(cffi:defcfun "load_bmp" :pointer (bmp-path :string))
(defun load-img
    (img-path renderer);game-surface
  (let* ((raw-surface (img-load img-path))
	 ;;(converted-surface (sdl-convertsurface raw-surface (get-address game-surface surface format) 0))
	 (converted-surface (sdl-createtexturefromsurface renderer raw-surface))
	 )
    
    (free-surface raw-surface)
    converted-surface))
;;misc.h
(cffi:defcfun "delay" :void (delay :int))

;;sdl.h
(cffi:defcfun "SDL_GetWindowTitle" :string (sdl-window :pointer))
(cffi:defcfun "SDL_SetWindowTitle" :void (sdl-window :pointer) (title :string))
(cffi:defcfun "SDL_GetWindowSize" :void (sdl-window :pointer) (width :pointer) (height :pointer))
(cffi:defcfun "SDL_SetWindowSize" :void (sdl-window :pointer) (width :int) (height :int))

(def-class sdl-window
    :slots ((address nil) 
	    (title nil) 
	    (size '(0 0))
	    (viewport nil)
	    (renderer nil)))

(defmethod initialize-instance :after ((sdl-window sdl-window) &key address title size)
  (setf (:address sdl-window) address 
	(:title   sdl-window) title 
	(:size    sdl-window) size))

;;(override-setter sdl-window title (progn (setf title value) (SDL-SetWindowTitle address value)))
;;(override-setter sdl-window size (progn (setf size value) (SDL-SetWindowSize address (first value) (second value))))

;;TODO throw an error when a macro is overriding a function in slots or vice versa

(defun init
    ()
  (if [(init-sdl) >= 0]
      (print "sdl init success")
      (error "sdl init failed"))
  (if [(init-glew) >= 0]
      (print "glew init success") 
      (error "glew init failed"))
  (print "init finished"))

(defun create-window
  (title w h)
  (let ((window-pointer (sdl-createwindow title 100 100 w h 4)))
    ;;hide and show the window so to circumvent the bug
    (hide-window window-pointer)
    (show-window window-pointer)
    (sdl-window :address window-pointer :title title :size `(,w ,h) :viewport (new-rect 0 0 w h))))

(defun update-viewport
    (sdl-window)
  (let* ((viewport (:viewport sdl-window)))
    (cffi:with-foreign-pointer (w 1)
      (cffi:with-foreign-pointer (h 1)
	(sdl-getwindowsize (:address sdl-window) w h)
	(rect-set-w viewport (cffi:mem-ref w :int))
	(rect-set-h viewport (cffi:mem-ref h :int))))))


(utilities:export-all-symbols-except '(window))




