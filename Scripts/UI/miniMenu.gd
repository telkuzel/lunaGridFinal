extends ItemList

@export var module: Placeable # Переделать чтобы передавался сам модуль

var manager

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
					ResourceSaver.save(save,"res://Scenes/complexes/test.tscn")
					%ItemListCom.Modules.append(save)
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

func _on_empty_clicked(at_position: Vector2, mouse_button_index: int) -> void:
	%miniMenu.visible = false
