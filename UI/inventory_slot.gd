extends TextureRect

@onready var item_texture_button = %ItemTextureButton

var follow_mouse = false
var slot_item = WeaponStats.weapons['ranged'][0]
var slot_item_type = 'ranged' # melee, ranged, special, empty

func _ready():
	if slot_item:
		item_texture_button.texture_normal = slot_item['sprite']
	else:
		item_texture_button.texture_normal = CompressedTexture2D

func _process(_delta):
	if follow_mouse == true:
		item_texture_button.global_position = get_global_mouse_position() - (Vector2(texture.get_width(), texture.get_height()) / 2)

func _on_item_texture_button_pressed():
	match slot_item_type:
		'melee':
			PlayerValues.melee_weapon = slot_item
		'ranged':
			PlayerValues.ranged_weapon = slot_item
		'special':
			PlayerValues.special_weapon = slot_item
		'empty':
			return
	
	get_node("../../../../../").update_inventory_ui()
