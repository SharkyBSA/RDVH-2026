extends Control

func _on_play_pressed(): 
	$VBoxContainer/Play/AudioStreamPlayer.play()
	await $VBoxContainer/Play/AudioStreamPlayer.finished
	get_tree().change_scene_to_file("res://baptiste/main.tscn")

func _on_quit_pressed(): 
	$VBoxContainer/Quit/AudioStreamPlayer.play()
	await $VBoxContainer/Quit/AudioStreamPlayer.finished
	get_tree().quit()
