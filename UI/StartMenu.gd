extends Control

@onready var start_button = %StartButton
@onready var settings_button = %SettingsButton
@onready var quit_button = %QuitButton


func _ready():
	print(OS.get_user_data_dir())
	start_button.grab_focus()
	if FileAccess.file_exists("user://saves/GameData.tres"):
		GameValues.load_game_values()
	else:
		GameValues.save_game_values()

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://UI/profile_select.tscn")
	
func _on_settings_button_pressed():
	get_tree().change_scene_to_file("res://UI/settings.tscn")

func _on_quit_button_pressed():
	get_tree().quit()


func _on_button_container_mouse_entered():
	start_button.release_focus()
	settings_button.release_focus()
	quit_button.release_focus()


