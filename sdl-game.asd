;;;; sdl-game.asd

(asdf:defsystem #:sdl-game
  :description "Describe sdl-game here"
  :author "Your Name <your.name@example.com>"
  :license "Specify license here"
  :serial t
  :depends-on (#:utilities
               #:cffi)
  :components ((:file "package")
	       (:file "sdl")

	       (:file "game-utilities/game-utilities")
	       (:file "game-utilities/event-manager")
	       (:file "game-utilities/asset-manager")
	       
	       (:file "game")
	       ;(:file "jacob-test")
               (:file "sdl-game")))
