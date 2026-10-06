extends Node

signal music_changed(value)
signal sfx_changed(value)

var music_volume := -10.:
	set(value):
		music_volume = value
		emit_signal("music_changed", value)
var sfx_volume := -10:
	set(value):
		sfx_volume = value
		emit_signal("sfx_changed", value)
