extends GPUParticles2D

@export var shoot_direction = Vector2(1, 0)

func _process(_delta):
	process_material.set("direction", shoot_direction)
