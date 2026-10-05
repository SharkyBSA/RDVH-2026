extends PathFollow2D
class_name ExpeditionToken

enum State {ALIVE,SINKING}

const SPEED : float = 0.35
var move_tween : Tween
var expedition_progress : float = 0.0
var state : State = State.ALIVE
	
@export var sprite_alive : Texture2D
@export var sprite_sink : Texture2D

@export var sprite : Sprite2D

func _init() -> void:
	rotates=false

func _ready() -> void:
	if sprite == null:
		sprite = get_child(0)

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
	if move_tween != null:
		await move_tween.finished
	sprite.texture = sprite_sink

func kill()->void:
	if move_tween != null:
		await move_tween.finished
	
	var tween:= create_tween()
	tween.tween_property(self,"modulate:a",0.0,0.5)
	await tween.finished
	get_parent().hide()
	queue_free()
