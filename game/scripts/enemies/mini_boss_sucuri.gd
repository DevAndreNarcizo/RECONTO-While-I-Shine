class_name MiniBossSucuri
extends Enemy
## Mini-boss da Amazônia — SUCURI DE LAMA (docs/06 §5). Submerge na lama
## (intocável, só a marola denuncia), emerge telegrafada e dá o bote em linha.
## Herda de Enemy: dropa o Baú de Luz via bursts do EnemyData.

const DATA := preload("res://resources/enemies/sucuri_de_lama.tres")
const SUBMERGE_SPEED := 110.0
const SUBMERGE_TIME := 2.4
const TELEGRAPH_TIME := 0.7
const LUNGE_SPEED := 480.0
const LUNGE_DIST := 340.0
const REST_TIME := 1.8

enum State { SUBMERGED, TELEGRAPH, LUNGE, REST }

var player: Player

var _state := State.SUBMERGED
var _t := SUBMERGE_TIME
var _lunge_target := Vector2.ZERO

func _ready() -> void:
	setup(DATA, global_position)
	_submerge()

func _submerge() -> void:
	_state = State.SUBMERGED
	_t = SUBMERGE_TIME
	modulate.a = 0.35
	set_deferred("monitorable", false)  # sob a lama: armas e contato não alcançam
	queue_redraw()

func _physics_process(delta: float) -> void:
	if player == null:
		return
	var to_player := player.global_position - global_position
	_t -= delta
	match _state:
		State.SUBMERGED:
			set_move_dir(to_player)
			global_position += to_player.normalized() * SUBMERGE_SPEED * delta
			if _t <= 0.0 or to_player.length() < 120.0:
				_emerge(to_player)
		State.TELEGRAPH:
			queue_redraw()
			if _t <= 0.0:
				_state = State.LUNGE
		State.LUNGE:
			set_move_dir(_lunge_target - global_position)
			global_position = global_position.move_toward(_lunge_target, LUNGE_SPEED * delta)
			if global_position.distance_squared_to(_lunge_target) < 64.0:
				_state = State.REST
				_t = REST_TIME
				queue_redraw()
		State.REST:
			if _t <= 0.0:
				_submerge()

func _emerge(to_player: Vector2) -> void:
	_state = State.TELEGRAPH
	_t = TELEGRAPH_TIME
	modulate.a = 1.0
	set_deferred("monitorable", true)
	_lunge_target = global_position + to_player.normalized() * LUNGE_DIST
	queue_redraw()

func die() -> void:
	EventBus.enemy_killed.emit(self)  # PickupPool solta o baú
	EventBus.screen_shake.emit(5.0)
	queue_free()

func _draw() -> void:
	super()
	if _state == State.SUBMERGED:
		# a marola na lama é o único aviso
		draw_arc(Vector2.ZERO, data.radius + 6.0, 0, TAU, 16, Color(0.5, 0.4, 0.25, 0.6), 3.0)
	elif _state == State.TELEGRAPH:
		draw_line(Vector2.ZERO, to_local(_lunge_target), Color(1, 0.3, 0.2, 0.7), 4.0)
