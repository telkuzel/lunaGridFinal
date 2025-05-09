class_name Connection

extends Node3D

@export var parent: Connectabel
var other_connection: Connection
@export var is_buisy = false

func _ready() -> void:
	parent = get_parent()

func connect_module(connection: Connection):
	is_buisy = true
	other_connection = connection

func disconnect_module():
	is_buisy = false
	var con = other_connection
	other_connection = null
	if con != null:
		con.disconnect_module()
	
