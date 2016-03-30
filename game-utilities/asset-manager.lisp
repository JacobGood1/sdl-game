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
	    (renderer nil))
    :constructor (lambda (all-images all-audio renderer)
		   (set-slots asset-manager :all-images all-images :all-audio all-audio :renderer renderer)
		   (let* ((load-loop (lambda (element type)
				       (loop 
					  for e in (map 'list #'identity element) 
					  do (attach (:images asset-manager) (to-keyword e) 
						     (load-img (concatenate 'string (:path asset-manager) e type) renderer))
					  finally (return (:images asset-manager)) (return (:audio asset-manager))))))
		     (if (not (nil? (:all-images asset-manager)))
			 (funcall load-loop (:all-images asset-manager) (:image-type asset-manager)))
		     (if (not (nil? (:all-audio asset-manager)))
			 (funcall load-loop (:all-audio asset-manager) (:audio-type asset-manager))))))
