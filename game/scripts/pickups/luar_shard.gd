class_name LuarShard
extends Area2D
## Fragmento de Luar — drop raro que vira Cristal de Luar permanente no fim
## da run. Mesmo comportamento de coleta da Semente de Luz. Pooled.

const FLY_SPEED := 300.0
const COLLECT_DISTANCE := 18.0

var _pool: Node
var _target: Node2D

func setup(pool: Node, pos: Vector2) -> void:
	_pool = pool
	global_position = pos
	_target = null
	show()
	set_deferred("monitorable", true)
	set_physics_process(false)

func magnetize(target: Node2D) -> void:
	if _target != null:
		return
	_target = target
	set_deferred("monitorable", false)
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	global_position = global_position.move_toward(_target.global_position, FLY_SPEED * delta)
	if global_position.distance_squared_to(_target.global_position) < COLLECT_DISTANCE * COLLECT_DISTANCE:
		GameState.add_luar(1)
		EventBus.seed_collected.emit(global_position)
		_pool.collect_shard(self)

# Visual: Sprite2D na cena (cristal de luar do PixelLab).
