extends Control

@onready var new_game_button = $CenterContainer/VBoxContainer/NewGameButton
@onready var profile_one_button = $CenterContainer/VBoxContainer/ProfileOneButton
@onready var profile_two_button = $CenterContainer/VBoxContainer/ProfileTwoButton
@onready var profile_three_button = $CenterContainer/VBoxContainer/ProfileThreeButton

var game_data

func _ready():
	profile_one_button.text = GameValues.profile_names[0]
	profile_two_button.text = GameValues.profile_names[1]
	profile_three_button.text = GameValues.profile_names[2]
	
	if GameValues.unlocked_profiles[0]:
		profile_one_button.disabled = false
	if GameValues.unlocked_profiles[1]:
		profile_two_button.disabled = false
	if GameValues.unlocked_profiles[2]:
		profile_three_button.disabled = false
	
	if GameValues.unlocked_profiles[2]:
		new_game_button.disabled = true
	
									#   1      2      3
func _on_new_game_button_pressed(): # false, false, false	
	if GameValues.unlocked_profiles[1]:
		GameValues.current_profile_edit = 3
	elif GameValues.unlocked_profiles[0]:
		GameValues.current_profile_edit = 2
	else:
		GameValues.current_profile_edit = 1
		
	get_tree().change_scene_to_file("res://UI/new_profile.tscn")


func _on_profile_one_button_pressed():
	GameValues.load_profile(1)

func _on_profile_two_button_pressed():
	GameValues.load_profile(2)

func _on_profile_three_button_pressed():
	GameValues.load_profile(3)
