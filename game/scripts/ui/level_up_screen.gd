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

# Placeholder até a fase 2.3 (cartas dinâmicas com sorteio de pool).
const NEW_ENCANTOS := [
	preload("res://resources/encantos/vagalumes_guardioes.tres"),
	preload("res://resources/encantos/pedra_do_saci.tres"),
	preload("res://resources/encantos/relampago_do_trovao.tres"),
]

func _choose(index: int) -> void:
	var manager: EncantoManager = player.get_node("EncantoManager")
	match index:
		0:  # Novo Encanto (o primeiro do pool que ainda não tem)
			for data in NEW_ENCANTOS:
				if not manager.has_encanto(data.id) and manager.add_encanto(data):
					break
		1:  # +Velocidade
			player.move_speed += 10.0
		2:  # +Cipó nível
			manager.upgrade(&"cipo_chicoteante")

	_pending -= 1
	if _pending > 0:
		return  # mais níveis na fila: continua pausado, escolhe de novo
	visible = false
	get_tree().paused = false
