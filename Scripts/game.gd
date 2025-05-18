extends Node3D
class_name GameScript

@export var curentSceneIndex: int

func _ready():
	# Ждем, пока все узлы добавятся в дерево
	await get_tree().process_frame
	
	var player = $Player
	var main_ui = $Main
	var ground = $StaticBody3D/MeshInstance3D2
	var modulesManager = $modulesManager
	
	var camera_pivot = player.get_node("Pivot")
	
	var Errors = main_ui.get_node(
		"VBoxContainer/BotomBar/Botombar/HBoxContainer/Errors"
	)
	
	# Передаем ссылку
	Errors.moduleM = modulesManager
	main_ui.grounMesh = ground
	main_ui.camera_pivot = camera_pivot
