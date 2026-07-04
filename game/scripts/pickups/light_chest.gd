class_name LightChest
extends Area2D
## Baú de Luz — dropado por elites e mini-boss. Ao ser tocado pelo player:
## se houver Ritual de Sincretismo elegível, EVOLUI o encanto (forma
## ancestral); senão, explode em Luz (XP grande). Raro — não precisa de pool.

const FALLBACK_XP := 25.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	var pl := body as Player
	if pl == null:
		return
	var options := Evolutions.eligible(pl)
	if options.is_empty():
		GameState.add_xp(FALLBACK_XP * pl.stats.xp_mult)
	else:
		Evolutions.apply(options[0], pl)
	EventBus.seed_collected.emit(global_position)
	EventBus.screen_shake.emit(3.0)
	queue_free()

func _draw() -> void:
	draw_rect(Rect2(-10, -8, 20, 16), Color(0.85, 0.65, 0.2))
	draw_rect(Rect2(-10, -8, 20, 6), Color(1.0, 0.85, 0.4))
	draw_arc(Vector2.ZERO, 16.0, 0, TAU, 20, Color(1.0, 0.9, 0.5, 0.5), 2.0)
