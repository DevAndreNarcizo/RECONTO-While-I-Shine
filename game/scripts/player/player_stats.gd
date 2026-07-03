class_name PlayerStats
extends RefCounted
## Agregador central de stats (GDD §5): base + amuletos + (futuro) Árvore Sagrada.
## Regra: SEMPRE recalcular do zero (reset + aplicar tudo) — nunca acumular
## bônus por cima de bônus, senão upgrades duplicam.

# --- Valores base (GDD §5; move_speed calibrado p/ câmera 2x — tunar aqui) ---
const BASE_MAX_HP := 100.0
const BASE_RECOVERY := 0.0
const BASE_ARMOR := 0.0
const BASE_MOVE_SPEED := 90.0
const BASE_MAGNETISM := 50.0

var max_hp := BASE_MAX_HP
var recovery := BASE_RECOVERY          # HP por segundo
var armor := BASE_ARMOR                # reduz dano por hit (mín. 1)
var move_speed := BASE_MOVE_SPEED
var damage_mult := 1.0
var attack_speed_mult := 1.0           # divide o cooldown dos encantos
var area_mult := 1.0
var duration_mult := 1.0
var amount_bonus := 0                  # projéteis/instâncias extras
var projectile_speed_mult := 1.0
var luck := 1.0                        # afeta cartas/drops
var magnetism := BASE_MAGNETISM        # raio de coleta em px
var xp_mult := 1.0
var luar_mult := 1.0

func reset() -> void:
	max_hp = BASE_MAX_HP
	recovery = BASE_RECOVERY
	armor = BASE_ARMOR
	move_speed = BASE_MOVE_SPEED
	damage_mult = 1.0
	attack_speed_mult = 1.0
	area_mult = 1.0
	duration_mult = 1.0
	amount_bonus = 0
	projectile_speed_mult = 1.0
	luck = 1.0
	magnetism = BASE_MAGNETISM
	xp_mult = 1.0
	luar_mult = 1.0
