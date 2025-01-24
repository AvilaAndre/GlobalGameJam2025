all: build run

build:
		odin build src/ -out:bin/game
run:
		./bin/game

