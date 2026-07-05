class_name FloodWaves
extends Node2D
## Hazard do Pantanal — o rio TRANSBORDA: ondas periódicas varrem a área
## empurrando player e inimigos. Telegrafada por uma linha de espuma.

const INTERVAL := 40.0
const TELEGRAPH_TIME := 2.0
const WAVE_SPEED := 260.0
const WAVE_WIDTH := 90.0
const WAVE_REACH := 640.0   # meia altura da faixa varrida
const TRAVEL := 1500.0
const PUSH_PLAYER := 520.0
const PUSH_ENEMY := 300.0

enum State { IDLE, TELEGRAPH, WAVE }

var player: Player

var _state := State.IDLE
var _t := INTERVAL * 0.5  # primeira onda mais cedo
var _dir := Vector2.RIGHT
var _origin := Vector2.ZERO
var _travelled := 0.0

func _physics_process(delta: float) -> void:
	if player == null:
		return
	_t -= delta
	match _state:
		State.IDLE:
			if _t <= 0.0:
				_dir = Vector2.RIGHT if randf() < 0.5 else Vector2.LEFT
				_origin = player.global_position - _dir * 700.0
				_state = State.TELEGRAPH
				_t = TELEGRAPH_TIME
				queue_redraw()
		State.TELEGRAPH:
			queue_redraw()
			if _t <= 0.0:
				_state = State.WAVE
				_travelled = 0.0
				EventBus.screen_shake.emit(3.0)
		State.WAVE:
			_travelled += WAVE_SPEED * delta
			_push_entities()
			queue_redraw()
			if _travelled >= TRAVEL:
				_state = State.IDLE
				_t = INTERVAL
				queue_redraw()

func _wave_pos() -> Vector2:
	return _origin + _dir * _travelled

func _push_entities() -> void:
	var wave := _wave_pos()
	# player: empurrão contínuo enquanto está na faixa da onda
	var d := (player.global_position - wave).dot(_dir)
	if absf(d) < WAVE_WIDTH and absf((player.global_position - wave).dot(_dir.orthogonal())) < WAVE_REACH:
		player.external_push = _dir * PUSH_PLAYER
	for e in EnemySpawner.active_enemies():
		var ed := (e.global_position - wave).dot(_dir)
		if absf(ed) < WAVE_WIDTH:
			e.knockback = _dir * PUSH_ENEMY

func _draw() -> void:
	if player == null or _state == State.IDLE:
		return
	if _state == State.TELEGRAPH:
		# linha de espuma na origem: a onda vem DALI
		var base := to_local(_origin)
		var side := _dir.orthogonal() * WAVE_REACH
		var blink := 0.4 + 0.3 * sin(_t * 12.0)
		draw_line(base - side, base + side, Color(0.6, 0.8, 1.0, blink), 5.0)
		return
	# a onda em si: faixa d'água
	var wave := to_local(_wave_pos())
	var across := _dir.orthogonal() * WAVE_REACH
	var along := _dir * WAVE_WIDTH * 0.5
	draw_colored_polygon(PackedVector2Array([
		wave - across - along, wave + across - along,
		wave + across + along, wave - across + along,
	]), Color(0.35, 0.55, 0.8, 0.4))
	draw_line(wave - across + along, wave + across + along, Color(0.85, 0.95, 1.0, 0.8), 4.0)
