# Expansão de Conteúdo — História, Lendas, Encantos, Inimigos e Chefes

> Documento ADITIVO gerado a partir da análise dos docs 01–05. Nada aqui substitui os docs originais:
> é o catálogo expandido para as Fases 3–6 do roadmap. Quando uma proposta conflitar com decisão sua,
> a sua decisão vence — atualize aqui.
> **Convenção:** ✅ = já existia nos docs 01–05 · ✨ = proposta nova.

---

## 1. História expandida (arco em 3 atos)

### 1.1 Prólogo — "A Primeira Noite"
Numa noite sem estrelas, a Luz da Mata tremeluziu pela primeira vez em mil anos. O Curupira, guardião
mais antigo da Mata Atlântica, sentiu o cheiro antes de ver: fumaça que não vinha de fogueira, e um
silêncio onde deviam cantar os grilos. Quando chegou à clareira, os bichos que ele jurou proteger já
não eram bichos — eram cascas ocas de olhos roxos, marchando para o coração da floresta.

A Árvore Sagrada — a jabuticabeira anciã, raiz do mundo encantado — o chamou pela última vez com voz
inteira: *"Eles estão esquecendo, menino. E o que é esquecido, apodrece. Segura a noite. Eu seguro a
raiz."*

> **Uso no jogo:** cutscene de 4–6 quadros de pixel art estático + texto, antes do tutorial. Barata de
> produzir, estabelece tom.

### 1.2 Estrutura em atos

| Ato | Biomas | Pergunta dramática | Revelação ao fim do ato |
|---|---|---|---|
| **I — A Praga** | Mata Atlântica, Amazônia | "O que é a Corrupção?" | Ela não mata: ela **apaga**. Os corrompidos são lendas e bichos que o mundo deixou de contar. |
| **II — As Lendas Caídas** | Pantanal, Caatinga, Cerrado | "Por que lendas antigas viraram chefes?" | Todo chefe é um Encantado que foi esquecido primeiro. Vencê-lo não o destrói — **purifica**. As lendas redimidas se juntam a você (viram jogáveis). |
| **III — A Origem** | Fundo do Rio, Cidade Assombrada | "De onde ela vem?" | A Corrupção nasce na cidade — não das pessoas, mas do **esquecimento** delas. O chefe final é feito das histórias não contadas. |

### 1.3 O sistema narrativo das "Lendas Redimidas" ✨
Isso resolve uma inconsistência dos docs atuais (Mula, Cuca e Lobisomem são chefes E jogáveis) e vira
um pilar narrativo:

> **Vencer um chefe-lenda = purificá-lo.** A Alvorada queima a Corrupção do corpo dele e a lenda
> desperta, com uma dívida de gratidão. No hub (Árvore Sagrada), a lenda redimida aparece como NPC
> antes de ser selecionável — uma fala curta de agradecimento por redenção dá peso emocional grátis.

- Mula-sem-Cabeça purificada → jogável (já previsto ✅).
- Lobisomem purificado → jogável (já previsto ✅).
- Cuca purificada → jogável (já previsto ✅).
- **Iara** ✨: no Fundo do Rio ela não é a chefe — é a **prisioneira** da Cuca corrompida. Resgatá-la
  (vencer o bioma) a desbloqueia. Isso conserta o desbloqueio duplo "Vencer Fundo do Rio" dos docs:
  Cuca é redimida, Iara é resgatada — dois desbloqueios, duas cenas, um bioma.

### 1.4 O chefe final — "Coração da Corrupção" (proposta que resolve o Saci-Sombra)
O doc 02 cita "Saci-Sombra / Coração da Corrupção" e o doc 04 só "Coração da Corrupção". Proposta ✨:

O Coração não tem forma própria — ele é **espelho**. A luta tem 4 fases; nas 3 primeiras ele assume a
**Sombra de uma lenda que você já jogou** (prioriza as 3 mais usadas pelo jogador no save: Saci-Sombra,
Curupira-Sombra, Iara-Sombra...), usando versões corrompidas dos encantos delas. Na fase final, ele
vira o que realmente é: um vazio com forma de gente, que ataca **apagando pedaços da arena** (o chão
esquecido deixa de existir).

