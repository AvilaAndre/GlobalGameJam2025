package main

import rl "github.com/gen2brain/raylib-go/raylib"

import "ggj2025.ncgm/manager"

type Planet struct {
	id       int64
	position rl.Vector2
}

func main() {
	rl.InitWindow(800, 450, "raylib [core] example - basic window")
	defer rl.CloseWindow()

	rl.SetTargetFPS(60)

	gm := manager.NewGameManager()

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()

		rl.ClearBackground(rl.Black)

		gm.Draw()

		rl.EndDrawing()
	}
}
