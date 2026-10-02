---
name: radar-social
description: Llegeix les mètriques de les peces ja publicades i en treu conclusions per al playbook — retenció, desades i què repetir. Fes-la servir amb /radar-social.
disable-model-invocation: true
---

Analitza el rendiment de `$ARGUMENTS` (una peça, un mes o un compte). Si no t'han donat dades,
demana-les: **no te les inventes ni les estimes mai**.

Treballa com el subagent `social-strategist`.

## Què necessites

Captures de les estadístiques de la plataforma, o els números copiats. Com a mínim, per peça:

- **Retenció als 3 segons** (o la corba, si la plataforma la dona).
- **Desades** i **compartits**.
- Visualitzacions, i quantes venen de seguidors i quantes de recomanació.
- Accions sobre l'enllaç, si la peça en tenia.

Si una captura té dades personals (noms de qui ha comentat, missatges), **no les reprodueixis**
al document.

## Com es llegeix

| Senyal | Què vol dir | Què es canvia |
|---|---|---|
| Cau al segon 1 | El primer fotograma no para l'scroll | Obertura més forta: més contrast, més moviment, el dato abans |
| Cau al segon 3 | Ha parat l'scroll però la promesa és fluixa | Reescriure la frase del ganxo |
| Cau a mig vídeo | Hi ha un tram mort | Un canvi visual fort en aquell segon exacte |
| Moltes vistes, poques desades | Entreté, no serveix | Angle més útil i concret |
| Poques vistes, moltes desades | Bona peça mal distribuïda | Repetir l'angle, provar una altra obertura |

**Les desades i els compartits manen sobre els "m'agrada".** Diuen si la peça serveix a algú; els
"m'agrada" diuen que algú passava per allà.

## La disciplina que fa que això serveixi

Una conclusió a partir de resultats **no és una regla fins que hi ha tres peces que apunten en la
mateixa direcció**. Abans d'això s'escriu al playbook com a **hipòtesi amb el seu `n=`**.

Dos casos entren de seguida: una **decisió de l'Adrià** i un **fet verificat** (comportament
d'una eina reproduït).

Compte amb les comparacions que no es poden fer: una peça publicada un dimarts a les nou i una
un dissabte a les tres no són comparables, i dues peces de format diferent, tampoc.

## Entrega

Un resum curt: què ha funcionat, què no, i **una sola cosa** a canviar a la pròxima peça. Una
llista de deu millores no es fa; una es fa.

Després proposa l'actualització del playbook `playbook-social-strategist.md` — i
**espera el vistiplau de l'Adrià abans d'escriure-hi res**.
