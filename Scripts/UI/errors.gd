extends Label

@export var moduleM: ModuleManager

func _process(delta: float) -> void:
	self.text = "Ошибка: " + moduleM.plasment_error
	if moduleM.plasment_error == "":
		self.text = ""
