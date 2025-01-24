package manager

type SceneCode int8

const (
	MAIN_MENU SceneCode = 0
)

type GameManager struct {
	scene SceneCode
}

func NewGameManager() GameManager {
	return GameManager{
		scene: MAIN_MENU,
	}
}

func (gm *GameManager) Draw() {
	switch gm.scene {
	case MAIN_MENU:
		{
			draw_main_menu()
		}
	}
}
