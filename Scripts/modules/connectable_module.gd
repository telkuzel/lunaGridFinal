class_name Connectabel
extends Placeable

@export var connections = Array([], TYPE_NODE_PATH, "", null)
@export var complex:int

var current_connection = 0
var other_module: Connectabel
var other_connection

func _ready() -> void:
	super._ready()
	#for i in range(0, connections.size()):
	#	connections_free.append(true)

func try_place(event):
	var exclude = -1
	if other_module:
		exclude = other_module.type
	if event is InputEventMouseButton \
		and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and \
		_is_can_place() and not Input.is_key_pressed(KEY_SHIFT) and \
		manager.is_distance_valid(type, self, exclude):
		is_plasment = false
		player.set_plasment_mode(false)
		mesh.hide()
		manager.modules.append(self)
		register_in_complex(other_module)
		if other_module:
			var con1 = get_connection(current_connection)
			var con2 = other_module.get_connection(other_connection)
			con1.connect_module(con2)
			con2.connect_module(con1)
	if Input.is_key_pressed(KEY_R) and other_module != null:
		current_connection += 1
		if current_connection >= connections.size():
			current_connection = 0;
	elif Input.is_key_pressed(KEY_R):
		rotation.y += 0.1

func _process(delta: float) -> void:
	super._process(delta)
	if not is_plasment:
		return
	var connect_raycast = player.raycast_layer(2, self)
	if connect_raycast:
			connection(connect_raycast)
	else:
		other_module = null
		other_connection = null
		
func delete():
	disconnect_module()
	super.delete()

func get_connection(idx: int) -> Connection:
	return get_node(connections[idx])

func start_plasment():
	super.start_plasment()
	disconnect_module()

func disconnect_module():
	for i in range(0, connections.size()):
		get_connection(i).disconnect_module()

func register_in_complex(module: Connectabel):
	if module:
		complex = manager.regisrate_module(self, module.complex)
	else:
		manager.regisrate_complex(self)
		

func get_nearest_connection(pos: Vector3) -> int:
	var minimum = 1000
	var con = -1
	for i in range(0, connections.size()):
		var cur_con = get_node(connections[i])
		if not cur_con.is_buisy:
			var len = (pos - to_global(cur_con.position)) \
				.length()
			if minimum > len:
				minimum = len
				con = i
	return con

func connection(raycast_result):
	if not raycast_result.collider is Connectabel:
		return
	var module: Connectabel = raycast_result.collider
	other_module = module
	other_connection = module.get_nearest_connection(raycast_result.position)
	if other_connection == -1:
		return
	rotation = module.get_connection(other_connection).global_rotation
	position = module.get_connection(other_connection).global_position
	var angle = get_connection(current_connection).rotation.y
	if angle <= 0:
		angle -= PI
	rotate(Vector3.UP, angle)
	position += (position - get_connection(current_connection).global_position)

func plasment_accept_visualize():	
	var material
	var exclude = -1
	if other_module:
		exclude = other_module.type
	var is_can_place = false
	if _is_can_place() and manager.is_distance_valid(type, self, exclude):
		mesh.material_override = material_sucsess
		is_can_place = true
	else: 
		mesh.material_override = material_deny
	send_plasment_error()
	return is_can_place
