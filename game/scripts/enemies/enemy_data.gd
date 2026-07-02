class_name EnemyData
extends Resource
## Dados de um tipo de inimigo (criar variações como .tres em resources/enemies/).

@export var display_name: String = "Inimigo"
@export var max_hp: float = 1.0
@export var contact_damage: float = 5.0
@export var move_speed: float = 45.0
@export var radius: float = 9.0
@export var color: Color = Color(0.8, 0.2, 0.2)
@export var xp_value: int = 1
