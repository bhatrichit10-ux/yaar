extends Control

func restart():
	get_tree().change_scene_to_file("res://Level/tilemap.tscn")

func _on_restart_button_pressed() -> void:
	restart()
