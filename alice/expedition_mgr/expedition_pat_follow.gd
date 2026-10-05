extends PathFollow2D
class_name ExpeditionToken

enum State {ALIVE,SINKING}

@export_category("Parametres, tu peux toucher")
@export var sprite_alive : Texture2D
@export var sprite_sink : Texture2D
@export var fail_text : String = "Expedition perdue !"
@export var fail_theme : Theme = Theme.new()
@export_category("Nodes, pas toucher")
@export var sprite : Sprite2D
@export var tooltip_detection_area : Area2D

const SPEED : float = 0.35

var move_tween : Tween
var expedition_progress : float = 0.0
var state : State = State.ALIVE

const TOOLTIP_CHECK_PERIOD : float = 0.2
var hovered_by_mouse := false 

signal requet_tooltip(me : ExpeditionToken)

func _init() -> void:
	rotates=false

func _ready() -> void:
	if sprite == null:
		sprite = get_child(0)
	
	_check_has_hovered_state_changed()

#Verifie la position de la souris pour savoir si elle est dans ou hors du cadre
#Marche mieux que d'utiliser les signaux mouse_entered et mouse_exited
func _check_has_hovered_state_changed()-> void:
	var shape_rect : RectangleShape2D = tooltip_detection_area.get_child(0).shape
	if not hovered_by_mouse:
		hovered_by_mouse = shape_rect.get_rect().has_point(get_local_mouse_position())
		if hovered_by_mouse:
			requet_tooltip.emit(self)
	else:
		hovered_by_mouse = shape_rect.get_rect().has_point(get_local_mouse_position())
		if not hovered_by_mouse:
			for child in get_children():
				if child is ExpeditionTooltip:
					remove_child(child)

	get_tree().create_timer(TOOLTIP_CHECK_PERIOD).timeout.connect(_check_has_hovered_state_changed)

func set_progess(prog_val: float):
	if state==State.SINKING:
		return
		
	if move_tween != null:
		move_tween.kill()
	
	move_tween = create_tween()
	var duration = abs(expedition_progress-prog_val)/SPEED
	move_tween.tween_method(_compute_progress,expedition_progress,prog_val,duration)

func _compute_progress(prog_val: float)->void:
	expedition_progress = prog_val
	if prog_val<0.5:
		progress_ratio=prog_val*2.0
	else:
		progress_ratio=2-prog_val*2.0 #Je jure que mes maths sont bonnes, niveau college

func start_sink()->void:
	state =State.SINKING
	if move_tween != null && move_tween.is_valid():
		await move_tween.finished
	sprite.texture = sprite_sink
	var fail_lbl := Label.new()
	fail_lbl.text=fail_text
	add_child(fail_lbl)
	fail_lbl.theme= fail_theme
	fail_lbl.global_position=global_position
	fail_lbl.position.x-=fail_lbl.size.x/2.0

	var fail_tween := create_tween()
	fail_tween.set_parallel()
	fail_tween.tween_property(fail_lbl,"position:y",-200,2.5)
	fail_tween.tween_property(fail_lbl,"modulate:a",0,1.5)
	fail_tween.finished.connect(fail_lbl.queue_free)

func kill()->void:
	
	if move_tween != null && move_tween.is_valid():
		await move_tween.finished
		
	var tween:= create_tween()
	tween.tween_property(self,"modulate:a",0.0,0.5)
	await tween.finished
	get_parent().hide()
	queue_free()
