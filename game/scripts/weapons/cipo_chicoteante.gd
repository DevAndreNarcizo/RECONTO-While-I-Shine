class_name CipoChicoteante
extends EncantoBase
## Cipó Chicoteante — golpe em área à FRENTE do player (direção de facing).
## Arma inicial do Curupira. Placeholder: retângulo verde que pisca no golpe.

const HIT_WIDTH := 96.0
const HIT_HEIGHT := 56.0
const HIT_DISTANCE := 46.0
const VISUAL_TIME := 0.15

var _visual_t := 0.0
var _hit_dir := Vector2.RIGHT
var _shape := RectangleShape2D.new()
var _query := PhysicsShapeQueryParameters2D.new()

func _init() -> void:
	display_name = "Cipó Chicoteante"
	damage = 10.0
	cooldown = 1.2
	_query.shape = _shape
	_query.collision_mask = 2  # physics layer "enemies"
	_query.collide_with_areas = true
	_query.collide_with_bodies = false

func _attack() -> void:
	_hit_dir = player.facing
	_visual_t = VISUAL_TIME
	queue_redraw()

	_shape.size = Vector2(HIT_WIDTH, HIT_HEIGHT) * area_scale
	_query.transform = Transform2D(
		_hit_dir.angle(),
		player.global_position + _hit_dir * HIT_DISTANCE * area_scale
	)
	var space := get_world_2d().direct_space_state
	for result in space.intersect_shape(_query, 128):
		var enemy := result.collider as Enemy
		if enemy:
			enemy.take_damage(damage)

func _on_level_up() -> void:
	damage += 4.0
	cooldown = maxf(0.6, cooldown - 0.05)
	if level % 3 == 0:
		area_scale += 0.15

func _process(delta: float) -> void:
	if _visual_t > 0.0:
		_visual_t -= delta
		if _visual_t <= 0.0:
			queue_redraw()

func _draw() -> void:
	if _visual_t <= 0.0:
		return
	draw_set_transform(_hit_dir * HIT_DISTANCE * area_scale, _hit_dir.angle(), Vector2.ONE)
	var size := Vector2(HIT_WIDTH, HIT_HEIGHT) * area_scale
	draw_rect(Rect2(-size / 2.0, size), Color(0.35, 0.8, 0.35, 0.7))
