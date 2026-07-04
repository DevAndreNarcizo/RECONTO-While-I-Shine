extends Node
## GameState — estado da run atual (nível, XP, kills, tempo, fim de run).

var level := 1
var xp := 0.0
var xp_to_next := 5.0
var kills := 0
var run_time := 0.0
var run_active := false
var run_luar := 0  # Cristais de Luar coletados nesta run (vira permanente no fim)
var boss_phase := false  # tempo esgotou: o boss do bioma está em campo

var _miniboss_fired := false

# Escolhas da tela de seleção (null/padrão = Curupira na Mata Atlântica)
var selected_legend: LegendData = null
var selected_biome_id := &"mata_atlantica"

func _ready() -> void:
	EventBus.enemy_killed.connect(_on_enemy_killed)
	EventBus.player_died.connect(_on_player_died)
	EventBus.boss_defeated.connect(_on_boss_defeated)

func _process(delta: float) -> void:
	# Pausa do jogo congela este _process — o timer para junto, como deve.
	if not run_active:
		return
	run_time += delta
	var duration := Balance.run_duration()
	if not _miniboss_fired and run_time >= duration * Balance.MINIBOSS_FRAC:
		_miniboss_fired = true
		EventBus.miniboss_time.emit()
	if not boss_phase and run_time >= duration:
		# A Alvorada chegou — mas a vitória agora exige derrotar o boss do bioma.
		boss_phase = true
		EventBus.boss_time.emit()

func reset_run() -> void:
	level = 1
	xp = 0.0
	xp_to_next = Balance.xp_for_level(1)
	kills = 0
	run_time = 0.0
	run_luar = 0
	boss_phase = false
	_miniboss_fired = false
	run_active = true
	EventBus.xp_changed.emit(xp, xp_to_next, level)

func add_luar(amount: int) -> void:
	run_luar += amount

var last_luar_gained := 0

func end_run(victory: bool) -> void:
	if not run_active:
		return
	run_active = false
	var luar_mult := 1.0 + 0.10 * SaveManager.tree_level(&"luar")
	last_luar_gained = Balance.luar_for_run(run_luar, kills, level, luar_mult)
	SaveManager.add_luar(last_luar_gained)
	if victory:
		SaveManager.mark_biome_cleared(selected_biome_id)
	EventBus.run_ended.emit(victory)

func _on_boss_defeated() -> void:
	end_run(true)

func add_xp(amount: float) -> void:
	xp += amount
	# `while` cobre coleta que rende mais de um nível de uma vez;
	# a tela de level up enfileira os pendentes.
	while xp >= xp_to_next:
		xp -= xp_to_next
		level += 1
		xp_to_next = Balance.xp_for_level(level)
		EventBus.level_up_ready.emit(level)
	EventBus.xp_changed.emit(xp, xp_to_next, level)

func _on_enemy_killed(_enemy: Node2D) -> void:
	kills += 1

func _on_player_died() -> void:
	end_run(false)

# TODO(fase 2): Cristais de Luar e meta-progressão (Árvore Sagrada).
