extends Control

@onready var melee_weapons = %MeleeWeapons
@onready var ranged_weapons = %RangedWeapons
@onready var special_weapons = %SpecialWeapons
 
@onready var armor = %Armor
@onready var perks = %Perks

@onready var weapon_scroll = %WeaponScroll
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
	for melee_weapon_id in PlayerValues.inventory.melee_weapons:
		var inventory_slot = inventory_slot_scene.instantiate()
		inventory_slot.slot_item_type = 'melee'
		inventory_slot.slot_item = WeaponStats.weapons['melee'][melee_weapon_id]
		melee_weapons.add_child(inventory_slot)

	for ranged_weapon_id in PlayerValues.inventory.ranged_weapons:
		var inventory_slot = inventory_slot_scene.instantiate()
		inventory_slot.slot_item_type = 'ranged'
		inventory_slot.slot_item = WeaponStats.weapons['ranged'][ranged_weapon_id]
		ranged_weapons.add_child(inventory_slot)
		
	#for special_weapon_id in PlayerValues.inventory.special_weapons:
		#var inventory_slot = inventory_slot_scene.instantiate()
		#inventory_slot.slot_item_type = 'special'
		#inventory_slot.slot_item = WeaponStats.weapons['special'][special_weapon_id]
		#armor.add_child(inventory_slot)

func update_inventory_ui():
	weapon_scroll.visible = false
	armor_scroll.visible = false
	perks_scroll.visible = false
	
	equipped_melee.visible = false
	equipped_ranged.visible = false
	equipped_special.visible = false
	
	match current_tab:
		WEAPONS:
			weapon_scroll.visible = true
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
