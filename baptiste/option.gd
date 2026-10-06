extends Control

func show_window(): show()

func _on_resume_button_pressed(): hide()

func _on_quit_button_pressed(): get_tree().change_scene_to_file("res://baptiste/menu.tscn")

func _on_music_slider_value_changed(value): Volumes.music_volume = value

func _on_sfx_slider_value_changed(value): Volumes.sfx_volume = value
