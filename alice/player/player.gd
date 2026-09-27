extends Node
class_name Player

@export var inventory : Dictionary[int,float] = {}:
	set(value):
		inventory = value
		emit_signal("updated", value)

signal updated(inv)
signal game_over
signal inventory_modified(key : Merchandise.Type, updated_amount : float)

func _ready(): emit_signal("updated", inventory)

# Escape to exit quickly
func _process(_delta):
	if Input.is_action_just_pressed("escape"): get_tree().quit()

##Add (or substract if delta<0) the amount delta to the inventory. resource_key 
##identifies the resource to modify
func modify_inventory(resource_key : int, delta:float) ->void :
	if not inventory.has(resource_key):
		inventory[resource_key] = 0
	
	inventory[resource_key]+=delta
	#resource_key 0 is gold. If no more gold, game over
	if resource_key == 0 and inventory[resource_key] < 0:
		game_over.emit()
		return
	
	inventory[resource_key]= maxf(0.0,inventory[resource_key])
	inventory_modified.emit(resource_key,inventory[resource_key])

##Return the amount of a given ressource. If resource doesnt exist, return -1.0
func get_resource_amount(resource_key : int) -> float:
	if not inventory.has(resource_key):
		return -1.0
	return inventory[resource_key]
	
##Helper function to get the amount of gold the player has. Can also be obtained with 
##get_resource_amount(0)
func get_gold_amount() -> float:
	return get_resource_amount(0)
