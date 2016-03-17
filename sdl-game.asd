;;;; sdl-game.asd

(asdf:defsystem #:sdl-game
  :description "Describe sdl-game here"
  :author "Your Name <your.name@example.com>"
  :license "Specify license here"
  :depends-on (#:utilities
               #:cffi)
  :serial t
  :components ((:file "package")
	       (:file "sdl")
	       (:file "game-utilities")
	       (:file "game")
	       (:file "travis-test")
               (:file "sdl-game")))
