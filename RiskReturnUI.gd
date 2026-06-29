extends Control
class_name RiskReturnUI

@onready var back_ground: Panel = $BackGround
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var player : Player
var risk_ids : Array[String]

signal on_risk_selected(id : String)

func _ready() -> void:
	for node in back_ground.get_children():
		var panel : RiskReturnPanel = node as RiskReturnPanel
		var picked_id = GlobalResourceLoader.obelisk_cache.keys().pick_random()
		risk_ids.append(picked_id)
		panel.setup("FixedModifier", picked_id)
		panel.risk_return_selected.connect(_on_risk_return_selected)
	animation_player.play("Ready")

func _on_risk_return_selected(gain_resource_id : String, loss_resource_id : String) -> void:
	player = get_tree().get_first_node_in_group("Player")
	var weapon : Weapon = player.weapon
	var id : String = player.mod_resource_ids.pick_random()
	weapon.decrease_modifier(id)
	weapon.add_lock_modifier(id)
	print(loss_resource_id)
	on_risk_selected.emit(loss_resource_id)
	animation_player.play("End")
