extends Node2D
## World — orquestra a run: reseta estado, inicia o spawner e liga a UI.
## Fim de run (morte/tempo) é tratado por GameState + EndScreen via EventBus.

@onready var player: Player = $Player

func _ready() -> void:
	GameState.reset_run()
	EnemySpawner.start(player, $Enemies)
	$HUD.player = player
	$LevelUpScreen.player = player
