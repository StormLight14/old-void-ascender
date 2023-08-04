extends TextureRect

@onready var item_texture_button = %ItemTextureButton

var follow_mouse = false

func _process(_delta):
	if follow_mouse == true:
		item_texture_button.global_position = get_global_mouse_position() - (Vector2(texture.get_width(), texture.get_height()) / 2)

func _on_item_texture_button_pressed():
	follow_mouse = true
