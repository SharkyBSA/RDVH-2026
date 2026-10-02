extends Path2D
class_name ExpeditionPath

@export var maritime_path: bool = true
@export var color := Color.WHITE
var line := Line2D.new()

func _ready():
	line.default_color = color
	line.width = 2
	for point in curve.get_baked_points():
		line.add_point(point + position)
	add_child(line)
	anim_line()

func anim_line():
	var tween = create_tween()
	tween.tween_property(line, "default_color:a", 0.15, 1)
	await tween.finished
	var tween2 = create_tween()
	tween2.tween_property(line, "default_color:a", 0.75, 1)
	await tween2.finished
	anim_line()
