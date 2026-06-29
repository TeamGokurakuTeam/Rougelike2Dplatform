extends Control
class_name RiskReturnUI

@onready var back_ground: Panel = $BackGround
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var player : Player
var risk_ids : Array[String]
var parent : MainGame

signal risk_selected(id : String)

func _ready() -> void:
	for node in back_ground.get_children():
		var panel : RiskReturnPanel = node as RiskReturnPanel
		var picked_gain_id = GlobalResourceLoader.gain_cache.keys().pick_random()
		var picked_loss_id = GlobalResourceLoader.loss_cache.keys().pick_random()
		risk_ids.append(picked_loss_id)
		panel.setup(picked_gain_id, picked_loss_id)
		panel.risk_return_selected.connect(_on_risk_return_selected)
	animation_player.play("Ready")

func _on_risk_return_selected(gain_resource_id : String, loss_resource_id : String) -> void:
	player = get_tree().get_first_node_in_group("Player")
	var weapon : Weapon = player.weapon
	var id : String = player.mod_resource_ids.pick_random()
	weapon.decrease_modifier(id)
	weapon.add_lock_modifier(id)
	print(loss_resource_id)
	risk_selected.emit(loss_resource_id)
	animation_player.play("End")
