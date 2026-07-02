# Mecânicas Detalhadas — RECONTO

> Detalhamento das 4 inovações + sistema de Encantos, Amuletos e Evolução. Base para os prompts.

---

## 1. As 4 inovações (o que diferencia de qualquer clone)

### 🌙 Inovação #1 — Ciclo da Lua (o run vivo)
A run de 30 min passa por 5 fases temporais (ver tabela no GDD §3.3). Cada fase aplica **modificadores
globais** a inimigos e às lendas.

**Implementação:**
- Um `MoonCycleManager` (autoload/singleton) com um timer de 30 min dividido em 5 janelas.
- Emite sinal `phase_changed(phase)` na virada de fase.
- Cada inimigo e lenda lê a fase atual e aplica buffs (ex: `if phase == LUA_CHEIA: stats *= lunar_mult`).
- UI: ícone da lua no topo + transição de iluminação/cor da tela (shader de tint) a cada fase.

**Exemplos de modificadores:**
| Fase | Inimigos | Lendas |
|---|---|---|
| 🌆 Crepúsculo | -20% spawn | normal |
| 🌙 Noite | normal | normal |
| 🌕 Lua Cheia | Lobisomem/Mula +50% HP e dano; +30% spawn | Lobisomem (jogável) +50% poder |
| 🌌 Madrugada | inimigos aquáticos +40%; névoa reduz visão | Boto/Iara +40% |
| 🌅 Alvorada | Corrupção -25% (sol enfraquece) | regen leve para todos |

> **Por que importa:** dá arco dramático e estratégia temporal. O jogador *planeja* a build sabendo que a
> Lua Cheia vem aí.

---

### ✨ Inovação #2 — Encantar a horda (conversão de inimigos)
Alguns Encantos não causam dano: eles **encantam** inimigos, que viram **aliados temporários** e atacam
outros inimigos até a "Luz" deles se esgotar (timer) ou morrerem.

**Implementação:**
- Inimigo tem máquina de estados: `HOSTIL → ENCANTADO (timer) → volta HOSTIL ou morre`.
- No estado ENCANTADO: troca de "time" (target = inimigos hostis), recebe outline/cor aliada, e o player
  não toma dano por contato dele.
- Limite de aliados encantados simultâneos (ex: 10) para performance e balanceamento.
- Sinergia de build: amuletos que aumentam duração/quantidade de encantados → build "Exército".

**Encantos de conversão (exemplos):** Canto da Iara (encanta 1 alvo forte), Assobio do Saci (confunde área:
inimigos atacam uns aos outros), Dança do Boto (encanta vários fracos).

> **Por que importa:** mexe no power fantasy clássico. Abre um eixo de build inédito no gênero.

---

### 🔥 Inovação #3 — Ritual de Sincretismo (evolução em árvore)
Em vez do "arma máx + passiva → baú" simples do VS, a evolução exige uma **tríade**:

```
ENCANTO no nível máximo (8)  +  AMULETO correspondente (qualquer nível)  +  CONDIÇÃO (ex: estar na Lua Cheia
   OU derrotar um mini-boss)  →  abre um BAÚ DE LUZ  →  Encanto evolui para a FORMA ANCESTRAL
```

- Cada Encanto tem 1 (às vezes 2) caminho(s) de evolução, exigindo amuletos diferentes → **árvore de fusões**.
- Algumas evoluções só acontecem em **condições especiais** (Lua Cheia, bioma específico) → rejogabilidade.
- A Forma Ancestral muda o comportamento, não só o número (ex: vira efeito de tela, ou ganha mecânica nova).

**Exemplo de árvore (Encanto "Cipó Chicoteante"):**
- Cipó (máx) + Amuleto Figa → **"Cipó da Mãe-da-Mata"** (raízes brotam por toda a tela).
- Cipó (máx) + Amuleto Fita do Bonfim + Lua Cheia → **"Cipó Sagrado"** (cura ao acertar).

> **Por que importa:** profundidade de build = horas de teorização = retenção. É o que sustenta o escopo
> ambicioso.

---

