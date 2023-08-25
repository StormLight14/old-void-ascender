extends Node

var weapons = {
	'melee': { # melee
		'stone_sword': { # melee weapon id
			'name': 'Stone Sword',
			'size': 0, # 0: small, 1: medium, 2: large
			'damage': 5.0,
			'attack_delay': 0.4, # delay in seconds between attacks
			'auto_swing': false,
			'knockback_strength': 50,
			'sprite': preload("res://Assets/weapons/melee_weapons/stone_sword.png"),
		},
		'steel_sword': {
			'name': 'Steel Sword',
			'size': 0,
			'damage': 7.5,
			'attack_delay': 0.45,
			'auto_swing': false,
			'knockback_strength': 50,
			'sprite': preload("res://Assets/weapons/melee_weapons/steel_sword.png"),
		},
		'vampire_sword': {
			'name': 'Vampire Sword',
			'size': 0,
			'damage': 25.0,
			'attack_delay': 0.1,
			'auto_swing': true,
			'knockback_strength': 60,
			'sprite': preload("res://Assets/weapons/melee_weapons/vampire_sword.png"),
		},
		'ice_sword': {
			'name': 'Ice Sword',
			'size': 1,
			'damage': 50.0,
			'attack_delay': 0.3,
			'auto_swing': true,
			'knockback_strength': 60,
			'sprite': preload("res://Assets/weapons/melee_weapons/ice_sword.png"),
		},
		'dark_sword': {
			'name': 'Dark Sword',
			'size': 2,
			'damage': 100.0,
			'attack_delay': 0.5,
			'auto_swing': true,
			'knockback_strength': 80,
			'sprite': preload("res://Assets/weapons/melee_weapons/dark_sword.png"),
		}
	},
	'ranged': { # ranged
		'colt': { # ranged weapon id
			'name': 'Colt',
			'type': 'gun',
			'shot_projectiles': 1,
			'ammo_count': 16,
			'reload_time': 1,
			'shot_delay': 0.2,
			'projectile_speed': 250,
			'projectile_damage': 10.0, # per projectile
			'projectile_knockback_strength': 30,
			'auto_shoot': true,
			'sprite': preload("res://Assets/weapons/ranged_weapons/guns/colt.png"),
			'sprite_scale': 0.3,
		},
		'ar': {
			'name': 'AR',
			'type': 'gun',
			'shot_projectiles': 1,
			'ammo_count': 30,
			'reload_time': 1,
			'shot_delay': 0.1,
			'projectile_speed': 300,
			'projectile_damage': 15.0, # per projectile
			'projectile_knockback_strength': 30,
			'auto_shoot': true,
			'sprite': preload("res://Assets/weapons/ranged_weapons/guns/ar.png"),
			'sprite_scale': 0.4,
		},
		'shotgun': {
			'name': 'Shotgun',
			'type': 'gun',
			'shot_projectiles': 5,
			'spread_degrees': 10,
			'ammo_count': 30,
			'reload_time': 1,
			'shot_delay': 0.5,
			'projectile_speed': 300,
			'projectile_damage': 10.0, # per projectile
			'projectile_knockback_strength': 50,
			'auto_shoot': true,
			'sprite': preload("res://Assets/weapons/ranged_weapons/guns/shotgun.png"),
			'sprite_scale': 0.4,
		}
	},
	'special': { # special
		'flamethrower': {
			'name': 'Flamethrower',
			'base_damage': 5.0,
			'damage_increment': 5.0,
			'max_damage': 50.0,
			'increment_delay': 1,
			'no_shot_delay': true,
			'auto_attack': true,
			'sprite': preload("res://Assets/weapons/ranged_weapons/guns/shotgun.png"),
			'sprite_scale': 0.4,
		}
	}
}
