class_name Complex
extends Node3D

@export var complexIdx: int
@export var modules: Array = []
@export var infoModuleNames: String
@export var infoModuleImages: CompressedTexture2D
@export var infoModuleDescriptionTexts: String
@export var infoModuleSpecifTexts: String

@export var complex_save: Complex_save

var player: Player
var manager: ModuleManager
var is_placement: bool = true

func _ready() -> void:
	player = get_node("/root/Game/Player")
	manager = get_node("/root/Game/modulesManager")

func spawn_complex(complex_resource: Complex_save) -> void:
	if complex_resource == null:
		printerr("Error: complex_resource is null")
		return
	complex_save = complex_resource
	var center_pos = Vector3.ZERO
	for i in complex_save.modules:
		if i.resource == null:
			printerr("Error: Invalid module resource")
			continue
		var module_inst = load(i.resource).instantiate()
		if not is_instance_valid(module_inst):
			printerr("Error: Failed to instantiate module")
			continue
		modules.append(module_inst)
		var last_module = modules.back()
		last_module.complex = complexIdx
		last_module.position = i.position
		last_module.rotation = i.rotation
		center_pos += i.position
		last_module.is_plasment = false
		add_child(last_module)
	center_pos /= complex_save.modules.size()
	if Global.save_data == null:
		for module in modules:
			module.position -= center_pos
	else:
		for module in modules:
			module.position.y = -2

func _input(event: InputEvent) -> void:
	if not is_placement:
		return
	if Input.is_key_pressed(KEY_ESCAPE) and player.is_plasmet_mode:
		for i in modules:
			i.delete()
		delete()
		player.is_plasmet_mode = false
		return
	var is_can_place: bool = true
	if  event is InputEventMouseButton and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		pass
	for i in modules:
		is_can_place = i.plasment_accept_visualize() and is_can_place
	if event is InputEventMouseButton and \
		is_can_place and not Input.is_key_pressed(KEY_SHIFT) and \
		Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and is_placement:
		is_placement = false
		player.is_plasmet_mode = false
		for module in modules:
			module.clear_outline()

func _set_position():
	if is_placement:
		var result = player.raycast()
		if result:
			position = result.position
	if Input.is_key_pressed(KEY_R) and is_placement:
		rotation.y += 0.1

func _process(delta: float) -> void:
	_set_position()

func delete():
	manager.complexes.erase(self)
	self.queue_free()
