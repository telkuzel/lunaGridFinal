class_name Complex
extends Node3D

@export var complexIdx:int
@export var modules:Array

@export var comlex_save:Complex_save

var player: Player
var manager: ModuleManager
var is_plasment = true

func _ready() -> void:
	player = get_node("/root/Game/Player")
	manager = get_node("/root/Game/modulesManager")
	for i in comlex_save.modules:
		modules.append(i.resource.instantiate())
		modules.get(modules.size()-1).complex = complexIdx
		modules.get(modules.size()-1).position = i.position
		modules.get(modules.size()-1).rotation.y = i.rotation
		modules.get(modules.size()-1).set
		modules.get(modules.size()-1).is_plasment = false
		self.add_child(modules.get(modules.size()-1))

func _input(event: InputEvent) -> void:
	var is_can_place = true
	for i in modules:
		is_can_place = i.plasment_accept_visualize() and is_can_place
	if event is InputEventMouseButton and \
		is_can_place and not Input.is_key_pressed(KEY_SHIFT) and \
		Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		is_plasment = false

func _set_position():
	if is_plasment:
		var result = player.raycast()
		if result:
			position = result.position

func _process(delta: float) -> void:
	_set_position()
