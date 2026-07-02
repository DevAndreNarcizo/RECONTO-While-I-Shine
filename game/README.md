# RECONTO: Enquanto Eu Brilhar — projeto Godot

Jogo 2D top-down estilo *Vampire Survivors* com tema de folclore brasileiro.
Documentação de design completa em `../docs/` (leia o `../CLAUDE.md`).

## Como rodar

1. Instale o [Godot 4.3+](https://godotengine.org/download).
2. Abra o Godot → **Importar** → selecione esta pasta (`game/`) → abra o projeto.
3. Pressione **F5** para rodar a cena principal.

## Estrutura

```
scenes/     cenas (player, inimigos, mundo, UI)
scripts/    GDScript por domínio; scripts/autoload/ = singletons
resources/  Resources .tres (dados de encantos, amuletos, inimigos)
data/       tabelas de balanceamento
assets/     sprites, áudio, UI, fontes (placeholders por enquanto)
```
