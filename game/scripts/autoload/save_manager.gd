extends Node
## SaveManager — progresso permanente em user://save.json.
## Escrita ATÔMICA (tmp + rename): fechar o jogo no meio nunca corrompe o save.

const SAVE_PATH := "user://save.json"
const TMP_PATH := "user://save.json.tmp"
const SCHEMA_VERSION := 1

var luar := 0
var tree_levels: Dictionary = {}  # String (id do upgrade) → int (nível)
var biomes_cleared: Array = []    # Strings (ids de bioma vencidos)

func _ready() -> void:
	load_game()

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
