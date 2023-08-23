#keeps track of all player values, persists between scenes
extends Node

var melee_weapons = WeaponStats.weapons['melee']
var ranged_weapons = WeaponStats.weapons['ranged']
var special_weapons = WeaponStats.weapons['special']

enum {
	MELEE,
	RANGED,
	SPECIAL
}

@export var position: Vector2
@export var health = 50.0
@export var strength = 1.0 # multiplier * damage of weapon

@export var current_attack = MELEE
@export var inventory = Inventory.new()

@export var melee_weapon: Dictionary = melee_weapons['stone_sword'] # by melee weapon id, found in WeaponStats.gd
@export var melee_weapon_sprite: CompressedTexture2D = melee_weapon['sprite']
@export var melee_weapon_auto_swing: bool = melee_weapon['auto_swing']

@export var ranged_weapon: Dictionary = ranged_weapons['ar']
@export var ranged_weapon_sprite: CompressedTexture2D = ranged_weapon['sprite']
@export var ranged_weapon_auto_shoot: bool = ranged_weapon['auto_shoot']

@export var special_weapon: Dictionary = special_weapons['flamethrower']
@export var special_weapon_sprite: CompressedTexture2D = special_weapon['sprite']
@export var special_weapon_auto_attack: bool = special_weapon['auto_attack']
@export var special_weapon_attacking: bool = false

func _process(delta):
	melee_weapon_sprite = melee_weapon['sprite']
	melee_weapon_auto_swing = melee_weapon['auto_swing']
	
	ranged_weapon_sprite = ranged_weapon['sprite']
	ranged_weapon_auto_shoot = ranged_weapon['auto_shoot']
	
	special_weapon_sprite = special_weapon['sprite']
	special_weapon_auto_attack = special_weapon['auto_attack']
