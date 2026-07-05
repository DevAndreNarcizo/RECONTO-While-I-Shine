class_name MiniBossTouro
extends Enemy
## Mini-boss do Pantanal — TOURO ATOLADO (docs/06 §5): investidas em linha
## reta telegrafadas que atravessam a arena. Dropa Baú de Luz (bursts do data).

const DATA := preload("res://resources/enemies/touro_atolado.tres")
const TELEGRAPH_TIME := 0.8
const CHARGE_SPEED := 460.0
const CHARGE_DIST := 520.0
const REST_TIME := 1.6

enum State { CHASE, TELEGRAPH, CHARGE, REST }

var player: Player

var _state := State.CHASE
var _t := 2.0
var _charge_target := Vector2.ZERO

func _ready() -> void:
	setup(DATA, global_position)

func _physics_process(delta: float) -> void:
	if player == null:
		return
	var to_player := player.global_position - global_position
	_t -= delta
	match _state:
		State.CHASE:
			set_move_dir(to_player)
			global_position += to_player.normalized() * speed * delta
			if _t <= 0.0 and to_player.length() < 420.0:
				_charge_target = global_position + to_player.normalized() * CHARGE_DIST
				_state = State.TELEGRAPH
				_t = TELEGRAPH_TIME
				queue_redraw()
		State.TELEGRAPH:
			queue_redraw()
			if _t <= 0.0:
				_state = State.CHARGE
				EventBus.screen_shake.emit(3.0)
		State.CHARGE:
			set_move_dir(_charge_target - global_position)
			global_position = global_position.move_toward(_charge_target, CHARGE_SPEED * delta)
			if global_position.distance_squared_to(_charge_target) < 64.0:
				_state = State.REST
				_t = REST_TIME
				queue_redraw()
		State.REST:
			if _t <= 0.0:
				_state = State.CHASE
				_t = 1.2

func die() -> void:
	EventBus.enemy_killed.emit(self)  # PickupPool solta o baú
	EventBus.screen_shake.emit(5.0)
	queue_free()

func _draw() -> void:
	super()
	if _state == State.TELEGRAPH:
		draw_line(Vector2.ZERO, to_local(_charge_target), Color(1, 0.3, 0.2, 0.7), 5.0)
