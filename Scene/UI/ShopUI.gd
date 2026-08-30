extends Control
class_name ShopUI

const SHOP_ITEM_PANEL = preload("uid://dnwva6k65r1i6")

const DROP_ITEM = preload("uid://dy6pxaf7y18u7")
const DROP_HEAL_ITEM = preload("uid://d4cyex0no1ifo")
const DROP_MODIFIER = preload("uid://b47iwp7p6b4wk")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var grid_container: GridContainer = $ShopItemPanel/GridContainer

@onready var item_name: Label = $ExplainPanel/ItemNamePanel/ItemName
@onready var item_sprite: TextureRect = $ExplainPanel/ItemSpritePanel/ItemSprite
@onready var price: Label = $ExplainPanel/ItemSpritePanel/TextureRect/Price
@onready var item_explain: RichTextLabel = $ExplainPanel/ItemExplain
@onready var buy_button: Button = $BuyButton

var npc : MerchantFrog
var current_index : int = -1

func _ready() -> void:
	animation_player.play("Start")
	for i in npc.item_table.item_list.size():
		var shop_item_panel : ShopItemPanel = SHOP_ITEM_PANEL.instantiate()
		var res : Resource = npc.item_table.item_list[i]
		shop_item_panel.shop_item_panel_clicked.connect(_on_shop_item_panel_clicked)
		shop_item_panel.index = i
		grid_container.add_child(shop_item_panel)
		shop_item_panel.resource = res
		if res is ResourceItem:
			shop_item_panel.item_sprite.texture = res.Sprite
		if res is ModifierResource:
			shop_item_panel.item_sprite.texture = res.texture
		if res is HealItemRes:
			shop_item_panel.item_sprite.texture = res.texture
	for i in grid_container.get_child_count():
		var panel : ShopItemPanel = grid_container.get_child(i)
		panel.is_lock = npc.sold_list[i]

func _on_exit_button_pressed() -> void:
	animation_player.play("End")
	GameEvents.shop_ui_closed.emit()

func _on_shop_item_panel_clicked(index : int) -> void:
	var res = npc.item_table.item_list[index]
	if res is ResourceItem:
		item_name.text = res.Name
		item_sprite.texture = res.Sprite
		price.text = str(res.price)
	elif res is ModifierResource:
		item_name.text = res.modifier_name
		item_sprite.texture = res.texture
		item_explain.text = res.explanation
		price.text = str(res.price)
	elif res is HealItemRes:
		item_name.text = res.name
		item_sprite.texture = res.texture
		item_explain.text = res.explanation
		price.text = str(res.price)
	for node in grid_container.get_children():
		var panel : ShopItemPanel = node as ShopItemPanel
		if panel.index != index:
			panel.clicked.visible = false
	current_index = index
	if npc.sold_list[current_index] == true:
		buy_button.disabled = true
	else:
		buy_button.disabled = false

func _on_buy_button_pressed() -> void:
	var player : Player = get_tree().get_first_node_in_group("Player")
	if npc.sold_list[current_index] == false:
		var res : Resource = npc.item_table.item_list[current_index]
		if player != null and player.mod_resource_ids.size() >= res.price:
			for i in res.price:
				var max_value : int = player.mod_resource_ids.size()
				var pick_num : int = randi_range(0, max_value - 1)
				player.mod_resource_ids.remove_at(pick_num)
				player.update_modifier()
			
			npc.sold_list[current_index] = true
			
			if res is HealItemRes:
				var heal_item : DropHealItem = DROP_HEAL_ITEM.instantiate()
				heal_item.item_res = res
				var target_node = npc.room if npc.room != null else get_tree().current_scene
				target_node.add_child(heal_item)
				heal_item.global_position = npc.item_spawn_point.global_position
			elif res is ModifierResource:
				var modifier_item : DropModifier = DROP_MODIFIER.instantiate()
				modifier_item.modifier = res
				var target_node = npc.room if npc.room != null else get_tree().current_scene
				target_node.add_child(modifier_item)
				modifier_item.global_position = npc.item_spawn_point.global_position
			for node in grid_container.get_children():
				var panel : ShopItemPanel = node as ShopItemPanel
				if panel.index == current_index:
					panel.is_lock = true
			buy_button.disabled = true
		else:
			print("player != null :: ", player)
			print("player.mod_resource_ids.size() <= res.price :: ", player.mod_resource_ids.size() <= res.price)
			print("player.mod_resource_ids size :: ", player.mod_resource_ids.size)
