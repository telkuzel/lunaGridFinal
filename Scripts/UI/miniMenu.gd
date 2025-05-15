extends ItemList

@export var moduleIdx: int # Переделать чтобы передавался сам модуль
@export var complexIdx: int  # храниться в самом модуле?

func _ready() -> void:
	var manager = get_node("/root/Game/modulesManager")

func _on_item_selected(index: int) -> void:
	%miniMenu.visible = false
	if index == 0:
		#for () { #поиск по Modules (переделать ItemList чтобы хранил только модули)
			#if () {
				##update_module_info(indexOfMenu) # Из ItemList.gd, но нужно переделать его чтобы передавать сам модуль
				#
			#}
		#}
		%BtnToggleRight.button_pressed = !%BtnToggleRight.button_pressed
	if index == 1:
		print("saved")
		#func make_save(complex_idx)->Complex_save:
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
	deselect(index)


func _on_empty_clicked(at_position: Vector2, mouse_button_index: int) -> void:
	%miniMenu.visible = false
