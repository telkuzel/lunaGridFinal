extends ItemList

@onready var moduleInfoPanel = %RightBar
@export var ModuleNames: Array = []  
@export var ModuleImages: Array = []  
@export var ModuleDescriptionTexts: Array = [] 
@export var ModuleSpecifTexts: Array = []  
@export var Modules: Array = []


var hover_enabled: bool = false
var is_first_time = true
var player: Player
var root


func _ready():
	player = get_node("/root/Game/Player")
	root = get_node("/root/Game")


func _draw():
	# Отрисовка каждого элемента
	for i in range(get_item_count()):
		var rect = get_item_rect(i)
		## Стиль для нормального состояния (фон)
		#var style = StyleBoxFlat.new()
		#style.bg_color = Color(0.2, 0.2, 0.2)  # Темно-серый фон для элементов
		#style.border_color = Color(0.5, 0.5, 0.5)  # Серый цвет границы
		#style.border_width_top = 1
		#style.border_width_bottom = 1
		#style.border_width_left = 1
		#style.border_width_right = 1
		#draw_style_box(style, rect)
		## Отрисовка текста элемента
		#var text = get_item_text(i)
		#var font = load("res://Scenes/fonts/Black_Ops_One/BlackOpsOne-Regular_RUS_by_alince.otf") 
		#var text_pos = rect.position + Vector2(5, rect.size.y / 2 - font.get_height() / 2)
		#draw_string(font, text_pos, text, HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color.WHITE)
		# Отрисовка разделительной линии
		var line_start = Vector2(rect.position.x, rect.position.y + rect.size.y)
		var line_end = Vector2(rect.position.x + rect.size.x, rect.position.y + rect.size.y)
		draw_line(line_start, line_end, Color("#1d1d1d"), 3.0)


func _on_mouse_entered() -> void:
	hover_enabled = true
	if is_first_time:
		is_first_time = false
		%BtnToggleRight.button_pressed = !%BtnToggleRight.button_pressed


func _on_mouse_exited() -> void:
	hover_enabled = false


func _on_item_selected(index: int) -> void:
	update_module_info(index)
	# Спавним модуля
	var module = Modules[index]
	if player.get_plasment_mode():
		return
	var inst = module.instantiate()
	root.add_child(inst)
	# СБРАСЫВАЕМ выбор этого пункта, 
	# чтобы при следующем клике на тот же индекс _on_item_selected вызвался снова:
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
		update_module_info(hover_index)


func update_module_info(index: int) -> void:
	if index < 0 or index >= ModuleNames.size():
		return
	%ModuleName.text = ModuleNames[index].replace("\\n", "\n")
	%ModuleImage.texture = ModuleImages[index]
	%ModuleImage.expand = true
	%ModuleDescriptionText.text = ModuleDescriptionTexts[index].replace("\\n", "\n")
	%ModuleSpecifText.text = ModuleSpecifTexts[index].replace("\\n", "\n")
