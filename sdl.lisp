;;;;TODO Installer must handle glew libs when released on steam.
;;;;Install glew.dll on windows system32

(in-package :sdl)

(define-condition continue-compiling
    (error)
  ())

(defun pause-till-compile
    ()
  (error 'continue-compiling))

(cffi:define-foreign-library STEAM
  (:windows (:or "C:\\emacs\\bin\\dlls\\steam\\steam_api64.dll"
	     ;;"C:\\emacs\\bin\\dlls\\steam\\Steam_CommonLisp.dll"
	     ;;"dlls/steam/Steam_CommonLisp.dll"
	     )))
(cffi:use-foreign-library STEAM)

(cffi:define-foreign-library SDL
  (:windows (:or ;;"C:\\Libs\\sdl\\lib\\x64\\SDL2.dll"
                 "dlls/SDL2.dll")))
(cffi:use-foreign-library SDL)

(cffi:define-foreign-library SDL-IMAGE
  (:windows (:or ;;"C:\\libs\\sdl\\lib\\x64\\SDL2_image.dll" 
		 "dlls/SDL2_image.dll")))
(cffi:use-foreign-library SDL-IMAGE)

(cffi:define-foreign-library SDL-MIXER
  (:windows (:or ;;"C:\\libs\\sdl\\lib\\x64\\SDL2_mixer.dll"
		 "dlls/SDL2_mixer.dll")))
(cffi:use-foreign-library SDL-MIXER)

;;TODO possible remove the wrapper code dll completely, I(Jacob) will start calling into the dll directly ^

(cffi:define-foreign-library SDL-WRAPPER
  (:windows (:or ;;"c:\\users\\jacobgood1\\documents\\visual studio 2015\\Projects\\SDL_Common_Lisp\\x64\\Release\\SDL_Common_Lisp"
                 ;;"c:\\home\\SDL_Common_Lisp"
		 "dlls/SDL_Common_Lisp.dll")))
;;"c:\\users\\travis\\documents\\visual studio 2015\\Projects\\SDL_Common_Lisp\\x64\\Release\\SDL_Common_Lisp.dll"
(cffi:use-foreign-library SDL-WRAPPER)

(cffi:define-foreign-library SDL-RELOAD 
  (:windows (:or ;;"c:\\users\\jacobgood1\\documents\\visual studio 2015\\Projects\\SDL_Common_Lisp_Reloadable\\x64\\Release\\SDL_Common_Lisp_Reloadable.dll"
		 ;;"C:\\home\\quicklisp\\local-projects\\SDL_Common_Lisp_Reloadable\\x64\\Release\\SDL_Common_Lisp_Reloadable.dll"
		 "dlls/SDL_Common_Lisp_Reloadable.dll")))
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
  (:d          100)
  (:q          113)
  (:e          101))

(cffi:defcenum keyboard-scancode
  (:w 26)
  (:a 4)
  (:s 22)
  (:d 7)
  (:q 20)
  (:e 8))

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
(cffi:defcfun "SDL_Quit" :void)
(cffi:defcfun "get_error" :string)
(cffi:defcfun "SDL_GetError" :string)
(cffi:defcfun "SDL_RWFromFile" :pointer (file :string) (mode :string))
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
(cffi:defcfun "render_clear" :void (renderer :pointer))
(cffi:defcfun "SDL_RenderCopy" :void (renderer :pointer) (texture :pointer) (src-rect :pointer) (dest-rect :pointer))
(cffi:defcfun "SDL_RenderCopyEx" :void (renderer :pointer) (texture :pointer) (src-rect :pointer) (dest-rect :pointer) (angle :double) (center :pointer) (flip :int))
(cffi:defcfun "render_present" :void (renderer :pointer))
(cffi:defcfun "destroy_renderer" :void (renderer :pointer))
(cffi:defcfun "SDL_RenderSetViewport" :int (renderer :pointer) (rect :pointer))
(cffi:defcfun "SDL_RenderFillRect" :void (renderer :pointer) (rect :pointer))
(cffi:defcfun "SDL_RenderDrawRect" :void (renderer :pointer) (rect :pointer))
(cffi:defcfun "SDL_RenderDrawLine" :void (renderer :pointer) (x1 :int) (y1 :int) (x2 :int) (y2 :int))
;;--media.h
;;texture.h
(cffi:defcfun "SDL_CreateTextureFromSurface" :pointer (renderer :pointer) (surface :pointer))
(cffi:defcfun "SDL_DestroyTexture" :void (texture :pointer))
;;image
(cffi:defcfun "IMG_Init" :int (flag :int))
(cffi:defcfun "IMG_GetError" :string)
(cffi:defcfun "IMG_Load" :pointer (path :string))
(cffi:defcfun "IMG_Quit" :void)
;;audio.h
(cffi:defcfun "Mix_OpenAudio" :int (flag1 :int) (flag2 :uint16) (flag3 :int) (flag4 :int))
(cffi:defcfun "Mix_GetError" :string)
(cffi:defcfun "Mix_LoadMUS" :pointer (path :string))
(cffi:defcfun "Mix_LoadWAV_RW" :pointer (source :pointer) (free-src :int))
(cffi:defcfun "Mix_PlayChannelTimed" :void (channel :int) (sound-bite :pointer) (repeat-amount :int) (ticks :int))
(cffi:defcfun "Mix_PlayMusic" :int (music :pointer) (loops :int))
(cffi:defcfun "Mix_Quit" :void)
(cffi:defcfun "Mix_FreeChunk" :void (audio-bite :pointer))
(cffi:defcfun "Mix_FreeMusic" :void (audio-music :pointer))
;;window.h
(cffi:defcfun "create_window_internal" :pointer (title :string) (screen-width :int) (screen-height :int))
(cffi:defcfun "SDL_CreateWindow" :pointer (title :string) (x :int) (y :int) (w :int) (h :int) (flag :uint32))
(cffi:defcfun "destroy_window" :void (sdl-window :pointer))
(cffi:defcfun "hide_window" :void (sdl-window :pointer))
(cffi:defcfun "show_window" :void (sdl-window :pointer))
(cffi:defcfun "update_window_surface" :int (sdl-window :pointer))
(cffi:defcfun "get_window_surface" :pointer (sdl-window :pointer))

;;steam.h
(cffi:defcfun "SteamAPI_Init" :bool)

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
;;set slots position
(defun rect-set-position
    (rect x y)
  (rect-set-x rect x)
  (rect-set-y rect y))
;;get slots position
(defun rect-get-position
    (rect)
  (math::point :px (rect-get-x rect) :py (rect-get-y rect)))
;;set slots dimension
(defun rect-set-dimension
    (rect w h)
  (rect-set-w rect w)
  (rect-set-h rect h))
(defun rect-get-dimension
    (rect)
  (math::point :px (rect-get-w rect) :py (rect-get-h rect)))
;;set slots all
(defun rect-set-all
    (rect x y w h)
  (rect-set-x rect x)
  (rect-set-y rect y)
  (rect-set-w rect w)
  (rect-set-h rect h))

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
	 (converted-surface (sdl-createtexturefromsurface renderer raw-surface)))
    (free-surface raw-surface)
    converted-surface))
