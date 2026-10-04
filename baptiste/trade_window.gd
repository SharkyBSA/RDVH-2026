extends Control
class_name TradeWindow

var merch_type : Merchandise.Type
var trade_amount := 0:
	set(value):
		trade_amount = value
		update_cost()
		
var guard_amount := 0:
	set(value):
		guard_amount = value
		update_cost()
		
var min_guard := 0
var res_strings : Array = ["", "unités de poivre", "unités de soie", "unités d'ivoire", "unités de coton",\
	"", "unités d'épice", "animaux", ""]
var threat := 0
var turn := 0
var destination : int = 0
var cost := 0
var buy := false
var merc := 0
var town : Town
var price_modifier : float
signal launch_expedition(expedition: Expedition)

func _ready():
	for town : Town in %TownManager.get_children():
		town.clicked.connect(popup)

func update_cost()->void:
	var turn_cost := 0
	var unit_size := 0
	match town.transport_mode:
		0:
			turn_cost = 5
			unit_size = 20
		1:
			turn_cost = 17
			unit_size = 60
		2:
			turn_cost = 30
			unit_size = 100
	cost = trade_amount * Merchandise.prices.get(merc) * price_modifier + \
		ceil(float(trade_amount) / unit_size) * turn_cost * turn + guard_amount * turn if buy else\
		ceil(float(trade_amount) / unit_size) * turn_cost * turn + guard_amount * turn
	
	%CostLabel.text = "Coût de l'expédition : "+str(cost)
	%GainLabel.text = "Argent remporté : " + str(int(trade_amount * Merchandise.prices[merc] * price_modifier))
	
## Shows the trade window
func popup(trade_town : Town, town_offer : TownOffer, transport_turn := 1):
	town = trade_town
	$TradeBox/HBoxContainer/VBoxContainer/TextureRect.texture = load("res://assets/transport/boat.png") \
		if town.transport_mode else load("res://assets/Trading_interface/Chariot_V1.png")
	# Animation
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(self, "anchor_top", 0.1, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "anchor_bottom", 0.9, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	
	# Setups all base values
	$Title.text = "Lancement d'expédition vers %s" % town.town_name
	trade_amount = 0
	%TradeLabel.text = "0"
	%LabelShipping.text = "\nCargo 0"
	%TradeProgressBar.max_value = town_offer.amount
	%TradeProgressBar.value = 0
	%LabelStock.text = "%d %s %s" % [town_offer.amount, Merchandise.names.get(town_offer.merchadise),\
		"à vendre" if town_offer.is_buying else "à acheter"]
	
	guard_amount = town_offer.min_gards
	min_guard = town_offer.min_gards
	%GuardLabel.text = str(min_guard)
	%GuardProgressBar.value = town_offer.threat_level
	threat = town_offer.threat_level
	turn = transport_turn
	destination=town_offer.town
	price_modifier=town_offer.price_modifier
	%PercentLabel.text = "\n%d%%" % [($%GuardProgressBar.value / 100) * 100]
	%GuardButtonAdd.disabled = true if %GuardProgressBar.value <= 0 else false
	%GuardButtonAdd.modulate = Color(0.6, 0.6, 0.6) if %GuardButtonAdd.disabled else Color.WHITE
	
	%CostLabel.text = "Coût de l'expédition : 0"
	%DurationLabel.text = "Durée de l'expédition : %d %s" % [turn, "tour" if turn <= 1 else "tours"]
	
	buy = !town_offer.is_buying
	
	_on_button_guard_pressed(0)
	_on_button_trade_pressed(0)
	
	%GainLabel.visible = !buy
	
	merc = town_offer.merchadise
# Hide the window
func disapear()->void:
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(self, "anchor_top", 1.1, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "anchor_bottom", 1.9, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

# Closes the windw
func _on_exit_button_pressed():
	disapear()
	
# Adds or substract "amount" to the amount of resource
func _on_button_trade_pressed(amount : int):
	trade_amount += amount
	%TradeButtonSubtract.disabled = false if trade_amount >= 1 else true
	%TradeButtonSubtract.modulate = Color(0.6, 0.6, 0.6) if %TradeButtonSubtract.disabled else Color.WHITE
	%TradeLabel.text = str(trade_amount)
	var new_amount = trade_amount
	if new_amount > %TradeProgressBar.max_value: new_amount = %TradeProgressBar.max_value
	%LabelShipping.text = "\nCargo %d" % new_amount
	%TradeProgressBar.value = new_amount
	%TradeButtonAdd.disabled = true if %TradeProgressBar.value >= %TradeProgressBar.max_value else false
	%TradeButtonAdd.modulate = Color(0.6, 0.6, 0.6) if %TradeButtonAdd.disabled else Color.WHITE
	
	check_legality()

func _on_button_guard_pressed(amount : int):
	guard_amount += amount
	%GuardButtonSubtract.disabled = false if guard_amount > min_guard else true
	%GuardButtonSubtract.modulate = Color(0.6, 0.6, 0.6) if %GuardButtonSubtract.disabled else Color.WHITE
	%GuardLabel.text = str(guard_amount)
	threat += -amount * 5
	%GuardProgressBar.value = threat
	%GuardButtonAdd.disabled = true if %GuardProgressBar.value <= 0 else false
	%GuardButtonAdd.modulate = Color(0.6, 0.6, 0.6) if %GuardButtonAdd.disabled else Color.WHITE
	%PercentLabel.text = "\n%d%%" % [($%GuardProgressBar.value / 100) * 100]
	
	check_legality()

# Checks if enough gold or resources to trade. Min 1 trade cart/boat to trade.
func check_legality():
	if trade_amount == 0 or cost > %Player.get_resource_amount(0) or !buy and trade_amount > %Player.get_resource_amount(merc):
		%LaunchExpedition.disabled = true
		%LaunchExpedition.modulate = Color(0.6, 0.6, 0.6)
	else:
		%LaunchExpedition.disabled = false
		%LaunchExpedition.modulate = Color.WHITE

func _on_launch_expedition_pressed() -> void:
	%Player.modify_inventory(Merchandise.Type.GOLD, -cost)
	if !buy: %Player.modify_inventory(merc, -trade_amount)
	var expedition := Expedition.new() 
	expedition.fail_risk=threat/100.0
	expedition.destination=destination
	if buy:
		expedition.delta_res[merc] = trade_amount
	else:
		expedition.delta_res[Merchandise.Type.GOLD]= int(trade_amount * Merchandise.prices[merc] * price_modifier)
	expedition.success_duration = turn
	expedition.draw_fail()
	launch_expedition.emit(expedition)
	disapear()
