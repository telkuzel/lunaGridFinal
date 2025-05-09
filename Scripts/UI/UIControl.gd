extends Control

@onready var anim_player = %AnimationPlayer
@onready var TabContainerCentr = %TabContainerCenter
@onready var TabCont = %TabContainerModuleList
@onready var material_surface: StandardMaterial3D = preload("res://3dModels/material/surface.tres")
@onready var material_surfaceHeight: StandardMaterial3D = preload("res://3dModels/material/surfaceHieght.tres")

@export var camera_pivot: Node3D 
@export var grounMesh: MeshInstance3D


var min_zoom: float = 20.0     # Минимальная дистанция
var max_zoom: float = 100.0    # Максимальная дистанция


func _ready() -> void:
	%Leftbar.custom_minimum_size.x = 270
	ShowAllText()
	%BtnGenModules.connect("toggled", Callable(self, "BtnModules_on_toggled").bind(%ItemListGen))
	%BtnLiveModules.connect("toggled", Callable(self, "BtnModules_on_toggled").bind(%ItemListLive))
	%BtnAdmModules.connect("toggled", Callable(self, "BtnModules_on_toggled").bind(%ItemListAdm))
	%BtnAgroModules.connect("toggled", Callable(self, "BtnModules_on_toggled").bind(%ItemListAgro))
	%BtnEngModules.connect("toggled", Callable(self, "BtnModules_on_toggled").bind(%ItemListEng))
	%BtnLogModules.connect("toggled", Callable(self, "BtnModules_on_toggled").bind(%ItemListLog))
	%BtnDistModules.connect("toggled", Callable(self, "BtnModules_on_toggled").bind(%ItemListDist))
	%BtnComModules.connect("toggled", Callable(self, "BtnModules_on_toggled").bind(%ItemListCom))
	%BtnZoomOut.connect("toggled", Callable(self, "BtnZoom_on_toggled").bind(2.0)) #шаг приближения
	%BtnZoomIn.connect("toggled", Callable(self, "BtnZoom_on_toggled").bind(-2.0))

func BtnToggled_on_toggled(toggled_on: bool) -> void:
	var button = %BtnToggle
	if toggled_on:
		anim_player.play("LeftbarAnim")
		await anim_player.animation_finished
		ShowAllText()
		button.icon = load("res://Scenes/UI/Icons/LeftArrow.png")
	else:
		anim_player.play_backwards("LeftbarAnim")
		HideAllText()
		button.icon = load("res://Scenes/UI/Icons/RightArrow.png")
		
func ShowAllText() -> void:
	%BtnInfo.text = "Инфо о команде"
	%BtnGenModules.text = "Общ. модули"
	%BtnLiveModules.text = "Жилой компл."
	%BtnAdmModules.text = "Адм.-науч. компл."
	%BtnAgroModules.text = "Агро-компл."
	%BtnEngModules.text = "Инж. компл."
	%BtnLogModules.text = "Логист. компл."
	%BtnDistModules.text = "Удал. модули"
	%BtnComModules.text = "Констр. компл."
	
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

func BtnInfo_on_toggled(toggled_on: bool) -> void:
	if TabContainerCentr.visible and TabContainerCentr.current_tab == 0:
		TabContainerCentr.visible = false
		TabContainerCentr.current_tab = 1
	else:
		TabContainerCentr.visible = true
		TabContainerCentr.current_tab = 0
		

func BtnModules_on_toggled(toggled_on: bool, itemlist: Node) -> void:
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
