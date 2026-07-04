class_name EnemyProjectile
extends Area2D
## Projétil inimigo (sapos/atiradores). Pooled e movido em LOTE pelo EnemySpawner.
## Fica na layer "enemies" — o Hurtbox do player o detecta como dano de contato.

const LIFETIME := 4.0
const SPEED := 150.0

var damage := 6.0
var dir := Vector2.RIGHT
var ttl := 0.0

func launch(pos: Vector2, p_dir: Vector2, p_damage: float) -> void:
	global_position = pos
	dir = p_dir
	damage = p_damage
	ttl = LIFETIME
	show()
	set_deferred("monitorable", true)

func expire() -> void:
	EnemySpawner.despawn_projectile(self)

# Visual: Sprite2D na cena (cusparada venenosa do PixelLab).
