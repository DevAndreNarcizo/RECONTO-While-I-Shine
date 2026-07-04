class_name EncantoAreaPlayer
extends EncantoBase
## AREA_PLAYER — Roda do Boitatá: aura de fogo contínua ao redor do player.
## O cooldown do data é o TICK de dano. Passiva (não usa o gatilho manual).
## Forma ancestral "Fogaréu" (data.ignites) incendeia o chão (bioma reativo).

const RING_RADIUS := 78.0
const SPIN_SPEED := 2.6

var _spin := 0.0

func _is_passive() -> bool:
	return true  # o fogo do Boitatá nunca dorme

func _physics_process(delta: float) -> void:
	super(delta)
	_spin = wrapf(_spin + SPIN_SPEED * delta, 0.0, TAU)
	queue_redraw()

func _attack() -> void:
	var reach := RING_RADIUS * area()
	damage_circle(player.global_position, reach, damage())
	if data.ignites:
		# Fogaréu: a borda da roda acende a vegetação
		EventBus.fire_started.emit(
			player.global_position + Vector2.from_angle(randf() * TAU) * reach
		)

func _draw() -> void:
	var reach := RING_RADIUS * area()
	# chamas correndo pela borda da roda
	for i in 8:
		var start := _spin + TAU * i / 8.0
		draw_arc(Vector2.ZERO, reach, start, start + 0.5, 6, Color(1.0, 0.55, 0.15, 0.85), 4.0)
		draw_arc(Vector2.ZERO, reach - 5.0, start + 0.25, start + 0.6, 5, Color(1.0, 0.8, 0.3, 0.5), 2.5)
	if data and data.ignites:
		draw_arc(Vector2.ZERO, reach + 5.0, 0, TAU, 32, Color(0.3, 0.6, 1.0, 0.25), 2.0)