### 🌿 Inovação #4 — Bioma Reativo (hazard dinâmico)
O terreno reage e vira parte do combate, variando por bioma.

| Bioma | Hazard reativo |
|---|---|
| Mata Atlântica | cipós no chão prendem (lento) |
| Amazônia | chuva forte reduz velocidade de projéteis; poças elétricas |
| Pantanal | rio transborda em ondas — zonas alagam e empurram |
| Caatinga | chão racha e abre **fendas** que dão dano; calor (fogo se espalha rápido) |
| Cerrado | **queimada se propaga**: fogo (seu ou do Boitatá) alastra na vegetação seca |
| Fundo do Rio | correnteza empurra; bolhas de ar = zonas seguras |
| Cidade Assombrada | postes caem, fios elétricos, vidro no chão |

**Implementação:** um `BiomeHazardManager` por cena de bioma, com regras próprias (tilemap de "vegetação
seca" que pega fogo via propagação de células vizinhas, etc.). Comece simples (1 hazard por bioma).

> **Por que importa:** identidade visual/tática única por bioma + diferencial de marketing.

---

## 2. Sistema de Encantos (armas)

- **Slots:** 6 de Encanto + 6 de Amuleto.
- **Níveis:** 1 → 8. Cada nível melhora (dano, quantidade, área, cooldown).
- **Comportamentos-base** (reaproveitar e tematizar):
  | Padrão | Exemplo folclórico | Descrição |
  |---|---|---|
  | Melee frontal | Cipó Chicoteante | acerta na direção que você anda |
  | Projétil mira-próximo | Peixeira Voadora | atira no inimigo mais perto |
  | Orbital | Vaga-lumes Guardiões | giram ao redor, dão dano por contato |
  | Área no player | Roda do Boitatá | aura de fogo contínua |
  | Projétil saltitante | Pedra do Saci | quica entre inimigos |
  | Raio do céu | Relâmpago do Trovão | cai aleatório / no mais forte |
  | Conversão | Canto da Iara | encanta (inovação #2) |
  | Invocação | Chamado do Negrinho | invoca aliado que luta |

## 3. Sistema de Amuletos (passivas)

Bônus de stat global + chave de evolução. Exemplos:
| Amuleto | Efeito | Evolui qual Encanto |
|---|---|---|
| Figa | +Área, +Sorte | Cipó → Mãe-da-Mata |
| Fita do Bonfim | +Duração, regen leve | Cipó → Cipó Sagrado |
| Galho de Arruda | +Dano | Roda do Boitatá → Fogaréu |
| Sal Grosso | +Armadura, reflete dano | Vaga-lumes → Muralha de Luz |
| Pó de Estrela | +Velocidade de Ataque | Relâmpago → Tempestade |
| Pena de Tucano | +Velocidade Mov., +Magnetismo | Peixeira → Revoada |
| Chocalho | +Quantidade de projéteis | vários |
| Lua Minguante | +Ganho de XP | — |

> **Nota cultural (decidido):** "Pó de Pemba" tinha origem religiosa — renomeado para **"Pó de Estrela"**.
> Pelo mesmo critério, "Relâmpago de Tupã" virou **"Relâmpago do Trovão"** (Tupã é entidade religiosa Guarani).
> Catálogo completo de encantos/amuletos: `06-expansao-conteudo.md` §3–4.

## 4. Tabela de progressão de dificuldade (curva de spawn)

| Minuto | Inimigos/seg (spawn) | Tipos ativos | Eventos |
|---|---|---|---|
| 0–6 | 1–2 | básicos | — |
| 6–14 | 3–5 | + médios | 1º mini-boss (min 10) |
| 14–20 | 6–9 | + lunares | Lua Cheia (horda densa) |
| 20–26 | 8–12 | + aquáticos | "rio de inimigos" (corredores) |
| 26–30 | 12–18 | todos | onda final |
| 30:00 | — | BOSS | confronto final do bioma |

> Ajustar números no playtest. Regra: o jogador deve sentir-se **quase** sobrecarregado no pico, e
> **invencível** se montou a build certa.
