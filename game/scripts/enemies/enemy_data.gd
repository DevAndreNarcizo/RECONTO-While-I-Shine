class_name EnemyData
extends Resource
## Dados de um tipo de inimigo (criar variações como .tres em resources/enemies/).
## O comportamento é processado em LOTE pelo EnemySpawner (docs/04 §3).

enum Behavior {
	CHASE,    # Enxame/Médio: corre no player
	ZIGZAG,   # Enxame esquivo: corre com onda lateral
	SHOOTER,  # Atirador: mantém distância e atira
	TANK,     # Tanque: lento, muito HP, resiste a knockback
	ELITE,    # Corrompido especial: brilho roxo, recompensa ao morrer
}

@export var display_name: String = "Inimigo"
@export var behavior: Behavior = Behavior.CHASE
@export var max_hp: float = 1.0
@export var contact_damage: float = 5.0
@export var move_speed: float = 45.0
@export var radius: float = 9.0
@export var color: Color = Color(0.8, 0.2, 0.2)
@export var xp_value: int = 1
@export var knockback_scale := 1.0  # tanques resistem (< 1)

@export_group("Recompensa ao morrer")
@export var seed_burst := 1   # quantas Sementes de Luz dropa
@export var shard_burst := 0  # Fragmentos de Luar garantidos (elite/boss)

@export_group("Atirador")
@export var shoot_interval := 2.8
@export var projectile_damage := 6.0
@export var keep_distance := 200.0  # tenta ficar a essa distância do player
