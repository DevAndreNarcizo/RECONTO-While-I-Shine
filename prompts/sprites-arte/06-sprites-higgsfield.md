# 06 — Geração de Arte (Higgs Field / IA de imagem)

> O Claude Code NÃO gera boa pixel art. Use IA de imagem (Higgs Field, ChatGPT/DALL·E, Midjourney, ou
> ferramentas específicas de pixel art como Retro Diffusion) para gerar, e o Claude integra no Godot.
> Estes são prompts prontos de imagem. Ajuste a paleta conforme docs/02 §8.

---

## Diretrizes gerais de estilo (cole junto com qualquer prompt)

```
Estilo: pixel art 2D, top-down (visão de cima levemente angulada, estilo Vampire Survivors / GBA),
paleta vibrante e quente para a natureza saudável, contornos definidos, sombreamento simples (cel),
fundo TRANSPARENTE, sprite isolado e centralizado, sem texto, sem moldura.
Resolução do sprite: 64x64 px (personagens) ou conforme indicado.
```

> ⚠️ Muitas IAs não exportam pixel art "real" (grade de pixels limpa). Se a imagem vier "borrada",
> use o site **Pixelator / Retro Diffusion / Aseprite** para limpar, ou peça arte real no itch.io (ver 07).

---

## A. Personagens (Lendas) — sprite sheets direcionais

Para CADA lenda, você precisa de animações: **idle** + **andar** nas 4 direções (cima/baixo/esq/dir).
Gere idealmente como sprite sheet ou frames separados.

### Curupira (protagonista)
```
Pixel art top-down de um Curupira do folclore brasileiro: menino indígena de cabelos vermelhos/fogo,
pele morena, com os PÉS VIRADOS PARA TRÁS (característica da lenda), expressão corajosa, segurando um
cipó/chicote verde. Estilo Vampire Survivors, 64x64, fundo transparente, vibrante.
Gere uma folha de sprites com: idle (2-4 frames) e caminhada para baixo, cima, esquerda e direita
(3-4 frames cada).
```

### Saci-Pererê
```
Pixel art top-down de um Saci-Pererê: menino negro de UMA PERNA só, gorro/carapuça vermelho mágico,
fumando um cachimbo, envolto por um pequeno redemoinho de vento. Saltitante e travesso. 64x64,
fundo transparente. Folha de sprites: idle + caminhada nas 4 direções.
```

### Iara
```
Pixel art top-down da Iara (sereia do folclore brasileiro): mulher com cauda de peixe verde-azulada,
longos cabelos escuros, aura de água encantada, beleza serena. 64x64, fundo transparente.
Folha de sprites: idle + movimento nas 4 direções (deslizando sobre a água).
```

### Boitatá
```
Pixel art top-down do Boitatá: serpente de fogo brilhante, corpo feito de chamas e brasas, olhos
incandescentes, rastro de fogo. 64x64 a 96x96, fundo transparente. Idle + movimento nas 4 direções.
```

> Repita o padrão para: Boto (golfinho encantado que vira homem elegante), Lobisomem, Negrinho do
> Pastoreio (menino com vela e cavalo), Mula-sem-Cabeça (égua flamejante sem cabeça), Cuca (jacaré-bruxa),
> Caipora (guardião com javali). Use as descrições de docs/04 §1.

---

## B. Inimigos (criaturas corrompidas)

```
Pixel art top-down de um [ANIMAL] CORROMPIDO pela praga: [animal] da fauna brasileira com aspecto
sombrio e apodrecido, brilho roxo/preto oleoso nos olhos, energia corrompida saindo do corpo.
Mantém a silhueta reconhecível do animal. 48x48, fundo transparente, estilo Vampire Survivors.
Animação de caminhada simples (2-4 frames) na direção do alvo.
```
Variações de `[ANIMAL]`: vaga-lume sombrio (enxame), formigão, lobo do cerrado, jacaré, capivara,
urubu (atirador), sapo venenoso (atirador), cabra-demônio (tanque), escorpião, onça (mini-boss).

### Inimigo elite (dropa baú)
```
Pixel art top-down de uma criatura corrompida ELITE: maior, com aura/brilho roxo intenso e uma coroa
de espinhos de Corrupção, claramente mais perigosa. 64x64, fundo transparente.
```

---

## C. Bosses

