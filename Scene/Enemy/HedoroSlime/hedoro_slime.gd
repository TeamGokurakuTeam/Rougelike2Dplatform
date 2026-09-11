extends Enemy
class_name HedoroSlime

@onready var hitbox: Hitbox = $Hitboxes/Hitbox

var is_player_entered : bool = false
var eat_count : int = 0 : 
	set(value):
		eat_count = value
		hitbox.damage += float(value)

func player_dir() -> float:
	var player : Player = get_tree().get_nodes_in_group("Player")[0]
	navigation_agent.target_position = player.global_position
	if navigation_agent.is_navigation_finished():
		return 0
	var next_pos : Vector2 =  navigation_agent.get_next_path_position()
	var player_dir_x : float = sign(next_pos.x - global_position.x)
	
	return player_dir_x

func modifier_random_delete() -> void:
	if not is_player_entered:
		return
	var player : Player = get_tree().get_nodes_in_group("Player")[0]
	if player.weapon == null:
		return
	var mod_ids : Array = player.weapon.modifiers_ids.keys()
	if mod_ids == null or mod_ids.size() <= 0:
		return
	if player.is_dodgeroll or player.is_just_dodgeroll:
		return
	var picked_mod : String = mod_ids.pick_random()
	player.weapon.modifiers_ids.erase(picked_mod)
	eat_count += 1
