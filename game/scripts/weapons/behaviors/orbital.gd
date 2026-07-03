class_name EncantoOrbital
extends EncantoBase
## ORBITAL — orbes giram ao redor do player e dão dano por contato.
## (Vaga-lumes Guardiões.) O cooldown do data é o TICK de dano do contato.

const ORBIT_RADIUS := 62.0
const ORB_RADIUS := 7.0
const ROT_SPEED := 2.6  # rad/s

var _angle := 0.0
var _orbs: Array[Area2D] = []

func _on_setup() -> void:
	_rebuild_orbs()

func _on_level_up() -> void:
	_rebuild_orbs()

func _rebuild_orbs() -> void:
	for orb in _orbs:
		orb.queue_free()
	_orbs.clear()
	for i in amount():
		var orb := Area2D.new()
		orb.collision_layer = 0
		orb.collision_mask = 2  # enemies
		orb.monitorable = false
		var cs := CollisionShape2D.new()
		var shape := CircleShape2D.new()
		shape.radius = ORB_RADIUS * area()
		cs.shape = shape
		orb.add_child(cs)
		add_child(orb)
		_orbs.push_back(orb)

func _physics_process(delta: float) -> void:
	super(delta)  # roda o tick de dano (_attack)
	_angle = wrapf(_angle + ROT_SPEED * delta, 0.0, TAU)
	var n := _orbs.size()
	for i in n:
		_orbs[i].position = Vector2.from_angle(_angle + TAU * i / n) * ORBIT_RADIUS * area()
	queue_redraw()

func _attack() -> void:
	for orb in _orbs:
		for a in orb.get_overlapping_areas():
			var enemy := a as Enemy
			if enemy:
				enemy.take_damage(damage())

func _draw() -> void:
	for orb in _orbs:
		draw_circle(orb.position, ORB_RADIUS * area() + 2.0, Color(1.0, 0.9, 0.4, 0.25))
		draw_circle(orb.position, ORB_RADIUS * area(), Color(1.0, 0.85, 0.3))
