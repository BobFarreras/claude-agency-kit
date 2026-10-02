---
name: optimitza-context
description: Audita i optimitza el consum de context d'un projecte de codi — mesura què es carrega a cada sessió, hi deixa un .claude/settings.json, i retalla la cadena de lectura obligatòria. Fes-ho servir en qualsevol repo, nou o existent, quan els límits s'esgotin massa ràpid.
disable-model-invocation: true
---

Optimitza el consum de context del projecte on ets ara. **Mesura primer, després actua** —
mai proposis retallades sense números.

El principi de fons: el 95% del consum és `Messages` (el que s'acumula durant la sessió),
no la configuració. Per això aquesta skill ataca **el que es carrega a cada sessió i a cada
subagent**, que és la part de la configuració que sí que es multiplica. El detall és a
`~/.claude/company/_engine/ESTALVI-DE-CONTEXT.md`.

---

## Pas 1 — Mesura

Recull, sense modificar res:

1. **Mida del `CLAUDE.md`** del projecte (i de qualsevol `CLAUDE.md` de subdirectori).
2. **Què mana llegir.** Llegeix el `CLAUDE.md` i identifica cada document que digui de
   llegir per defecte a l'inici. Mesura'ls tots.
3. **Documents grans del repo**: qualsevol `.md` de més de 15 KB a l'arrel, a `docs/` o
   allà on visqui la documentació.
4. **Configuració existent**: hi ha `.claude/settings.json`? `.claude/agents/`?
   `.mcp.json`? Quins MCP hi ha actius que aquest projecte no fa servir?

Presenta-ho en una taula amb bytes i tokens estimats (≈ bytes ÷ 4), i **el total
d'arrencada**: el que es carrega abans de fer res.

Recorda-ho i digues-ho: aquest total es paga **un cop per sessió i un cop més per cada
subagent personalitzat**, perquè tots carreguen el `CLAUDE.md` del projecte (només `Explore`
i `Plan` se'l salten).

## Pas 2 — Proposa

Amb els números a la mà, proposa només el que compensi de veritat:

- **`.claude/settings.json`** versionat, si no n'hi ha:
  ```json
  {
    "model": "sonnet",
    "autoCompactWindow": 300000
  }
  ```
  Ajusta `model` a `opus` si el projecte és crític o toca seguretat o diners.

- **Retalla la cadena de lectura obligatòria.** La regla: al `CLAUDE.md` només hi va per
  defecte el que cal **sempre**. La resta passa a "consulta-ho quan…". Els documents
  segueixen existint i accessibles; només deixen de carregar-se cada cop.

- **Documents de més de 20 KB que es llegeixen sempre.** Assenyala'ls i proposa partir-los,
  però **no els parteixis tu sense que t'ho aprovin**: el contingut és de qui manté el
  projecte. El cas típic és un `current-state.md` o un `CHANGELOG` que acumula història
  dins d'un document que hauria de dir només què passa ara.

- **Subagents de projecte** a `.claude/agents/`, si el projecte té feina repetitiva amb
  molta sortida que ara va al context principal. Abans de crear-ne cap, comprova que no ho
  cobreixi ja un d'usuari (`test-runner`, `Explore`).

- **MCP que sobren.** Un repo de landing no necessita el d'n8n; un d'automatitzacions no
  necessita el de Vercel. Es desactiven amb `disabledMcpjsonServers` a `.claude/settings.json`.

## Pas 3 — Aplica

Aplica només el que t'aprovin. Els canvis additius (`settings.json`, subagents nous) els
pots fer directament; **tocar el contingut de la documentació del projecte, no** — això es
proposa com a diff.

Si el repo és en una branca de feina, digues-ho i pregunta si volen els canvis aquí o en una
branca a part.

## Pas 4 — Tanca amb el resultat

Una taula **abans → després** del total d'arrencada, i la manera de comprovar-ho:
`/context` a mitja sessió de treball real, mirant el número de `Messages`.

Sigues honest amb el resultat. Si l'estalvi és de 2k tokens, digues que és de 2k i que no
val la pena celebrar-ho — la palanca gran segueix sent `/clear` entre feines.

---

## El que aquesta skill NO ha de fer

- **No retallis el `CLAUDE.md` fins a deixar-lo inútil.** Un `CLAUDE.md` de 1-2 KB que
  apunta bé val els seus 400 tokens mil vegades. L'objectiu no és zero context: és que no
  es carregui allò que no es farà servir aquella sessió.
- **No treguis normes de seguretat ni de qualitat** per estalviar tokens. Si una regla evita
  un error car, es queda encara que ocupi.
- **No proposis retallar skills, agents ni MCP globals** com a mesura principal: junts són
  ~5% del consum. Només els que aquell projecte concret no fa servir mai.
