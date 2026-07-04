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

## Animações de ATAQUE (VFX dos encantos e ativas)

> Modo de ANIMAÇÃO DE EFEITO do PixelLab: strip horizontal de frames, transparente,
> **só 1 direção (apontando para a DIREITA)** — a rotação é feita no Godot.
> Estilo p/ efeitos: `pixel art game VFX animation frames, vibrant magical folklore
> energy, transparent background, Resurrect-64 palette`
> Regra de cor: golpes das lendas = verde/dourado/azul-luz · Corrupção = roxo.
> Loops (auras/orbes): pedir "seamless loop". Impactos: último frame em fade out.

### Já no jogo ✅

| Encanto | Prompt | Tam/frames |
|---|---|---|
| Cipó Chicoteante | `whip slash effect of a living green vine with small leaves, horizontal arc swing, motion trail` | 64x32 · 5 |
| Cipó da Mãe-da-Mata | `thorny ancient roots bursting upward from the ground, dark green with golden sap glow, dirt particles` | 32x48 · 6 |
| Cipó Sagrado | `sacred golden-green vine whip slash, holy light sparkles, warm healing glow trail` | 64x32 · 5 |
| Vaga-lumes Guardiões | `tiny orb of warm golden firefly light, pulsing glow, soft trail` | 16x16 · 4 loop |
| Pedra do Saci | `spinning round stone with wind swirl lines around it, bouncing motion blur` | 16x16 · 4 loop |
| Relâmpago do Trovão | `vertical lightning bolt striking down, white-blue jagged electric arc, bright impact flash at bottom` | 32x96 · 5 |
| Canto da Iara | `expanding circles of magical song, water-blue musical notes and ripples radiating outward` | 48x48 · 6 |
| Pés Invertidos (ativa) | `expanding ring of glowing green backwards footprints on the ground, leaves swirling` | 96x96 · 6 |

### Próximas lendas (docs/04 §1 e 06 §2)

| Lenda | Arma/Ativa | Prompt | Tam/frames |
|---|---|---|---|
| Saci | Dash de Vento | `small tornado whirlwind of wind, leaves and red cap sparks, spiral motion` | 32x48 · 6 loop |
| Boitatá | Roda do Boitatá | `ring of living fire circling around empty center, orange-blue serpent-shaped flames` | 96x96 · 6 loop |
| Boitatá | Explosão Ígnea | `radial fire explosion nova, expanding ring of flames with ember particles` | 96x96 · 7 |
| Boto | Dança Encantadora | `charming pink-white musical hearts and water droplets swirling in a wave pattern` | 48x48 · 6 loop |
| Lobisomem | Garras Lunares | `triple claw slash marks glowing pale moonlight silver-blue, fierce diagonal strikes` | 48x48 · 4 |
| Negrinho | Vela do Pastoreio | `small warm candle flame spirit, gentle golden halo, floating wisp of light` | 16x24 · 4 loop |
| Negrinho | Chamado (tropilha) | `ghostly glowing horse made of golden light galloping, ethereal mane trailing sparkles` | 48x32 · 6 |
| Mula-sem-Cabeça | Coice Flamejante | `powerful double kick fire burst, orange flame shockwave with hoof shapes` | 48x48 · 5 |
| Cuca | Maldição | `bubbling dark curse cloud, sickly green-purple magic smoke with tiny skull wisps` | 48x48 · 6 loop |
| Cuca | Feitiço do Sono | `expanding circle of drowsy magic, floating purple Z symbols and sparkling dust` | 96x96 · 6 |
| Caipora | Matilha | `charging wild peccary boar with dust cloud trail, determined eyes, motion lines` | 32x24 · 4 loop |

## Inimigos — Amazônia (mesmo formato dos da Mata: 8 rotações)

| Inimigo (tamanho) | Prompt |
|---|---|
| Formigão de Correição (16) | `giant corrupted army ant, dark red-brown carapace, oversized mandibles, marching pose, purple glowing joints` |
| Mosquito da Praga (16) | `corrupted swamp mosquito, translucent tattered wings, long crooked proboscis, sickly gray-purple body` |
| Jacaré-Açu Oco (32) | `hollow corrupted black caiman, dark green cracked scales, glowing purple eyes, low predator crawl` |
| Tatu-Canastra Blindado (32) | `giant armadillo with thick segmented armor plates, stone-like shell, purple corruption veins in the cracks` |
| Sucuri de Lama (mini-boss, 64) | `massive anaconda covered in dripping mud, muddy brown coils, glowing violet eyes, striking pose` |
| **Mapinguari (boss, 96)** | `towering one-eyed sloth-beast of Brazilian legend, shaggy dark fur, gaping fanged mouth on its belly, huge claws, single glowing red eye, moss and vines on shoulders` |

## Ícones de encantos e amuletos (cartas + HUD)

> Formato: **item icon**, 32x32, frame único, sem direções. Estilo:
> `pixel art game item icon, centered, clean silhouette on transparent background,
> subtle glow, Resurrect-64 palette`

| Item | Prompt |
|---|---|
| Cipó Chicoteante | `coiled green living vine whip with small leaves` |
| Cipó da Mãe-da-Mata | `ancient thorned root coil with golden sap glow` |
| Cipó Sagrado | `golden-green vine coil with holy light sparkles` |
| Vaga-lumes Guardiões | `three golden fireflies in triangle formation, warm glow` |
| Pedra do Saci | `round gray stone wrapped in a small wind swirl` |
| Relâmpago do Trovão | `blue-white lightning bolt inside a storm cloud` |
| Canto da Iara | `water-blue musical note with ripple rings` |
| Peixeira Voadora | `silver fish-gutting knife with worn wooden handle` |
| Revoada de Peixeiras | `fan of seven silver blades spread like feathers` |
| Roda do Boitatá | `ring of orange serpent-shaped fire` |
| Fogaréu | `blazing fire ring with blue-hot core` |
| Figa | `carved dark wood figa hand charm on a cord` |
| Fita do Bonfim | `ribbon tied in three knots, warm yellow` |
| Galho de Arruda | `small green rue herb branch` |
| Sal Grosso | `small burlap pouch spilling coarse salt crystals` |
| Pena de Tucano | `vibrant toucan feather, orange and black` |
| Chocalho | `indigenous gourd rattle with carved patterns` |
| Semente/XP (HUD) | `tiny glowing golden seed` |
| Cristal de Luar (HUD) | `tiny pale blue moon crystal` |

## Ordem de produção recomendada

1. Curupira + 6 inimigos da Mata + 3 pickups (~10 sprites) → integrar e validar o visual
2. VFX dos ataques já no jogo (tabela acima) + bosses (Preguiça, Onça)
3. Saci + tilesets (estes melhor no itch.io — ver `07-itch-io-guia.md`)
