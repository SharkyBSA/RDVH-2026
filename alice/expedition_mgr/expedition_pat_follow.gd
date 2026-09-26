extends PathFollow2D
class_name ExpeditionPathFollow2D

func _init() -> void:
	rotates=false

func set_progess(prog_val: float):
	if prog_val<0.5:
		progress_ratio=prog_val*2.0
	else:
		progress_ratio=2-prog_val*2.0 #Je jure que mes maths sont bonnes, niveau college

func kill()->void:
	var tween:= create_tween()
	tween.tween_property(self,"modulate:a",0.0,0.5)
	await tween.finished
	queue_free()
