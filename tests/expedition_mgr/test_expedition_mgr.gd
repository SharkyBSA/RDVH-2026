extends Control

@onready var next_turn_btn: Button = %next_turn
@onready var expedition_mgr: ExpeditionManager = %ExpeditionMgr
var current_turn = 0

func _ready() -> void:
	next_turn_btn.pressed.connect(next_turn)
	
	var expedition1:=Expedition.new()
	var expedition2:=Expedition.new()
	
	expedition1.success_duration=2
	expedition2.success_duration=3
	expedition1.start_turn=0
	expedition2.start_turn=0
	expedition1.current_turn=0
	expedition2.current_turn=0
	expedition1.fail_risk=0
	expedition2.fail_risk=1
	expedition1.destination=0
	expedition2.destination=1
	expedition1.delta_res={0:5,2:3,1:1}
	expedition2.delta_res={1:9,3:2.3}
	
	expedition1.draw_fail()
	expedition2.draw_fail()
	print("Expedition 1 succeed:",expedition1.will_succeed)
	print("Expedition 2 succeed:",expedition2.will_succeed)
	print("Fail duraiton: ", expedition2._real_duration)
	expedition_mgr.add_expedition(expedition2)
	expedition_mgr.add_expedition(expedition1)
	expedition_mgr.update_expeditions(0)

func next_turn()->void:
	current_turn+=1
	print(expedition_mgr.update_expeditions(current_turn))
	print(expedition_mgr._ongoing_expeditions.size())
