class_name MiniBossPreguica
extends Enemy
## Mini-boss "Bicho-Preguiça Desperto" (docs/06 §5) — quase parado, mas puxa
## o player com cipós, telegrafado. Não é pooled: nasce e morre na cena.
## Herda de Enemy: leva dano das armas e dropa o "baú" (bursts do EnemyData).

const DATA := preload("res://resources/enemies/preguica_desperta.tres")
const PULL_RANGE := 420.0
const PULL_FORCE := 240.0
const TELEGRAPH_TIME := 1.0
const PULL_TIME := 0.6
const REST_TIME := 2.2

enum State { CHASE, TELEGRAPH, PULL, REST }

var player: Player

var _state := State.CHASE
var _t := 0.0

func _ready() -> void:
	setup(DATA, global_position)

func _physics_process(delta: float) -> void:
	if player == null:
		return
	var to_player := player.global_position - global_position
	set_move_dir(to_player)  # a preguiça sempre encara o player
	_t -= delta
	match _state:
		State.CHASE:
			global_position += to_player.normalized() * speed * delta
			if to_player.length() < PULL_RANGE:
				_enter(State.TELEGRAPH, TELEGRAPH_TIME)
		State.TELEGRAPH:
			if _t <= 0.0:
				_enter(State.PULL, PULL_TIME)
		State.PULL:
			# puxa o player na direção do bicho — obriga a reagir
			player.external_push = -to_player.normalized() * PULL_FORCE
			if _t <= 0.0:
				_enter(State.REST, REST_TIME)
		State.REST:
			if _t <= 0.0:
				_enter(State.CHASE, 0.0)

func _enter(state: State, time: float) -> void:
	_state = state
	_t = time
	queue_redraw()

func die() -> void:
	EventBus.enemy_killed.emit(self)  # PickupPool solta o baú (seed/shard burst)
	EventBus.screen_shake.emit(5.0)
	queue_free()

func _process(_delta: float) -> void:
	if _state == State.TELEGRAPH or _state == State.PULL:
		queue_redraw()  # a linha acompanha o player

func _draw() -> void:
	super()
	if player and (_state == State.TELEGRAPH or _state == State.PULL):
		var color := Color(1.0, 0.85, 0.3, 0.5) if _state == State.TELEGRAPH else Color(0.45, 0.9, 0.45, 0.9)
		draw_line(Vector2.ZERO, to_local(player.global_position), color, 3.0)
