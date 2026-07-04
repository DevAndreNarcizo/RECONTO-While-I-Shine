# 08 — Prompts para o PixelLab (sprites do jogo)

> Prompts em INGLÊS (o PixelLab responde melhor). Fluxo: gerar ~20 variações →
> escolher → refinar no Aseprite. Rotação em 4 direções e animação (walk/attack)
> são CONFIGURAÇÃO da ferramenta, não parte do prompt.
> Salve os PNGs em `game/assets/sprites/` — o Claude Code integra no Godot.

## Configuração no PixelLab

- **Tamanho:** 32x32 (lendas/inimigos médios) · 16x16 (enxames/pickups) · 64x64 (bosses)
- **Paleta:** Resurrect-64 (citar no prompt) — a MESMA em tudo
- **Direções:** 4 (top-down) para tudo que anda · **Walk:** 4-6 frames · Bosses: + pose de ataque
- Gerar tudo na mesma sessão/estilo para consistência

## Bloco de estilo (colar no fim de TODOS os prompts)

```
top-down game sprite, vibrant Brazilian rainforest folklore theme, dark fantasy
but colorful, clean readable silhouette, Resurrect-64 palette, transparent background
```

## Lendas (32x32, 4 direções + walk)

| Lenda | Prompt |
|---|---|
| Curupira | `small forest guardian boy, wild flame-like orange-red hair, green skin, feet turned backwards, amber glowing eyes, leaf loincloth, mischievous brave expression` |
| Saci | `one-legged trickster boy, bright red magic cap, dark skin, small smoke pipe, standing on a mini whirlwind of wind and leaves, playful grin` |

## Inimigos — Mata Atlântica

| Inimigo (tamanho) | Prompt |
|---|---|
| Vaga-lume Sombrio (16) | `corrupted firefly, small dark insect with sickly purple glow instead of yellow, tattered wings, hollow eyes` |
| Cutia Oca (24) | `hollow corrupted agouti rodent, brown fur cracked like dry wood, glowing purple eyes, skittish pose` |
| Macaco-Prego (32) | `corrupted capuchin monkey, purple-tinted matted fur, long limbs, aggressive hunched pose, glowing violet eyes` |
| Sapo-Cururu (32) | `bloated corrupted cane toad, sickly green skin with purple pustules, wide toxic mouth, ready to spit` |
| Tamanduá Casca-Grossa (32) | `giant anteater with armor of thick tree bark plates, slow heavy stance, long snout, purple corruption veins between bark` |
| Corrompido Especial (32) | `elite corrupted forest beast, deep purple body with bright violet aura and floating dark particles, menacing glow` |

## Bosses (64x64, 4 direções + pose de ataque)

| Boss | Prompt |
|---|---|
| Bicho-Preguiça Desperto | `massive ancient sloth, moss and vines growing on fur, long hooked claws, sleepy but menacing face, vines extending from arms like whips, earthy green-brown tones` |
| Onça Corrompida (+ frame agachada p/ bote) | `large corrupted jaguar, orange fur with black rosette spots, glowing purple corruption veins across body, bright violet eyes, powerful crouched predator stance` |

## Pickups e itens (16x16, 2 frames de brilho)

| Item | Prompt |
|---|---|
| Semente de Luz | `glowing golden seed of light, diamond shape, warm radiant sparkle` |
| Fragmento de Luar | `pale blue moonlight crystal shard, cold silver glow, faceted` |
| Baú de Luz | `small wooden chest overflowing with golden light rays, ornate leaf carvings` |

## Projéteis/efeitos (16x16, sem direções)

| Efeito | Prompt |
|---|---|
| Cusparada do sapo | `toxic green venom glob projectile, dripping, small purple bubbles` |
| Pedra do Saci | `small round gray stone with faint wind swirl trail` |
| Vaga-lume Guardião (aliado) | `friendly firefly of pure golden light, warm bright glow, tiny wings` |

## Ordem de produção recomendada

1. Curupira + 6 inimigos da Mata + 3 pickups (~10 sprites) → integrar e validar o visual
2. Bosses (Preguiça, Onça) + projéteis/efeitos
3. Saci + tilesets (estes melhor no itch.io — ver `07-itch-io-guia.md`)
