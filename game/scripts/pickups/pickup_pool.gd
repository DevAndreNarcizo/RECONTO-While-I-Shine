class_name PickupPool
extends Node2D
## Pool de Sementes de Luz. Escuta mortes de inimigos (EventBus) e dropa XP.

const SEED_SCENE := preload("res://scenes/pickups/LightSeed.tscn")
const SHARD_SCENE := preload("res://scenes/pickups/LuarShard.tscn")
const CHEST_SCENE := preload("res://scenes/pickups/LightChest.tscn")

var _pool: Array[LightSeed] = []
var _shard_pool: Array[LuarShard] = []

func _ready() -> void:
	EventBus.enemy_killed.connect(_on_enemy_killed)

func _on_enemy_killed(enemy: Node2D) -> void:
	var e := enemy as Enemy
	if e == null or e.data == null:
		return
	# "Baú" de elite/boss = rajada de sementes + fragmentos garantidos
	for i in e.data.seed_burst:
		spawn_seed(e.global_position + _spread(i), e.data.xp_value)
	for i in e.data.shard_burst:
		spawn_shard(e.global_position + _spread(i + 3))
	if e.data.shard_burst == 0 and randf() < Balance.LUAR_DROP_CHANCE:
		spawn_shard(e.global_position + Vector2(10, 0))
	if e.data.drops_chest:
		var chest: LightChest = CHEST_SCENE.instantiate()
		add_child(chest)
		chest.global_position = e.global_position

func _spread(i: int) -> Vector2:
	if i == 0:
		return Vector2.ZERO
	return Vector2.from_angle(randf() * TAU) * randf_range(12.0, 34.0)

func spawn_seed(pos: Vector2, xp: int) -> void:
	var seed_node: LightSeed
	if _pool.is_empty():
		seed_node = SEED_SCENE.instantiate()
		add_child(seed_node)
	else:
		seed_node = _pool.pop_back()
	seed_node.setup(self, pos, xp)

func collect(seed_node: LightSeed) -> void:
	seed_node.hide()
	seed_node.set_deferred("monitorable", false)
	seed_node.set_physics_process(false)
	_pool.push_back(seed_node)

func spawn_shard(pos: Vector2) -> void:
	var shard: LuarShard
	if _shard_pool.is_empty():
		shard = SHARD_SCENE.instantiate()
		add_child(shard)
	else:
		shard = _shard_pool.pop_back()
	shard.setup(self, pos)

func collect_shard(shard: LuarShard) -> void:
	shard.hide()
	shard.set_deferred("monitorable", false)
	shard.set_physics_process(false)
	_shard_pool.push_back(shard)
