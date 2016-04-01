(in-package #:jacob-test)

(def-class 
    game-object 
    :slots ((x 0)
	    (y 0)
	    (width 0)
	    (height 0)
	    (texture-id "")
	    (current-frame 0)
	    (current-row 0)))

(def-method :draw   game-object () (print "draw"))
(def-method :update game-object () (print "update"))
(def-method :clean  game-object () (print "clean"))
(def-method :load game-object
  ((x integer) (y integer) (width integer) (height integer) (texture-id string))
  (print texture-id))

(def-class
    player
    :extends (game-object))

(def-method :draw player
  ()
  (call-next-method)
  (print "draw player"))

(def-method :update player
  ()
  (set-slots player
	     :x 10
	     :y 20))

(def-method :clean player
  ()
  (call-next-method)
  (print "clean player"))


;;input handling code, start of a test area for handling input


