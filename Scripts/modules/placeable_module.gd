class_name Placeable
extends StaticBody3D

var player: Player
var is_plasment = true
var manager: ModuleManager

@export var type = 1
@export var resource: String
@export var rayLenght = 0.6
@export var ground_markers = Array([], TYPE_NODE_PATH, "", null)
@export var collision_shape: CollisionShape3D
@export var mesh: MeshInstance3D
@export var material_sucsess: StandardMaterial3D = preload("res://3dModels/material/deny_material.tres")
@export var material_deny: StandardMaterial3D = preload("res://3dModels/material/sucsess_material.tres")
@export var material_select: StandardMaterial3D = preload("res://3dModels/material/select_material.tres")
@export var material_alert: StandardMaterial3D = preload("res://3dModels/material/alert_material.tres")
@export var infoModuleNames: String
@export var infoModuleImages: CompressedTexture2D
@export var infoModuleDescriptionTexts: String
@export var infoModuleSpecifTexts: String

func set_alert():
	mesh.show()
	mesh.material_override = material_alert
	
func clear_outline():
	mesh.hide()

func _ready() -> void:
	player = get_node("/root/Game/Player")
	manager = get_node("/root/Game/modulesManager")
	player.set_plasment_mode(true)

func _process(delta: float) -> void:
	_set_position()
	
func _input(event: InputEvent) -> void:
	if not is_plasment:
		return
	if Input.is_key_pressed(KEY_ESCAPE) and player.is_plasmet_mode:
		delete()
		player.is_plasmet_mode = false
		return
	plasment_accept_visualize()
	try_place(event)

func start_plasment():
	is_plasment = true
	mesh.show()
	manager.modules.erase(self)
	player.set_plasment_mode(true)

func try_place(event: InputEvent):
	if event is InputEventMouseButton and \
		_is_can_place() and not Input.is_key_pressed(KEY_SHIFT) and \
		manager.is_distance_valid(type, self, -1) and \
		Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		is_plasment = false
		player.set_plasment_mode(false);
		mesh.hide()
		manager.modules.append(self)
	if Input.is_key_pressed(KEY_R):
		rotation.y += 0.1	

func delete():
	manager.modules.erase(self)
	self.queue_free()

func select():
	mesh.show()
	mesh.material_override = material_select

func deselect():
	mesh.hide()

func plasment_accept_visualize()->bool:
	var material
	var is_can_place = false
	if _is_can_place() and manager.is_distance_valid(type, self, -1):
		mesh.material_override = material_sucsess
		is_can_place = true
	else: 
		mesh.material_override = material_deny
	send_plasment_error()
	return is_can_place

func send_plasment_error():
	if not _is_can_place():
		manager.plasment_error = "пересечение или неровная поверхность"
		return
	if not manager.is_distance_valid(type, self, -1):
		manager.plasment_error = "слишком близко к другим модулям"
		return
	else:
		manager.plasment_error = ""

func _is_can_place() -> bool:
	return not is_intersect() and is_surafase_flat()

func _set_position():
	if is_plasment:
		var result = player.raycast()
		if result:
			position = result.position

func is_intersect() -> bool:
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsShapeQueryParameters3D.new()
	query.shape = collision_shape.shape
	query.transform = collision_shape.global_transform
	query.exclude = [self, get_child(-1)]
	query.collision_mask = 3
	var collisions = space_state.intersect_shape(query)
	for collision in collisions:
		var collider = collision.collider
		if collider:
			return true
	return false

func is_surafase_flat() -> bool:
	for i in ground_markers:
		var from = get_node(i).global_position
		var to = from
		to.y -= rayLenght
		var space = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(from, to, \
			1)
		var result = space.intersect_ray(query)
		if !result:
			return false
	return true
