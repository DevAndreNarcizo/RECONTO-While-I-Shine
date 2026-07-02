# 03 — Sistemas de Build e Meta-progressão

> Transforma o protótipo num jogo com profundidade: múltiplos encantos, amuletos, stats, e progressão
> permanente entre runs. Continue: um prompt por vez, testar, commit.

---

## PROMPT 3.1 — Sistema de Encantos com níveis (1→8) e múltiplos slots

```
Refatore o sistema de Encantos para suportar múltiplas armas e níveis, conforme docs/03 §2.

Requisitos:
- O Player tem até 6 slots de Encanto. Cada Encanto tem nível 1→8.
- Cada Encanto é definido por um Resource (EncantoData .tres) com: id, nome, descrição, ícone, comportamento
  (enum: MELEE_FRONTAL, PROJETIL_MIRA, ORBITAL, AREA_PLAYER, SALTITANTE, RAIO, CONVERSAO, INVOCACAO),
  e uma tabela de stats por nível (dano, cooldown, área, quantidade, etc.).
- Implemente um EncantoManager no Player que instancia/atualiza os encantos ativos e roda os cooldowns.
- Implemente 3 encantos concretos com comportamentos DIFERENTES (além do Cipó já existente):
  1. "Vaga-lumes Guardiões" (ORBITAL): orbes giram ao redor do player dando dano por contato.
  2. "Pedra do Saci" (SALTITANTE): projétil que quica entre inimigos próximos.
  3. "Relâmpago de Tupã" (RAIO): cai do céu periodicamente sobre inimigos aleatórios/mais fortes.
- Subir nível de um encanto melhora seus stats conforme a tabela.

Use os nomes exatos do docs/04. Mantenha pooling para projéteis.
```

🔬 **TESTE:** consiga ter 3-4 armas ativas ao mesmo tempo. Cada uma se comporta diferente? Sobe de nível?
💾 **COMMIT:** `feat: sistema de encantos com niveis e comportamentos`

---

## PROMPT 3.2 — Amuletos (passivas) e stats globais

```
Implemente os Amuletos (itens passivos) conforme docs/03 §3.

Requisitos:
- Até 6 slots de Amuleto. Cada Amuleto é um Resource (AmuletoData .tres) com id, nome, ícone, e os bônus
  de stat que concede por nível (ex: +Dano%, +Área%, +Velocidade Mov, +Vida Máx, +Sorte, +Magnetismo).
- Crie um sistema central de STATS do player que agrega: stats base + soma de todos os amuletos + (futuro)
  bônus de meta-progressão. Encantos leem esses stats globais (ex: +Área% aumenta a área de TODOS).
- Implemente pelo menos 5 amuletos: Figa (+Área,+Sorte), Pena de Tucano (+VelMov,+Magnetismo),
  Galho de Arruda (+Dano), Sal Grosso (+Armadura), Chocalho (+Quantidade de projéteis).
- Recalcular stats sempre que um amuleto é adquirido/sobe de nível (use sinais).

Use os nomes do docs/03 §3 (lembrando a nota cultural sobre renomear itens religiosos se preferir).
```

🔬 **TESTE:** pegar um amuleto de +Área faz TODAS as armas ficarem maiores? Stats agregam certo?
💾 **COMMIT:** `feat: amuletos e sistema de stats globais`

---

## PROMPT 3.3 — Tela de Level Up real (cartas dinâmicas)

```
Substitua a tela de level up placeholder por um sistema de cartas dinâmico.

Requisitos:
- Ao subir de nível, gere 3-4 cartas (4 se o jogador tiver bônus de sorte) sorteadas do pool válido:
  - "Novo Encanto" (só se houver slot livre de encanto)
  - "Melhorar Encanto" (só para encantos que já tem e não estão no nível 8)
  - "Novo Amuleto" / "Melhorar Amuleto"
  - Itens de cura/ouro ("Galinha"=cura, "Saco de Sementes"=XP) como cartas raras
- Cada carta mostra ícone, nome, e descrição do efeito (nível atual → próximo).
- Respeite a SORTE do jogador (afeta raridade/chance de 4 cartas).
- Botões opcionais (desbloqueáveis depois): Reroll (re-sortear), Banir (remover do pool), Pular (ganhar ouro).
- Pausa corretamente e aplica o efeito ao escolher.

Deixe a lógica de sorteio numa função testável e fácil de balancear.
```

🔬 **TESTE:** as cartas oferecem opções coerentes (não oferece "melhorar" arma que você não tem)? Escolher
aplica certo?
💾 **COMMIT:** `feat: tela de level up com cartas dinamicas`

---

## PROMPT 3.4 — HUD completo e juice de combate

```
Melhore o HUD e adicione "game juice" (feedback) — isso é o que faz o jogo parecer profissional.

HUD:
- Barra de HP, barra de XP + nível, timer (mm:ss), ouro/Cristais de Luar coletados na run, ícones dos
  encantos e amuletos ativos com nível, contador de kills.

Juice (sutil, sem exagero):
- Números de dano flutuantes ao acertar inimigos (com pooling).
- Hit-flash branco nos inimigos, pequeno knockback.
- Screen shake leve em explosões/level up.
- Partículas simples ao matar inimigo e ao coletar semente.
- Hit-stop minúsculo (alguns ms) em acertos fortes/boss (opcional).

Mantenha tudo configurável e com performance — juice não pode derrubar o FPS com 300 inimigos.
```

🔬 **TESTE:** matar inimigos agora é "suculento"? Números aparecem? Sem queda de FPS no pico?
💾 **COMMIT:** `feat: hud completo e juice de combate`

---

## PROMPT 3.5 — Meta-progressão: Cristais de Luar, save e Árvore Sagrada

```
Implemente a progressão permanente entre runs conforme docs/01 §3.4.

Requisitos:
- Durante a run, inimigos dropam ouro (placeholder) que ao fim vira CRISTAIS DE LUAR (moeda permanente).
- SaveManager: salvar/carregar (user://save.json ou ConfigFile) os Cristais de Luar totais, upgrades
  comprados, lendas/biomas desbloqueados, e conquistas. Salvar ao fim de cada run.
- Tela "ÁRVORE SAGRADA" (meta-progressão): menu onde o jogador gasta Cristais de Luar em upgrades PERMANENTES
  que se aplicam a todas as runs:
    +Vida Máx, +Dano, +VelMov, +Sorte, +Magnetismo, +1 Reroll inicial, +Ganho de Luar, +Armadura.
  Cada upgrade tem vários níveis com custo crescente.
- Esses bônus permanentes entram no cálculo de stats do player (PROMPT 3.2).
- Fluxo: Menu principal → jogar run → fim de run (mostra Luar ganho) → Árvore Sagrada → jogar de novo.

Garanta que o save é robusto (não corromper se fechar no meio).
```

🔬 **TESTE:** ganhar Luar numa run, gastar na Árvore, começar nova run mais forte, fechar e reabrir o jogo —
o progresso persiste?
💾 **COMMIT:** `feat: meta-progressao, save e arvore sagrada`

➡️ **PRÓXIMO:** `04-conteudo.md` (dar identidade: Curupira, bioma, bosses).
