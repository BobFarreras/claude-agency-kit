# Playbook — webapp-builder

> El subagent `webapp-builder` llegeix aquest fitxer abans de començar una feina nova.
> Neix buit de regles confirmades — es va omplint amb feina real. Cap regla sense evidència.

## Regles confirmades

> Dos tipus d'evidència poden confirmar una regla sense esperar tres casos:
> **(decisió)** — l'Adrià ho ha demanat explícitament.
> **(fet verificat)** — comportament d'una llibreria reproduït i comprovat en execució.
>
> La inferència a partir de resultats ("això sembla que funciona millor") sí que necessita
> **≥3 casos** i comença sempre com a hipòtesi.

### Disseny

1. **El cos del text va a 18 px, no a 16.** Res que s'hagi de llegir de debò per sota de
   16 px. Camps de formulari a 19 px. Sobre fons càlids i de contrast baix, l'escala per
   defecte de Tailwind es llegeix malament.
   · *decisió, 2026-07-28*

2. **El hero ha de tenir moviment que impacti des del primer segon.** La il·lustració
   principal, gran i construint-se davant de l'usuari (traç amb `stroke-dashoffset`), amb
   el titular i la crida entrant esglaonats. Les seccions apareixen en fer scroll. Sempre
   amb sortida per `prefers-reduced-motion` i `@media (scripting: none)`.
   · *decisió, 2026-07-28*

3. **Res que soni a prova, demo o placeholder.** Cap "projecte de demostració", cap domini
   `.test` visible, cap text de farciment. Encara que sigui feina interna, el producte ha
   de semblar acabat i entregable.
   · *decisió, 2026-07-28*

4. **Si el client ven ofici visual** (tatuadors, clíniques dentals, estètica), **la galeria
   va en pàgina pròpia**, i ha d'admetre fotos reals sense tocar codi — amb un estat per
   defecte que no deixi forats mentre no n'hi hagi.
   · *decisió, 2026-07-28*

### Trampes del stack — comprovar-les sempre abans de donar res per acabat

5. **Els `@keyframes` han d'anar fora de qualsevol `@layer`.** Dins de `@layer utilities`,
   Tailwind v4 els processa com a utilitats i se'ls menja. No hi ha cap error: l'animació
   simplement no existeix i l'element es queda a `opacity: 0` per sempre.
   · *fet verificat — la regla `rise` no era al CSSOM; moguda fora del layer, hi apareix*

6. **React 19 buida el formulari després de cada `action`.** En un error de validació la
   persona perd tot el que ha escrit. L'acció ha de retornar els valors i el formulari els
   ha de tornar a posar com a `defaultValue`.
   · *fet verificat — tots els inputs a "" després d'enviar; cap test unitari ho detectava*

7. **L'autocompletat del navegador tapa els camps amb un rectangle blanc.** No es corregeix
   amb `background-color`: cal `-webkit-box-shadow: 0 0 0 100px <color> inset` més
   `-webkit-text-fill-color`, amb una variant per a les superfícies de paper.
   · *fet verificat*

## Hipòtesis en prova

- **El formulari públic escriu amb la clau publishable, no amb la secreta.** Amb la secreta
  tot funciona igual, però les polítiques d'RLS deixen de protegir res: passen a ser
  decoració. Amb la pública, la política d'insert és l'única cosa que decideix què entra —
  i es pot verificar amb tests reals contra la base de dades. · *n=1 (Arrel Estudi)*
- **Idempotència per token contra el doble clic.** El formulari genera un `submission_token`
  al primer enviament i el reutilitza; la restricció `unique` descarta el duplicat i per a
  la persona segueix sent un èxit. · *n=1*
- **Il·lustracions SVG pròpies en comptes de fotos d'estoc** quan encara no hi ha material
  del client: pesen zero, agafen el color del context i no delaten que hi ha una plantilla
  a sota. · *n=1*
- **Verificar sempre al navegador abans de donar res per bo.** Els tres errors de la secció
  anterior van conviure amb 32 tests en verd, `tsc` net i el build correcte. · *n=1, però
  amb tres errors trobats de cop*

## Changelog

- **2026-07-28** · primeres entrades, a partir del projecte Arrel Estudi (landing, galeria,
  captació de leads i registre intern). Set regles confirmades — quatre per decisió, tres
  per fet verificat — i quatre hipòtesis. Aprovat per l'Adrià.
