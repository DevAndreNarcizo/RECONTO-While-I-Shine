extends Control
## Opções — áudio (3 canais), vídeo, jogabilidade e idioma. Tudo persiste no
## save e é aplicado na hora (SaveManager.apply_settings).

const LOCALES := ["pt_BR", "en"]
const LOCALE_NAMES := ["Português (Brasil)", "English"]

@onready var master: HSlider = $Center/Panel/VBox/MasterRow/Slider
@onready var music: HSlider = $Center/Panel/VBox/MusicRow/Slider
@onready var sfx: HSlider = $Center/Panel/VBox/SfxRow/Slider
@onready var language: OptionButton = $Center/Panel/VBox/LanguageRow/Options
@onready var fullscreen: CheckButton = $Center/Panel/VBox/Fullscreen
@onready var auto_attack: CheckButton = $Center/Panel/VBox/AutoAttack
@onready var screen_shake: CheckButton = $Center/Panel/VBox/ScreenShake
@onready var damage_numbers: CheckButton = $Center/Panel/VBox/DamageNumbers
@onready var back: Button = $Center/Panel/VBox/Back

func _ready() -> void:
	for locale_name in LOCALE_NAMES:
		language.add_item(locale_name)
	language.selected = maxi(0, LOCALES.find(String(SaveManager.settings.get("language", "pt_BR"))))

	master.value = float(SaveManager.settings.get("volume", 1.0))
	music.value = float(SaveManager.settings.get("volume_music", 1.0))
	sfx.value = float(SaveManager.settings.get("volume_sfx", 1.0))
	fullscreen.button_pressed = bool(SaveManager.settings.get("fullscreen", false))
	auto_attack.button_pressed = bool(SaveManager.settings.get("auto_attack", false))
	screen_shake.button_pressed = bool(SaveManager.settings.get("screen_shake", true))
	damage_numbers.button_pressed = bool(SaveManager.settings.get("damage_numbers", true))

	master.value_changed.connect(func(v): SaveManager.set_setting("volume", v))
	music.value_changed.connect(func(v): SaveManager.set_setting("volume_music", v))
	sfx.value_changed.connect(func(v): SaveManager.set_setting("volume_sfx", v))
	language.item_selected.connect(func(i): SaveManager.set_setting("language", LOCALES[i]))
	fullscreen.toggled.connect(func(on): SaveManager.set_setting("fullscreen", on))
	auto_attack.toggled.connect(func(on): SaveManager.set_setting("auto_attack", on))
	screen_shake.toggled.connect(func(on): SaveManager.set_setting("screen_shake", on))
	damage_numbers.toggled.connect(func(on): SaveManager.set_setting("damage_numbers", on))
	back.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/Main.tscn"))
	back.grab_focus()
