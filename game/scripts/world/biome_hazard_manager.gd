class_name BiomeHazardManager
extends Node2D
## Inovação #4 — Bioma Reativo. Hazard da Mata/Cerrado: QUEIMADA que se
## propaga por células em tiques discretos (nunca por frame), queima por um
## tempo e apaga deixando terra queimada (que não pega fogo de novo).
## Fogo fere inimigos E player (lendas fire_immune ignoram; Fogo que Lembra cura).
## Outros biomas ganham managers próprios depois (rio, fendas, correnteza).

const CELL := 64.0  # alinhado à grade do chão

@export var enabled := true
@export var spread_chance := 0.35   # chance por vizinho por tique
@export var burn_time := 3.0        # segundos que uma célula queima
@export var tick_interval := 0.5
@export var fire_dps := 6.0
@export var max_burning_cells := 400  # trava de performance

var player: Player

var _burning: Dictionary = {}  # Vector2i → tempo restante de queima
var _burned: Dictionary = {}   # Vector2i → true (terra queimada)
var _tick := 0.0

func _ready() -> void:
	z_index = -5  # acima do chão, abaixo das entidades
	EventBus.fire_started.connect(ignite)

func ignite(world_pos: Vector2) -> void:
	if not enabled:
		return
	_ignite_cell(Vector2i((world_pos / CELL).floor()))

func _ignite_cell(cell: Vector2i) -> void:
	if _burning.has(cell) or _burned.has(cell) or _burning.size() >= max_burning_cells:
		return
	_burning[cell] = burn_time
	queue_redraw()

func _physics_process(delta: float) -> void:
	if _burning.is_empty():
		return
	_tick += delta
	if _tick < tick_interval:
		return
	_tick = 0.0
	_spread()
	_apply_damage()
	queue_redraw()

func _spread() -> void:
	var to_ignite: Array[Vector2i] = []
	for cell in _burning.keys():
		_burning[cell] = float(_burning[cell]) - tick_interval
		if float(_burning[cell]) <= 0.0:
			_burning.erase(cell)
			_burned[cell] = true
			continue
		for offset in [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]:
			if randf() < spread_chance * tick_interval:
				to_ignite.push_back(cell + offset)
	for cell in to_ignite:
		_ignite_cell(cell)

func _apply_damage() -> void:
	var dmg := fire_dps * tick_interval
	for e in EnemySpawner.active_enemies():
		if _burning.has(Vector2i((e.global_position / CELL).floor())):
			e.take_damage(dmg)
	if player == null:
		return
	if not _burning.has(Vector2i((player.global_position / CELL).floor())):
		return
	if player.legend and player.legend.fire_immune:
		return  # Boitatá caminha no próprio fogo
	if GameState.has_simpatia(&"fogo_que_lembra"):
		player.heal(dmg)  # Simpatia: toda queimada cura em vez de ferir
	else:
		player.take_damage(dmg)

func _draw() -> void:
	for cell in _burned:
		draw_rect(Rect2(Vector2(cell) * CELL, Vector2(CELL, CELL)), Color(0.08, 0.06, 0.05, 0.55))
	for cell in _burning:
		var base := Vector2(cell) * CELL
		var life: float = clampf(float(_burning[cell]) / burn_time, 0.0, 1.0)
		draw_rect(Rect2(base, Vector2(CELL, CELL)), Color(0.9, 0.35, 0.1, 0.25 + 0.2 * life))
		var center := base + Vector2(CELL, CELL) / 2.0
		draw_colored_polygon(PackedVector2Array([
			center + Vector2(0, -14 - 6.0 * life), center + Vector2(9, 6), center + Vector2(-9, 6),
		]), Color(1.0, 0.6, 0.15, 0.8))
