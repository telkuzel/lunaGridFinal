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


var min_zoom: float = 20.0     # Минимальная дистанция
var max_zoom: float = 100.0    # Максимальная дистанция


func _ready() -> void:
	leftBar.custom_minimum_size.x = 316
	leftToggleBtn.size.x = 346
	rightToggleBtn.scale = Vector2(-1, 1)
	rightToggleBtn.position.x += rightToggleBtn.size.x
	rightToggleBtn.get_child(0).position.x += rightToggleBtn.get_child(0).size.x - 24
	rightToggleBtn.get_child(0).scale = Vector2(-1, 1)
	ShowAllText()
	%BtnGenModules.connect("pressed", BtnModules_on_pressed.bind(%ItemListGen))
	%BtnLiveModules.connect("pressed", BtnModules_on_pressed.bind(%ItemListLive))
	%BtnAdmModules.connect("pressed", BtnModules_on_pressed.bind(%ItemListAdm))
	%BtnAgroModules.connect("pressed", BtnModules_on_pressed.bind(%ItemListAgro))
	%BtnEngModules.connect("pressed", BtnModules_on_pressed.bind(%ItemListEng))
	%BtnLogModules.connect("pressed", BtnModules_on_pressed.bind(%ItemListLog))
	%BtnDistModules.connect("pressed", BtnModules_on_pressed.bind(%ItemListDist))
	%BtnComModules.connect("pressed", BtnModules_on_pressed.bind(%ItemListCom))
	%BtnZoomOut.connect("toggled", BtnZoom_on_toggled.bind(2.0)) #шаг приближения
	%BtnZoomIn.connect("toggled", BtnZoom_on_toggled.bind(-2.0))


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
	%BtnLogModules.text = "ЛОГИСТ."
	%BtnDistModules.text = "УДАЛЁННЫЕ"
	%BtnComModules.text = "КОМПЛЕКСЫ"
	%BtnConstructor.text = "КОНСТРУКТОР"
	leftToggleBtn.text = "СПИСКИ МОДУЛЕЙ"
	%SearchLineEdit.visible = true


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
	%SearchLineEdit.visible = false


func BtnInfo_on_toggled(toggled_on: bool) -> void:
	if TabContainerCentr.visible and TabContainerCentr.current_tab == 0:
		TabContainerCentr.visible = false
		TabContainerCentr.current_tab = 1
	else:
		TabContainerCentr.visible = true
		TabContainerCentr.current_tab = 0
		


func BtnModules_on_pressed(itemlist: Node) -> void:
	if TabCont.visible and itemlist.visible:
		TabCont.visible = false
		itemlist.visible = false
	else:
		TabCont.visible = true
		itemlist.visible = true


func BtnSave_on_toggled(toggled_on: bool) -> void:
	if TabContainerCentr.visible and TabContainerCentr.current_tab == 1:
		TabContainerCentr.visible = false
		TabContainerCentr.current_tab = 0
	else:
		TabContainerCentr.visible = true
		TabContainerCentr.current_tab = 1


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
