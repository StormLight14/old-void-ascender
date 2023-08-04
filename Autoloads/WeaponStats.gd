extends Node

var weapons = {
	'melee': { # melee
		0: { # melee weapon id
			'name': 'Stone Sword',
			'size': 0, # 0: small, 1: medium, 2: large
			'damage': 5.0,
			'attack_delay': 0.4, # delay in seconds between attacks
			'auto_swing': false,
			'knockback_strength': 50,
			'sprite': preload("res://Assets/melee_weapons/stone_sword.png"),
		},
		1: {
			'name': 'Steel Sword',
			'size': 0,
			'damage': 7.5,
			'attack_delay': 0.45,
			'auto_swing': false,
			'knockback_strength': 50,
			'sprite': preload("res://Assets/melee_weapons/steel_sword.png"),
		},
		99: {
			'name': 'Ice Sword',
			'size': 1,
			'damage': 50.0,
			'attack_delay': 0.3,
			'auto_swing': true,
			'knockback_strength': 60,
			'sprite': preload("res://Assets/melee_weapons/ice_sword.png"),
		},
		100: {
			'name': 'Dark Sword',
			'size': 2,
			'damage': 100.0,
			'attack_delay': 0.5,
			'auto_swing': true,
			'knockback_strength': 80,
			'sprite': preload("res://Assets/melee_weapons/dark_sword.png"),
		}
	},
	'ranged': { # ranged
		0: { # ranged weapon id
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
			'sprite': preload("res://Assets/ranged_weapons/guns/colt.png"),
			'sprite_scale': 0.3,
		},
		1: {
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
			'sprite': preload("res://Assets/ranged_weapons/guns/ar.png"),
			'sprite_scale': 0.4,
		},
		2: {
			'name': 'Shotgun',
			'type': 'gun',
			'shot_projectiles': 5,
			'spread_degrees': 10,
			'ammo_count': 30,
			'reload_time': 1,
			'shot_delay': 0.5,
			'projectile_speed': 300,
			'projectile_damage': 5.0, # per projectile
			'projectile_knockback_strength': 30,
			'auto_shoot': true,
			'sprite': preload("res://Assets/ranged_weapons/guns/shotgun.png"),
			'sprite_scale': 0.4,
		}
	},
	'special': { # special
		
	}
}
