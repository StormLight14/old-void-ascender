extends Resource
class_name GameData

#JUST FOR SAVING VALUES THAT GAMEVALUES.GD HAS

@export var current_profile_edit = 1 # 1, 2, or 3 depending on what profile is getting made in new_profile.tscn
@export var current_profile = 1
@export var unlocked_profiles = [false, false, false]
@export var profile_names = ["Profile 1", "Profile 2", "Profile 3"]