**Mecânica-tema:** durante a luta final, os Encantados que você já redimiu aparecem na borda da arena
**contando histórias** — cada lenda desbloqueada no save = 1 buff ativo na luta. Jogar o jogo é
literalmente juntar contadores de história para o confronto final. O tema ("enquanto as histórias forem
contadas, os Encantados não morrem") vira mecânica.

### 1.5 Textos de bioma (abertura/vitória — para telas de loading e pós-run)
| Bioma | Abertura (1 linha) | Vitória (1 linha) |
|---|---|---|
| Mata Atlântica | "O cheiro de fumaça chegou antes do amanhecer." | "A mata respira. Por hoje." |
| Amazônia | "O coração verde bate fraco — e algo enorme anda entre as árvores." | "O Mapinguari dorme de novo. Que sonhe com o que era." |
| Pantanal | "O rio subiu torto, e o que subiu com ele não é peixe." | "As águas baixaram limpas. A Cobra-Grande guarda o fundo outra vez." |
| Caatinga | "O sertão rachou. Das fendas, sobe um galope de fogo." | "A Mula parou de correr. Pela primeira vez em cem anos, descansou." |
| Cerrado | "Aqui a lua não desce. Alguém a pregou no céu." | "A lua cheia se pôs. O uivo agora é de alívio." |
| Fundo do Rio | "A canção da Iara sumiu. No lugar dela, um silêncio com dentes." | "O rio canta de novo — e desta vez, canta junto." |
| Cidade Assombrada | "Ninguém aqui olha pra cima há muito tempo. É onde a praga mora." | "Uma criança na janela apontou pra você e sorriu. Lembrou." |

---

## 2. Lendas jogáveis — fichas completas

Formato: stats são **desvios da base** do GDD §5. Habilidade ativa com cooldown em segundos.

### 2.1 Curupira 🦶 (inicial — protagonista)
- **História:** o guardião dos bichos, pés virados para trás para confundir caçadores. Foi o primeiro
  a ver a Corrupção — e o primeiro a jurar que ela não passa.
- **Arma inicial:** Cipó Chicoteante. **Passiva:** +0,5 HP/s parado sobre vegetação; rastro de pegadas
  invertidas (inimigos que pisam nelas se confundem 1s a cada 10s).
- **Ativa — "Pés Invertidos" (CD 20s):** por 3s, todos os inimigos num raio invertem direção.
- **Stats:** HP 100 · Vel 62 · sem modificadores. A régua de balanceamento.

### 2.2 Saci 🌀 (1.000 Luar)
- **História:** o menino do redemoinho nunca levou nada a sério — até a Corrupção engolir a mata onde
  ele escondia todas as suas travessuras. Agora apronta com raiva.
- **Arma inicial:** Pedra do Saci. **Passiva:** +15% Vel. Mov.; 10% de chance de esquivar dano de contato.
- **Ativa — "Dash de Vento" (CD 6s):** dash curto com i-frames; deixa mini-redemoinho que empurra.
- **Stats:** HP 80 (frágil) · Vel 72 · Sorte 110%.

### 2.3 Iara 🌊 (resgatada no Fundo do Rio)
- **História:** a dona das águas cantou por séculos para acalmar o rio. A Cuca corrompida roubou sua
  voz e a prendeu no próprio reino. Resgatada, ela canta de novo — agora para chamar de volta os perdidos.
- **Arma inicial:** Canto da Iara. **Passiva:** +50% duração de encantados; +2 no limite de aliados.
- **Ativa — "Canto Hipnótico" (CD 30s):** encanta todos os inimigos não-elite num raio médio por 4s.
- **Stats:** HP 90 · Vel 58 · Dano 90% (o exército compensa).

### 2.4 Boitatá 🔥 (vencer Cerrado)
- **História:** a serpente de fogo que protege os campos de quem queima por ganância. A Corrupção usou
  o fogo dele como arma — agora ele quer o fogo de volta ao seu propósito: proteger.
- **Arma inicial:** Roda do Boitatá. **Passiva:** imune a fogo (inclusive queimada do bioma); movimento
  deixa rastro flamejante curto.
- **Ativa — "Explosão Ígnea" (CD 15s):** nova radial que incendeia o chão em anel.
- **Stats:** HP 110 · Vel 56 · Área 110%.

### 2.5 Boto 🐬 (5.000 Luar)
- **História:** o encantador dos bailes ribeirinhos. Sedução aqui é carisma de festa: ele lembra a cada
  criatura corrompida a alegria que ela teve um dia.
- **Arma inicial:** Dança do Boto. **Passiva:** encantados fracos não contam no limite de aliados.
- **Ativa — "Convite ao Baile" (CD 25s):** inimigos num cone dançam (atordoados) 3s; os que morrerem
  dançando soltam +50% Sementes.
- **Stats:** HP 95 · Vel 64 · Sorte 120%.

### 2.6 Lobisomem 🐺 (vencer Cerrado)
- **História:** redimido sob a lua que o escravizava. Aprendeu que a fúria pode ter dono.
- **Arma inicial:** Garras Lunares. **Passiva:** +50% dano/vel. ataque na Lua Cheia; -20% na Alvorada.
- **Ativa — "Fúria Lunar" (CD 40s):** por 6s, força "estado Lua Cheia" pessoal (buffa a si e as Garras).
- **Stats:** HP 120 · Vel 66 · Recuperação 0,5/s. **Risco/recompensa temporal** — a lenda para quem
  entendeu o Ciclo da Lua.

### 2.7 Negrinho do Pastoreio 🕯️ (conquista: encantar 100 inimigos)
- **História:** o menino que nunca mais perdeu nada — porque a mata inteira procura com ele. Tratado
  com máxima dignidade: aqui ele é o pastor de luz que devolve o que a Corrupção roubou.
- **Arma inicial:** Vela do Pastoreio (invoca 1 aliado espectral persistente).
- **Passiva:** velas acesas marcam o chão onde ele para; aliados dentro do círculo ganham +25% dano.
- **Ativa — "Chamado" (CD 35s):** invoca a tropilha (3 cavalos de luz que atravessam a tela).
- **Stats:** HP 85 · Vel 60 · Duração 130%.

### 2.8 Mula-sem-Cabeça 🐴🔥 (vencer Caatinga)
- **Arma inicial:** Coice Flamejante. **Passiva:** dano de contato contra inimigos (ela machuca ao
  esbarrar); knockback recebido -100%.
- **Ativa — "Galope" (CD 18s):** 2s de investida imparável atravessando a horda, com dano no caminho.
- **Stats:** HP 150 · Vel 50 (lenta!) · Armadura 3. A tanque.

### 2.9 Cuca 🐊 (vencer Fundo do Rio)
- **Arma inicial:** Maldição da Cuca (DoT em área). **Passiva:** inimigos com DoT dão +20% Sementes.
- **Ativa — "Feitiço do Sono" (CD 30s):** área grande dorme 4s (elites 2s); acordar com dano.
- **Stats:** HP 90 · Vel 54 · Duração 140% · Dano 110%. A build de "bruxa de controle".

### 2.10 Caipora 🐗 (conquista: sobreviver aos 30 min com 3 lendas diferentes)
- **Arma inicial:** Matilha da Caipora (invoca porcos-do-mato que investem em linha).
- **Passiva:** animais encantados/invocados ganham +30% velocidade e dano.
- **Ativa — "Estouro" (CD 45s):** manada atravessa a tela inteira na direção do movimento.
- **Stats:** HP 100 · Vel 68 · Quantidade +1 (só para invocações).

### 2.11 Candidatas pós-v1.0 ✨ (backlog, não fazer agora)
| Lenda | Gancho mecânico |
|---|---|
| **Matinta Pereira** | assobio = marca inimigos; marcados tomam +dano de tudo (build de "debuffer") |
| **Naiá (lenda da vitória-régia)** | flores na água curam em área; a lenda-suporte |
| **Anhangá** | forma espectral: atravessa inimigos, mas não pode parar de se mover |

---

## 3. Encantos — catálogo completo (20 para a v1.0)

Colunas: padrão (do doc 03 §2), evolução = Amuleto + condição → Forma Ancestral.

| # | Encanto | Padrão | Evolução (Amuleto + condição) | Forma Ancestral — o que muda |
|---|---|---|---|---|
| 1 ✅ | **Cipó Chicoteante** | melee frontal | Figa | **Cipó da Mãe-da-Mata** — raízes brotam em toda a tela |
| 1b ✅ | (caminho 2) | | Fita do Bonfim **+ Lua Cheia** | **Cipó Sagrado** — cura 1 HP por acerto |
| 2 ✅ | **Pedra do Saci** | projétil saltitante | Chocalho | **Redemoinho de Pedras** — pedras nunca param, orbitam a tela quicando |
| 3 ✅ | **Vaga-lumes Guardiões** | orbital | Sal Grosso | **Muralha de Luz** — anel duplo que reflete projéteis |
| 4 ✅ | **Roda do Boitatá** | aura de fogo | Galho de Arruda | **Fogaréu** — a aura incendeia o chão permanentemente (usa bioma reativo) |
| 5 ✅ | **Peixeira Voadora** | projétil no mais próximo | Pena de Tucano | **Revoada de Peixeiras** — leque de 7, atravessam inimigos |
| 6 ✅ | **Relâmpago do Trovão**¹ | raio do céu | Pó de Estrela¹ | **Tempestade** — raios em cadeia (salta a 3 vizinhos) |
| 7 ✅ | **Canto da Iara** | conversão (1 alvo forte) | Espelho d'Água ✨ **+ Madrugada** | **Coro das Águas** — encantados cantam: convertem por contágio |
| 8 ✅ | **Vela do Pastoreio** | invocação persistente | Olho-de-Boi ✨ | **Tropilha Encantada** — 3 cavalos de luz patrulham |
| 9 ✅ | **Assobio do Saci** | confusão em área | Apito de Barro ✨ | **Ventania Traquina** — redemoinho que arrasta confusos |
| 10 ✅ | **Dança do Boto** | conversão (vários fracos) | Fita Colorida ✨ | **Baile do Rio** — pista de dança fixa no chão: quem entra, dança pro seu lado |
| 11 ✨ | **Fogo-Fátuo** | projétil errante que persegue | Galho de Arruda **+ Cerrado** | **Fogo Corredor** — se divide a cada abate |
| 12 ✨ | **Casca de Jabuticaba** | retaliação (dano a quem toca) | Couro de Anta ✨ | **Casca da Anciã** — retaliação + 50% do dano refletido em área |
| 13 ✨ | **Rede do Pescador** | zona que prende + dano lento | Renda de Bilro ✨ | **Rede da Maré** — a rede puxa os presos para o centro (agrupa p/ combo) |
| 14 ✨ | **Flores de Ipê** | chuva em área aleatória | Mel de Jataí ✨ | **Primavera Teimosa** — pétalas curam você e danificam inimigos |
| 15 ✨ | **Tacape Rodante** | bumerangue | Dente de Jacaré ✨ | **Tacape do Gigante** — gigante, lento, moe tudo no caminho de ida e volta |
| 16 ✨ | **Poeira do Sertão** | cone que cega (erram ataques) | Ferradura ✨ | **Vendaval de Areia** — 360°, cegos tomam +30% dano |
| 17 ✅ | **Coice Flamejante** | explosão radial periódica | Ferradura ✨ **+ Caatinga** | **Coice do Trovão** — a explosão abre fenda de fogo em linha |
| 18 ✅ | **Maldição da Cuca** | DoT em área | Lua Minguante | **Pesadelo** — quem morre com DoT explode em maldição contagiosa |
| 19 ✅ | **Matilha da Caipora** | invocação (investida em linha) | Cuia de Erva ✨ | **Estouro Eterno** — a matilha volta a cada 8s sozinha |
| 20 ✅ | **Garras Lunares** | melee giratório 360° | Lua Minguante **+ Lua Cheia** | **Eclipse** — cada golpe escala com a fase da lua; na Cheia, dobra |

> ¹ **Correção cultural aplicada aqui:** o doc 03 chama de "Relâmpago de Tupã", mas Tupã é entidade
> religiosa Guarani — pela própria regra do doc 02 §1, melhor evitar. Proposta: **"Relâmpago do
> Trovão"** (mantém a força, zera o risco). Mesma lógica já anotada no doc 03 para "Pó de Pemba" →
> **"Pó de Estrela"** (adotado aqui). Decisão final é sua.

**Regra de distribuição por build (verificar no balanceamento):** 6 dano direto, 3 conversão, 3
invocação, 3 controle/debuff, 2 defesa/retaliação, 3 híbridos. Todo arquétipo de build (dano, exército,
tanque, controle) precisa fechar 6 slots sem repetir padrão.

---

## 4. Amuletos — catálogo completo (16)

Sobre **"armaduras e acessórios"**: no gênero survivors não existem slots de equipamento separados —
**Amuletos SÃO os acessórios** e "Armadura" é um stat que eles concedem. Recomendo não criar um sistema
de gear paralelo na v1.0 (escopo). Para a coceira de "equipamento", ver §7 (Relíquias, v2).

| # | Amuleto | Efeito por nível (máx 5) | Chave de evolução de |
|---|---|---|---|
| 1 ✅ | Figa | +8% Área, +5% Sorte | Cipó Chicoteante |
| 2 ✅ | Fita do Bonfim | +10% Duração, +0,2 HP/s | Cipó (caminho 2) |
| 3 ✅ | Galho de Arruda | +8% Dano | Roda do Boitatá, Fogo-Fátuo |
| 4 ✅ | Sal Grosso | +1 Armadura, reflete 5% dano de contato | Vaga-lumes |
| 5 ✅ | Pó de Estrela¹ | +6% Vel. Ataque | Relâmpago |
| 6 ✅ | Pena de Tucano | +5% Vel. Mov., +15 px Magnetismo | Peixeira |
| 7 ✅ | Chocalho | +1 Quantidade (nível 3 e 5) | Pedra do Saci |
| 8 ✅ | Lua Minguante | +8% XP | Maldição, Garras Lunares |
| 9 ✨ | Espelho d'Água | +10% Vel. Projétil; nível 5: projéteis inimigos 10% de refletir | Canto da Iara |
| 10 ✨ | Olho-de-Boi | +10% Ganho de Luar, +10 px Magnetismo | Vela do Pastoreio |
| 11 ✨ | Apito de Barro | +12% duração de encantados, +1 limite de aliados (nv 3/5) | Assobio do Saci |
| 12 ✨ | Fita Colorida | +6% Sorte, +6% Duração | Dança do Boto |
| 13 ✨ | Couro de Anta | +2 Armadura | Casca de Jabuticaba |
| 14 ✨ | Renda de Bilro | +8% Área (só zonas/áreas fixas) | Rede do Pescador |
| 15 ✨ | Mel de Jataí | +0,4 HP/s | Flores de Ipê |
| 16 ✨ | Dente de Jacaré | +10% dano contra Tanques e Elites | Tacape Rodante |
| 17 ✨ | Ferradura | +1 Armadura, +8% Sorte | Poeira do Sertão, Coice |
| 18 ✨ | Cuia de Erva | invocações ganham +10% dano e HP | Matilha da Caipora |

> Nomes escolhidos entre objetos de proteção **popular** (figa, ferradura, olho-de-boi, fita) e cultura
> material brasileira (renda de bilro, cuia, chocalho) — sem termos litúrgicos, seguindo o doc 02 §1.

---

## 5. Bestiário por bioma

Stats em tamanhos relativos (P/M/G) — números absolutos só no playtest. "Fase" = quando ele brilha
(Ciclo da Lua). Todo bioma tem no mínimo: 2 enxames, 1 médio, 1 atirador, 1 tanque, 1 lunar OU aquático.

### Mata Atlântica (ato 1 — ensina o jogo)
| Inimigo | Cat. | Comportamento | Fase |
|---|---|---|---|
| Vaga-lume Sombrio | Enxame | reta no player, morre em 1 hit | — |
| Cutia Oca | Enxame | corre em zigue-zague curto | — |
| Macaco-Prego Corrompido | Médio | orbita e investe | Noite |
| Sapo-Cururu Pustulento | Atirador | cospe arco de 3 projéteis lentos | — |
| Tamanduá Casca-Grossa | Tanque | lento, empurra, braçada telegrafada | — |
| Gato-do-Mato Lunar | Lunar | invisível fora da Lua Cheia; na Cheia, ataca em saltos | Lua Cheia |
| **Mini-boss: Bicho-Preguiça Desperto** | min 10 | quase parado, mas puxa o player com cipós (obriga a mover) | — |
| **BOSS: Onça Corrompida** | 30:00 | ver §6 | — |

### Amazônia
| Inimigo | Cat. | Comportamento | Fase |
|---|---|---|---|
| Formigão de Correição | Enxame | anda em FILA (corredores de dano — inédito no gênero) | — |
| Mosquito da Praga | Enxame | voa errático, rápido | — |
| Sapo Venenoso | Atirador | projétil que deixa poça de veneno | — |
| Jacaré-Açu Oco | Médio | investida em linha reta longa | Madrugada |
| Tatu-Canastra Blindado | Tanque | rola como bola quando toma dano | — |
| Boto Sombrio | Aquático | emerge de poças, agarra 1s | Madrugada |
| **Mini-boss: Sucuri de Lama** (min 10) · **Mini-boss 2: Harpia Cega** (min 20, mergulhos telegrafados) | | | |
| **BOSS: Mapinguari** ✅ | 30:00 | já especificado no doc 04 §4 | |

### Pantanal
| Inimigo | Cat. | Comportamento | Fase |
|---|---|---|---|
| Piranha Voadora | Enxame | salta do rio em arcos | Madrugada |
| Carrapato Gigante | Enxame | gruda e drena (dano contínuo até matar) | — |
| Capivara-Zumbi | Tanque | manada lenta que empurra em bloco | — |
| Jacaré do Brejo | Médio | fica submerso, emerge onde você vai estar | Madrugada |
| Tuiuiú Agourento | Atirador | voa alto, bica em mergulho | — |
| Ariranha Raivosa | Médio | ataca em duplas coordenadas | — |
| **Mini-boss: Touro Atolado** (min 12, investidas que abrem trilhas na lama) | | | |
| **BOSS: Cobra-Grande** | 30:00 | ver §6 | |

### Caatinga
| Inimigo | Cat. | Comportamento | Fase |
|---|---|---|---|
| Escorpião de Brasa | Enxame | rápido, deixa faísca ao morrer | — |
| Urubu de Três Olhos | Atirador | círculos no alto, cospe em quem está parado | — |
| Cabra-Demônio | Tanque | cabeçada com knockback forte | Lua Cheia |
| Cascavel Rachada | Médio | dá o bote de dentro das fendas | — |
| Fogo-Fátuo Faminto | Lunar | persegue flutuando, explode ao morrer | Lua Cheia |
| **Mini-boss: Carcará Rei** (min 10) · **Mini-boss 2: Bode Preto** (min 20) | | | |
| **BOSS: Mula-sem-Cabeça** ✅ | 30:00 | ver §6 | |

### Cerrado
| Inimigo | Cat. | Comportamento | Fase |
|---|---|---|---|
| Cupim Alado | Enxame | nuvens densas e lentas | — |
| Lobo-Guará Voraz | Médio | caça em matilha, cerca o player | Lua Cheia |
| Seriema Gritadora | Atirador | grito em cone (empurra projéteis seus) | — |
| Anta de Cinzas | Tanque | imune a fogo; espalha a queimada ao andar | — |
| Lobisomem Menor | Lunar | fraco fora da Cheia; na Cheia, dobra de tamanho | Lua Cheia |
| **Mini-boss: Alma da Queimada** (min 15, só toma dano quando fora do fogo) | | | |
| **BOSS: Lobisomem** ✅ | 30:00 | ver §6 — arena em Lua Cheia eterna | |

### Fundo do Rio
| Inimigo | Cat. | Comportamento | Fase |
|---|---|---|---|
| Peixe-Fantasma | Enxame | atravessa obstáculos, flutua em cardume | Madrugada |
| Afogado | Médio | lento, agarra e prende 1,5s | Madrugada |
| Água-Viva da Fossa | Atirador | pulso elétrico radial periódico | — |
| Bagre Ancião | Tanque | varre com a cauda em 180° | — |
| Sereia Rouca | Especial | canto que INVERTE seus controles 2s (telegrafado, raro) | Madrugada |
| **Mini-boss: Caranguejo Colossal** (min 12, pinças fecham corredores) | | | |
| **BOSS: Cuca** ✅ | 30:00 | ver §6 | |

### Cidade Assombrada (ato final)
| Inimigo | Cat. | Comportamento | Fase |
|---|---|---|---|
| Sombra de Esquina | Enxame | só se move quando você não olha (direção do movimento) | Noite |
| Papel Esquecido | Enxame | redemoinhos de lixo que cortam | — |
| Manequim Vazio | Médio | anda travado, acelera perto | — |
| Assombração de Terno | Atirador | maleta dispara moedas corrompidas | — |
| Caminhão Fantasma | Tanque | atravessa a tela em linha reta (evento, não perseguidor) | Madrugada |
| Eco de Lenda | Lunar | mini-versões-sombra de lendas jogáveis aleatórias | Lua Cheia |
| **Mini-boss: O Cobrador** (min 10) · **Mini-boss 2: A Notícia Ruim** (min 20, nuvem que cresce se ignorada) | | | |
| **BOSS FINAL: Coração da Corrupção** | 30:00 | ver §1.4 e §6 | |

---

## 6. Chefes — fichas de design (padrão do doc 04 §4: 2-3 fases, telegrafado, usa o hazard)

### Onça Corrompida (Mata Atlântica) — o chefe-tutorial
- **F1:** anda em círculos, bote telegrafado (sombra no chão 1s antes). Ensina "olhe o telegraph".
- **F2 (50%):** some nas sombras da borda, ataca de ângulos; cipós do hazard prendem o player.
- **F3 (20%):** rugido contínuo (tela treme), botes encadeados mais rápidos.
- **Leitura de design:** poucos adds. O chefe É a lição. Recompensa: 1º contato com a narrativa (a onça
  purificada foge mata adentro — plantando a ideia de redenção do ato II).

### Cobra-Grande (Pantanal)
- **F1:** submersa; só a marola indica posição. Emerge em bote vertical (área circular telegrafada).
- **F2 (60%):** ondas do hazard empurram o player para "ilhas"; ela cerca uma ilha por vez com o corpo.
- **F3 (25%):** enrola a arena inteira (anel que aperta), forçando você para o centro com os adds.

### Mula-sem-Cabeça (Caatinga)
- **F1:** galopes em linha atravessando a arena, trilha de fogo persistente (usa hazard de fogo).
- **F2 (50%):** galopa nas BORDAS (arena vira forno que encolhe), coices abrem fendas radiais.
- **F3 (20%):** para de correr pela primeira vez — chora fogo, explosões radiais lentas e enormes.
  (O choro prepara a purificação — ela não é vilã, é prisioneira.)

### Lobisomem (Cerrado)
- **F1:** caçador — investe, recua, investe. A arena está em **Lua Cheia eterna** (buffa ele E inimigos
  lunares seus, se você trouxe encantos lunares — risco/recompensa de build).
- **F2 (55%):** uiva e chama a matilha de lobos-guará; queimada do hazard começa nas bordas.
- **F3 (25%):** a lua **eclipsa** por 10s a cada 30s — no eclipse ele enfraquece (janela de dano), fora
  dele enfurece. Ensina o jogador a lutar em janelas.

### Cuca (Fundo do Rio)
- **F1:** flutua fora de alcance, lança maldições em área (círculos de sono — dormir = 2s vulnerável).
- **F2 (60%):** invoca Afogados; a correnteza do hazard muda de direção a cada 15s.
- **F3 (30%):** rouba temporariamente 1 encanto SEU (aleatório) e o usa corrompido contra você por 20s.
- **Cena pós-luta:** a jaula de canto se abre — Iara é libertada (desbloqueio duplo, ver §1.3).

### Coração da Corrupção (Cidade Assombrada — final)
- **F1–F3:** Sombras das 3 lendas mais jogadas do save (movesets = encantos iniciais delas, corrompidos).
- **F4 (30%):** forma verdadeira — o Vazio. Apaga células da arena (chão some, ver §1.4); as lendas
  redimidas na borda contam histórias = buffs por lenda desbloqueada.
- **Final:** derrotado, não explode — **lembra**. A cutscene inverte o prólogo: a cidade à noite, uma
  avó contando história para netos. A Luz da Mata acende nas janelas.

---

## 7. Sistemas complementares propostos ✨

### 7.1 Relíquias (a resposta a "armadura/equipamento" — SÓ v2, não incha a v1)
1 slot equipável antes do run, desbloqueada ao purificar cada chefe. Ex.: **Pelo da Onça** (+1 Armadura
na Mata Atlântica), **Escama da Cobra-Grande** (respirar no alagado), **Lágrima da Mula** (imune à
1ª morte por fogo). Dá função de longo prazo aos chefes já vencidos sem criar inventário complexo.

### 7.2 Simpatias adicionais (junta com as 6 do doc 04 §5)
| Simpatia | Efeito |
|---|---|
| **Noite Comprida** | run de 40 min: +2 fases de lua, chefe mais forte, +50% Luar |
| **Mata Silenciosa** | sem mini-bosses; o chefe final tem +1 fase |
| **Sina do Andarilho** | parado >2s = tomar dano; +25% Vel. e +25% XP |
| **Promessa** | escolha 1 Encanto antes do run: ele é garantido nas 3 primeiras cartas |
| **Contador de Histórias** | Ecos de lendas redimidas aparecem como aliados 1x por fase da lua |
| **Chuva de Prata** | Sementes viram Luar ao expirar sem coleta (build "deixa cair") |

### 7.3 Conquistas narrativas (amostra — ligam mecânica ao tema)
- **"Quem conta um conto"** — redima as 3 lendas-chefe (Mula, Lobisomem, Cuca).
- **"Aumenta um ponto"** — vença um run com 6 encantos evoluídos.
- **"Ninguém solta a mão de ninguém"** — termine a Lua Cheia com 10 encantados vivos.
- **"O sertão vai virar mar"** — na Caatinga, apague 50 células de fogo com encantos de água. *(pede
  interação água×fogo no bioma reativo — anotar na Fase 4)*

---

## 8. Correções e decisões pendentes nos docs 01–05 (para você bater o martelo)

| # | Onde | Problema | Proposta |
|---|---|---|---|
| 1 | doc 02 §6 vs doc 04 §2 | Chefe do Pantanal: "Cobra-Grande / Boitatá das águas" vs "Cobra-Grande". Boitatá é lenda JOGÁVEL — usar o nome no chefe confunde | Padronizar **Cobra-Grande** e remover "Boitatá das águas" do doc 02 |
| 2 | doc 03 §2 | "Relâmpago de Tupã" — Tupã é entidade religiosa Guarani; fere a regra do doc 02 §1 | Renomear **"Relâmpago do Trovão"** |
| 3 | doc 03 §3 | "Pó de Pemba" — o próprio doc sugere renomear | Adotar **"Pó de Estrela"** de vez |
| 4 | doc 04 §1 | Iara E Cuca desbloqueiam com "Vencer Fundo do Rio" (duplicado e sem explicação) | Sistema de Lendas Redimidas (§1.3): Cuca = redimida, Iara = resgatada |
| 5 | doc 02 §6 vs doc 04 §2 | "Saci-Sombra" como chefe final vs Saci jogável, sem conexão | Coração-espelho multi-fase (§1.4) — as Sombras são de QUALQUER lenda que você jogou |
| 6 | doc 01 §7 | Gamepad: "A" confirma level up E dispara habilidade ativa — conflito | Ativa no **RT/R2** (já sugerido na própria tabela), confirmar no A |
| 7 | doc 02 §6 | Mata Atlântica sem chefe na lore (doc 04 tem Onça Corrompida) | Adicionar Onça Corrompida ao doc 02 §6 item 1 |
| 8 | doc 04 §2 | Fundo do Rio: "Boss: Cuca" mas a lore diz que é o reino DA IARA | Resolvido pela §1.3 (Cuca invasora aprisiona Iara) — refletir no doc 02 §6 item 6 |
| 9 | geral | Projeto ainda não é repositório git (o CLAUDE.md pede commits por feature) | `git init` + primeiro commit dos docs antes de abrir o Godot |
