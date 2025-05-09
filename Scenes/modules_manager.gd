class_name ModuleManager
extends Node3D
@export var plasment_error = ""

@export var modules = Array()

@export var distances = Array()

func is_distance_valid(type: int, module: Placeable, exclude: int) -> bool:
	if type <= distances.size():
		for i in modules:
			if i.type != exclude and i.type != type:
				if (i.position - module.position).length() < \
					distances[type - 1][i.type - 1]:
					return false
	return true
