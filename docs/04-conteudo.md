# Conteúdo — Lendas, Biomas, Bosses e Inimigos

> Catálogo de conteúdo do jogo. Use como fonte de verdade ao gerar arte e programar.

---

## 1. Lendas jogáveis (personagens)

Cada lenda = arma inicial única + stats próprios + (opcional) 1 habilidade ativa. Comece pelo **Curupira**
(protagonista/tutorial).

| # | Lenda | Arma inicial | Identidade / passiva | Habilidade ativa (opcional) | Desbloqueio |
|---|---|---|---|---|---|
| 1 | **Curupira** 🦶 | Cipó Chicoteante | +regen na vegetação; protetor da mata | "Pés Invertidos": confunde inimigos por 3s | Inicial |
| 2 | **Saci** 🌀 | Pedra Saltitante | +velocidade; redemoinho | "Dash de Vento" | 1.000 Luar |
| 3 | **Iara** 🌊 | Canto (conversão) | mestra do Encantar; +duração de encantados | "Canto Hipnótico" (encanta em área) | Vencer Fundo do Rio |
| 4 | **Boitatá** 🔥 | Roda de Fogo | imune a fogo; deixa rastro | "Explosão Ígnea" | Vencer Cerrado |
| 5 | **Boto** 🐬 | Dança Encantadora | +encantados fracos; carisma | "Sedução" | 5.000 Luar |
| 6 | **Lobisomem** 🐺 | Garras | +50% poder na Lua Cheia, -na Alvorada | "Fúria Lunar" | Vencer Cerrado |
| 7 | **Negrinho do Pastoreio** 🕯️ | Vela (invoca aliado) | invocador; +aliados | "Chamado" (invoca 3) | Conquista |
| 8 | **Mula-sem-Cabeça** 🐴🔥 | Coice Flamejante | tanque; alta vida, lenta | "Galope" (atravessa tudo) | Vencer Caatinga |
| 9 | **Cuca** 🐊 | Maldição (área) | dano por tempo; debuffs | "Feitiço do Sono" | Vencer Fundo do Rio |
| 10 | **Caipora** 🐗 | Chamado da Caça (matilha) | comanda animais da mata | "Estouro da Boiada" | Conquista |

> Para o protótipo, só o **Curupira** é necessário. Os outros entram no roadmap.

---

## 2. Biomas (fases)

Ordem de progressão = ordem da narrativa (ver `02-lore.md` §6).

| # | Bioma | Paleta | Hazard reativo | Inimigos temáticos | Boss |
|---|---|---|---|---|---|
| 1 | **Mata Atlântica** | verde vivo, dourado | cipós que prendem | bichos corrompidos, vaga-lumes sombrios | Onça Corrompida |
| 2 | **Amazônia** | verde escuro, chuva | chuva + poças elétricas | formigões, sapos venenosos | **Mapinguari** |
| 3 | **Pantanal** | azul, lama, pôr-do-sol | rio transborda | jacarés, capivaras-zumbi, piranhas | **Cobra-Grande** |
| 4 | **Caatinga** | ocre, rachado | fendas + fogo | cabras-demônio, escorpiões | **Mula-sem-Cabeça** |
| 5 | **Cerrado** | dourado seco, fogo | queimada se propaga | lobos, urubus, fogo-fátuo | **Lobisomem (Lua Cheia)** |
| 6 | **Fundo do Rio** | azul profundo, bioluz | correnteza | peixes-fantasma, afogados | **Cuca** |
| 7 | **Cidade Assombrada** | cinza, neon doente | postes/fios/vidro | assombrações urbanas, sombras | **Coração da Corrupção** |

---

## 3. Inimigos (categorias)

| Categoria | Comportamento | Exemplos |
|---|---|---|
| **Enxame** (fraco) | corre reto no player, morre em 1 hit | vaga-lumes sombrios, formigões |
| **Médio** | mais HP, talvez zigue-zague | jacarés, lobos |
| **Atirador** | mantém distância, atira projétil | sapos venenosos, urubus |
| **Tanque** | lento, muito HP, empurra | capivara-zumbi, cabra-demônio |
| **Lunar** | só forte na Lua Cheia | lobisomens menores, mulas pequenas |
| **Aquático** | forte na Madrugada | peixes-fantasma, afogados |
| **Mini-boss** | aparece em min específicos | varia por bioma |
| **Corrompido especial** | dropa baú/evolução ao morrer | "elite" com brilho roxo |

**Padrão de IA base (reaproveitar):** `seguir o player` (steering simples) + variações (manter distância,
investida, orbitar). Performance: usar pooling de inimigos e processamento em lote (ver prompts).

---

## 4. Bosses (estrutura)

Cada boss = 2-3 fases, padrões de ataque telegrafados, arena que usa o hazard do bioma.

**Exemplo — Mapinguari (Amazônia):**
- Fase 1: investidas lentas + rugido que atordoa (telegrafado).
- Fase 2 (50% HP): invoca enxames + a boca-na-barriga atira projétil em cone.
- Fase 3 (20% HP): enfurece, fica mais rápido, a chuva vira tempestade elétrica.
- Recompensa: desbloqueio de narrativa + bônus de Luar + (às vezes) novo amuleto.

---

## 5. Simpatias (Arcanas — cartas que mudam regras)

Desbloqueáveis; o jogador escolhe 1-3 antes do run (na meta). Exemplos:
| Simpatia | Efeito na partida |
|---|---|
| **Lua Eterna** | a run inteira fica em Lua Cheia (alto risco/recompensa) |
| **Mata Generosa** | +50% Sementes de Luz, mas inimigos +25% HP |
| **Encanto Coletivo** | todo inimigo encantado explode em Luz ao morrer |
| **Fogo que Lembra** | toda queimada cura você ao invés de ferir |
| **Silêncio** | sem level up: você começa com build aleatória completa |
| **Espelho** | seus encantos também atingem por trás (efeito tela) |

---

## 6. Resumo de prioridade de produção

**Protótipo:** Curupira + Mata Atlântica + 3 encantos (Cipó, Vaga-lumes, Pedra) + inimigo Enxame + 1 mini-boss.
**Depois:** Ciclo da Lua → meta-progressão → 2º bioma → evolução → demais lendas → inovações restantes.
