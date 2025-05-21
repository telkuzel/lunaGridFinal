class_name Player
extends CharacterBody3D

const RAY_LENGTH = 300

@export var speed = 14
@export var mouse_sencetevity = 0.002
@export var min_zoom = 5
@export var max_zoom = 100
@export var min_rot = -80
@export var max_rot = 0

var is_plasmet_mode = false

var target_velocity = Vector3.ZERO
@export var cursoir_position = Vector3.ZERO

func _input(event):
	camera_move(event)



func _physics_process(delta: float):
	var vel = Input.get_vector("move_left", "move_right", \
		"move_forward", "move_backward")
	if vel != Vector2.ZERO:
		var aim = get_global_transform().basis
		target_velocity = aim.z*vel.y + aim.x*vel.x 

		target_velocity *= speed * 1.2
	velocity = target_velocity
	move_and_slide()

func _process(delta: float) -> void:
	if not Input.is_key_pressed(KEY_SHIFT):
		var result = raycast()
		if result:
			cursoir_position = result.position

func set_plasment_mode(flag: bool):
	is_plasmet_mode = flag

func get_plasment_mode() -> bool:
	return is_plasmet_mode

func camera_move(event: InputEvent):
	#camera zoom
	if event is InputEventMouseButton:
		var dir = 0
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			dir = -1
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			dir = 1
		var cam_pivot_dir = \
		$Pivot.position.direction_to($Pivot/Camera3D.position)
		if $Pivot/Camera3D.position.length() <= min_zoom and dir == -1 or \
			$Pivot/Camera3D.position.length() >= max_zoom and dir == 1:
			return
		cam_pivot_dir *= dir
		cam_pivot_dir = cam_pivot_dir.normalized()
		$Pivot/Camera3D.position += cam_pivot_dir
	#camera rotation
	if not Input.is_key_pressed(KEY_SHIFT):
		target_velocity = Vector3.ZERO
		return
	if event is InputEventMouseMotion and \
		Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		rotate_y(-event.relative.x * mouse_sencetevity)
		$Pivot.rotate_x(-event.relative.y * mouse_sencetevity)
		$Pivot.rotation.x = \
			clampf($Pivot.rotation.x , deg_to_rad(min_rot), deg_to_rad(max_rot))
	#camera movement
	if event is InputEventMouseMotion and \
		Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var input = Vector2(-event.relative.x * mouse_sencetevity * 100, \
			-event.relative.y * mouse_sencetevity * 100) 
		var movement_dir = transform.basis * Vector3(input.x, 0, input.y)
		target_velocity = movement_dir * speed
		target_velocity.normalized()
	else:
		target_velocity = Vector3.ZERO
	

# calc position under cursoir
func raycast() -> Dictionary:
	var from = \
		$Pivot/Camera3D.project_ray_origin(get_viewport().get_mouse_position())
	var to = from + \
		$Pivot/Camera3D.project_ray_normal(get_viewport().get_mouse_position())\
		* RAY_LENGTH
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, \
		to, get_collision_mask_value(1))
	var result = space_state.intersect_ray(query)
	return result

func raycast_layer(collision_mask: int, module: Placeable) -> Dictionary:
	var from = \
		$Pivot/Camera3D.project_ray_origin(get_viewport().get_mouse_position())
	var to = from + $Pivot/Camera3D.project_ray_normal(\
		get_viewport().get_mouse_position()) * RAY_LENGTH
	var space_state = get_world_3d().direct_space_state
	var query
	if !module:
		query = PhysicsRayQueryParameters3D.create(from, to,collision_mask)
	else:
		query = PhysicsRayQueryParameters3D.create(from, to,\
			collision_mask, [module])
	var result = space_state.intersect_ray(query)
	return result
