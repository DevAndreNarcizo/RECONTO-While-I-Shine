class_name Balance
## Tabelas de balanceamento — só dados/fórmulas, sem estado.
## Regra do GDD §5: ajustar aqui, não espalhar números pelo código.

const XP_BASE := 5.0
const XP_GROWTH := 1.2  # cada nível exige ~20% mais

# Duração da run (GDD §3.3). DEV_MODE encurta para testar rápido.
const DEV_MODE := true
const RUN_DURATION := 30.0 * 60.0
const DEV_RUN_DURATION := 5.0 * 60.0

static func xp_for_level(level: int) -> float:
	return ceilf(XP_BASE * pow(XP_GROWTH, level - 1))

static func run_duration() -> float:
	return DEV_RUN_DURATION if DEV_MODE else RUN_DURATION
