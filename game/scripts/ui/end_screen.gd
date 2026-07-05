extends CanvasLayer
## Tela de fim de run — vitória (Alvorada) ou derrota (a Luz se apagou).
## Mostra o Luar ganho e leva de volta ao ciclo: jogar de novo ou Árvore Sagrada.

@onready var title: Label = $Dim/Center/Panel/VBox/Title
@onready var stats: Label = $Dim/Center/Panel/VBox/Stats
@onready var restart: Button = $Dim/Center/Panel/VBox/Restart
@onready var tree_button: Button = $Dim/Center/Panel/VBox/TreeButton

func _ready() -> void:
	visible = false
	EventBus.run_ended.connect(_on_run_ended)
	restart.pressed.connect(_on_restart)
	tree_button.pressed.connect(_on_tree)

func _on_run_ended(victory: bool) -> void:
	get_tree().paused = true
	visible = true
	title.text = tr("END_VICTORY") if victory else tr("END_DEFEAT")
	var t := int(GameState.run_time)
	stats.text = tr("END_STATS") % [
		t / 60, t % 60, GameState.kills, GameState.level,
		GameState.last_luar_gained, SaveManager.luar,
	]
	restart.grab_focus()

func _on_restart() -> void:
	_leave()
	get_tree().reload_current_scene()

func _on_tree() -> void:
	_leave()
	get_tree().change_scene_to_file("res://scenes/ui/SacredTree.tscn")

func _leave() -> void:
	# O pool do spawner vive dentro da cena — esquecer referências antes de sair.
	EnemySpawner.reset()
	get_tree().paused = false
