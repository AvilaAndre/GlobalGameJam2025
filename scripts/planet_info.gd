extends Node2D

var id: int = -1

func get_data() -> PlanetType:
	if !$"/root/Autoload".planets.has(self.id):
		return null
	return $"/root/Autoload".planets[self.id] 