```
Pixel art top-down de boss para jogo estilo Vampire Survivors: o MAPINGUARI corrompido — criatura
gigante peluda da Amazônia, um olho só, boca na barriga, garras enormes, energia de Corrupção roxa.
Imponente, ocupa bastante da tela. 128x128 ou maior, fundo transparente, com frames de ataque e idle.
```
> Repita para: Onça Corrompida (Mata Atlântica), Cobra-Grande (Pantanal), Mula-sem-Cabeça (Caatinga),
> Lobisomem (Cerrado), Cuca (Fundo do Rio), Coração da Corrupção (boss final). Ver docs/04 §2 e §4.

---

## D. Projéteis e efeitos dos Encantos

```
Pixel art de efeitos para jogo top-down, fundo transparente, vibrantes:
- Cipó/chicote verde em arco (sprite de ataque frontal)
- Vaga-lumes dourados brilhantes (orbe pequeno, 16x16)
- Pedra mágica saltitante (16x16)
- Raio de Tupã (relâmpago vertical, 32x96)
- Onda de canto da Iara (ondas concêntricas azuis translúcidas)
- Roda de fogo do Boitatá (anel de chamas)
- Semente de Luz (cristal/gema brilhante para coletar, 16x16, com brilho)
```

---

## E. Cenário / Tilesets por bioma

```
Pixel art tileset top-down para jogo estilo Vampire Survivors, tileável (seamless), bioma MATA ATLÂNTICA
brasileira: chão de terra e grama exuberante, com variações (folhas, raízes, flores, pedras). Paleta
verde vibrante e dourada. Tiles de 32x32 ou 48x48, organizados em grade.
```
> Repita para Amazônia (verde escuro/chuva), Pantanal (lama/água), Caatinga (ocre/rachado), Cerrado
> (dourado seco), Fundo do Rio (azul/bioluz), Cidade Assombrada (cinza/neon). Ver docs/04 §2.

---

## F. Menu: background, logo e botões (igual o vídeo, mas temático)

### Background do menu (depois animável em vídeo loop)
```
Arte 2D pixelada, 1920x1080, para tela de menu de jogo: uma floresta da Mata Atlântica brasileira à
noite sob uma LUA CHEIA enorme, vaga-lumes dourados flutuando, silhueta de um Curupira de cabelo de
fogo em uma clareira, atmosfera mágica e mítica, tons de verde profundo, azul-noite e dourado.
Estilo pixel art detalhada, cinematográfico.
```
> Para animar (opcional, estilo do vídeo): leve esse PNG a uma ferramenta de image-to-video (ex: Higgs
> Field Sea Dance / Kling / Runway) com o prompt: *"loop suave: vaga-lumes flutuam, folhas balançam ao
> vento, a luz da lua pulsa devagar, fumaça/névoa se move. Vídeo em loop perfeito."*

### Logo do jogo
```
Logo pixelada 2D para um jogo indie chamado "RECONTO", com subtítulo menor "Enquanto Eu Brilhar"
(versão em inglês: "While I Shine"), tema folclore brasileiro místico, fundo TRANSPARENTE. Tipografia
que mistura o místico e o natural (folhas, fogo, vaga-lumes integrados às letras). Cores: dourado,
verde e um toque de roxo mágico. Estilo medieval-folclórico, divertido e épico.
```

### Botões e ícones de UI
```
Conjunto de botões e ícones de UI em pixel art para jogo de folclore brasileiro, fundo transparente:
botões de madeira/cipó com cantos de folha, ícones de coração (vida), gema (XP), lua (ciclo), amuleto
(figa), e ícones para os encantos. Estilo coeso, cores quentes e mágicas.
```

---

## Como integrar a arte no jogo (prompt para o Claude Code)

Depois de baixar/gerar os arquivos e colocá-los em `assets/sprites/`, abra o Claude Code e use:

```
Tenho um sprite sheet em assets/sprites/curupira.png. É um personagem top-down 2D pixelado com
animações: as linhas/colunas representam idle e caminhada para baixo, cima, esquerda e direita
(me confirme a leitura analisando a imagem; o frame é aproximadamente 64x64).
Faça o seguinte:
1. Configure a importação como pixel art (filtro Nearest).
2. Crie um AnimatedSprite2D (ou SpriteFrames) com as animações: idle, walk_down, walk_up, walk_left,
   walk_right, fatiando o sheet corretamente.
3. Substitua o placeholder do Player (Curupira) por esse AnimatedSprite2D, tocando a animação de
   caminhada correta conforme a direção de movimento e idle quando parado.
Garanta que o pivot/centro fique correto e que não haja "shimmer" de pixel.
```

> Repita esse prompt para cada inimigo/boss, ajustando o nome do arquivo e o tamanho do frame.
> Para tilesets: peça ao Claude para criar um TileSet a partir da imagem e pintar o chão do bioma.
