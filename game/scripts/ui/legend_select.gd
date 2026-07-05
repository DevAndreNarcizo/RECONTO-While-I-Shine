extends Control
## Tela "Jogar" — seleção de LENDA e BIOMA (docs/04 §1-2).
## Lendas bloqueadas mostram o requisito; as compráveis com Luar são
## desbloqueadas com um clique se houver saldo.

const LEGENDS: Array = [
	preload("res://resources/legends/curupira.tres"),
	preload("res://resources/legends/saci.tres"),
	preload("res://resources/legends/lobisomem.tres"),
]

const BIOMES := [
	{"id": &"mata_atlantica", "name": "Mata Atlântica", "playable": true, "requires": &""},
	{"id": &"amazonia", "name": "Amazônia", "playable": true, "requires": &"mata_atlantica"},
	{"id": &"pantanal", "name": "Pantanal", "playable": true, "requires": &"amazonia"},
	{"id": &"caatinga", "name": "Caatinga (em breve)", "playable": false, "requires": &"pantanal"},
]

var _sel_legend: LegendData
var _sel_biome: StringName = &"mata_atlantica"
var _sel_simpatias: Array[StringName] = []
var _legend_buttons: Dictionary = {}
var _biome_buttons: Dictionary = {}
var _simpatia_buttons: Dictionary = {}

@onready var luar_label: Label = $Center/Panel/VBox/LuarLabel
@onready var legends_box: HBoxContainer = $Center/Panel/VBox/Legends
@onready var biomes_box: HBoxContainer = $Center/Panel/VBox/Biomes
@onready var simpatias_box: HBoxContainer = $Center/Panel/VBox/Simpatias
@onready var info_label: Label = $Center/Panel/VBox/Info
@onready var start: Button = $Center/Panel/VBox/Start
@onready var back: Button = $Center/Panel/VBox/Back

func _ready() -> void:
	for legend in LEGENDS:
		var b := Button.new()
		b.custom_minimum_size = Vector2(300, 120)
		b.toggle_mode = true
		b.add_theme_font_size_override("font_size", 22)
		b.pressed.connect(_on_legend_pressed.bind(legend))
		legends_box.add_child(b)
		_legend_buttons[legend.id] = b
	for biome in BIOMES:
		var b := Button.new()
		b.custom_minimum_size = Vector2(300, 72)
		b.toggle_mode = true
		b.add_theme_font_size_override("font_size", 22)
		b.pressed.connect(_on_biome_pressed.bind(biome))
		biomes_box.add_child(b)
		_biome_buttons[biome["id"]] = b
	for id in Balance.SIMPATIAS:
		var b := Button.new()
		b.custom_minimum_size = Vector2(220, 84)
		b.toggle_mode = true
		b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		b.add_theme_font_size_override("font_size", 18)
		b.tooltip_text = Balance.SIMPATIAS[id]["desc"]
		b.pressed.connect(_on_simpatia_pressed.bind(id))
		simpatias_box.add_child(b)
		_simpatia_buttons[id] = b
	start.pressed.connect(_on_start)
	back.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/Main.tscn"))
	_sel_legend = LEGENDS[0]
	_sel_simpatias = GameState.active_simpatias.duplicate()  # lembra a última escolha
	_refresh()
	start.grab_focus()

func _on_simpatia_pressed(id: StringName) -> void:
	if not SaveManager.is_simpatia_unlocked(id):
		SaveManager.unlock_simpatia(id)  # compra com Luar (se der)
	elif _sel_simpatias.has(id):
		_sel_simpatias.erase(id)
	elif _sel_simpatias.size() < Balance.SIMPATIA_MAX_ACTIVE:
		_sel_simpatias.push_back(id)
	_refresh()

func _on_legend_pressed(legend: LegendData) -> void:
	if SaveManager.is_legend_unlocked(legend):
		_sel_legend = legend
	elif SaveManager.unlock_legend(legend):
		_sel_legend = legend  # comprada com Luar
	_refresh()

func _on_biome_pressed(biome: Dictionary) -> void:
	if _biome_available(biome):
		_sel_biome = biome["id"]
	_refresh()

func _biome_available(biome: Dictionary) -> bool:
	if not biome["playable"]:
		return false
	var req: StringName = biome["requires"]
	return req == &"" or SaveManager.is_biome_cleared(req)

func _on_start() -> void:
	GameState.selected_legend = _sel_legend
	GameState.selected_biome_id = _sel_biome
	GameState.active_simpatias = _sel_simpatias.duplicate()
	get_tree().change_scene_to_file("res://scenes/world/World.tscn")

func _refresh() -> void:
	luar_label.text = tr("UI_LUAR_TOTAL") % SaveManager.luar
	for legend in LEGENDS:
		var b: Button = _legend_buttons[legend.id]
		if SaveManager.is_legend_unlocked(legend):
			b.text = legend.display_name
		else:
			b.text = "🔒 %s\n%s" % [legend.display_name, legend.unlock_desc]
		b.button_pressed = (legend == _sel_legend)
	for biome in BIOMES:
		var b: Button = _biome_buttons[biome["id"]]
		b.text = biome["name"] if _biome_available(biome) else "🔒 %s" % biome["name"]
		b.disabled = not _biome_available(biome)
		b.button_pressed = (biome["id"] == _sel_biome)
	for id in _simpatia_buttons:
		var b: Button = _simpatia_buttons[id]
		var info: Dictionary = Balance.SIMPATIAS[id]
		if SaveManager.is_simpatia_unlocked(id):
			b.text = info["name"]
		else:
			b.text = "🔒 %s\n%d ❖" % [info["name"], info["cost"]]
		b.button_pressed = _sel_simpatias.has(id)
	info_label.text = "%s — %s" % [_sel_legend.display_name, _sel_legend.description]
