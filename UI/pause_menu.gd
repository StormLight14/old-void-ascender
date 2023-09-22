extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	GameValues.ui_open = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	controls()

func controls():
	if Input.is_action_just_pressed("ui_close"):
		get_tree().paused = false
		GameValues.ui_open = false
		queue_free()
