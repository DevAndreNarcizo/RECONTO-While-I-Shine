class_name MiniBossCarcara
extends Enemy
## Mini-boss da Caatinga — CARCARÁ REI: circula alto e MERGULHA sobre o player,
## telegrafado por uma sombra que encolhe. Dropa Baú de Luz (bursts do data).

const DATA := preload("res://resources/enemies/carcara_rei.tres")
const CIRCLE_DIST := 260.0
const CIRCLE_SPEED := 130.0
const CIRCLE_TIME := 1.6
const TELEGRAPH_TIME := 0.7
const DIVE_SPEED := 620.0
const DIVE_RADIUS := 50.0
const DIVE_DAMAGE := 16.0
const REST_TIME := 1.0

enum State { CIRCLE, TELEGRAPH, DIVE, REST }

var player: Player

var _state := State.CIRCLE
var _t := CIRCLE_TIME
var _mark := Vector2.ZERO
var _orbit_sign := 1.0

func _ready() -> void:
	setup(DATA, global_position)

func _physics_process(delta: float) -> void:
	if player == null:
		return
	_t -= delta
	match _state:
		State.CIRCLE:
			var to_player := player.global_position - global_position
			var tangent := to_player.orthogonal().normalized() * _orbit_sign
			var radial := to_player.normalized() * clampf((to_player.length() - CIRCLE_DIST) * 0.02, -1.0, 1.0)
			var dir := (tangent + radial).normalized()
			set_move_dir(dir)
			global_position += dir * CIRCLE_SPEED * delta
			if _t <= 0.0:
				_mark = player.global_position
				_state = State.TELEGRAPH
				_t = TELEGRAPH_TIME
				queue_redraw()
		State.TELEGRAPH:
			queue_redraw()
			if _t <= 0.0:
				_state = State.DIVE
		State.DIVE:
			set_move_dir(_mark - global_position)
			global_position = global_position.move_toward(_mark, DIVE_SPEED * delta)
			if global_position.distance_squared_to(_mark) < 100.0:
				_land()
		State.REST:
			if _t <= 0.0:
				_orbit_sign = -_orbit_sign
				_state = State.CIRCLE
				_t = CIRCLE_TIME

func _land() -> void:
	EventBus.screen_shake.emit(4.0)
	if player.global_position.distance_to(global_position) < DIVE_RADIUS:
		player.take_damage(DIVE_DAMAGE)
	_state = State.REST
	_t = REST_TIME
	queue_redraw()

func die() -> void:
	EventBus.enemy_killed.emit(self)
	EventBus.screen_shake.emit(5.0)
	queue_free()

func _draw() -> void:
	super()
	if _state == State.TELEGRAPH:
		var grow: float = clampf(_t / TELEGRAPH_TIME, 0.0, 1.0)
		var local_mark := to_local(_mark)
		draw_circle(local_mark, DIVE_RADIUS * (0.5 + grow), Color(0, 0, 0, 0.3))
		draw_arc(local_mark, DIVE_RADIUS, 0, TAU, 20, Color(1, 0.4, 0.2, 0.8), 3.0)
