---
name: proposta-client
description: Redacta i maqueta una proposta comercial per a un client (abast, fases, preu, condicions) com a pàgina visual, més el PDF per enviar i signar. Fes-la servir amb /proposta-client.
disable-model-invocation: true
---

Prepara la proposta per al client `$ARGUMENTS`. Si no t'han dit de qui és ni de què, demana-ho.

**Escriu a** `%USERPROFILE%\Desktop\empresa\entregues\<client>\propostes\AAAA-MM-DD-nom\`,
mai a una carpeta temporal. Vegeu `entregues\README.md`.

Treballa com el subagent `doc-designer`, amb
`~/.claude/company/docs-visuals/SISTEMA-VISUAL.md` com a base.

## El preu no te l'inventes

**Els imports, els terminis i les condicions de pagament els posa l'Adrià.** Si no te'ls ha
donat, para i demana'ls; deixa'ls marcats com a pendents i no continuïs fins tenir-los. Una
proposta enviada amb un preu inventat és un compromís que algú haurà de complir.

El mateix per a: dates d'entrega, quantes revisions inclou, i què passa si el client no
entrega el material a temps.

## Què has de saber abans d'escriure

1. Què li has entès **tu** al client (el problema en les seves paraules, no en les teves).
2. Què entra i, sobretot, **què no entra**.
3. Qui llegirà la proposta i qui signa. No sempre és la mateixa persona.
4. Si hi ha manteniment o quota mensual després de l'entrega.

## Estructura

1. **El que hem entès** — el problema del client, primer de tot. Una proposta que comença
   parlant de qui som es llegeix com un catàleg.
2. **Què proposem**, en una frase i un diagrama del resultat final.
3. **Abast** — llista concreta del que s'entrega.
4. **El que no inclou** — explícit i sense por. És el que evita la discussió del mes tres.
5. **Fases i calendari** — línia temporal amb què entrega cada fase i què necessites del
   client a cada punt.
6. **Inversió** — l'import per fase o total, amb les condicions de pagament. Si hi ha
   opcions, màxim tres i amb una recomanada.
7. **Manteniment** després de l'entrega, si n'hi ha.
8. **Condicions** — validesa de la proposta, propietat del codi, què passa si s'atura.
9. **Següent pas** — una sola acció clara.

## To

- Escrit per a algú que no és tècnic. Cap sigla sense explicar la primera vegada.
- Frases curtes. Res de "solucions integrals" ni "sinergies".
- El preu **no s'amaga** ni es posa en lletra petita: va en la seva secció, gran i clar.
  Amagar-lo fa desconfiar.
- La taula d'inversió ha de ser llegible impresa en blanc i negre.

## Comporta visual

Obre la proposta al panell i **espera el vistiplau**. Aquí la comporta té una feina extra: és
el moment que l'Adrià repassi amb calma **l'abast, el que no inclou i la taula d'inversió**,
que són les tres seccions que després es discuteixen.

## Verificar i entregar

1. Repassa que no hi hagi **cap import, data ni condició** que no t'hagi donat l'Adrià. Si en
   queda algun pendent, deixa'l marcat com a pendent i digues-ho — no l'estimis.
2. PDF — **és el que s'envia**, així que obre'l i comprova'l sencer: cap secció tallada, la
   taula de preus completa en una sola pàgina, i cap element animat invisible.
   ```bash
   "/c/Program Files/Google/Chrome/Application/chrome.exe" --headless --disable-gpu --no-pdf-header-footer --print-to-pdf="proposta-<client>.pdf" "proposta-<client>.html"
   ```
3. **Revisor independent — aquí sí que cal, sempre.** La proposta se li envia al client i hi
   ha imports que algú haurà de complir. Un subagent `general-purpose` que no l'ha redactada.
   Dona-li el PDF i les captures i encarrega-li que verifiqui, un per un: que **cada import i
   cada data** siguin els que li has dit que estaven aprovats, que l'apartat del que **no
   s'inclou** hi és i és explícit, i que la taula d'inversió es llegeix impresa en blanc i
   negre. Si el veredicte no és `PASS`, corregeix i revalida.
4. Entrega els fitxers. **No l'enviïs tu al client** ni per correu ni per cap altre canal:
   la revisa i l'envia l'Adrià.
