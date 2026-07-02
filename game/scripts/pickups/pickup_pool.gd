class_name PickupPool
extends Node2D
## Pool de Sementes de Luz. Escuta mortes de inimigos (EventBus) e dropa XP.

const SEED_SCENE := preload("res://scenes/pickups/LightSeed.tscn")

var _pool: Array[LightSeed] = []

func _ready() -> void:
	EventBus.enemy_killed.connect(_on_enemy_killed)

func _on_enemy_killed(enemy: Node2D) -> void:
	var e := enemy as Enemy
	if e and e.data:
		spawn_seed(e.global_position, e.data.xp_value)

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
