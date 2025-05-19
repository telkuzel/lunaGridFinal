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

#func make_project_save()->Prj_save:
	#var prj_save = Prj_save.new()
	#for complex in manager.complexes:
		#var save = Complex_save.new()
		#for module in complex.modules:
			#var module_s = Module_save.new()
			#module_s.position = module.position
			#module_s.rotation = module.rotation.y
			#module_s.resource = module.resource
			#save.modules.append(module_s)
		#prj_save.complexes.append(save)
	#for module in manager.modules:
		#if not module is Connectabel:
			#var module_s = Module_save.new()
			#module_s.position = module.position
			#module_s.rotation = module.rotation.y
			#module_s.resource = module.resource
			#prj_save.modules.append(module_s)
	#return prj_save
#
#var complex_scene
##root = get_node("/root/Game")
#func spawn_prj(prj_save: Prj_save):
	#for complex in prj_save.complexes:
		#var comp = complex_scene.instantiate()
		#root.add_child(comp)
		#comp.spavn_complex(complex)
		#comp.is_plasment = false
	#for module in prj_save.modules:
		#var mod = module.resource.instantiate()
		#root.add_child(mod)
		#mod.position = module.position
		#mod.rotation = module.rotation.y
		#mod.resource = module.resource
		#mod.is_plasment = false
