# 05 — As 4 Inovações (o que faz ser RECONTO, não um clone)

> Estas features são o seu diferencial competitivo. Detalhes completos em docs/03-mecanicas-detalhadas.md §1.
> Implemente uma por vez. Cada uma muda o jogo de forma sentida.

---

## PROMPT 5.1 — 🌙 Ciclo da Lua (o run vivo)

```
Implemente a Inovação #1: o CICLO DA LUA (docs/03 §1 Inovação #1, e docs/01 §3.3).

Requisitos:
- Crie o autoload MoonCycleManager que divide a run de 30 min em 5 fases:
  Crepúsculo → Noite → Lua Cheia → Madrugada → Alvorada (durações conforme docs/01 §3.3).
- Emite um sinal `phase_changed(phase)` na virada de fase (via EventBus).
- Aplica MODIFICADORES GLOBAIS por fase (docs/03 tabela): ex. na Lua Cheia inimigos lunares ganham +50% HP/dano
  e +30% spawn; na Alvorada a Corrupção enfraquece -25%; na Madrugada inimigos aquáticos +40% + névoa.
  Estruture os modificadores em /data para balancear fácil.
- VISUAL: a cada fase, faça uma transição de iluminação/cor da tela (CanvasModulate ou shader de tint) +
  um ícone de lua no HUD mostrando a fase atual e quanto falta pra próxima.
- Inimigos e lendas devem CONSULTAR a fase atual ao calcular stats (ex: Lobisomem jogável +50% na Lua Cheia).

Garanta que isso integra com o spawner e os stats já existentes sem quebrar performance.
```

🔬 **TESTE:** (em modo dev rápido) dá pra sentir o jogo mudar a cada fase? A Lua Cheia é claramente o pico
de tensão? A cor da tela muda?
💾 **COMMIT:** `feat: ciclo da lua com modificadores por fase`

---

## PROMPT 5.2 — 🔥 Ritual de Sincretismo (evolução de encantos)

```
Implemente a Inovação #3: o RITUAL DE SINCRETISMO — evolução de encantos (docs/03 §1 Inovação #3).

Requisitos:
- Cada EncantoData pode ter caminho(s) de evolução, definidos por: encanto no nível MÁXIMO (8) + um AMULETO
  requerido (de qualquer nível) + uma CONDIÇÃO opcional (ex: estar na Lua Cheia, ou ter derrotado um mini-boss).
- Quando as condições são satisfeitas e o jogador abre um BAÚ DE LUZ (dropado por mini-boss/elite), o encanto
  evolui para sua FORMA ANCESTRAL: um novo EncantoData mais poderoso, que muda o COMPORTAMENTO (não só números).
- Implemente 2 evoluções de exemplo (docs/03 §1):
  1. Cipó Chicoteante (máx) + Figa → "Cipó da Mãe-da-Mata": raízes brotam por toda a tela periodicamente.
  2. Cipó Chicoteante (máx) + Fita do Bonfim + Lua Cheia → "Cipó Sagrado": cura o player ao acertar inimigos.
- O baú deve checar as evoluções disponíveis e conceder uma (priorizando, ou deixando o jogador escolher se
  houver várias). Mostre uma tela de "EVOLUÇÃO!" com destaque visual.
- Estruture as receitas de evolução como dados (/data) para escalar para ~20 encantos depois.
```

🔬 **TESTE:** dá pra montar a condição, abrir o baú e ver o encanto evoluir com comportamento novo? A
condição da Lua Cheia funciona?
💾 **COMMIT:** `feat: ritual de sincretismo (evolucao de encantos)`

---

## PROMPT 5.3 — ✨ Encantar a horda (conversão de inimigos)

```
Implemente a Inovação #2: ENCANTAR A HORDA (docs/03 §1 Inovação #2).

Requisitos:
- Adicione uma máquina de estados ao inimigo: HOSTIL → ENCANTADO (com timer) → volta a HOSTIL (ou morre).
- No estado ENCANTADO: o inimigo muda de "time" (passa a atacar/perseguir inimigos hostis em vez do player),
  ganha um outline/cor de aliado, e NÃO causa dano de contato no player.
- Limite de aliados encantados simultâneos (ex: 10) por performance/balanceamento. Ao exceder, o mais antigo
  volta a hostil ou expira.
- Crie 1-2 encantos de CONVERSÃO (comportamento CONVERSAO):
  1. "Canto da Iara": encanta periodicamente o inimigo forte mais próximo por X segundos.
  2. "Assobio do Saci" (opcional): confunde inimigos numa área (eles atacam uns aos outros) por alguns segundos.
- Amuletos podem aumentar duração/quantidade de encantados (sinergia de build "Exército").

Integre com o pooling: inimigos encantados que morrem voltam ao pool normalmente.
```

🔬 **TESTE:** o Canto da Iara converte inimigos? Eles lutam pelo seu lado? É divertido/estratégico?
💾 **COMMIT:** `feat: encantar a horda (conversao de inimigos)`

---

## PROMPT 5.4 — 🌿 Bioma Reativo (hazard dinâmico)

```
Implemente a Inovação #4: BIOMA REATIVO (docs/03 §1 Inovação #4). Comece por UM hazard.

Requisitos (exemplo: queimada que se propaga — ideal para o Cerrado, mas implemente já na Mata como teste):
- Defina um TileMap/grid de "vegetação seca" (células inflamáveis).
- Quando uma fonte de fogo toca uma célula (ex: o encanto Roda do Boitatá, ou um inimigo de fogo), o fogo
  ACENDE e se PROPAGA para células vizinhas ao longo do tempo, depois apaga (deixa terra queimada).
- Fogo causa dano por segundo a quem estiver nele (inimigos E player). Lendas imunes a fogo (Boitatá) ignoram.
- Crie um BiomeHazardManager por cena de bioma, com regras próprias, para depois adicionar: rio que transborda
  (Pantanal), fendas (Caatinga), correnteza (Fundo do Rio).
- Mantenha performance: propagação por tique discreto (timer), não por frame.

Estruture para ser fácil ligar/desligar e configurar o hazard por bioma.
```

🔬 **TESTE:** o fogo se espalha de forma interessante? Vira decisão tática (evitar/usar)? Sem travar com
muita propagação?
💾 **COMMIT:** `feat: bioma reativo (queimada que se propaga)`

➡️ **PRÓXIMO:** arte e áudio — pasta `sprites-arte/`. Depois, expandir em largura (docs/05 Fase 6).

---

## Bônus — PROMPT 5.5 — Simpatias (Arcanas)

```
Implemente o sistema de SIMPATIAS (cartas que mudam as regras da partida — docs/04 §5).

Requisitos:
- O jogador pode escolher 1-3 Simpatias antes do run (na tela de seleção), entre as desbloqueadas.
- Cada Simpatia aplica um modificador global na run. Implemente pelo menos 4 (docs/04 §5):
  Lua Eterna, Mata Generosa, Encanto Coletivo, Fogo que Lembra.
- Desbloqueio por conquistas/Luar (integra com o save).
- Devem combinar entre si e com o resto dos sistemas sem quebrar.
```

💾 **COMMIT:** `feat: sistema de simpatias (arcanas)`
