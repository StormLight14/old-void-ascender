extends GPUParticles2D

@export var shoot_direction = Vector2(1, 0)
@export var spawn_particles = true

@onready var timeout_timer = $TimeoutTimer

func _ready():
	timeout_timer.wait_time = lifetime
	
func _process(_delta):
	process_material.set("direction", shoot_direction)
	if spawn_particles == false:
		if timeout_timer.is_stopped():
			timeout_timer.start()
		emitting = false

func _on_timeout_timer_timeout():
	queue_free()
