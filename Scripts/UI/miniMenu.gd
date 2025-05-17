extends ItemList

@export var module: Placeable # Переделать чтобы передавался сам модуль

var manager
static var isMouseInMiniMenu = false

func _ready() -> void:
	manager = get_node("/root/Game/modulesManager")

func _on_item_selected(index: int) -> void:
	%miniMenu.visible = false
	if index == 0:
		%ItemListGen.update_module_info(module)
		%BtnToggleRight.button_pressed = false
	if index == 1:
		for complex in manager.complexes:
			for complexModule in complex.modules:
				if (module == complexModule): 
					var save = make_save(complex)
					var file_name = "res://Scenes/complexes/complex_%d.tres" % complex.get_instance_id()
					ResourceSaver.save(save, file_name)
					%ItemListCom.Modules.append(save)
					%ItemListCom.add_item("Complex %d" % %ItemListCom.get_item_count())
					break
	deselect(index)

func make_save(complex)->Complex_save:
	var save = Complex_save.new()
	for module in complex.modules:
		var module_s = Module_save.new()
		module_s.position = module.position
		module_s.rotation = module.rotation.y
		module_s.resource = module.resource
		save.modules.append(module_s)
	return save

func _on_mouse_exited() -> void:
	isMouseInMiniMenu = false
func _on_mouse_entered() -> void:
	isMouseInMiniMenu = true
