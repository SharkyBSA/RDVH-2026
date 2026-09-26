extends Control

@export var town_name := ""
@export var res_type_high := 0
@export var res_type_low := 0
@export var portuguese := false
signal clicked(display_name, resource)

func _ready():
	$VBoxContainer/TownName.text = town_name
	$VBoxContainer/TownName.modulate = Color(0.7, 0, 0) if !portuguese else Color(0.7, 0, 1)
	$VBoxContainer/Icon.modulate = Color(0.7, 0, 0) if !portuguese else Color(0.7, 0, 1)
	if portuguese: scale = Vector2.ZERO

func _process(_delta):
	if Input.is_action_just_pressed("escape"): get_tree().free()

func _on_texture_button_pressed():
	emit_signal("clicked", town_name, res_type_high)

func display():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

## Show the popup to start a trade. If type is 0, hides the down. 1, hides the up. 2, show both.
func popup(type := 0):
	$TradeHBox/ArrowUp.visible = true if type == 0 else false
	$TradeHBox/ArrowDown.visible = true if type == 1 else false
	# Animation
	$TradeHBox.position.y = 0
	$TradeHBox.modulate.a = 1
	$TradeHBox.show()
	var tween = create_tween()
	tween.tween_property($TradeHBox, "position:y", -80, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)

func hide_popup():
	var tween = create_tween()
	tween.tween_property($TradeHBox, "modulate:a", 0, 0.5)
