---
name: presentacio
description: Genera una presentació (deck) a partir d'un guió, unes notes o un document — diapositives HTML a pantalla completa amb animació, més el PDF apaïsat per enviar. Fes-la servir amb /presentacio.
disable-model-invocation: true
---

Munta la presentació sobre `$ARGUMENTS`. Si no t'han dit el tema ni el material de partida,
demana'l.

**Escriu a** `%USERPROFILE%\Desktop\empresa\entregues\empresa\AAAA-MM-DD-nom-curt\` (o a
`entregues\<client>\documents\...`), mai a una carpeta temporal. Vegeu `entregues\README.md`.

Treballa com el subagent `doc-designer`, amb
`~/.claude/company/docs-visuals/SISTEMA-VISUAL.md` com a base.

## Abans de res, tres preguntes

1. **Qui hi ha a la sala** i què decideix després (un client que ha de contractar, un equip
   que ha d'executar, una xerrada oberta).
2. **Es projecta amb tu al davant, o s'envia perquè la llegeixin sols?** Canvia-ho tot: la
   projectada porta poques paraules i tu ets el text; l'enviada s'ha d'entendre sense veu.
3. **Quant dura.** Compta **una diapositiva per minut** com a màxim. Si en surten 40 per a 20
   minuts, en sobren 20.

## Estructura

Comença per l'esquelet en una llista i confirma'l abans de construir res:

1. **Portada** — el títol diu la conclusió, no el tema.
2. **El problema**, en una diapositiva i amb una dada. Si l'audiència no el reconeix com a
   seu, la resta no importa.
3. **La idea**, una sola frase, sola a la diapositiva.
4. **Desenvolupament** — una idea per diapositiva. Si en necessites dues, són dues.
5. **La prova** — dades, cas real, demostració.
6. **Què passa ara** — què ha de fer qui escolta, concretament.

## Regles de la diapositiva

- **Una idea per diapositiva.** El titular és una frase completa que diu el missatge, no una
  etiqueta ("Les comandes es perden entre correus" i no "Situació actual").
- **Res per sota de 24 px projectats.** Al fons de la sala no s'hi veu.
- Màxim **sis línies** de text. Si en calen més, és un document, no una presentació.
- Les xifres, grans i soles. Una dada que ocupa mitja diapositiva es recorda; dins d'un
  paràgraf, no.
- Les notes de l'orador van a `<aside class="notes">` (amagat a pantalla i a la impressió),
  no dins la diapositiva.

## Construcció

Un sol fitxer HTML, diapositives a pantalla completa amb `scroll-snap`:

```css
*, *::before, *::after { box-sizing: border-box; }   /* imprescindible, mira la nota */

.deck { scroll-snap-type: y mandatory; overflow-y: auto; height: 100dvh; }
.slide { scroll-snap-align: start; min-height: 100dvh; display: grid; place-content: center;
         padding: clamp(2rem, 6vw, 6rem); }

@media print {
  @page { size: 297mm 167mm; margin: 0; }            /* 16:9 apaïsat */
  .deck { display: block; height: auto; overflow: visible; }
  .slide { height: 167mm; min-height: 0; overflow: hidden; break-inside: avoid; padding: 14mm; }
  .slide:not(:last-child) { break-after: page; }
  .notes { display: none; }
}
```

> **Comprovat el 2026-07-29:** amb `min-height: 167mm` en comptes de `height`, o sense
> `box-sizing: border-box`, el `padding` se suma a l'alçada i **cada diapositiva genera una
> pàgina en blanc darrere** — un deck de 20 surt de 40 pàgines. Igualment, `break-after: page`
> a l'última diapositiva n'afegeix una de buida al final: per això va amb `:not(:last-child)`.
> Compta sempre les pàgines del PDF abans d'entregar-lo.

- Navegació amb fletxes i espai, a més del scroll.
- Cada diapositiva anima el seu contingut en entrar-hi (entrada esglaonada); els diagrames
  es construeixen. Sempre amb `prefers-reduced-motion` i `@media (scripting: none)`.
- Numeració visible a baix a la dreta, fora a la impressió si no la vols al PDF.

## Comporta visual

Obre el deck al panell perquè l'Adrià el passi. **Espera el vistiplau** abans del PDF: en un
deck, canviar l'ordre o partir una diapositiva en dues és barat aquí i car després. No li
fabriquis una captura per diapositiva.

## Verificar i entregar

```bash
"/c/Program Files/Google/Chrome/Application/chrome.exe" --headless --disable-gpu --no-pdf-header-footer --print-to-pdf="presentacio.pdf" "presentacio.html"
python -c "import re;d=open('presentacio.pdf','rb').read();print(len(re.findall(rb'/Type\s*/Page[^s]',d)),'pagines')"
```

**Les pàgines han de ser tantes com diapositives.** Si en són el doble, mira la nota de
`height: 167mm` d'aquí sobre — és el defecte clàssic i el compte el destapa sol.

Comprova també el prefix `.js` i que no hi hagi cap petició a internet (vegeu `/guia-visual`).
Un deck intern **no necessita revisor independent**; si es projecta davant d'un client, sí.

Entrega `presentacio.html` i `presentacio.pdf`, i digues quantes diapositives són i quants
minuts calcules.
