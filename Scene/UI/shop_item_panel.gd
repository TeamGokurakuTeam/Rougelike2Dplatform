@tool

extends Button
class_name ShopItemPanel

@onready var clicked: Panel = $Clicked
@onready var item_sprite: TextureRect = $Panel/ItemSprite
@onready var lock: Panel = $Lock

@export var resource : Resource

var index : int = -1

signal shop_item_panel_clicked(index : int)

@export var is_lock : bool = false :
	set(value):
		is_lock = value
		lock.visible = value

func _ready() -> void:
	clicked.visible = false

func setup(res : Resource) -> void:
	if res:
		resource = res
		if res is ResourceItem:
			item_sprite.texture = res.Sprite
		if res is ModifierResource:
			item_sprite.texture = res.texture
		if res is HealItemRes:
			item_sprite.texture = res.texture

func _on_pressed() -> void:
	shop_item_panel_clicked.emit(index)
	clicked.visible = true
