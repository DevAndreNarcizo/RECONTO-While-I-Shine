# CLAUDE.md — Contexto do Projeto RECONTO

> Este arquivo é lido automaticamente pelo Claude Code. Mantém o contexto do jogo entre sessões.
> **Quando o projeto Godot for criado, copie este arquivo para a raiz do projeto Godot.**

## O que é este projeto

**RECONTO** — um jogo 2D top-down estilo *Vampire Survivors* (bullet heaven / roguelite) com tema de
**folclore brasileiro**. O jogador é uma lenda (Curupira, Saci, Iara...) que defende a mata da **Corrupção**,
sobrevivendo a hordas por ~30 min por bioma.

**Nome oficial:** título mundial **RECONTO** + subtítulo localizado — pt-BR: *RECONTO: Enquanto Eu
Brilhar* · en: *RECONTO: While I Shine*. "Encantados" segue sendo o termo do MUNDO para as lendas
(glossário em `02-lore.md`), não o nome do jogo.

## Stack técnica

- **Engine:** Godot 4.x
- **Linguagem:** GDScript (preferir; usar C# só se eu pedir)
- **Alvo:** Steam (PC desktop). Export Windows/Linux.
- **Resolução base:** 1920x1080, com viewport que escala. Pixel art (manter `texture_filter` em Nearest).

## Documentação de design (LER ANTES DE IMPLEMENTAR)

Os documentos de design estão em `docs/` (ou na pasta `/var/www/Jogo-2D/docs/`):
- `01-game-design-document.md` — core loop, stats, pilares.
- `02-lore.md` — narrativa, nomes, glossário do mundo.
- `03-mecanicas-detalhadas.md` — as 4 inovações, encantos, evolução.
- `04-conteudo.md` — lendas, biomas, bosses, inimigos.
- `05-roadmap.md` — ORDEM de construção.
- `06-expansao-conteudo.md` — catálogo expandido APROVADO: história em 3 atos, Lendas Redimidas,
  fichas das 10 lendas, 20 encantos com evoluções, 18 amuletos, bestiário e chefes dos 7 biomas.
- `07-lore-encantados.md` — lore da tradição → versão exclusiva do jogo por lenda; sistemas
  Livro de Recontos, Oferendas e armadilhas da Corrupção; novos inimigos (Pisadeira, Corpo-Seco,
  Bicho-Papão, Tutu Marambá, Matinta) e amuletos folclóricos.

**Sempre que eu pedir uma feature, consulte o doc relevante para nomes e regras corretas.**

## Princípios de código (seguir sempre)

1. **Performance é crítica** (centenas de inimigos na tela):
   - Use **object pooling** para inimigos, projéteis e drops (não `instantiate`/`queue_free` em loop).
   - Prefira processamento em lote; evite `_process` pesado por nó quando der.
   - Use `Area2D`/colisão por camadas bem definidas; cheque colisões com physics layers, não distância manual em massa.
2. **Arquitetura limpa e modular:**
   - Dados de encantos/inimigos/amuletos em **Resources** (`.tres`) ou dicionários, não hardcoded espalhado.
   - Singletons (autoload) para: `GameState`, `MoonCycleManager`, `SaveManager`, `EnemySpawner`, `EventBus` (sinais).
   - Comunicação por **sinais** (signals), baixo acoplamento.
3. **Pixel art:** texturas em filtro Nearest, movimento em coordenadas que evitem shimmer.
4. **Nomes do mundo:** use os termos do glossário (`02-lore.md`): "Semente de Luz" (XP), "Cristal de Luar"
   (moeda meta), "Encanto" (arma), "Amuleto" (passiva), "Encantado" (lenda/aliado).
5. **Idioma:** comentários e textos de UI em **pt-BR**. Código (nomes de var/func) em inglês.
6. **Git:** sugerir commit a cada feature funcional.

## Estilo de trabalho

- Implemente **uma coisa por vez**, de forma testável. Não tente construir o jogo todo num prompt.
- Quando criar placeholders de arte, use formas geométricas coloridas (ColorRect/círculos) claramente
  rotuladas, fáceis de trocar depois.
- Ao terminar uma feature, diga **como testar** e **o que vem a seguir** segundo o roadmap.
- Se precisar de Python/terminal, peça permissão e explique o porquê.

## Nota cultural (importante)

Tratar o folclore com respeito, como homenagem heroica — nunca caricatura. Evitar termos religiosos sagrados
em mecânicas; usar fantasia. Ver `02-lore.md` §1.
