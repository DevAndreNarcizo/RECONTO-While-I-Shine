extends Node2D
## World — orquestra a run: inicia o spawner e reage à morte do player.

@onready var player: Player = $Player

func _ready() -> void:
	EnemySpawner.start(player, $Enemies)
	$DebugHud.player = player
	EventBus.player_died.connect(_on_player_died)

func _on_player_died() -> void:
	# TODO(fase 1e): substituir por tela de fim de run
	print("GAME OVER")
	get_tree().paused = true
