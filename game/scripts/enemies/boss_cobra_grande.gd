class_name BossCobraGrande
extends Enemy
## Boss do Pantanal — COBRA-GRANDE (docs/06 §6).
## F1: submersa (só a marola), bote VERTICAL telegrafado onde você está.
## F2 (≤60%): cada bote invoca piranhas.
## F3 (≤25%): botes encadeados mais rápidos.
## Derrotá-la = vitória do bioma.

const DATA := preload("res://resources/enemies/cobra_grande.tres")
const SUBMERGE_TIME := 2.6
const TELEGRAPH_TIME := 0.9
const STRIKE_RADIUS := 64.0
const STRIKE_DAMAGE := 16.0
const SURFACE_TIME := 1.6

enum State { SUBMERGED, TELEGRAPH, SURFACED }

var player: Player

var _state := State.SUBMERGED
var _t := SUBMERGE_TIME
var _mark := Vector2.ZERO
var _phase := 1

func _ready() -> void:
	setup(DATA, global_position)
	_submerge()

func take_damage(amount: float, from := Vector2.INF) -> void:
	super(amount, from)
	if hp <= 0.0:
		return
	if _phase == 1 and hp <= data.max_hp * 0.6:
		_phase = 2
		EventBus.screen_shake.emit(6.0)
	elif _phase == 2 and hp <= data.max_hp * 0.25:
		_phase = 3
		EventBus.screen_shake.emit(9.0)

func die() -> void:
	EventBus.enemy_killed.emit(self)
	EventBus.screen_shake.emit(10.0)
	EventBus.boss_defeated.emit()  # vitória do bioma
	queue_free()

func _submerge() -> void:
	_state = State.SUBMERGED
	_t = SUBMERGE_TIME / (1.6 if _phase == 3 else 1.0)
	modulate.a = 0.3
	set_deferred("monitorable", false)  # sob a água: intocável, siga a marola
	queue_redraw()

func _physics_process(delta: float) -> void:
	if player == null:
		return
	_t -= delta
	match _state:
		State.SUBMERGED:
			var to_player := player.global_position - global_position
			set_move_dir(to_player)
			global_position += to_player.normalized() * speed * delta
			if _t <= 0.0:
				_mark = player.global_position  # o bote sobe AQUI
				_state = State.TELEGRAPH
				_t = TELEGRAPH_TIME / (1.5 if _phase == 3 else 1.0)
				queue_redraw()
		State.TELEGRAPH:
			queue_redraw()
			if _t <= 0.0:
				_strike()
		State.SURFACED:
			if _t <= 0.0:
				_submerge()

func _strike() -> void:
	global_position = _mark
	modulate.a = 1.0
	set_deferred("monitorable", true)
	EventBus.screen_shake.emit(5.0)
	if player.global_position.distance_to(_mark) < STRIKE_RADIUS:
		player.take_damage(STRIKE_DAMAGE)
	if _phase >= 2:
		EnemySpawner.spawn_burst(&"piranha", 5)  # as águas fervem
	_state = State.SURFACED
	_t = SURFACE_TIME / (1.4 if _phase == 3 else 1.0)
	queue_redraw()

func _draw() -> void:
	super()
	if _state == State.SUBMERGED:
		draw_arc(Vector2.ZERO, data.radius + 8.0, 0, TAU, 18, Color(0.5, 0.7, 0.8, 0.6), 3.0)
	elif _state == State.TELEGRAPH:
		var local_mark := to_local(_mark)
		draw_circle(local_mark, STRIKE_RADIUS, Color(0.2, 0.4, 0.7, 0.3))
		draw_arc(local_mark, STRIKE_RADIUS, 0, TAU, 24, Color(0.4, 0.8, 1.0, 0.9), 3.0)
