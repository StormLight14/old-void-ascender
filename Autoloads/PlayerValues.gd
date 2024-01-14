#keeps track of all player values, persists between scenes
extends Node

enum {
	MELEE,
	RANGED,
	SPECIAL
}

var melee_weapons = WeaponStats.weapons['melee']
var ranged_weapons = WeaponStats.weapons['ranged']
var special_weapons = WeaponStats.weapons['special']

@export var player_data = {
	"position": Vector2.ZERO,
	"health": 50.0,
	"strength": 1.0,
	"current_attack": MELEE,
	"inventory": Inventory.new(),
	"melee_weapon": melee_weapons['stone_sword'],
	"ranged_weapon": ranged_weapons['ar'],
	"special_weapon": special_weapons['flamethrower']
	
}

@export var melee_weapon_sprite: CompressedTexture2D = player_data.melee_weapon['sprite']
@export var melee_weapon_auto_swing: bool = player_data.melee_weapon['auto_swing']

@export var ranged_weapon_sprite: CompressedTexture2D = player_data.ranged_weapon['sprite']
@export var ranged_weapon_auto_shoot: bool = player_data.ranged_weapon['auto_shoot']

@export var special_weapon_sprite: CompressedTexture2D = player_data.special_weapon['sprite']
@export var special_weapon_auto_attack: bool = player_data.special_weapon['auto_attack']
@export var special_weapon_attacking: bool = false

func _process(delta):
	melee_weapon_sprite = player_data.melee_weapon['sprite']
	melee_weapon_auto_swing = player_data.melee_weapon['auto_swing']
	
	ranged_weapon_sprite = player_data.ranged_weapon['sprite']
	ranged_weapon_auto_shoot = player_data.ranged_weapon['auto_shoot']
	
	special_weapon_sprite = player_data.special_weapon['sprite']
	special_weapon_auto_attack = player_data.special_weapon['auto_attack']
