extends HBoxContainer

@export var curent_module: Placeable
var player: Player

func _ready() -> void:
	player = get_node("/root/Game/Player")
	$replace.pressed.connect(on_replace_presed)
	$cansel.pressed.connect(on_cansel_presed)
	$delete.pressed.connect(on_delete_pressed)
	
func on_replace_presed():
	curent_module.start_plasment()
	visible = false
	
func on_cansel_presed():
	visible = false
	curent_module.deselect()
	
func on_delete_pressed():
	visible = false
	curent_module.delete()
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and !$replace.pressed:
		visible = false
