extends Control
class_name EventWindow

@onready var text_lbl: Label = %TextLbl
@onready var exit_btn: TextureButton = %ExitBtn

func _ready() -> void:
	hide()
	exit_btn.pressed.connect(disappear)

func set_text(text : String)->void:
	text_lbl.text=text

func appear()->void:
	show()
	
func disappear()->void:
	hide()
