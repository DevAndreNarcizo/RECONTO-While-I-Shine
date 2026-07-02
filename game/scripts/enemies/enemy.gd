class_name Enemy
extends Area2D
## Inimigo genérico dirigido por EnemyData. Sem _process próprio:
## o movimento é feito em LOTE pelo EnemySpawner (performance para centenas).

var data: EnemyData
var hp: float = 0.0
var speed: float = 0.0

var _flash := false

func setup(p_data: EnemyData, pos: Vector2) -> void:
	data = p_data
	hp = data.max_hp
	speed = data.move_speed
	global_position = pos
	_flash = false
	show()
	set_deferred("monitorable", true)
	queue_redraw()

func take_damage(amount: float) -> void:
	if hp <= 0.0:
		return
	hp -= amount
	_flash = true
	queue_redraw()
	# false = timer respeita pausa do jogo
	get_tree().create_timer(0.08, false).timeout.connect(_end_flash, CONNECT_ONE_SHOT)
	if hp <= 0.0:
		die()

func die() -> void:
	EventBus.enemy_killed.emit(self)
	EnemySpawner.despawn(self)

func _end_flash() -> void:
	_flash = false
	queue_redraw()

func _draw() -> void:
	var radius := data.radius if data else 9.0
	var color := Color.WHITE if _flash else (data.color if data else Color(0.8, 0.2, 0.2))
	draw_circle(Vector2.ZERO, radius, color)
