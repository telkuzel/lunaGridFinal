extends Control

@onready var anim_leftBar = %LeftBarAnimation
@onready var anim_rightBar = %RightBarAnimation
@onready var leftBar = %Leftbar
@onready var rightBar = %RightBar
@onready var leftToggleBtn = %BtnToggleLeft
@onready var rightToggleBtn = %BtnToggleRight
@onready var TabContainerCentr = %TabContainerCenter
@onready var TabCont = %TabContainerModuleList
@onready var material_surface: StandardMaterial3D = preload("res://3dModels/material/surface.tres")
@onready var material_surfaceHeight: StandardMaterial3D = preload("res://3dModels/material/surfaceHieght.tres")

@export var camera_pivot: Node3D 
@export var grounMesh: MeshInstance3D

#static var active_button: Button = null
var min_zoom: float = 20.0     # Минимальная дистанция
var max_zoom: float = 100.0    # Максимальная дистанция
var root
var player: Player
var manager: ModuleManager


func _ready() -> void:
	root = get_node("/root/Game")
	player = get_node("/root/Game/Player")
	manager = get_node("/root/Game/modulesManager")
	leftBar.custom_minimum_size.x = 316
	leftToggleBtn.size.x = 346
	rightToggleBtn.scale = Vector2(-1, 1)
	rightToggleBtn.position.x += rightToggleBtn.size.x
	rightToggleBtn.get_child(0).position.x += rightToggleBtn.get_child(0).size.x - 24
	rightToggleBtn.get_child(0).scale = Vector2(-1, 1)
	ShowAllText()
	%BtnGenModules.connect("pressed", BtnModules_on_pressed.bind(%ItemListGen, %BtnGenModules))
	%BtnLiveModules.connect("pressed", BtnModules_on_pressed.bind(%ItemListLive, %BtnLiveModules))
	%BtnAdmModules.connect("pressed", BtnModules_on_pressed.bind(%ItemListAdm, %BtnAdmModules))
	%BtnAgroModules.connect("pressed", BtnModules_on_pressed.bind(%ItemListAgro, %BtnAgroModules))
	%BtnEngModules.connect("pressed", BtnModules_on_pressed.bind(%ItemListEng, %BtnEngModules))
	%BtnLogModules.connect("pressed", BtnModules_on_pressed.bind(%ItemListLog, %BtnLogModules))
	%BtnDistModules.connect("pressed", BtnModules_on_pressed.bind(%ItemListDist, %BtnDistModules))
	%BtnComModules.connect("pressed", BtnModules_on_pressed.bind(%ItemListCom, %BtnComModules))
	%BtnZoomOut.connect("toggled", BtnZoom_on_toggled.bind(2.0)) #шаг приближения
	%BtnZoomIn.connect("toggled", BtnZoom_on_toggled.bind(-2.0))
	if Global.save_data != null:
		await get_tree().process_frame
		spawn_prj(load("res://Scenes/projects/project.tres"))
		Global.save_data = null 


func BtnToggledLeft_on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		anim_leftBar.play("LeftbarAnim")
		await anim_leftBar.animation_finished
		ShowAllText()
		leftToggleBtn.icon = load("res://Scenes/UI/Icons/LeftArrow.png")
	else:
		anim_leftBar.play_backwards("LeftbarAnim")
		HideAllText()
		leftToggleBtn.icon = load("res://Scenes/UI/Icons/RightArrow.png")


func BtnToggledRight_on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		anim_rightBar.play_backwards("RightBarAnim")
		await anim_rightBar.animation_finished
		%BtnToggleRight.text = ""
		rightToggleBtn.icon = load("res://Scenes/UI/Icons/RightArrow.png")
		rightToggleBtn.get_child(0).visible = false
	else:
		rightToggleBtn.get_child(0).visible = true
		anim_rightBar.play("RightBarAnim")
		rightToggleBtn.icon = load("res://Scenes/UI/Icons/LeftArrow.png")


func ShowAllText() -> void:
	%BtnInfo.text = "ИНФО О КОМАНДЕ"
	%BtnGenModules.text = "ОБЩИЕ"
	%BtnLiveModules.text = "ЖИЛЫЕ"
	%BtnAdmModules.text = "АДМИН."
	%BtnAgroModules.text = "АГРОПРОМ."
	%BtnEngModules.text = "ИНЖЕНЕРНЫЕ"
	%BtnLogModules.text = "ТРАНСПОР."
	%BtnDistModules.text = "ИЗОЛИР."
	%BtnComModules.text = "КОМПЛЕКСЫ"
	if get_node("/root/Game").curentSceneIndex == 0:
		%BtnConstructor.text = "КОНСТРУКТОР"
	else:
		%BtnConstructor.text = "ПРОЕКТ"
	leftToggleBtn.text = "СПИСКИ МОДУЛЕЙ"
	#%SearchLineEdit.visible = true


func HideAllText() -> void:
	%BtnInfo.text = ""
	%BtnGenModules.text = ""
	%BtnLiveModules.text = ""
	%BtnAdmModules.text = ""
	%BtnAgroModules.text = ""
	%BtnEngModules.text = ""
	%BtnLogModules.text = ""
	%BtnDistModules.text = ""
	%BtnComModules.text = ""
	%BtnConstructor.text = ""
	leftToggleBtn.text = ""
	#%SearchLineEdit.visible = false


