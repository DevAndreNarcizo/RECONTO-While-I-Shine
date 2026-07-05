class_name FissureField
extends Node2D
## Hazard da Caatinga — o chão RACHA: fendas abrem perto do player, telegrafadas
## por uma rachadura crescente, depois ERUPTEM fogo por um instante ferindo quem
## estiver em cima. Fere player e inimigos. Boitatá (fire_immune) ignora o fogo.

const INTERVAL := 5.0
const TELEGRAPH_TIME := 1.1
const ERUPT_TIME := 0.6
const COUNT_MIN := 2
const COUNT_MAX := 4
const RADIUS := 46.0
const SPAWN_RANGE := 480.0
const DPS := 22.0

var player: Player

var _t := INTERVAL * 0.6
# cada fenda: {pos, state ("telegraph"/"erupt"), t}
var _fissures: Array[Dictionary] = []

func _physics_process(delta: float) -> void:
	if player == null:
		return
	_t -= delta
	if _t <= 0.0:
		_t = INTERVAL
		_open_fissures()

	var still_active: Array[Dictionary] = []
	for f in _fissures:
		f["t"] = float(f["t"]) - delta
		if f["state"] == "telegraph":
			if float(f["t"]) <= 0.0:
				f["state"] = "erupt"
				f["t"] = ERUPT_TIME
				EventBus.screen_shake.emit(2.0)
			still_active.push_back(f)
		else:  # erupt
			_damage_at(f["pos"])
			if float(f["t"]) > 0.0:
				still_active.push_back(f)
	_fissures = still_active
	if not _fissures.is_empty():
		queue_redraw()

func _open_fissures() -> void:
	var count := randi_range(COUNT_MIN, COUNT_MAX)
	for i in count:
		var pos := player.global_position + Vector2.from_angle(randf() * TAU) * randf_range(80.0, SPAWN_RANGE)
		_fissures.push_back({"pos": pos, "state": "telegraph", "t": TELEGRAPH_TIME})
	queue_redraw()

func _damage_at(pos: Vector2) -> void:
	var dmg := DPS * get_physics_process_delta_time()
	for e in EnemySpawner.active_enemies():
		if pos.distance_squared_to(e.global_position) < RADIUS * RADIUS:
			e.take_damage(dmg)
	if pos.distance_squared_to(player.global_position) < RADIUS * RADIUS:
		if not (player.legend and player.legend.fire_immune):
			player.take_damage(dmg)

func _draw() -> void:
	for f in _fissures:
		var c := to_local(f["pos"])
		if f["state"] == "telegraph":
			# rachadura crescendo (aviso): quanto menos tempo, mais aberta
			var grow: float = 1.0 - clampf(float(f["t"]) / TELEGRAPH_TIME, 0.0, 1.0)
			var blink := 0.3 + 0.4 * grow
			draw_arc(c, RADIUS * grow, 0, TAU, 20, Color(0.9, 0.4, 0.15, blink), 2.0)
			for a in 5:
				var ang := TAU * a / 5.0
				draw_line(c, c + Vector2.from_angle(ang) * RADIUS * grow, Color(0.5, 0.25, 0.1, blink), 2.0)
		else:
			# erupção: fogo saindo da fenda
			draw_circle(c, RADIUS, Color(0.95, 0.45, 0.12, 0.4))
			draw_arc(c, RADIUS, 0, TAU, 24, Color(1.0, 0.7, 0.2, 0.9), 3.0)
