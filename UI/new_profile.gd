extends Control

@onready var profile_name_edit = %ProfileNameEdit
@onready var submit_button = %SubmitButton
@onready var create_button = %CreateButton

func _ready():
	create_button.visible = false
	match GameValues.current_profile_edit:
		1:
			profile_name_edit.placeholder_text = "Profile 1"
		2:
			profile_name_edit.placeholder_text = "Profile 2"
		3:
			profile_name_edit.placeholder_text = "Profile 3"


func _on_profile_name_edit_text_submitted(new_text):
	submit_profile_name(new_text)

func _on_submit_button_pressed():
	submit_profile_name(profile_name_edit.text)
	submit_button.release_focus()
	submit_button.text = "Rename"

func submit_profile_name(profile_name):
	match GameValues.current_profile_edit:
		1:
			GameValues.profile_names[0] = profile_name
		2:
			GameValues.profile_names[1] = profile_name
		3:
			GameValues.profile_names[2] = profile_name
	
	create_button.visible = true
	create_button.text = "Create Profile \"" + profile_name + "\""

func _on_create_button_pressed():
	GameValues.current_profile = GameValues.current_profile_edit
	match GameValues.current_profile:
		1:
			GameValues.unlocked_profiles[0] = true
		2:
			GameValues.unlocked_profiles[1] = true
		3:
			GameValues.unlocked_profiles[2] = true
			
	GameValues.save_profile(GameValues.current_profile, PlayerValues)
	GameValues.save_game_values()

	GameValues.save_profile(GameValues.current_profile, PlayerValues)

	GameValues.current_world = 0 # tutorial world
	GameValues.current_level = 0
	get_tree().change_scene_to_packed(GameValues.worlds[0].levels[0])
