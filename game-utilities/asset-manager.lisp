(in-package :game-utilities/asset-manager)

;;;;TODO asset-manager is still a WIP.
;;;;all files will be loaded directly from C:/ for now.

(def-class asset-manager
    :slots ((load% 0.0) 
	    (path "C:/") 
	    (all-images '())
	    (all-audio '()) 
	    (images (make-hash-table)) 
	    (audio (make-hash-table))
	    (image-type ".png")
	    (audio-type ".ogg")
	    (renderer nil)
	    (animations (make-map))))


(def-class animation
    :slots ((fps nil) (sprite-coordinates nil) (texture nil)))

(defmethod initialize-instance :after ((asset-manager asset-manager) &key all-images all-audio animations renderer)
  (setf (:all-images asset-manager) all-images
	(:all-audio  asset-manager) all-audio
	(:renderer   asset-manager) renderer
	(:images     asset-manager) (make-hash-table))
  (let* ((load-loop (lambda (element type)
		      (loop 
			 for e in (map 'list #'identity element)
			 do (attach (:images asset-manager) (to-keyword e) 
				    (load-img (concatenate 'string (:path asset-manager) e type) renderer))
			 finally (return (:images asset-manager)) (return (:audio asset-manager))))))
    (if (not (nil? (:all-images asset-manager)))
	(funcall load-loop (:all-images asset-manager) (:image-type asset-manager)))
    (if (not (nil? (:all-audio asset-manager)))
	(funcall load-loop (:all-audio asset-manager) (:audio-type asset-manager)))
    (if (not (nil? animations))
					;(loop for animation-map in animation-maps do
					;     (let* ((name (gethash :name animation-map)))
					;	(remhash :name animation-map)
					;	(attach (:animations asset-manager) name animation-map)))
					;(attach (:animations asset-manager) animations)
	(set-slots asset-manager :animations animations))))

(defmethod initialize-instance :after ((animation animation) &key name fps sprite-coordinates texture)
  (setf (:fps                animation) fps
	(:sprite-coordinates animation) sprite-coordinates
	(:texture            animation) texture))
