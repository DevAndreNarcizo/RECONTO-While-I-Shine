# 04 — Conteúdo: Lendas, Bioma, Bosses e Menus

> Transforma o sistema genérico em RECONTO com identidade. Consulte sempre docs/04-conteudo.md.

---

## PROMPT 4.1 — A lenda Curupira (personagem com identidade)

```
Transforme o Player genérico no primeiro personagem jogável: o CURUPIRA (docs/04 §1).

Requisitos:
- Crie um sistema de "Lenda" (CharacterData Resource): id, nome, descrição, arma inicial, modificadores de
  stat base, e uma habilidade ativa opcional.
- Curupira:
  - Arma inicial: Cipó Chicoteante (já existe).
  - Passiva: regeneração de HP leve quando está parado sobre vegetação (ou sempre, simplifique se preciso);
    protetor da mata.
  - Habilidade ativa (tecla Espaço / botão gamepad, com cooldown ~12s): "Pés Invertidos" — confunde os
    inimigos próximos por 3s (eles se movem em direção ERRADA / aleatória).
- A escolha de lenda deve influenciar stats e arma inicial ao começar a run.
- Deixe a arquitetura pronta para adicionar as outras 9 lendas (docs/04 §1) depois, só criando novos Resources.
```

🔬 **TESTE:** o Curupira tem cara própria? A habilidade "Pés Invertidos" funciona e é útil?
💾 **COMMIT:** `feat: lenda Curupira com passiva e habilidade ativa`

---

## PROMPT 4.2 — Bioma Mata Atlântica + variedade de inimigos

```
Construa o primeiro bioma completo: a MATA ATLÂNTICA (docs/04 §2 e §3).

Requisitos:
- Cena de bioma com chão/tileset temático (placeholders coloridos verdes por ora; arte vem depois).
- Crie 4-5 tipos de inimigo usando EnemyData diferentes (docs/04 §3):
  - Enxame (já existe): fraco, corre reto.
  - Médio: mais HP, zigue-zague.
  - Atirador: mantém distância e atira projétil.
  - Tanque: lento, muito HP, empurra o player.
  - Corrompido elite: brilho roxo, mais forte, dropa baú/recompensa ao morrer.
- Configure a curva de spawn por minuto conforme docs/03 §4 (use a tabela). Diferentes tipos entram em
  diferentes minutos. Exponha a tabela em /data para balancear fácil.
- Spawns em ondas/grupos ocasionais (ex: a cada 2 min, um "grupo" temático aparece).
```

🔬 **TESTE:** a run tem variedade? A dificuldade sobe com o tempo de forma sentida?
💾 **COMMIT:** `feat: bioma Mata Atlantica com variedade de inimigos`

---

## PROMPT 4.3 — Mini-boss e Boss do bioma

```
Implemente um mini-boss e o boss do bioma Mata Atlântica.

Requisitos:
- Mini-boss: aparece no minuto 10 (configurável). Mais HP, um padrão de ataque telegrafado, dropa baú de
  recompensa (XP grande + chance de evolução depois).
- Boss do bioma: a "ONÇA CORROMPIDA" (docs/04 §2). Aparece ao fim da run (minuto 30, ou quando você decidir
  o gatilho). Estrutura de 2-3 fases com padrões diferentes conforme HP cai (ex: investida → invocar enxame
  → fúria mais rápida). Barra de vida do boss no topo.
- Derrotar o boss = VITÓRIA do bioma: tela de vitória, bônus de Luar, e marca o bioma como concluído no save
  (desbloqueando o próximo).
- Reaproveite a base de inimigo, mas bosses têm IA de padrões (máquina de estados) e telegrafia (aviso visual
  antes do ataque).
```

🔬 **TESTE:** o boss é um desafio justo e telegrafado? Vencer dá sensação de conquista e salva o progresso?
💾 **COMMIT:** `feat: mini-boss e boss Onca Corrompida`

---

## PROMPT 4.4 — Menu principal + seleção de Lenda e Bioma

```
Crie o fluxo de menus do jogo.

Requisitos:
- Menu Principal: título "RECONTO" (placeholder de logo), botões: Jogar, Árvore Sagrada, Opções, Créditos,
  Sair. Background placeholder (a arte virá da pasta sprites-arte).
- Tela "Jogar": seleção de LENDA (mostra as desbloqueadas; bloqueadas aparecem com cadeado e requisito) e
  seleção de BIOMA (só os desbloqueados). Confirmar inicia a run com a lenda/bioma escolhidos.
- Integre com o save: lendas/biomas bloqueados respeitam o progresso.
- Opções: volume (música/SFX), tela cheia, idioma (pt-BR/en placeholder).
- Navegação funciona com teclado E gamepad.

Garanta transições limpas entre cenas (sem vazar nós/estado da run anterior).
```

🔬 **TESTE:** dá pra navegar Menu → escolher Curupira + Mata Atlântica → jogar → vencer/morrer → voltar ao
menu, tudo sem bug?
💾 **COMMIT:** `feat: menu principal e selecao de lenda/bioma`

➡️ **CHECKPOINT:** você tem uma VERTICAL SLICE jogável de ponta a ponta. **Mostre para amigos e teste.**
Considere já criar a página da Steam (ver docs/05 §marco de validação). Depois: `05-inovacoes.md`.
