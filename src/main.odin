package main

import rl "vendor:raylib"


SCREEN_WIDTH :: 800
SCREEN_HEIGHT :: 450

main :: proc() {

	rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "GGJ 2025")


	rl.SetTargetFPS(60)
	for (!rl.WindowShouldClose()) {
		rl.BeginDrawing()
		{
			rl.ClearBackground(rl.WHITE)
			rl.DrawText("Hello World!", SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2, 12, rl.BLACK)
		}
		rl.EndDrawing()
	}


	rl.CloseWindow()
}
