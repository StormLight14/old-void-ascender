extends Node

var current_profile_edit = 0 # 1, 2, or 3 depending on what profile is getting made in new_profile.tscn
var current_profile = 0
var unlocked_profiles = [false, false, false]
var profile_names = ["Profile 1", "Profile 2", "Profile 3"]

var using_controller = false

var current_world = 0
var current_level = 0

var ui_open = true

@export var worlds: Array[Resource] = []

func _process(_delta):
	if Input.is_action_just_pressed("save"):
		save_game_values()
		save_profile(GameValues.current_profile, PlayerValues)
		
	if Input.is_action_just_pressed("next_level"):
		if GameValues.current_level < GameValues.worlds[GameValues.current_world].levels.size() - 1:
			GameValues.current_level += 1
			get_tree().change_scene_to_packed(GameValues.worlds[GameValues.current_world].levels[GameValues.current_level])
			print("Moved to World " + str(GameValues.current_world) + ", Level " + str(GameValues.current_level))
		else:
			if GameValues.current_world < GameValues.worlds.size() - 1:
				GameValues.current_world += 1
				GameValues.current_level = 0
				get_tree().change_scene_to_packed(GameValues.worlds[GameValues.current_world].levels[GameValues.current_level])
				print("Moved to World " + str(GameValues.current_world) + ", Level " + str(GameValues.current_level))
		GameValues.save_game_values()
		GameValues.save_profile(GameValues.current_profile, PlayerValues)
	if Input.is_action_just_pressed("previous_level"):
		if GameValues.current_level > 0:
			GameValues.current_level -= 1
			get_tree().change_scene_to_packed(GameValues.worlds[GameValues.current_world].levels[GameValues.current_level])
			print("Moved to World " + str(GameValues.current_world) + ", Level " + str(GameValues.current_level))
		else:
			if GameValues.current_world > 0:
				GameValues.current_world -= 1
				GameValues.current_level = GameValues.worlds[GameValues.current_world].levels.size() - 1
				print(GameValues.worlds[GameValues.current_world].levels.size() - 1)
				get_tree().change_scene_to_packed(GameValues.worlds[GameValues.current_world].levels[GameValues.current_level])
				print("Moved to World " + str(GameValues.current_world) + ", Level " + str(GameValues.current_level))
		GameValues.save_game_values()
		GameValues.save_profile(GameValues.current_profile, PlayerValues)

func verify_save_directory(path: String):
	DirAccess.make_dir_absolute(path)
	
func load_game_values():
	var game_values = ResourceLoader.load("user://saves/GameData.tres")
	unlocked_profiles = game_values.unlocked_profiles
	profile_names = game_values.profile_names

func save_game_values():
	print('save game values')
	var game_data = GameData.new()
	game_data.current_profile_edit = GameValues.current_profile_edit
	game_data.current_profile = GameValues.current_profile
	game_data.unlocked_profiles = GameValues.unlocked_profiles
	game_data.profile_names = GameValues.profile_names
	
	GameValues.verify_save_directory("user://saves/")
	ResourceSaver.save(game_data, "user://saves/GameData.tres")
	game_data = ResourceLoader.load("user://saves/GameData.tres")
	
func save_profile(profile, player_data):
	if profile:
		print("Saving profile: " + str(profile))
		var new_profile = Profile.new()
		new_profile.player_data = player_data
		new_profile.world = current_world
		new_profile.level = current_level
		
		GameValues.verify_save_directory(new_profile.save_file_path)
		
		match profile:
			1:
				ResourceSaver.save(new_profile, new_profile.save_file_path + "profile_one.tres")
			2:
				ResourceSaver.save(new_profile, new_profile.save_file_path + "profile_two.tres")
			3:
				ResourceSaver.save(new_profile, new_profile.save_file_path + "profile_three.tres")
			
func load_profile(profile):
	var load_profile: Resource
	match profile:
		1:
			load_profile = ResourceLoader.load("user://saves/profile_one.tres")
		2:
			load_profile = ResourceLoader.load("user://saves/profile_two.tres")
		3:
			load_profile = ResourceLoader.load("user://saves/profile_three.tres")
	
	if load_profile:
		current_profile = profile
		PlayerValues.player_data.position = load_profile.player_data.position
		PlayerValues.player_data.health = load_profile.player_data.health
		PlayerValues.player_data.strength = load_profile.player_data.strength # multiplier * damage of weapon
		
		PlayerValues.player_data.current_attack = load_profile.player_data.current_attack
		PlayerValues.player_data.melee_weapon = load_profile.player_data.melee_weapon # by melee weapon id, found in WeaponStats.gd
		PlayerValues.player_data.ranged_weapon = load_profile.player_data.ranged_weapon 
		
		get_tree().change_scene_to_packed(GameValues.worlds[load_profile.world].levels[load_profile.level])
	

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_game_values()
		save_profile(GameValues.current_profile, PlayerValues.player_data)
