extends Node
## SaveManager — progresso permanente em user://save.json.
## Escrita ATÔMICA (tmp + rename): fechar o jogo no meio nunca corrompe o save.

const SAVE_PATH := "user://save.json"
const TMP_PATH := "user://save.json.tmp"
const SCHEMA_VERSION := 1

var luar := 0
var tree_levels: Dictionary = {}   # String (id do upgrade) → int (nível)
var biomes_cleared: Array = []     # Strings (ids de bioma vencidos)
var legends_unlocked: Array = []   # Strings (além das unlocked_by_default)
var settings: Dictionary = {"volume": 1.0, "fullscreen": false}

func _ready() -> void:
	load_game()
	apply_settings()

# --- Opções ---

func set_setting(key: String, value: Variant) -> void:
	settings[key] = value
	apply_settings()
	save_game()

func apply_settings() -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(clampf(float(settings.get("volume", 1.0)), 0.0001, 1.0)))
	var mode := DisplayServer.WINDOW_MODE_FULLSCREEN if settings.get("fullscreen", false) else DisplayServer.WINDOW_MODE_WINDOWED
	DisplayServer.window_set_mode(mode)

# --- Lendas ---

func is_legend_unlocked(legend: LegendData) -> bool:
	return legend.unlocked_by_default or legends_unlocked.has(String(legend.id))

func unlock_legend(legend: LegendData) -> bool:
	if is_legend_unlocked(legend) or legend.unlock_luar_cost <= 0 or luar < legend.unlock_luar_cost:
		return false
	luar -= legend.unlock_luar_cost
	legends_unlocked.push_back(String(legend.id))
	save_game()
	return true

# --- Cristais de Luar ---

func add_luar(amount: int) -> void:
	luar += amount
	save_game()

# --- Progressão de mundo ---

func mark_biome_cleared(id: StringName) -> void:
	if not biomes_cleared.has(String(id)):
		biomes_cleared.push_back(String(id))
	save_game()

func is_biome_cleared(id: StringName) -> bool:
	return biomes_cleared.has(String(id))

# --- Árvore Sagrada ---

func tree_level(id: StringName) -> int:
	return int(tree_levels.get(String(id), 0))

func upgrade_cost(id: StringName) -> int:
	var info: Dictionary = Balance.TREE_UPGRADES[id]
	return int(info["base_cost"]) * (tree_level(id) + 1)

func can_buy(id: StringName) -> bool:
	var info: Dictionary = Balance.TREE_UPGRADES[id]
	return tree_level(id) < int(info["max_level"]) and luar >= upgrade_cost(id)

func buy_upgrade(id: StringName) -> bool:
	if not can_buy(id):
		return false
	luar -= upgrade_cost(id)
	tree_levels[String(id)] = tree_level(id) + 1
	save_game()
	return true

## Bônus permanentes no agregador de stats (textos em Balance.TREE_UPGRADES).
func apply_tree_bonuses(stats: PlayerStats) -> void:
	stats.max_hp += 10.0 * tree_level(&"vida")
	stats.damage_mult += 0.05 * tree_level(&"dano")
	stats.move_speed += 3.0 * tree_level(&"velocidade")
	stats.luck += 0.05 * tree_level(&"sorte")
	stats.magnetism += 15.0 * tree_level(&"magnetismo")
	stats.armor += 1.0 * tree_level(&"armadura")
	stats.luar_mult += 0.10 * tree_level(&"luar")

# --- Persistência ---

func save_game() -> void:
	var data := {
		"version": SCHEMA_VERSION,
		"luar": luar,
		"tree_levels": tree_levels,
		"biomes_cleared": biomes_cleared,
		"legends_unlocked": legends_unlocked,
		"settings": settings,
	}
	var file := FileAccess.open(TMP_PATH, FileAccess.WRITE)
	if file == null:
		push_error("SaveManager: não consegui escrever o save (%s)" % FileAccess.get_open_error())
		return
	file.store_string(JSON.stringify(data, "\t"))
	file.close()
	DirAccess.rename_absolute(TMP_PATH, SAVE_PATH)

func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(SAVE_PATH))
	if typeof(parsed) != TYPE_DICTIONARY:
		push_warning("SaveManager: save ilegível — começando do zero (o arquivo antigo foi mantido)")
		return
	luar = int(parsed.get("luar", 0))
	tree_levels = {}
	var raw_levels: Variant = parsed.get("tree_levels", {})
	if typeof(raw_levels) == TYPE_DICTIONARY:
		for key in raw_levels:
			tree_levels[String(key)] = int(raw_levels[key])
	biomes_cleared = []
	var raw_biomes: Variant = parsed.get("biomes_cleared", [])
	if typeof(raw_biomes) == TYPE_ARRAY:
		for b in raw_biomes:
			biomes_cleared.push_back(String(b))
	legends_unlocked = []
	var raw_legends: Variant = parsed.get("legends_unlocked", [])
	if typeof(raw_legends) == TYPE_ARRAY:
		for l in raw_legends:
			legends_unlocked.push_back(String(l))
	var raw_settings: Variant = parsed.get("settings", {})
	if typeof(raw_settings) == TYPE_DICTIONARY:
		for key in raw_settings:
			settings[String(key)] = raw_settings[key]
