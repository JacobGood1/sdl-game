(in-package :game-utilities/asset-manager)

(def-class asset-manager
    :slots ((load% 0.0) 
	    ;;(path "C:/")
	    (path "assets/")
	    (all-images '())
	    (all-audio-bites '())
	    (all-audio-music '())
	    (images (make-hash-table))
	    (audio-bites (make-hash-table))
	    (audio-music (make-hash-table))
	    (image-type ".png")
	    (audio-bite-type ".wav")
	    (audio-music-type ".wav")
	    (renderer nil)
	    (animations (make-map))
	    (sprites (make-map))))

(def-class animation
    :slots ((fps nil) (sprite-coordinates nil) (texture nil)))
(def-class sprite
    :slots ((sprite-coordinate nil) (texture nil)))

(var asset-manager (make-instance 'asset-manager))

;;(defmethod initialize-instance :after ((asset-manager asset-manager) &key all-images all-audio-bites all-audio-music animations renderer)
;;  (setf (:all-images asset-manager) all-images
;;	(:all-audio-bites asset-manager) all-audio-bites
;;	(:all-audio-music asset-manager) all-audio-music
;;	(:renderer    asset-manager) renderer
;;	(:animations asset-manager) animations)
;;  (let* ((load-loop (lambda (element type)
;;		      t)))
;;    (if (not (nil? (:all-images asset-manager)))
;;	;;(funcall load-loop (:all-images asset-manager) (:image-type asset-manager))
;;	(loop 
;;	   for e in (map 'list #'identity (:all-images asset-manager))
;;	   do (attach (:images asset-manager) (to-keyword e) 
;;		      (load-img (concatenate 'string (:path asset-manager) e (:image-type asset-manager)) renderer))
;;	   ;;finally (return (:images asset-manager)) (return (:audio asset-manager))
;;	     ))
;;    (if (not (nil? (:all-audio-music asset-manager)))
;;	;;(funcall load-loop (:all-audio asset-manager) (:audio-type asset-manager))
;;	(loop 
;;	   for e in (map 'list #'identity (:all-audio-music asset-manager))
;;	   do (progn (attach (:audio-music asset-manager) (to-keyword e)
;;			     (let* ((path (concatenate 'string (:path asset-manager) e (:audio-music-type asset-manager))))
;;			       (sdl::mix-loadmus path)))
;;		     (print (sdl::sdl-geterror)))
;;	   ;;finally (return (:images asset-manager)) (return (:audio asset-manager))
;;	     ))
;;    (if (not (nil? (:all-audio-bites asset-manager)))
;;	;;(funcall load-loop (:all-audio asset-manager) (:audio-type asset-manager))
;;	(loop 
;;	   for e in (map 'list #'identity (:all-audio-bites asset-manager))
;;	   do (attach (:audio-bites asset-manager) (to-keyword e) 
;;		      (sdl::load-wav (concatenate 'string (:path asset-manager) e (:audio-bite-type asset-manager))))
;;	   ;;finally (return (:images asset-manager)) (return (:audio asset-manager))
;;	     ))
;;    (if (not (nil? animations))
;;	;;(loop for animation-map in animation-maps do
;;	;;     (let* ((name (gethash :name animation-map)))
;;	;;	(remhash :name animation-map)
;;	;;	(attach (:animations asset-manager) name animation-map)))
;;	;;(attach (:animations asset-manager) animations)
;;	(set-slots asset-manager :animations animations))))

(defmethod initialize-instance :after ((animation animation) &key name fps sprite-coordinates texture)
  (setf (:fps                animation) fps
	(:sprite-coordinates animation) sprite-coordinates
	(:texture            animation) texture))

(defun asset
    (name type)
  (cond ((= name :image) (gethash name (:images a-m))
	 (= name :bite) (gethash name (:audio-bites a-m))
	 (= name :music (gethash name (:audio-music a-m))))))

(defun init-asset-managerr
    (&rest args)
  (progn (loop for (key value) in (partition args 2)
	    do `(setf ,(funcall key a-m) value))
	 a-m))

(defun init-asset-manager
    (&key all-images all-audio-bites all-audio-music animations sprites renderer)
  (print (to-string "asset-manager package: " *default-pathname-defaults*))
  (setf (:all-images asset-manager) all-images
	(:all-audio-bites asset-manager) all-audio-bites
	(:all-audio-music asset-manager) all-audio-music
	(:renderer    asset-manager) renderer
	(:images      asset-manager) (make-hash-table)
	(:audio-bites asset-manager) (make-hash-table)
	(:audio-music asset-manager) (make-hash-table)
	(:animations asset-manager) animations
	(:sprites asset-manager) sprites)
  (let* ((load-loop (lambda (element type)
		      t)))
    (if (not (nil? (:all-images asset-manager)))
	;;(funcall load-loop (:all-images asset-manager) (:image-type asset-manager))
	(loop 
	   for e in (map 'list #'identity (:all-images asset-manager))
	   do (progn (attach (:images asset-manager) (to-keyword e) 
			     (load-img (concatenate 'string (:path asset-manager) e (:image-type asset-manager)) renderer))
		     (print (sdl::sdl-geterror)))
	   ;;finally (return (:images asset-manager)) (return (:audio asset-manager))
	     ))
    (if (not (nil? (:all-audio-music asset-manager)))
	;;(funcall load-loop (:all-audio asset-manager) (:audio-type asset-manager))
	(loop 
	   for e in (map 'list #'identity (:all-audio-music asset-manager))
	   do (progn (attach (:audio-music asset-manager) (to-keyword e)
			     (let* ((path (concatenate 'string (:path asset-manager) e (:audio-music-type asset-manager))))
			       (sdl::mix-loadmus path)))
		     (print (sdl::sdl-geterror)))
	   ;;finally (return (:images asset-manager)) (return (:audio asset-manager))
	     ))
    (if (not (nil? (:all-audio-bites asset-manager)))
	;;(funcall load-loop (:all-audio asset-manager) (:audio-type asset-manager))
	(loop 
	   for e in (map 'list #'identity (:all-audio-bites asset-manager))
	   do (attach (:audio-bites asset-manager) (to-keyword e) 
		      (sdl::load-wav (concatenate 'string (:path asset-manager) e (:audio-bite-type asset-manager))))
	   ;;finally (return (:images asset-manager)) (return (:audio asset-manager))
	     ))))
