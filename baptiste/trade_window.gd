extends Control

var trade_amount := 0
var guard_amount := 0

func _ready():
	for town in %TownManager.get_children():
		town.clicked.connect(popup)

## Shows the trade window
func popup(town_name : String, res : int):
	# Animation
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(self, "anchor_top", 0.1, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "anchor_bottom", 0.9, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	
	# Setups all base values
	$VBoxContainer/Title.text = "Lancement d'expédition vers %s" % town_name
	trade_amount = 0
	%TradeLabel.text = "0"
	

# Closes the windw
func _on_exit_button_pressed():
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(self, "anchor_top", 1.1, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "anchor_bottom", 1.9, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

# Adds or substract "amount" to the amount of resource
func _on_button_trade_pressed(amount : int):
	trade_amount += amount
	%TradeButtonSubtract.disabled = false if trade_amount >= 1 else true
	%TradeLabel.text = str(trade_amount)
