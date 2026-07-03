extends Node2D
## World — orquestra a run: reseta estado, inicia o spawner, dá a arma inicial.
## Fim de run (morte/tempo) é tratado por GameState + EndScreen via EventBus.

# TODO(fase 3): a arma inicial virá da lenda selecionada (Curupira → Cipó).
const STARTING_ENCANTO := preload("res://resources/encantos/cipo_chicoteante.tres")

@onready var player: Player = $Player

func _ready() -> void:
	GameState.reset_run()
	EnemySpawner.start(player, $Enemies)
	$Player/EncantoManager.add_encanto(STARTING_ENCANTO)
	$HUD.player = player
	$LevelUpScreen.player = player
