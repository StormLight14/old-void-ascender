extends Control

@onready var weapons = %Weapons
@onready var armor = %Armor
@onready var perks = %Perks

@onready var weapons_scroll = %WeaponScroll
@onready var armor_scroll = %ArmorScroll
@onready var perks_scroll = %PerkScroll

@onready var equipped_melee = %EquippedMelee
@onready var equipped_ranged = %EquippedRanged
@onready var equipped_special = %EquippedSpecial

var inventory_slot_scene = preload("res://UI/inventory_slot.tscn")

enum {
	WEAPONS,
	ARMOR,
	PERKS,
}

var current_tab = WEAPONS

func _ready():
	update_inventory_ui()
	for i in range(20):
		weapons.add_child(inventory_slot_scene.instantiate())
	for i in range(20):
		armor.add_child(inventory_slot_scene.instantiate())
	for i in range(20):
		perks.add_child(inventory_slot_scene.instantiate())

func update_inventory_ui():
	weapons_scroll.visible = false
	armor_scroll.visible = false
	perks_scroll.visible = false
	
	match current_tab:
		WEAPONS:
			weapons_scroll.visible = true
		ARMOR:
			armor_scroll.visible = true
		PERKS:
			perks_scroll.visible = true
			
	equipped_melee.texture = PlayerValues.melee_weapon_sprite
	equipped_ranged.texture = PlayerValues.ranged_weapon_sprite
	#equipped_special.texture = PlayerValues.special_weapon_sprite

func _on_weapons_button_pressed():
	current_tab = WEAPONS
	update_inventory_ui()

func _on_armor_button_pressed():
	current_tab = ARMOR
	update_inventory_ui()

func _on_perks_button_pressed():
	current_tab = PERKS
	update_inventory_ui()
