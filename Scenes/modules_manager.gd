class_name ModuleManager
extends Node3D
@export var plasment_error = ""

@export var modules = Array()

@export var complexes = Array()
var complex_idx = -1

@export var distances = Array()

func is_distance_valid(type: int, module: Placeable, exclude: int) -> bool:
	if type <= distances.size():
		for i in modules:
			i.clear_outline()
		for i in modules:
			if i.type != exclude and i.type != type:
				if (i.position - module.position).length() < \
					distances[type - 1][i.type - 1]:
					i.set_alert()
					return false
	return true

func regisrate_complex(module: Connectabel)->int:
	complex_idx += 1
	var complex = Complex.new()
	complex.complexIdx = complex_idx
	complexes.append(complex)
	complex.modules.append(module)
	return complex_idx

func regisrate_module(module: Connectabel, complex_idx: int)->int:
	for complex in complexes:
		if complex.complexIdx == complex_idx:
			complex.modules.append(module)
	return complex_idx
