extends Control

@export var town_name := ""
@export var res_type_high := 0
@export var res_type_low := 0
@export var portuguese := false
signal clicked()

func _ready():
	$VBoxContainer/TownName.text = town_name
	$VBoxContainer/TownName.modulate = Color(1, 0, 0) if !portuguese else Color(1, 0, 1)
	$VBoxContainer/Icon.modulate = Color(1, 0, 0) if !portuguese else Color(1, 0, 1)
	popup(2)

func _process(_delta):
	if Input.is_action_just_pressed("escape"): get_tree().free()

func _on_texture_button_pressed():
	emit_signal("clicked")
	hide_popup()

## Show the popup to start a trade. If type is 0, hides the down. 1, hides the up. 2, show both.
func popup(type := 0):
	$TradeHBox/UpVBox.visible = true if type == 0 or type == 2 else false
	$TradeHBox/DownVBox.visible = true if type == 1 or type == 2 else false
	# Animation
	$TradeHBox.position.y = 20
	$TradeHBox.modulate = Color(1, 1, 1, 1)
	var tween = create_tween()
	tween.tween_property($TradeHBox, "position:y", -40, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)

func hide_popup():
	var tween = create_tween()
	tween.tween_property($TradeHBox, "modulate:a", 0, 0.5)
