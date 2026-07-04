extends CanvasLayer
## Menu de pausa (ESC durante a run) — continuar, configurações rápidas
## (volume/tela cheia, persistem no save) e sair para o menu.

@onready var resume: Button = $Dim/Center/Panel/VBox/Resume
@onready var volume: HSlider = $Dim/Center/Panel/VBox/VolumeRow/Slider
@onready var fullscreen: CheckButton = $Dim/Center/Panel/VBox/Fullscreen
@onready var to_menu: Button = $Dim/Center/Panel/VBox/ToMenu

func _ready() -> void:
	visible = false
	resume.pressed.connect(_close)
	to_menu.pressed.connect(_exit_to_menu)
	volume.value_changed.connect(func(v): SaveManager.set_setting("volume", v))
	fullscreen.toggled.connect(func(on): SaveManager.set_setting("fullscreen", on))

func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("pause"):
		return
	if visible:
		_close()
	elif not get_tree().paused:  # não abre por cima do level up / fim de run
		_open()
	get_viewport().set_input_as_handled()

func _open() -> void:
	get_tree().paused = true
	volume.set_value_no_signal(float(SaveManager.settings.get("volume", 1.0)))
	fullscreen.set_pressed_no_signal(bool(SaveManager.settings.get("fullscreen", false)))
	visible = true
	resume.grab_focus()

func _close() -> void:
	visible = false
	get_tree().paused = false

func _exit_to_menu() -> void:
	EnemySpawner.reset()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