(defun load-wav
    (file)
  (mix-loadwav-rw (sdl-rwfromfile file "rb") 1))
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

;;TODO;;inline this fn call
(defun play-music
    ;;repeat-amount: -1 : continually repeat
    (music-name &key (repeat-amount -1))
  (mix-playmusic (gethash music-name (:audio-music (:asset-manager scene))) repeat-amount))
;;TODO;;inline this fn call
(defun play-bite
    (bite-name &key (channel -1) (repeat-amount 0))
  (mix-playchanneltimed channel (gethash bite-name (:audio-bites (:asset-manager scene))) repeat-amount -1))



(defun pretty-print-normal
    (scene camera-rect line scale color-1 color-2)
  (multiple-value-bind
	(normal-down normal-up)
      (math::normal-of-line line)
    (let* ((line-mid-point (math::line-midpoint line))
	   (x1            (:px line-mid-point))
	   (y1            (:py line-mid-point)))
      
      (math::normalize-vector normal-up)
      (math::normalize-vector normal-down)
      
      (math::scale-vector normal-up scale)
      (math::scale-vector normal-down scale)

      ;;offset normal to line-mid-point for visualization
      (setf (:vx normal-up)   (+ x1 (:vx normal-up))
	    (:vy normal-up)   (+ y1 (:vy normal-up)))
      (setf (:vx normal-down) (+ x1 (:vx normal-down))
	    (:vy normal-down) (+ y1 (:vy normal-down)))

      ;;construct new lines for rendering normals
      (let* ((n-up (math::line :p1 (math::point :px x1 :py y1)
			       :p2 (math::point :px (:vx normal-up) :py (:vy normal-up))))
	     (n-down (math::line :p1 (math::point :px x1 :py y1)
				 :p2 (math::point :px (:vx normal-down) :py (:vy normal-down)))))

	;;round points for rendering
	(math::round-points-of-lines n-up n-down)

	;;remember to apply camera offset for rendering
	(let* ((c-x (sdl::rect-get-x camera-rect))
	       (c-y (sdl::rect-get-y camera-rect)))
	  ;;render lines
	  (set-render-draw-color (:renderer scene) (nth 0 color-1) (nth 1 color-1) (nth 2 color-1) (nth 3 color-1))
	  (sdl-renderdrawline (:renderer scene)
			      (- (:px (:p1 n-up)) c-x)
			      (- (:py (:p1 n-up)) c-y)
			      (- (:px (:p2 n-up)) c-x)
			      (- (:py (:p2 n-up)) c-y))
	  (set-render-draw-color (:renderer scene) (nth 0 color-2) (nth 1 color-2) (nth 2 color-2) (nth 3 color-2))
	  (sdl-renderdrawline (:renderer scene)
			      (- (:px (:p1 n-down)) c-x)
			      (- (:py (:p1 n-down)) c-y)
			      (- (:px (:p2 n-down)) c-x)
			      (- (:py (:p2 n-down)) c-y)))))))

