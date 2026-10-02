---
name: portafoli
description: Munta el cas d'èxit d'un projecte ja fet (problema, solució, resultats, captures) com a pàgina visual per ensenyar a clients nous, més el PDF. Fes-la servir amb /portafoli.
disable-model-invocation: true
---

Munta el cas de portafoli del projecte `$ARGUMENTS`. Si no t'han dit quin, mira la taula
"Índex de clients actius" del `~/.claude/CLAUDE.md` i pregunta quin d'aquests.

**Escriu a** `%USERPROFILE%\Desktop\empresa\entregues\<client>\portafoli\AAAA-MM-DD-nom\`,
mai a una carpeta temporal. Vegeu `entregues\README.md`.

Treballa com el subagent `doc-designer`, amb
`~/.claude/company/docs-visuals/SISTEMA-VISUAL.md` com a base.

## Recull el material primer

Abans d'escriure res, reuneix:

- **Què li passava al client** abans (amb dades, si n'hi ha: hores perdudes, comandes
  extraviades, trucades no ateses).
- **Què vau fer**, en termes del negoci del client — no en termes de stack.
- **Què ha canviat després**, mesurat. Si encara no hi ha mesura, digues-ho i deixa el cas
  com a esborrany fins que n'hi hagi.
- **Captures reals** de la web, del workflow o del panell. Si el repositori del projecte és
  a la màquina, aixeca'l i fes-ne les captures tu; si no, demana-les.
- **Permís del client** per ensenyar-ho, i què es pot dir amb nom i què no.

Si falta la meitat d'això, digues què falta abans de construir. Un cas de portafoli amb
resultats inventats no és un error de format: és una cosa que no es pot ensenyar a ningú.

## Estructura

1. **Una frase de resultat** com a titular ("Els pressupostos passen de 3 dies a 20 minuts").
   No el nom del projecte.
2. **El client en dues línies**: sector, mida, què ven.
3. **El problema**, concret i reconeixible. Qui el llegeixi ha de pensar "això em passa a mi".
4. **La solució**, explicada com un diagrama del flux: què entra, què passa, què surt. Aquí és
   on el diagrama fa més feina que el text.
5. **Els resultats**, com a xifres grans. Tres com a màxim.
6. **Les captures**, grans i amb un peu que digui què s'hi veu.
7. **Tancament**: què podria fer el mateix per a qui llegeix, i com contactar.

## Regles

- **Res de gerga tècnica al text principal.** "Supabase amb RLS" no diu res a un client
  potencial; "cada client només veu les seves dades, garantit pel servidor" sí. Deixa el
  stack en una fitxa lateral al final, per a qui li interessi.
- **Cap dada inventada ni arrodonida a l'alça.** Si el número és estimat, escriu que ho és.
- **Res que soni a demo**: cap captura amb dades de prova visibles, cap `lorem`, cap domini
  `.test`. Si les captures tenen dades falses, canvia-les per dades realistes o demana'n de
  reals.
- Les captures pesen: incrusta-les com a `data:` URI ja optimitzades (amplada màxima real
  1600 px) perquè el fitxer segueixi sent un de sol i no es dispari de mida.

## Comporta visual

Obre el cas al panell perquè l'Adrià el miri, i **espera el vistiplau** abans del PDF.
Repassa-ho tu abans amb ulls de client potencial: si una captura del projecte no es llegeix a
la mida en què surt, no serveix — retalla-la a la part que importa.

## Verificar i entregar

1. PDF, obert i comprovat: les imatges no han de quedar tallades entre pàgines.
   ```bash
   "/c/Program Files/Google/Chrome/Application/chrome.exe" --headless --disable-gpu --no-pdf-header-footer --print-to-pdf="cas-<client>.pdf" "cas-<client>.html"
   ```
2. **Revisor independent — aquí sí que cal**, perquè el cas s'ensenya a clients nous i
   l'error no el pagues amb una edició. Un subagent `general-purpose` que no ha muntat el cas.
   Encarrega-li expressament que miri **si es veu cap dada de tercers** a les captures i **si
   alguna xifra sona a inventada o arrodonida a l'alça**; això ho ha de marcar com a avís
   perquè ho signis tu, no resoldre-ho. Si el veredicte no és `PASS`, corregeix i revalida.
3. Entrega els fitxers i **recorda si el client havia donat permís** per ensenyar-ho amb nom.
   Si no consta, entrega'l anonimitzat i digues-ho.
