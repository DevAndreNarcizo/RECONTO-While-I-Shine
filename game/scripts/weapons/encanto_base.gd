class_name EncantoBase
extends Node2D
## Base de todo Encanto (arma). Ataque AUTOMÁTICO por cooldown — o jogador não aperta botão.
## Teremos ~20 encantos (melee, projétil, orbital, área, conversão, invocação):
## subclasses implementam _attack() e _on_level_up().

@export var display_name := "Encanto"
@export var damage := 10.0
@export var cooldown := 1.2
@export var area_scale := 1.0
@export var amount := 1  # projéteis/instâncias extras (stat Quantidade)

var level := 1
var player: Player

var _cd := 0.0

func _ready() -> void:
	player = owner as Player

func _physics_process(delta: float) -> void:
	_cd -= delta
	if _cd <= 0.0:
		_cd = cooldown
		_attack()

func level_up() -> void:
	level += 1
	_on_level_up()

## Virtual: executa um ataque.
func _attack() -> void:
	pass

## Virtual: melhoria por nível (dano, área, cooldown...).
func _on_level_up() -> void:
	pass
