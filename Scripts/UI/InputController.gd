extends Control

var player: Player

func  _ready() -> void:
	player = get_node("/root/Game/Player")

func _input(event: InputEvent) -> void:
	var res = player.raycast()
	if res:
		var posx = res.position.x + 1204
		var posy = res.position.z + 650
		self.text = "x: " + str("%1.3f" % posx) + "   y: " \
		 + str("%1.3f" % posy) + "   z: " + str("%1.3f" % res.position.y) + "     "
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) \
			and not Input.is_key_pressed(KEY_SHIFT): #можно убрать шифт после смены управления
			if (!%miniMenu.isMouseInMiniMenu): %miniMenu.visible = false
			var res2 = player.raycast_layer(2, null)
			if res2:
				var module: Placeable = res2.collider
				if module.is_plasment:
					return
				%RDCButtons.visible = true
				if %RDCButtons.curent_module:
					%RDCButtons.curent_module.deselect()
				%RDCButtons.curent_module = module
				module.select()
				if event is InputEventMouseButton and event.double_click:
					player.position = module.position 
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) \
			and not Input.is_key_pressed(KEY_SHIFT):
				var res3 = player.raycast_layer(2, null)
				if res3:
					var module: Placeable = res3.collider
					%miniMenu.position.x = get_viewport().get_mouse_position().x - 270
					%miniMenu.position.y = get_viewport().get_mouse_position().y - 70
					%miniMenu.visible = true
					%miniMenu.module = module
 
