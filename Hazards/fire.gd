extends Node2D

@export var color = "orange"

@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	match color:
		"orange":
			animated_sprite_2d.play("orange_start")
		"blue":
			animated_sprite_2d.play("blue_start")
		"green":
			animated_sprite_2d.play("green_start")

func _on_animated_sprite_2d_animation_finished():
	match color:
		"orange":
			animated_sprite_2d.play("orange_loop")
		"blue":
			animated_sprite_2d.play("blue_loop")
		"green":
			animated_sprite_2d.play("green_loop")
