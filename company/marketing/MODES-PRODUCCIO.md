# Com es fabrica cada cosa que es veu en pantalla

> El llegeixen el subagent `social-strategist` i les skills `/video-ia`, `/youtube` i `/reel`.
> Respon una sola pregunta: **d'on surt cada píxel**, amb quina eina, què costa i si està
> verificat en aquesta màquina.

## El malentès que cal treure del mig

Claude no dibuixa píxels. Però **la major part del que fa que un vídeo es vegi bé no és una
imatge generada**: són rètols que es mouen, captures reals del producte, diagrames vectorials i
ritme. Tot això és **codi** — HTML, CSS, SVG i una línia de temps de GSAP que Hyperframes
renderitza a MP4. És determinista, es corregeix al píxel i no costa res.

Només hi ha **una** categoria que necessita un model generatiu de debò: **fotografies i
persones fotorealistes**. I és, justament, la que es paga.

## Taula d'actius

| Què es veu | Amb què es fa | Cost | Estat |
|---|---|---|---|
| Animacions, transicions, entrades i sortides | Hyperframes + GSAP, codi escrit a mà | 0 | **verificat** |
| Rètols, xips, comptadors, barres, segells | idem (`kpop`, `wipe`, `slotReveal`, `typeIn`…) | 0 | **verificat** |
| Zoom, shake, flash, iris, PiP de la càmera | idem | 0 | **verificat** |
| Diagrames i esquemes (el flux d'una trucada) | **SVG en línia** escrit a mà | 0 | **verificat** (doc-designer) |
| Icones | SVG en línia, traç 1,5-2 px, `currentColor` | 0 | **verificat** |
| Logotips de tecnologies i plataformes | `media-use resolve --type logo` (svgl → simple-icons) | 0 | per verificar |
| Captures del producte, del web o del panell | `npx hyperframes capture <URL>` + Chrome headless en fosc | 0 | **verificat** |
| Gravació de pantalla (una trucada de Nertus de debò) | captura pròpia — el millor B-roll que teniu | 0 | **verificat** |
| Fons i fotografies d'estoc | `media-use resolve --type image` | via gratuïta de HeyGen | per verificar |
| Música de fons | `media-use resolve --type bgm` | idem | per verificar |
| Efectes de so | `make-sfx.sh` — sintetitzats amb ffmpeg, no es baixa res | 0 | **verificat** |
| Narració en veu | **1r: la veu dels agents de Nertel.** 2n: `media-use resolve --type voice` | 0 / via gratuïta | per verificar |
| Imatges fotorealistes i persones genèriques | fal.ai amb `fal-gen.py image` | **pagament** | no provat |
| Clip de 5-10 s a partir d'una foto | fal.ai imatge→vídeo (Kling) amb `fal-gen.py animate` | **pagament** | no provat |
| Avatar parlant de l'Adrià o de l'Enric | HeyGen: cal **una gravació de consentiment de ~2 min**, no fotos | **pagament** | no provat |
| Subtítols | `captions.py` sobre la transcripció, corregits a mà, cremats | 0 | **verificat** |

Les comandes exactes són a `~/.claude/skills/reel/SKILL.md`; el motor, a
`~/.claude/skills/forja-reel/assets/`.

## Ordre de preferència quan dubtis

1. **Una captura real** del producte abans que qualsevol cosa generada. Ven més una trucada de
   Nertus de debò que una recepcionista d'estoc.
2. **Un diagrama o un rètol animat** abans que una fotografia. Explica, i és nostre.
3. **Estoc** abans que generació per IA: és gratuït i no té artefactes.
4. **Generació per IA** l'última, i només quan la imatge és el missatge.

Cada baixada d'aquesta escala costa més diners i més risc de semblar fet amb IA.

## Els tres modes de producció

L'agent tria **un mode per peça** i ho diu al pla abans de produir res.

### Mode A — sense cara (el per defecte)

Veu + captures + motion graphics. Cap persona en pantalla. És el gruix del que es publicarà:
barat, ràpid, sense vall inquietant, i és el format de la majoria de reels tècnics que funcionen.

### Mode B — avatar nostre

Un avatar construït **una sola vegada** a partir d'una gravació de consentiment de dos minuts.
A partir d'aquí no es torna a gravar. Per a obertures i stories on convingui que hi hagi algú.

**No surt de fotos.** Una bateria de fotos dona clips curts sense parla (mode C), no un
presentador. I el sincronisme de llavis **en català** és la part més feble de totes les eines:
un pla curt aguanta; un primer pla parlant canta.

### Mode C — persones i escenes generades

Per il·lustrar una situació (algú desbordat de trucades). Clips de 5-10 s, sense parla.

**Tres límits que no es negocien:**

- **Cap persona generada pot aparèixer com un client de Nertel**, ni donar un testimoni, ni
  signar una xifra. Seria un cas d'èxit fabricat, i una empresa que ven que la seva IA diu que
  és IA no es pot permetre això.
- **El contingut sintètic realista s'etiqueta.** Instagram, TikTok i YouTube ho exigeixen, i
  l'agent ho ha de fer sol, cada vegada, no quan algú ho recordi.
- **Cap cara d'una persona real sense permís.** Ni clients, ni empleats, ni ningú que passi per
  una captura.

## Diners

fal.ai i HeyGen de pagament **no es contracten ni es gasten sense un sí explícit de l'Adrià per
a cada cosa.** `FAL_KEY` i les claus de HeyGen viuen a les variables d'entorn: mai en un repo,
mai impreses al terminal, mai enganxades al xat. Si una peça necessita un mode de pagament,
l'agent ho diu **al pla**, amb el cost estimat, abans de produir.

Abans de dissenyar cap peça sobre el mode B o el C, cal passar la prova de `PROVA-AVATAR.md`.
No es promet una capacitat que no s'ha vist funcionar.
