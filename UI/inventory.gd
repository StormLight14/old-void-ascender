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

@export var inventory_slot_scene: PackedScene

enum {
	WEAPONS,
	ARMOR,
	PERKS,
}

var current_tab = WEAPONS

func _ready():
	update_inventory_ui()
	for i in range(10):
		var inventory_slot = inventory_slot_scene.instantiate()
		inventory_slot.slot_item_type = 'melee'
		inventory_slot.slot_item = WeaponStats.weapons['melee'][0]
		weapons.add_child(inventory_slot)
	for i in range(10):
		var inventory_slot = inventory_slot_scene.instantiate()
		inventory_slot.slot_item_type = 'melee'
		inventory_slot.slot_item = WeaponStats.weapons['melee'][1]
		weapons.add_child(inventory_slot)
	for i in range(10):
		var inventory_slot = inventory_slot_scene.instantiate()
		inventory_slot.slot_item_type = 'ranged'
		inventory_slot.slot_item = WeaponStats.weapons['ranged'][1]
		weapons.add_child(inventory_slot)
	for i in range(10):
		var inventory_slot = inventory_slot_scene.instantiate()
		inventory_slot.slot_item_type = 'ranged'
		inventory_slot.slot_item = WeaponStats.weapons['ranged'][2]
		weapons.add_child(inventory_slot)
	for i in range(10):
		var inventory_slot = inventory_slot_scene.instantiate()
		inventory_slot.slot_item_type = 'ranged'
		inventory_slot.slot_item = WeaponStats.weapons['ranged'][1]
		armor.add_child(inventory_slot)
		
	#for i in range(20):
		#var inventory_slot = inventory_slot_scene.instantiate()
		#inventory_slot.slot_item_type = 'special'
		#perks.add_child(inventory_slot)

func update_inventory_ui():
	weapons_scroll.visible = false
	armor_scroll.visible = false
	perks_scroll.visible = false
	
	equipped_melee.visible = false
	equipped_ranged.visible = false
	equipped_special.visible = false
	
	match current_tab:
		WEAPONS:
			weapons_scroll.visible = true
			set_equipped_display_visible('weapons')
		ARMOR:
			armor_scroll.visible = true
			set_equipped_display_visible('armor')
		PERKS:
			perks_scroll.visible = true
			set_equipped_display_visible('special')
			
	equipped_melee.texture = PlayerValues.melee_weapon['sprite']
	equipped_ranged.texture = PlayerValues.ranged_weapon['sprite']
	#equipped_special.texture =  PlayerValues.special_weapon['sprite']
	
func set_equipped_display_visible(type):
	equipped_melee.visible = false
	equipped_ranged.visible = false
	equipped_special.visible = false
	#equipped_armor.visible = false
	#equipped_perk_1.visible = false
	#equipped_perk_2.visible = false
	#equipped_perk_3.visible = false
	
	match type:
		'weapons':
			equipped_melee.visible = true
			equipped_ranged.visible = true
			equipped_special.visible = true
		'armor':
			pass
			#equipped_armor.visible = true
		'perks':
			pass
			#equipped_perk_1.visible = true
			#equipped_perk_2.visible = true
			#equipped_perk_3.visible = true

func _on_weapons_button_pressed():
	current_tab = WEAPONS
	update_inventory_ui()

func _on_armor_button_pressed():
	current_tab = ARMOR
	update_inventory_ui()

func _on_perks_button_pressed():
	current_tab = PERKS
	update_inventory_ui()
