extends Control
## Árvore Sagrada — a jabuticabeira anciã. Gasta Cristais de Luar em
## upgrades PERMANENTES (Balance.TREE_UPGRADES + SaveManager).
## As linhas são montadas em código a partir da tabela — sem UI hardcoded.

@onready var luar_label: Label = $Center/Panel/VBox/LuarLabel
@onready var list: VBoxContainer = $Center/Panel/VBox/List
@onready var back: Button = $Center/Panel/VBox/Back

var _rows: Dictionary = {}  # id → {"level": Label, "buy": Button}

func _ready() -> void:
	back.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/Main.tscn"))
	for id in Balance.TREE_UPGRADES:
		_add_row(id)
	_refresh()

func _add_row(id: StringName) -> void:
	var info: Dictionary = Balance.TREE_UPGRADES[id]
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 16)

	var name_label := Label.new()
	name_label.text = "%s — %s" % [info["name"], info["desc"]]
	name_label.custom_minimum_size = Vector2(620, 0)
	name_label.add_theme_font_size_override("font_size", 22)
	row.add_child(name_label)

	var level_label := Label.new()
	level_label.custom_minimum_size = Vector2(110, 0)
	level_label.add_theme_font_size_override("font_size", 22)
	row.add_child(level_label)

	var buy := Button.new()
	buy.custom_minimum_size = Vector2(160, 48)
	buy.add_theme_font_size_override("font_size", 22)
	buy.pressed.connect(_buy.bind(id))
	row.add_child(buy)

	list.add_child(row)
	_rows[id] = {"level": level_label, "buy": buy}

func _buy(id: StringName) -> void:
	if SaveManager.buy_upgrade(id):
		_refresh()

func _refresh() -> void:
	luar_label.text = tr("UI_LUAR_TOTAL") % SaveManager.luar
	for id in _rows:
		var info: Dictionary = Balance.TREE_UPGRADES[id]
		var lv := SaveManager.tree_level(id)
		(_rows[id]["level"] as Label).text = tr("TREE_LEVEL") % [lv, info["max_level"]]
		var buy := _rows[id]["buy"] as Button
		if lv >= int(info["max_level"]):
			buy.text = tr("TREE_MAX")
			buy.disabled = true
		else:
			buy.text = "%d ❖" % SaveManager.upgrade_cost(id)
			buy.disabled = not SaveManager.can_buy(id)
