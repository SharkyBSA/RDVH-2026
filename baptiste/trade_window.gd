extends Control

var trade_amount := 0:
	set(value):
		trade_amount = value
		%CostLabel.text = "Coût de l'expédition : %d" % [turn * 5 + value * 3 + guard_amount * 2]
var guard_amount := 0:
	set(value):
		guard_amount = value
		%CostLabel.text = "Coût de l'expédition : %d" % [turn * 5 + trade_amount * 3 + value * 2]
var min_guard := 0
var res_strings : Array = ["poivre"]
var threat := 0
var turn := 0

func _ready():
	for town in %TownManager.get_children():
		town.clicked.connect(popup)

## Shows the trade window
func popup(town_name : String, res_type : int, res_amount : int, threat_level : int, transport_turn := 1):
	# Animation
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(self, "anchor_top", 0.1, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "anchor_bottom", 0.9, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	
	# Setups all base values
	$VBoxContainer/Title.text = "Lancement d'expédition vers %s" % town_name
	trade_amount = 0
	%TradeLabel.text = "0"
	%LabelShipping.text = "Cargo 0"
	%TradeProgressBar.max_value = res_amount
	%TradeProgressBar.value = 0
	%LabelStock.text = "%d de %s\n à vendre" % [res_amount, res_strings[res_type]]
	
	guard_amount = min_guard
	%GuardLabel.text = str(min_guard)
	%GuardProgressBar.value = threat_level
	threat = threat_level
	turn = transport_turn
	
	%CostLabel.text = "Coût de l'expédition : %d" % [turn * 5]
	%DurationLabel.text = "Durée de l'expédition : %d %s" % [turn, "tour" if turn <= 1 else "tours"]
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
	var new_amount = trade_amount * 2
	%LabelShipping.text = "Cargo %d" % new_amount
	%TradeProgressBar.value = new_amount
	%TradeButtonAdd.disabled = true if %TradeProgressBar.value >= %TradeProgressBar.max_value else false

func _on_button_guard_pressed(amount : int):
	guard_amount += amount
	%GuardButtonSubtract.disabled = false if guard_amount > min_guard else true
	%GuardLabel.text = str(guard_amount)
	threat += -amount * 5
	%GuardProgressBar.value = threat
	%GuardButtonAdd.disabled = true if %GuardProgressBar.value <= 0 else false
