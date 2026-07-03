extends CanvasLayer
## Tela de Level Up — pausa o jogo e oferece cartas sorteadas do pool válido
## (CardPool). 3 cartas; a Sorte pode conceder uma 4ª. Níveis pendentes
## enfileiram e re-sorteiam.

var player: Player

var _pending := 0
var _cards: Array[Dictionary] = []
var _rng := RandomNumberGenerator.new()

@onready var _buttons: Array[Button] = [
	$Dim/Center/Panel/VBox/Cards/Card1,
	$Dim/Center/Panel/VBox/Cards/Card2,
	$Dim/Center/Panel/VBox/Cards/Card3,
	$Dim/Center/Panel/VBox/Cards/Card4,
]

func _ready() -> void:
	visible = false
	_rng.randomize()
	EventBus.level_up_ready.connect(_on_level_up_ready)
	for i in _buttons.size():
		_buttons[i].pressed.connect(_choose.bind(i))

func _on_level_up_ready(_level: int) -> void:
	_pending += 1
	if not visible:
		_show_cards()

func _show_cards() -> void:
	get_tree().paused = true
	_cards = CardPool.roll(player, _rng)
	if _cards.is_empty():
		_cards = [CardPool.fallback_card()]
	for i in _buttons.size():
		var button := _buttons[i]
		if i < _cards.size():
			button.text = "%s\n\n%s" % [_cards[i]["title"], _cards[i]["desc"]]
			button.visible = true
		else:
			button.visible = false
	_buttons[0].grab_focus()  # navegação por teclado/gamepad
	visible = true

func _choose(index: int) -> void:
	if index >= _cards.size():
		return
	CardPool.apply(_cards[index], player)
	_pending -= 1
	if _pending > 0:
		_show_cards()  # próximo nível pendente: novo sorteio
		return
	visible = false
	get_tree().paused = false
