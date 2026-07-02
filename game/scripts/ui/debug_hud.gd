extends CanvasLayer
## HUD de debug provisório (vira HUD real na fase 1e).

var player: Player

@onready var label: Label = $Label

func _process(_delta: float) -> void:
	if player == null:
		return
	label.text = "Inimigos ativos: %d\nHP: %.0f / %.0f\nNível %d — XP %.0f / %.0f\nFPS: %d" % [
		EnemySpawner.active_count(), player.hp, player.max_hp,
		GameState.level, GameState.xp, GameState.xp_to_next,
		Engine.get_frames_per_second()
	]
