class_name Balance
## Tabelas de balanceamento — só dados/fórmulas, sem estado.
## Regra do GDD §5: ajustar aqui, não espalhar números pelo código.

const XP_BASE := 5.0
const XP_GROWTH := 1.2  # cada nível exige ~20% mais

# Duração da run (GDD §3.3). DEV_MODE encurta para testar rápido.
const DEV_MODE := true
const RUN_DURATION := 30.0 * 60.0
const DEV_RUN_DURATION := 5.0 * 60.0

# --- Cristais de Luar (meta) ---
const LUAR_DROP_CHANCE := 0.05  # chance de inimigo dropar 1 fragmento

## Upgrades permanentes da Árvore Sagrada. Os valores aplicados por nível
## estão em SaveManager.apply_tree_bonuses() — manter os textos em sincronia.
const TREE_UPGRADES := {
	&"vida": {"name": "Raiz Funda", "desc": "+10 de Vida Máxima por nível", "max_level": 5, "base_cost": 10},
	&"dano": {"name": "Seiva Brava", "desc": "+5% de Dano por nível", "max_level": 5, "base_cost": 15},
	&"velocidade": {"name": "Vento nas Folhas", "desc": "+3 de Velocidade por nível", "max_level": 5, "base_cost": 12},
	&"sorte": {"name": "Trevo da Copa", "desc": "+5% de Sorte por nível", "max_level": 5, "base_cost": 15},
	&"magnetismo": {"name": "Chamado da Luz", "desc": "+15 de Magnetismo por nível", "max_level": 5, "base_cost": 8},
	&"armadura": {"name": "Casca Grossa", "desc": "+1 de Armadura por nível", "max_level": 3, "base_cost": 25},
	&"luar": {"name": "Luar Fértil", "desc": "+10% de ganho de Luar por nível", "max_level": 5, "base_cost": 20},
}

static func xp_for_level(level: int) -> float:
	return ceilf(XP_BASE * pow(XP_GROWTH, level - 1))

static func run_duration() -> float:
	return DEV_RUN_DURATION if DEV_MODE else RUN_DURATION

## Luar ganho ao fim da run: fragmentos coletados + desempenho (kills, nível).
static func luar_for_run(run_luar: int, kills: int, level: int, luar_mult: float) -> int:
	return int(roundf((run_luar + kills / 20.0 + level) * luar_mult))
