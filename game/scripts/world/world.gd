extends Node2D
## World — orquestra a run: aplica a lenda escolhida, reseta estado e inicia
## o spawner. Fim de run é tratado por GameState + EndScreen via EventBus.

const DEFAULT_LEGEND := preload("res://resources/legends/curupira.tres")

@onready var player: Player = $Player

func _ready() -> void:
	GameState.reset_run()
	var legend: LegendData = GameState.selected_legend if GameState.selected_legend else DEFAULT_LEGEND
	player.set_legend(legend)
	player.encantos.add_encanto(legend.starting_encanto)
	EnemySpawner.start(player, $Enemies)
	$HUD.player = player
	$LevelUpScreen.player = player
