(in-package :game-utilities/animation)

(def-class animation
    :slots ((fps nil)
	    (frame-count 0)
	    (sprite-count nil)
	    (sprite-coordinates nil)
	    (texture nil))
    :constructor (lambda (sprite-coordinates texture fps)
		   (setf (:sprite-coordinates animation)
			 (let* ((length (length sprite-coordinates))
				(new-array (make-array (length sprite-coordinates)))
				(array-count 0))
			   (set-slots animation 
				      :sprite-count length
				      :texture texture
				      :fps fps)
			   (loop for sprite-coordinate
			      in sprite-coordinates
			      do (setf (aref new-array array-count)
				       
					(eval `(new-struct rect ,sprite-coordinate))
				       )
				(setf array-count [array-count + 1]))			   
			   new-array))))

(defn update-animation
    (animation-object)
  (let* ((sprite-count (:sprite-count animation-object))
	 (sprite-rects (:sprite-coordinates animation-object))
	 (f-c (:frame-count animation-object))
	 (fps (:fps animation-object)))
    (setf (:frame-count animation-object) [f-c + 1])
    (let* ((floored-frame-count (floor [[f-c * 0.6] / sprite-count]))
	   (ani-frame-index (if (> floored-frame-count (- sprite-count 1))
					;then
				(progn
				  (setf (:frame-count animation-object) 0)
				  0)
					;else
				floored-frame-count)))
      (aref sprite-rects ani-frame-index))))


