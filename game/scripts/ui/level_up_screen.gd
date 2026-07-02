extends CanvasLayer
## Tela de Level Up — pausa o jogo e oferece 3 cartas placeholder.
## (Fase 2 substitui pelas cartas reais de Encantos/Amuletos com raridade.)

var player: Player

var _pending := 0

@onready var _cards: Array[Button] = [
	$Dim/Center/Panel/VBox/Cards/Card1,
	$Dim/Center/Panel/VBox/Cards/Card2,
	$Dim/Center/Panel/VBox/Cards/Card3,
]

func _ready() -> void:
	visible = false
	EventBus.level_up_ready.connect(_on_level_up_ready)
	for i in _cards.size():
		_cards[i].pressed.connect(_choose.bind(i))

func _on_level_up_ready(_level: int) -> void:
	_pending += 1
	if not visible:
		get_tree().paused = true
		visible = true

func _choose(index: int) -> void:
	var weapons := player.get_node("Weapons")
	match index:
		0:  # +Dano (global, placeholder)
			for w in weapons.get_children():
				w.damage *= 1.15
		1:  # +Velocidade
			player.move_speed += 10.0
		2:  # +Cipó nível
			(weapons.get_node("CipoChicoteante") as EncantoBase).level_up()

	_pending -= 1
	if _pending > 0:
		return  # mais níveis na fila: continua pausado, escolhe de novo
	visible = false
	get_tree().paused = false
