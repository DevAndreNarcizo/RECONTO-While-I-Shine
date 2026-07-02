extends Node
## GameState — estado da run atual (nível, XP, kills, tempo).

var level := 1
var xp := 0.0
var xp_to_next := 5.0
var kills := 0
var run_time := 0.0
var run_active := false

func _ready() -> void:
	EventBus.enemy_killed.connect(_on_enemy_killed)

func reset_run() -> void:
	level = 1
	xp = 0.0
	xp_to_next = Balance.xp_for_level(1)
	kills = 0
	run_time = 0.0
	run_active = true
	EventBus.xp_changed.emit(xp, xp_to_next, level)

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

# TODO(fase 2): Cristais de Luar e meta-progressão (Árvore Sagrada).
