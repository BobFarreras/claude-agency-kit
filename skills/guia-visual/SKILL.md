---
name: guia-visual
description: Converteix un document dens (guia, manual, documentació, apunts) en una pàgina visual animada amb diagrames que s'entén a la primera, més el PDF derivat. Fes-la servir amb /guia-visual.
disable-model-invocation: true
---

Converteix en una guia visual el material indicat a `$ARGUMENTS` (una ruta de fitxer, una
URL o el text que t'hagin enganxat). Si no t'han dit quin material és, demana'l abans de
res.

**Escriu a** `%USERPROFILE%\Desktop\empresa\entregues\empresa\AAAA-MM-DD-nom-curt\` (o a
`entregues\<client>\documents\...` si és d'un client), mai a una carpeta temporal. Hi van la
guia, el PDF, el material original i un README de tres línies — vegeu `entregues\README.md`.

Treballa com el subagent `doc-designer`: llegeix
`~/.claude/company/docs-visuals/SISTEMA-VISUAL.md` i parteix de
`~/.claude/company/docs-visuals/plantilla-base.html`.

## 1. Entendre abans de maquetar

Llegeix el material **sencer**. Després digues, en tres frases:

- Quina és la idea principal.
- Qui és el lector i què n'ha de saber fer després.
- Què és el que ara mateix costa més d'entendre.

Aquesta tercera frase és la que decideix el document: allò difícil és el que ha de rebre el
diagrama, l'exemple o la comparació.

## 2. Retallar

Marca què surt. En un document dens sol sobrar un 30-40 %: repeticions, justificacions,
introduccions que anuncien el que ve després. **Treure text és la meitat de la feina** — una
guia visual que conserva tots els paràgrafs originals no és una guia visual, és el mateix
document amb colors.

No treguis mai: xifres, condicions, límits, avisos de seguretat ni res que tingui
conseqüències si el lector no ho sap.

## 3. Decidir què és dibuix

Repassa el material i marca cada bloc com a **text / diagrama / taula / xifra gran /
exemple**. Van a diagrama:

| Si el contingut és… | Dibuix |
| --- | --- |
| Un procés amb passos | Flux horitzontal amb els passos numerats |
| Una jerarquia o una estructura | Arbre o caixes niades |
| Una comparació de 2-3 opcions | Columnes enfrontades, no una taula de text |
| Una evolució en el temps | Línia temporal |
| Parts d'un tot | Esquema amb etiquetes sobre les parts |
| Una decisió amb condicions | Arbre de decisió amb les respostes a les branques |

## 4. Confirmar l'esquelet

Presenta la llista de seccions amb el tipus de cada una i **espera el vistiplau** abans de
construir. És el pas que evita refer la pàgina sencera.

## 5. Construir

- Un sol fitxer HTML autocontingut, cos a 18 px, un color d'accent.
- Cada secció entra en fer scroll; els diagrames de procés es dibuixen en l'ordre en què
  s'expliquen (`stroke-dashoffset`).
- Comença amb un **resum en una pantalla**: la idea principal i tres punts. Qui només llegeixi
  això ja ha d'endur-se el més important.
- Si la guia és llarga, posa un índex lateral amb la secció activa marcada (`nomes-pantalla`,
  fora a la impressió).

## 6. Comporta visual

Obre `guia.html` al panell del navegador perquè l'Adrià el miri, i digues-li en quatre línies
què hi trobarà i quines decisions no òbvies has pres. **Espera el vistiplau** abans del PDF.

No fabriquis una captura per secció: ell ho veu millor al navegador i a tu et costa car.
Captura només si hi ha un dubte concret, i només d'aquella secció.

## 7. Verificar i entregar

Amb comandes, que és el que és barat:

```bash
grep -c "classList.add('js')" guia.html            # 1, i cap "scripting: none" residual
grep -coE 'src="http|href="http|@import' guia.html # 0 — cap petició a internet
"/c/Program Files/Google/Chrome/Application/chrome.exe" --headless --disable-gpu --no-pdf-header-footer --print-to-pdf="guia.pdf" "guia.html"
python -c "import re;d=open('guia.pdf','rb').read();print(len(re.findall(rb'/Type\s*/Page[^s]',d)),'pagines')"
```

Comprova també que **traient la classe `.js` de l'arrel el document es veu sencer**, i
l'amplada de mòbil. Una guia és un document intern: **no cal revisor independent**.

Entrega `guia.html` i `guia.pdf`, i digues **què has tret del material original i per què**.
Qui te l'ha donat ha de poder discutir-ho.
