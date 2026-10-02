---
name: pla-social
description: Prepara el pla de contingut social d'un mes (angles, formats, plataformes i calendari) per a una marca, amb el mode de producció i el cost de cada peça. Fes-la servir amb /pla-social.
disable-model-invocation: true
---

Prepara el pla de contingut per a `$ARGUMENTS` (la marca i el període; si no t'ho han dit,
pregunta-ho). Per defecte: Nertel AI, el mes que ve.

**Escriu a** `%USERPROFILE%\Desktop\empresa\entregues\empresa\AAAA-MM-pla-social\PLA.md`,
mai a una carpeta temporal.

Treballa com el subagent `social-strategist`. Carrega abans:
`~/.claude/company/marketing/MARCA-<marca>.md`, `MODES-PRODUCCIO.md` i
`~/.claude/company/_engine/playbook-social-strategist.md`.

## 1. Parteix de l'objectiu, no del calendari

Pregunta què ha de passar aquest mes: **demos demanades**, **explicar el producte** o
**posicionar l'empresa**. Un pla que vol les tres coses no aconsegueix cap.

Pregunta també **quant es pot produir de debò**. Val més tres peces bones al mes que dotze
mitjanes, i un pla que no es compleix desmoralitza.

## 2. Banc d'angles

Proposa **8-10 angles** d'una línia, cadascun amb el problema del client que ataca. Surten del
producte i dels sectors de la marca, mai de l'actualitat de la IA.

Marca per cada angle:

| Camp | Què hi va |
|---|---|
| Format | reel · story · YouTube · carrusel · post |
| Plataforma | i per què aquella (Instagram, TikTok, YouTube, LinkedIn) |
| Mode de producció | A (sense cara) · B (avatar) · C (escenes generades) |
| Cost | 0, o l'import estimat si toca una eina de pagament |
| Material que falta | una captura, una gravació de pantalla, una xifra que ha de donar l'Adrià |

**Els angles que depenen d'una capacitat no verificada** (modes B i C, vegeu `PROVA-AVATAR.md`)
es marquen com a **condicionats**, i el pla ha de funcionar sense ells.

## 3. Que l'Adrià triï

Presenta els angles i **espera que en triï**. No muntis el calendari amb els teus preferits: el
pla el defensa ell davant dels clients i de l'Enric.

## 4. Calendari

Amb els angles aprovats:

- Una peça per fila: data, format, plataforma, angle, mode, què cal perquè es pugui produir.
- **Agrupa la producció**: tres reels del mateix mode es munten molt més barat seguits que
  repartits pel mes.
- Reserva la primera peça del mes a la més segura. Si falla la més ambiciosa, el mes no cau.
- Marca quines peces **necessiten material de l'Adrià** i amb quants dies d'antelació.

## 5. El text de publicació no s'escriu aquí

Al pla només hi va **la primera línia** de cada peça, perquè és l'única que es veu sense
desplegar i és el que decideix si es mira. La resta s'escriu quan es produeixi la peça.

## 6. Entrega

`PLA.md` amb els angles aprovats, el calendari i la llista de material pendent. Digues **què
bloqueja quina peça** i què necessites primer.

**No publiquis res ni programis res.** Si el pla demana publicació recurrent automatitzada, el
workflow el dissenya `n8n-architect` quan l'Adrià ho demani.
