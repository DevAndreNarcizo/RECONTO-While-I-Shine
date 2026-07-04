extends CanvasLayer
## Tela de EVOLUÇÃO — celebra o Ritual de Sincretismo com pausa e destaque.

@onready var evolved_name: Label = $Dim/Center/Panel/VBox/EvolvedName
@onready var desc: Label = $Dim/Center/Panel/VBox/Desc
@onready var continue_btn: Button = $Dim/Center/Panel/VBox/Continue

func _ready() -> void:
	visible = false
	EventBus.encanto_evolved.connect(_on_evolved)
	continue_btn.pressed.connect(_close)

func _on_evolved(data: EncantoData) -> void:
	get_tree().paused = true
	evolved_name.text = data.display_name
	desc.text = data.description
	visible = true
	continue_btn.grab_focus()

func _close() -> void:
	visible = false
	get_tree().paused = false
	EventBus.screen_shake.emit(6.0)
