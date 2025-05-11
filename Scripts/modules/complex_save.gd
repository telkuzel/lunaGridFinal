extends Resource
class_name Complex_save

@export var modules:Array

#func make_save(complex_idx)->Complex_save: #code for save btn
	#var complex
	#var save = Complex_save.new()
	#for i in manager.complexes:
		#if i.complexIdx == complex_idx:
			#complex = i
			#break
	#for module in complex.modules:
		#var module_s = Module_save.new()
		#module_s.position = module.position
		#module_s.rotation = module.rotation.y
		#module_s.resource = module.resource
		#save.modules.append(module_s)
