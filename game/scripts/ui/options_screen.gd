extends Control
## Opções — volume, tela cheia e idioma (placeholder). Persistem no save.

@onready var volume: HSlider = $Center/Panel/VBox/VolumeRow/Slider
@onready var fullscreen: CheckButton = $Center/Panel/VBox/Fullscreen
@onready var language: OptionButton = $Center/Panel/VBox/LanguageRow/Options
@onready var back: Button = $Center/Panel/VBox/Back

func _ready() -> void:
	volume.value = float(SaveManager.settings.get("volume", 1.0))
	fullscreen.button_pressed = bool(SaveManager.settings.get("fullscreen", false))
	language.add_item("Português (Brasil)")
	language.add_item("English (em breve)")
	language.set_item_disabled(1, true)  # TODO(fase 7): localização en
	volume.value_changed.connect(func(v): SaveManager.set_setting("volume", v))
	fullscreen.toggled.connect(func(on): SaveManager.set_setting("fullscreen", on))
	back.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/Main.tscn"))
	back.grab_focus()
