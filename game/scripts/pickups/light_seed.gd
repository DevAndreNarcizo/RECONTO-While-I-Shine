class_name LightSeed
extends Area2D
## Semente de Luz (XP dropado por inimigos). Pooled pelo PickupPool.
## Fica parada até o MagnetArea do player alcançá-la; então voa até ele.

const FLY_SPEED := 320.0
const COLLECT_DISTANCE := 18.0

var xp_value := 1

var _pool: Node
var _target: Node2D

func setup(pool: Node, pos: Vector2, xp: int) -> void:
	_pool = pool
	global_position = pos
	xp_value = xp
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
		GameState.add_xp(xp_value)
		_pool.collect(self)

func _draw() -> void:
	draw_colored_polygon(
		PackedVector2Array([Vector2(0, -7), Vector2(5, 0), Vector2(0, 7), Vector2(-5, 0)]),
		Color("ffd25e")
	)
	draw_circle(Vector2.ZERO, 2.5, Color(1, 1, 0.9))
