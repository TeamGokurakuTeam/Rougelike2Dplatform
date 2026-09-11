extends Node2D
class_name ComponentHost

@export var _components : Dictionary = {}

func _ready() -> void:
	_load_components()

func _load_components() -> void:
	_components.clear()
	for child in get_children():
		if child is Component:
			var component : Component = child as Component
			if component.component_id == null or component.component_id == "":
				component.component_id = component.get_name()
			_components[component.component_id] = component
			component.setup(self)

func get_component(id : String) -> Component:
	return _components.get(id, null)

func has_component(id : String) -> bool:
	return _components.has(id)
