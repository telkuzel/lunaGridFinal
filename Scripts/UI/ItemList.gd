extends ItemList

# Переменные для обработки наведения и выделения
var last_hovered_index: int = -1
var selected_index: int = -1
var hover_enabled: bool = false

const HIGHLIGHT_COLOR = Color("#919ec2")
const TEXT_COLOR = Color("#2b2b2b")
const TRANSPARENT   = Color(0, 0, 0, 0)

# Экспортируем путь к узлу панели с информацией о модуле.
@export var ModuleInfo: NodePath

# Экспортируем массивы для хранения данных по модулям.
@export var ModuleNames: Array         = []  # Например, ["Модуль 1", "Модуль 2", ...]
@export var ModuleImages: Array        = []  # Здесь можно заранее загрузить текстуры: [load("res://path/to/image1.png"), ...]
@export var ModuleDescriptionTexts: Array = []  # Описания модулей
@export var ModuleSpecifTexts: Array   = []  # Характеристики модулей

var player: Player
var root

func _ready():
	# Отключаем фокус, чтобы не появлялась рамка, и блокируем мышиные события
	focus_mode = Control.FOCUS_NONE
	mouse_filter = Control.MOUSE_FILTER_STOP
	# Для установки модуля
	player = get_node("/root/Game/Player")
	root = get_node("/root/Game")


# При входе курсора на область ItemList показываем панель с информацией.
func _on_mouse_entered() -> void:
	hover_enabled = true
	var moduleInfo = get_node(ModuleInfo)
	moduleInfo.visible = true

# При уходе курсора скрываем панель и сбрасываем подсветку наведения.
func _on_mouse_exited() -> void:
	hover_enabled = false
	_clear_hover_highlight()
	var moduleInfo = get_node(ModuleInfo)
	moduleInfo.visible = false

@export var Modules: Array        = []
# При выборе элемента производится выделение и обновление информации.
func _on_item_selected(index: int) -> void:
	# Снимаем прошлую подсветку
	if selected_index != -1 and selected_index != index:
		set_item_custom_bg_color(selected_index, TRANSPARENT)
		set_item_custom_fg_color(selected_index, TEXT_COLOR)
	# Выделяем новый
	selected_index = index
	set_item_custom_bg_color(index, HIGHLIGHT_COLOR)
	set_item_custom_fg_color(index, TEXT_COLOR)
	# Обновляем инфу
	update_module_info(index)
	# Спавним модуль
	var module = Modules[index]
	if player.get_plasment_mode():
		return
	var inst = module.instantiate()
	root.add_child(inst)
	# …и СБРАСЫВАЕМ выбор этого пункта, 
	# чтобы при следующем клике на тот же индекс _on_item_selected вызвался снова:
	deselect(index)
	selected_index = -1  # Сбрасываем нашу переменную тоже
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
	# Управляем подсветкой при смене наведённого элемента
	if hover_index != last_hovered_index:
		if last_hovered_index != -1 and last_hovered_index != selected_index:
			set_item_custom_bg_color(last_hovered_index, TRANSPARENT)
			set_item_custom_fg_color(last_hovered_index, TEXT_COLOR)
		if hover_index != -1 and hover_index != selected_index:
			set_item_custom_bg_color(hover_index, HIGHLIGHT_COLOR)
			set_item_custom_fg_color(hover_index, TEXT_COLOR)
		last_hovered_index = hover_index

# Функция сбрасывает подсветку наведения, если элемент не выбран.
func _clear_hover_highlight():
	if last_hovered_index != -1 and last_hovered_index != selected_index:
		set_item_custom_bg_color(last_hovered_index, TRANSPARENT)
		set_item_custom_fg_color(last_hovered_index, TEXT_COLOR)
	last_hovered_index = -1

# Функция обновления данных в ModuleInfo по заданному индексу.
func update_module_info(index: int) -> void:
	# Если индекс выходит за рамки массивов – ничего не делаем.
	if index < 0 or index >= ModuleNames.size():
		return

	# Получаем ссылку на панель с информацией
	var moduleInfoPanel = get_node(ModuleInfo)

	# Предполагаем, что структура панели такова:
	# Panel
	#   └── VBoxContainer
	#         ├── Label (название модуля)
	#         ├── TextureRect (изображение)
	#         ├── Label (описание)
	#         └── Label (характеристики)

	# Получаем VBoxContainer (предполагаем, что он — первый ребёнок панели)
	var vbox = moduleInfoPanel.get_child(0)

	# Обновляем Label с названием модуля
	var nameLabel = vbox.get_child(0) as Label
	nameLabel.text = ModuleNames[index].replace("\\n", "\n")

	# Обновляем TextureRect с изображением модуля
	var textureRect = vbox.get_child(1) as TextureRect
	textureRect.texture = ModuleImages[index]
	textureRect.expand = true

	# Обновляем Label с описанием модуля
	var descriptionLabel = vbox.get_child(2) as Label
	descriptionLabel.text = ModuleDescriptionTexts[index].replace("\\n", "\n")

	# Обновляем Label с характеристиками модуля
	var specifLabel = vbox.get_child(3) as Label
	specifLabel.text = ModuleSpecifTexts[index].replace("\\n", "\n")



##спавн модуля
#@export var module = preload("res://Scenes/module.tscn")
#
#func _on_gui_input_BtnInfo(event):
	#if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		#var inst = module.instantiate()
		#$"..".add_child(inst)