(defun draw-lines-GUI
    (scene lines colors)   
  (loop for (line color) in (partition (interleave lines colors) 2)
     do (progn
	  (let* ((p1  (:p1 line))
		 (p2  (:p2 line))
		 
		 (px1 (:px p1))
		 (py1 (:py p1))
		 (px2 (:px p2))
		 (py2 (:py p2)))
	    (set-render-draw-color (:renderer scene)
				   (nth 0 color)
				   (nth 1 color)
				   (nth 2 color)
				   (nth 3 color))
	    (sdl::sdl-renderdrawline (:renderer scene)
				     px1
				     py1
				     px2
				     py2)))))
(defun draw-lines-INGAME
    (scene camera-rect lines colors)   
  (loop for (line color) in (partition (interleave lines colors) 2)
     do (progn
	  (let* ((p1  (:p1 line))
		 (p2  (:p2 line))
		 
		 (px1 (:px p1))
		 (py1 (:py p1))
		 (px2 (:px p2))
		 (py2 (:py p2))
		 (c-x (sdl::rect-get-x camera-rect))
		 (c-y (sdl::rect-get-y camera-rect)))
	    (set-render-draw-color (:renderer scene)
				   (nth 0 color)
				   (nth 1 color)
				   (nth 2 color)
				   (nth 3 color))
	    (sdl::sdl-renderdrawline (:renderer scene)
				     (- px1 c-x)
				     (- py1 c-y)
				     (- px2 c-x)
				     (- py2 c-y))))))

(defun draw-rects-GUI
    (scene rects colors &key origin)   
  (loop for (rect color) in (partition (interleave rects colors) 2)
     do (progn
	  (let* ((r-x (sdl::rect-get-x rect))
		 (r-y (sdl::rect-get-y rect))
		 (r-w (sdl::rect-get-w rect))
		 (r-h (sdl::rect-get-h rect)))
	    (set-render-draw-color (:renderer scene)
				   (nth 0 color)
				   (nth 1 color)
				   (nth 2 color)
				   (nth 3 color))
	    (if origin
		(cond ((eq origin :center) (sdl::rect-set-position rect
								   (- r-x (/ r-w 2))
								   (- r-y (/ r-h 2))))
		      ;;user didn't supply vaid command;;return with only camera modifications
		      (:default (sdl::rect-set-position rect
							r-x
							r-y)))
		;;user didn't supply an origin;;return without only camera modifications
		(sdl::rect-set-position rect
					r-x
					r-y))
	    (sdl::sdl-renderdrawrect (:renderer scene)
				     rect)))))

(defun draw-rects-INGAME
    ;;"NOTE: This fn creates a copy of every rect that's being passed."
    (scene camera-rect rects colors &key origin type)   
  (loop for (rect color) in (partition (interleave rects colors) 2)
     do (progn
	  (let* ((r-x (sdl::rect-get-x rect))
		 (r-y (sdl::rect-get-y rect))
		 (r-w (sdl::rect-get-w rect))
		 (r-h (sdl::rect-get-h rect))
		 (c-x (sdl::rect-get-x camera-rect))
		 (c-y (sdl::rect-get-y camera-rect))
		 (rect (sdl::new-rect r-x r-y r-w r-h)))
	    (set-render-draw-color (:renderer scene)
				   (nth 0 color)
				   (nth 1 color)
				   (nth 2 color)
				   (nth 3 color))
	    (if origin
		(cond ((eq origin :center) (sdl::rect-set-position rect
								   (- (- r-x (/ r-w 2)) c-x)
								   (- (- r-y (/ r-h 2)) c-y)))
		      ;;user didn't supply vaid command;;return with only camera modifications
		      (:default (sdl::rect-set-position rect
							(- r-x c-x)
							(- r-y c-y))))
		;;user didn't supply an origin;;return without only camera modifications
		(sdl::rect-set-position rect
				    (- r-x c-x)
				    (- r-y c-y)))
	    (if (eq type :fill)
		(sdl::sdl-renderfillrect (:renderer scene)
					   rect)
		(sdl::sdl-renderdrawrect (:renderer scene)
					 rect))
	    (sdl::delete-rect rect)))))

(utilities:export-all-symbols-except '(window))
