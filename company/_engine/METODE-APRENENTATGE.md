# Com aprenen els nostres agents (mètode)

> Adaptat del patró d'una skill externa de gestió de reels: motor estable + coneixement viu
> + porta d'aprovació humana. El mètode és general d'enginyeria de software; l'aplicació
> concreta als nostres agents és nostra.

## La decisió que ho fa segur

**Els agents (`.claude/agents/*.md`) i les skills mai s'editen a si mateixos.** El que
evoluciona és un `_engine/playbook-<agent>.md` per cada agent — un fitxer de dades, no
d'instruccions. Això evita que el sistema es degradi sol amb el temps: si un agent pogués
reescriure les seves pròpies regles sense supervisió, un error es podria consolidar com si
fos coneixement vàlid.

## El cicle

```
FEINA REAL (projecte de client, incident, automatització)
   │
   ▼
S'ANOTA   → què es va decidir i per què (una entrada breu, no cal cap eina especial)
   ▼
S'ACUMULA → cada agent guarda les seves entrades a _engine/playbook-<agent>.md
   ▼
ES REVISA → periòdicament (mensual és un bon ritme per començar), es repassen les entrades
   ▼
ES PROPOSA → una regla només puja a "confirmada" amb ≥3 casos reals que hi apuntin
   ▼
S'APROVA  → tu decideixes quines regles entren — mai s'apliquen soles
   ▼
   └──────────────────────────────────────────────────────────────┘
        el playbook actualitzat alimenta la següent feina de l'agent
```

## Disciplina d'evidència (per no omplir-ho de suposicions)

No tot el que aprenem s'aprèn de la mateixa manera, i tractar-ho tot igual fa mal per les
dues bandes: obliga a trepitjar tres vegades el mateix error de llibreria, i alhora deixa
passar per "confirmat" el que només és una intuïció repetida. Per això hi ha **tres tipus
d'evidència**, i només un necessita acumular casos:

| Tipus | Què és | Quan puja a regla |
| --- | --- | --- |
| **Decisió** | L'Adrià ho ha demanat explícitament | **De seguida.** No l'ha de validar la realitat: la realitat és ell |
| **Fet verificat** | Comportament d'una llibreria o d'un sistema, reproduït i comprovat en execució | **De seguida**, indicant com s'ha comprovat |
| **Inferència** | "Això sembla que funciona millor" — un criteri tret de resultats | **Amb ≥3 casos reals** en la mateixa direcció |

- Tota **inferència** comença com a **hipòtesi**, amb el recompte de casos anotat (`n=1`).
- Una **decisió** o un **fet verificat** poden entrar directament a regles confirmades,
  però **sempre amb l'etiqueta i la data**, perquè qui llegeixi el playbook sàpiga per què
  hi ha una regla amb un sol cas.
- Si els fets contradiuen una regla confirmada, es rebaixa o s'elimina — això també és
  progrés, no un error. Val per als tres tipus: una decisió es pot canviar d'opinió i un
  fet verificat pot deixar de ser cert quan surt una versió nova.
- Cap dada inventada: si no ho saps, deixa-ho en blanc, no ho estimis.
- Si en una revisió no hi ha res a afegir, **escriu-ho al changelog**. Un playbook buit amb
  una nota de "revisat, res a afegir" informa; un playbook buit i mut no se sap si és
  honestedat o descuit.

## Una comporta ha de costar menys que el que protegeix

Val per a tots els agents. Una comporta — una aprovació, un revisor independent, una passada
de captures — existeix per evitar un cost. Si en costa més que aquell, no és una comporta: és
un peatge, i s'ha de reduir o treure.

El que decideix no és la importància de la feina, és **què costa desfer l'error**:

| Si desfer l'error costa… | La comporta pot costar… |
| --- | --- |
| Minuts de màquina o un render (un reel) | Molt: revisor independent, storyboard, doble validació |
| Una edició d'un fitxer (un HTML) | Poc: una comanda, una mirada, un `grep` |
| Un client, un import o una dada publicada | Molt, encara que desfer sigui tècnicament barat |

L'últim cas és el que enganya: el que es mesura no és la dificultat tècnica de desfer-ho,
sinó **si l'error surt de l'empresa abans que el trobis**.

Compte especialment amb **transplantar una comporta d'un agent a un altre**. Va passar el
2026-07-30: el revisor independent i la comporta de captures del `reels-producer` es van
copiar tal qual al `doc-designer`, i van costar més de 300.000 tokens per protegir un
document que es refà amb una edició. Les comportes eren bones; el que no es va comprovar és
que l'economia fos la mateixa. **Quan copiïs una comporta, copia també la pregunta de què
costa desfer l'error allà.**

## Dos tipus d'aprenentatge, dos mecanismes diferents

1. **Aprenentatge dels nostres propis resultats** (què ha funcionat amb els nostres
   clients) → viu al `playbook-<agent>.md` de cada agent, es revisa periòdicament, tu
   n'aproves els canvis.
2. **Aprenentatge de canvis externs** (noves versions, noves pràctiques del sector) → és
   feina de l'agent `tech-scout`, que vigila el món exterior i proposa diffs al `CLAUDE.md`
   i als agents — tampoc aplica res sol.

Cap dels dos mecanismes toca mai les instruccions d'un agent directament. Sempre passen
per un fitxer de dades intermedi que tu aproves.
