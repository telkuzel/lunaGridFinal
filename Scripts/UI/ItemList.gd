extends ItemList

@onready var moduleInfoPanel = %RightBar
@export var Modules: Array = []


static var is_first_time = true
var hover_enabled: bool = false
var player: Player
var root


func _ready():
	player = get_node("/root/Game/Player")
	root = get_node("/root/Game")


func _draw():
	# Отрисовка каждого элемента
	for i in range(get_item_count()):
		var rect = get_item_rect(i)
		var line_start = Vector2(rect.position.x, rect.position.y + rect.size.y)
		var line_end = Vector2(rect.position.x + rect.size.x, rect.position.y + rect.size.y)
		draw_line(line_start, line_end, Color("#1d1d1d"), 3.0)


func _on_mouse_entered() -> void:
	hover_enabled = true
	if is_first_time:
		is_first_time = false
		%BtnToggleRight.button_pressed = false


func _on_mouse_exited() -> void:
	hover_enabled = false


func _on_item_selected(index: int) -> void:
	# Спавним модуля
	var module = Modules[index]
	if player.get_plasment_mode():
		return
	var inst = module.instantiate()
	update_module_info(inst)
	root.add_child(inst)
	deselect(index)
	$"..".visible = false
	 # Запускаем отслеживание выхода из режима размещения
	_monitor_placement($"..")


# Асинхронная функция, ждущая окончания режима размещения
func _monitor_placement(ObjectItemList) -> void:
	while player.get_plasment_mode():
		await get_tree().process_frame
	# После выхода из режима размещения показываем ItemList
	ObjectItemList.visible = true
		


# В каждом кадре при включённом наведении вычисляем индекс элемента под курсором.
func _process(_delta: float) -> void:
	if not hover_enabled:
		return
	var mouse_pos = get_local_mouse_position()
	var hover_index = get_item_at_position(mouse_pos)
	# Если индекс, над которым навели, допустимый – обновляем панель с информацией
	if hover_index != -1:
		var inst = Modules[hover_index].instantiate()
		update_module_info(inst)
		inst = null
		


func update_module_info(module: Placeable) -> void:
	%ModuleName.text = module.infoModuleNames.replace("\\n", "\n")
	%ModuleImage.texture = module.infoModuleImages
	%ModuleImage.expand = true
	%ModuleDescriptionText.text = module.infoModuleDescriptionTexts.replace("\\n", "\n")
	%ModuleSpecifText.text = module.infoModuleSpecifTexts.replace("\\n", "\n")
