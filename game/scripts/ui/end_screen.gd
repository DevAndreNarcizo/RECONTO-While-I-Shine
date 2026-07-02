extends CanvasLayer
## Tela de fim de run — vitória (Alvorada) ou derrota (a Luz se apagou).

@onready var title: Label = $Dim/Center/Panel/VBox/Title
@onready var stats: Label = $Dim/Center/Panel/VBox/Stats
@onready var restart: Button = $Dim/Center/Panel/VBox/Restart

func _ready() -> void:
	visible = false
	EventBus.run_ended.connect(_on_run_ended)
	restart.pressed.connect(_on_restart)

func _on_run_ended(victory: bool) -> void:
	get_tree().paused = true
	visible = true
	title.text = "A Alvorada chegou — a mata não caiu!" if victory else "A Luz se apagou..."
	var t := int(GameState.run_time)
	stats.text = "Tempo sobrevivido: %02d:%02d\nInimigos derrotados: %d\nNível alcançado: %d" % [
		t / 60, t % 60, GameState.kills, GameState.level
	]

func _on_restart() -> void:
	# O pool do spawner vive dentro da cena — precisa esquecer as referências
	# antes do reload, senão apontaria para nós liberados.
	EnemySpawner.reset()
	get_tree().paused = false
	get_tree().reload_current_scene()
