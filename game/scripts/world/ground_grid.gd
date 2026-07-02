extends Node2D
## Chão placeholder da Mata Atlântica — grade "infinita" que acompanha o alvo.
## Redesenha só quando o alvo muda de célula (barato). Trocar por TileMap na Fase 5.

const CELL := 64.0
const COLS := 24  # cobre 1920/2 (zoom 2x) / 64 = 15 células + margem
const ROWS := 16

@export var target: Node2D

var _last_cell := Vector2i(2147483647, 2147483647)

func _process(_delta: float) -> void:
	if target == null:
		return
	var cell := Vector2i((target.global_position / CELL).floor())
	if cell != _last_cell:
		_last_cell = cell
		queue_redraw()

func _draw() -> void:
	if target == null:
		return
	var base := Color(0.09, 0.23, 0.14)
	var alt := Color(0.11, 0.26, 0.16)
	var center := Vector2i((target.global_position / CELL).floor())
	var half := Vector2i(COLS / 2, ROWS / 2)
	for y in range(-half.y, half.y + 1):
		for x in range(-half.x, half.x + 1):
			var c := center + Vector2i(x, y)
			var color := base if posmod(c.x + c.y, 2) == 0 else alt
			draw_rect(Rect2(Vector2(c) * CELL, Vector2(CELL, CELL)), color)
