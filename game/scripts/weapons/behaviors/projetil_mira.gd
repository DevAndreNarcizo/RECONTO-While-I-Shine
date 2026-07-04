class_name EncantoProjetilMira
extends EncantoBase
## PROJETIL_MIRA — Peixeira Voadora: lâminas retas no inimigo mais próximo,
## atravessando `pierce` alvos. Vários projéteis saem em leque.
## Projéteis geridos em lote (dicionários) — sem nós extras.

const BASE_SPEED := 300.0
const HIT_RADIUS := 10.0
const LIFETIME := 1.6
const FAN_STEP := 0.18  # rad entre lâminas do leque

var _projectiles: Array[Dictionary] = []
var _shape := CircleShape2D.new()
var _query := PhysicsShapeQueryParameters2D.new()

func _on_setup() -> void:
	_shape.radius = HIT_RADIUS
	_query.shape = _shape
	_query.collision_mask = 2  # enemies
	_query.collide_with_areas = true
	_query.collide_with_bodies = false

func _attack() -> void:
	var base_dir := player.facing
	var nearest := EnemySpawner._nearest_hostile(player.global_position, 500.0)
	if nearest:
		base_dir = (nearest.global_position - player.global_position).normalized()
	var n := amount()
	for i in n:
		var spread := (i - (n - 1) / 2.0) * FAN_STEP
		_projectiles.push_back({
			"pos": player.global_position,
			"dir": base_dir.rotated(spread),
			"ttl": LIFETIME,
			"left": data.pierce,
			"hit": [],
		})

func _physics_process(delta: float) -> void:
	super(delta)
	if _projectiles.is_empty():
		return
	var speed := BASE_SPEED * player.stats.projectile_speed_mult * GameState.projectile_env_mult
	var space := get_world_2d().direct_space_state
	var alive: Array[Dictionary] = []
	for p in _projectiles:
		p["ttl"] = float(p["ttl"]) - delta
		p["pos"] = (p["pos"] as Vector2) + (p["dir"] as Vector2) * speed * delta
		if float(p["ttl"]) > 0.0 and _hit_enemies(p, space):
			alive.push_back(p)
	_projectiles = alive
	queue_redraw()

## Aplica dano a inimigos novos no caminho. Retorna false quando o projétil acaba.
func _hit_enemies(p: Dictionary, space: PhysicsDirectSpaceState2D) -> bool:
	_query.transform = Transform2D(0.0, p["pos"])
	var hit: Array = p["hit"]
	for result in space.intersect_shape(_query, 8):
		var enemy := result.collider as Enemy
		if enemy == null or hit.has(enemy.get_instance_id()):
			continue
		enemy.take_damage(damage(), p["pos"])
		hit.push_back(enemy.get_instance_id())
		p["left"] = int(p["left"]) - 1
		if int(p["left"]) <= 0:
			return false
	return true

func _draw() -> void:
	for p in _projectiles:
		var local := to_local(p["pos"])
		var dir: Vector2 = p["dir"]
		# lâmina prateada alongada na direção do voo
		draw_colored_polygon(PackedVector2Array([
			local + dir * 10.0,
			local - dir * 6.0 + dir.orthogonal() * 3.0,
			local - dir * 6.0 - dir.orthogonal() * 3.0,
		]), Color(0.8, 0.85, 0.9))
