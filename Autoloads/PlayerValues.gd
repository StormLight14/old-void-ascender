#keeps track of all player values, persists between scenes
extends Node

var melee_weapons = WeaponStats.weapons[0]
var ranged_weapons = WeaponStats.weapons[1]
var special_weapons = WeaponStats.weapons[2]

@export var position: Vector2
@export var health = 50.0
@export var strength = 1.0 # multiplier * damage of weapon

@export var current_attack = "melee"

@export var melee_weapon: Dictionary = melee_weapons[1] # by melee weapon id, found in WeaponStats.gd
@export var melee_weapon_sprite: CompressedTexture2D = melee_weapon['sprite']
@export var melee_weapon_auto_swing: bool = melee_weapon['auto_swing']

@export var ranged_weapon: Dictionary = ranged_weapons[1]
@export var ranged_weapon_sprite: CompressedTexture2D = ranged_weapon['sprite']
@export var ranged_weapon_auto_shoot: bool = ranged_weapon['auto_shoot']
#var special_weapon = special_weapons[0]

func _process(delta):
	melee_weapon_sprite = melee_weapon['sprite']
	melee_weapon_auto_swing = melee_weapon['auto_swing']
	ranged_weapon_sprite = ranged_weapon['sprite']
	ranged_weapon_auto_shoot = ranged_weapon['auto_shoot']