func BtnInfo_on_toggled(toggled_on: bool) -> void:
	#active_button = %BtnInfo
	#var icon_path: String= %BtnInfo.icon.resource_path
	#var new_icon_path
	if TabContainerCentr.visible and TabContainerCentr.current_tab == 0:
		#new_icon_path = icon_path.left(-5) + "2.png"
		TabContainerCentr.visible = false
		TabContainerCentr.current_tab = 1
	else:
		#new_icon_path = icon_path.left(-5) + "1.png"
		TabContainerCentr.visible = true
		TabContainerCentr.current_tab = 0
		%TeamInfo.text = "Мы - команда студентов 3 курса МАДИ,\n специализирующихся на разработке дорожно-транспортных, земляных и строительных систем,\n включая автоматизацию, моделирование и разработку программного обеспичения.\n Участвовали в разработке Всеросийской олимпиады 'Все дороги ведут в МАДИ'."
		%TeamLead.text = "Грецкий Д.А.\nКапитан команды"
		%TeamDev.text = "Лоскутов Я.Д.\n Программист"
		%TeamDis.text = "Цирюта А.С.\n Дизайнер"
		%Mentor.text = "Подберёзкин А.А.\n Наставник"
	#%BtnInfo.icon = load(new_icon_path)


func BtnModules_on_pressed(itemlist: Node, button: Node) -> void:
	#active_button = button
	#var icon_path: String = button.icon.resource_path
	#var new_icon_path
	if TabCont.visible and itemlist.visible:
		#new_icon_path = icon_path.left(-5) + "2.png"
		TabCont.visible = false
		itemlist.visible = false
	else:
		#new_icon_path = icon_path.left(-5) + "1.png"
		if itemlist == %ItemListCom:
			itemlist.loadCompexes()
		TabCont.visible = true
		itemlist.visible = true
	#button.icon = load(new_icon_path)


func BtnSave_on_toggled(toggled_on: bool) -> void:
	var save = make_project_save()
	var file_name = "res://Scenes/projects/project.tres"
	ResourceSaver.save(save, file_name)


func BtnOpen_on_toggled(toggled_on: bool) -> void:
	if load("res://Scenes/projects/project.tres") != null:
		Global.save_data = 1
		change_scene("res://Scenes/game.tscn")


func make_project_save()->Prj_save:
	var prj_save = Prj_save.new()
	for complex in manager.complexes:
		var save = Complex_save.new()
		for module in complex.modules:
			if module == null:
				continue
			var module_s = Module_save.new()
			module_s.position = module.position
			module_s.position.y = 0
			module_s.rotation = module.rotation
			module_s.resource = module.resource
			save.modules.append(module_s)
		prj_save.complexes.append(save)
	for module in manager.modules:
		if module == null:
			continue
		if not module is Connectabel:
			var module_s = Module_save.new()
			module_s.position = module.position
			module_s.position.y = 0
			module_s.rotation = module.rotation
			module_s.resource = module.resource
			prj_save.modules.append(module_s)
	return prj_save


var complex_scene


func spawn_prj(prj_save: Prj_save):
	for complex in prj_save.complexes:
		var comp = load("res://Scenes/complex.tscn").instantiate()
		root.add_child(comp)
		comp.spawn_complex(complex)
		comp.is_placement = false
	#for module in prj_save.modules:
		#var mod = module.resource.instantiate()
		#root.add_child(mod)
		#mod.position = module.position
		#mod.rotation = module.rotation
		#mod.resource = module.resource
		#mod.is_placement = false
	player.is_plasmet_mode = false

func BtnZoom_on_toggled(toggled_on: bool, zoom_step: float) -> void:
	if camera_pivot:
		var current_pos = camera_pivot.get_node("Camera3D").position
		var new_pos = current_pos + current_pos.normalized() * zoom_step
		if new_pos.length() <= max_zoom and new_pos.length() >= min_zoom:
			camera_pivot.get_node("Camera3D").position = new_pos


func BtnHieghtView_on_toggled(toggled_on: bool) -> void:
	if grounMesh.material_override == material_surface or grounMesh.material_override == null:
		grounMesh.material_override = material_surfaceHeight
	else:
		grounMesh.material_override = material_surface


func _on_btn_constructor_pressed() -> void:
	if get_node("/root/Game").curentSceneIndex == 0:
		change_scene("res://Scenes/Constructor.tscn")
		%BtnComModules.visible = false
	else:
		change_scene("res://Scenes/game.tscn")
		%BtnComModules.visible = true


func change_scene(scenePath: String):
	get_tree().change_scene_to_file(scenePath)


#func clearBtnIcons():
	#%BtnGenModules.icon = load(%BtnGenModules.icon.resource_path.left(-5) + "2.png")
	#%BtnLiveModules.icon = load(%BtnLiveModules.icon.resource_path.left(-5) + "2.png")
	#%BtnAdmModules.icon = load(%BtnAdmModules.icon.resource_path.left(-5) + "2.png")
	#%BtnAgroModules.icon = load(%BtnAgroModules.icon.resource_path.left(-5) + "2.png")
	#%BtnEngModules.icon = load(%BtnEngModules.icon.resource_path.left(-5) + "2.png")
	#%BtnLogModules.icon = load(%BtnLogModules.icon.resource_path.left(-5) + "2.png")
	#%BtnDistModules.icon = load(%BtnDistModules.icon.resource_path.left(-5) + "2.png")
	#%BtnComModules.icon = load(%BtnComModules.icon.resource_path.left(-5) + "2.png")
	#%BtnInfo.icon = load(%BtnInfo.icon.resource_path.left(-5) + "2.png")
