class_name JuiceLayer
extends Node2D
## Juice de combate desenhado em LOTE: números de dano flutuantes e "puffs"
## de morte/coleta. Um único nó, zero instância de Label/Particles —
## aguenta centenas de inimigos sem derrubar FPS.

const MAX_NUMBERS := 80   # acima disso, descarta os mais antigos
const NUMBER_LIFE := 0.7
const NUMBER_RISE := 26.0
const PUFF_LIFE := 0.35
const FONT_SIZE := 14

var _numbers: Array[Dictionary] = []
var _puffs: Array[Dictionary] = []

func _ready() -> void:
	z_index = 50
	EventBus.damage_dealt.connect(_on_damage_dealt)
	EventBus.enemy_killed.connect(_on_enemy_killed)
	EventBus.seed_collected.connect(_on_seed_collected)

func _on_damage_dealt(pos: Vector2, amount: float) -> void:
	if _numbers.size() >= MAX_NUMBERS:
		_numbers.pop_front()
	_numbers.push_back({
		"pos": pos + Vector2(randf_range(-8, 8), randf_range(-6, 0)),
		"t": NUMBER_LIFE,
		"text": str(roundi(amount)),
	})

func _on_enemy_killed(enemy: Node2D) -> void:
	var e := enemy as Enemy
	var color := e.data.color if (e and e.data) else Color.WHITE
	_puffs.push_back({"pos": enemy.global_position, "t": PUFF_LIFE, "color": color, "size": 16.0})

func _on_seed_collected(pos: Vector2) -> void:
	_puffs.push_back({"pos": pos, "t": PUFF_LIFE * 0.7, "color": Color("ffd25e"), "size": 9.0})

func _process(delta: float) -> void:
	if _numbers.is_empty() and _puffs.is_empty():
		return
	for n in _numbers:
		n["t"] = float(n["t"]) - delta
	for p in _puffs:
		p["t"] = float(p["t"]) - delta
	_numbers = _numbers.filter(func(n): return float(n["t"]) > 0.0)
	_puffs = _puffs.filter(func(p): return float(p["t"]) > 0.0)
	queue_redraw()

func _draw() -> void:
	var font := ThemeDB.fallback_font
	for n in _numbers:
		var life: float = float(n["t"]) / NUMBER_LIFE
		var rise := (1.0 - life) * NUMBER_RISE
		draw_string(
			font,
			to_local(n["pos"]) + Vector2(-10, -14 - rise),
			n["text"],
			HORIZONTAL_ALIGNMENT_LEFT, -1, FONT_SIZE,
			Color(1, 1, 1, life)
		)
	for p in _puffs:
		var progress: float = 1.0 - float(p["t"]) / PUFF_LIFE
		var color: Color = p["color"]
		color.a = 1.0 - progress
		draw_arc(to_local(p["pos"]), 4.0 + progress * float(p["size"]), 0, TAU, 14, color, 2.0)
