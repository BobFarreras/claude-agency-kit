# Estalvi de context — com aguantar més amb els mateixos resultats

> Data: 2026-08-10. Basat en mesures reals de la màquina d'en Boby, no en teoria.
> Objectiu: reduir consum sense baixar la qualitat de l'entrega.

## 1. El diagnòstic

Mesura d'una sessió real de treball amb n8n:

| Categoria | Tokens | % |
| --- | ---: | ---: |
| **Messages** | **743,8k** | **94%** |
| MCP tools | 13,2k | 1,7% |
| System tools | 12,6k | 1,6% |
| Skills | 5,6k | 0,7% |
| System prompt | 5,0k | 0,6% |
| Memory files | 2,7k | 0,3% |
| Custom agents | 862 | 0,1% |
| **Total configuració** | **~40k** | **5%** |

**Conclusió: la configuració no és el problema.** Els 7 agents ocupen 862 tokens. Les 36
skills, 5,6k. El `CLAUDE.md`, 1,8k. Retallar-ho tot plegat estalviaria un 5%.

El problema és que **la conversa creix i es reenvia sencera a cada torn**.

### La matemàtica

No pagues pel que escrius: pagues pel context acumulat, multiplicat per cada torn.

```
Torn 10  → context 150k → cost 150k
Torn 30  → context 450k → cost 450k
Torn 50  → context 750k → cost 750k
```

El cost total d'una sessió creix **quadràticament**. Una sessió que arriba a 750k pot
haver consumit 15-20 milions de tokens d'entrada pel camí. Partir-la per la meitat
estalvia prop del 50% del total, no el 50% del pic.

### Per què les sessions d'n8n són les pitjors

Els resultats de les eines d'n8n són enormes i s'acumulen:

- `get_workflow_details` d'un workflow gran: desenes de milers de tokens
- `get_node_types`: definicions TypeScript senceres
- `get_sdk_reference`: document de referència complet
- `get_execution`: el payload sencer d'una execució
- El bucle `validate` → arreglar → `validate` torna a abocar tot el codi cada volta

Cinc iteracions de validació d'un workflow mitjà = 200k+ tokens que després viatgen a
cada missatge fins al final de la sessió.

---

## 2. Capa 1 — La comporta automàtica (la més important)

El problema és que depèn de recordar-se'n. Això no. A `~/.claude/settings.json`:

```json
{
  "autoCompactWindow": 300000
}
```

Compacta automàticament quan el context arriba a 300k, en comptes de deixar-lo créixer
fins a 750k+. Acceptat: la compactació resumeix i perd detall fi. Però un resum de 300k
és millor que arrossegar 450k de sortides d'eines que ja no tornaràs a mirar.

Rang admès: 100.000 – 1.000.000.

- **300000** — recomanat per a sessions d'n8n i infra (sortides d'eines grans)
- **400000** — si notes que perd context útil massa aviat

---

## 3. Capa 2 — Un model per agent (aplicat)

Cap dels 7 agents tenia `model:` al frontmatter, així que **tots corrien amb Opus**,
inclosos els que maqueten HTML o renderitzen reels.

El camp existeix i accepta `sonnet`, `opus`, `haiku`, `fable`, un ID complet, o `inherit`
(el valor per defecte).

| Agent | Model | Per què |
| --- | --- | --- |
| `webapp-builder` | **opus** | Codi de producció, arquitectura, TDD. Aquí la qualitat és el producte |
| `vps-guardian` | **opus** | Els errors d'infra són cars i sovint irreversibles. S'invoca poc |
| `n8n-architect` | **sonnet** | El SDK està documentat i el MCP valida per tu. És on més es gasta i on menys cal Opus |
| `doc-designer` | **sonnet** | Molt volum de sortida (HTML llarg), poca profunditat de raonament |
| `reels-producer` | **sonnet** | Igual: el gruix és renderitzar, no decidir |
| `ui-prototyper` | **sonnet** | Stitch + escriure el `DESIGN.md` |
| `tech-scout` | **sonnet** | Llegir changelogs i comparar convencions. Corre un cop al mes |

Regla per decidir-ho en el futur: **Opus quan una decisió equivocada costa cara i és
difícil de desfer. Sonnet quan el resultat es veu de seguida i es corregeix.**

### No hi ha escalada automàtica

Un agent amb `model: sonnet` **no pujarà mai sol a Opus** per molt que s'encalli. El camp és
fix. `fallbackModel` només cobreix que un model no estigui *disponible*, no que la tasca
sigui difícil.

L'escalada és manual i no cal tocar cap fitxer: en invocar l'agent se li pot passar el model.
La regla pràctica és **si falla dos cops seguits en el mateix punt, escala**. Si passa sovint
amb el mateix agent, llavors sí, canvia-li el frontmatter.

### Explore amb Haiku

Un agent d'usuari anomenat `Explore` sobreescriu el que ve de sèrie i conserva el seu
propi `model`. Buscar per la base de codi no necessita Opus:

```yaml
---
name: Explore
description: Cerca ràpida i de només lectura per la base de codi.
model: haiku
---
```

### Altres camps del frontmatter que estalvien

| Camp | Per a què |
| --- | --- |
| `mcpServers` | Limita quins MCP carrega l'agent. El `doc-designer` no necessita Supabase ni Vercel |
| `effort` | `low`/`medium`/`high`/`xhigh`/`max`. Baixa el raonament intern en tasques mecàniques |
| `tools` | Menys eines = menys esquema carregat |
| `maxTurns` | Talla els agents que s'enrotllen |

---

## 4. Capa 3 — La sessió principal

`settings.json` (es llegeix a l'inici de sessió; per canviar-lo en calent, `/model`):

```json
{
  "model": "sonnet",
  "autoCompactWindow": 300000
}
```

Posar **Sonnet per defecte i pujar a Opus quan cal** és millor que a l'inrevés: la majoria
de torns d'una sessió són coordinació, lectura i confirmacions, no raonament difícil.

Puja a Opus amb `/model opus` quan entris en:
- disseny d'arquitectura
- un bug que ja s'ha resistit a dos intents
- una migració de dades o un canvi d'infra

I torna a baixar quan surtis. `fallbackModel` també existeix si vols una cadena quan el
primari no està disponible.

---

## 5. Capa 4 — Els tres hàbits que realment compten

**1. `/clear` en canviar de feina.** El que més estalvia de tot el document. Acabes el
workflow d'n8n → `/clear` → comences la landing. No a mitja tasca: perds context útil i
la memòria cau del proveïdor.

**2. Tanca el bucle d'n8n abans de seguir.** Quan el workflow ja està creat i validat,
`/clear`. No continuïs demanant coses noves dins d'una sessió que arrossega cinc voltes
de validació.

**3. Agrupa les instruccions.** Cada "sí, endavant" reenvia el context sencer. Un missatge
amb tres coses costa un terç que tres missatges amb una cosa.

Bonus: per verificar que un text o un botó hi és, llegir la pàgina en text costa una
fracció d'una captura de pantalla — i la captura es queda al context tota la sessió.

---

## 6. Per a projectes de codi — la part generalitzada

Això no s'ha de refer projecte per projecte. Hi ha tres peces que ho cobreixen:

### `/optimitza-context` — per a qualsevol repo, nou o existent

Skill d'usuari. S'obre una sessió dins del projecte i s'invoca. Mesura què es carrega a cada
sessió, proposa amb números, i aplica el que se li aprovi. És la manera de posar al dia un
projecte que ja existeix.

### Subagents d'usuari amb Haiku — serveixen a tot arreu

Viuen a `~/.claude/agents/`, així que **cap projecte els ha de tornar a definir**:

| Agent | Model | Què resol |
| --- | --- | --- |
| `test-runner` | haiku | Executa tests/lint/typecheck/build i torna només el que falla |
| `Explore` | haiku | Cerca per la base de codi i torna ubicacions, no fitxers |

Aquí és on més es guanya en un projecte gran: el que abocaria milers de línies al context
principal es queda en un context d'usar i llençar, i en tornen cinc línies.

### `/new-client-project` — els projectes neixen configurats

El pas 5 de la skill ja crea el `.claude/settings.json` i marca com ha de ser el `CLAUDE.md`:

```json
{
  "model": "sonnet",
  "autoCompactWindow": 300000
}
```

### Com ha de ser el `CLAUDE.md` d'un projecte

Curt, i que **digui on són les normes en comptes de copiar-les**. Es carrega a cada sessió
**i a cada subagent personalitzat** (només `Explore` i `Plan` se'l salten), així que tot el
que hi posis es multiplica.

El número que importa és **el total d'arrencada**: el `CLAUDE.md` més tot el que mana llegir
per defecte. Si passa de ~5k tokens, hi ha feina. La correcció quasi sempre és la mateixa:
passar documents de "llegeix-los sempre" a "consulta'ls quan…". El document segueix sent-hi;
només deixa de carregar-se cada cop.

### MCP per projecte

Un repo de landing no necessita el MCP d'n8n; un d'automatitzacions no necessita el de
Vercel. Es desactiven amb `disabledMcpjsonServers` al `.claude/settings.json` del projecte.

---

## 7. Ordre d'implementació

| # | Pas | Esforç | Impacte |
| --- | --- | --- | --- |
| 1 | `model:` a cada agent | fet | Alt |
| 2 | `autoCompactWindow: 300000` global | 1 min | **El més alt** |
| 3 | Hàbit del `/clear` entre feines | continu | **El més alt** |
| 4 | `model: sonnet` per defecte a la sessió | 1 min | Alt |
| 5 | `Explore` amb Haiku | 2 min | Mitjà |
| 6 | `.claude/settings.json` als repos de client | 5 min/repo | Mitjà |
| 7 | `mcpServers` limitat per agent | 10 min | Mitjà |
| 8 | Partir `SERVIDOR-ACTUAL.md` (30 KB) per servei | 20 min | Baix-mitjà |

Els passos 2 i 3 sols ja et donen el gruix de l'estalvi. La resta són marges.

---

## 8. Com comprovar que funciona

`/context` en un terminal `claude` interactiu, un cop a mitja sessió de treball real.

El número a vigilar és **`Messages`**. Si arriba a 300k, la comporta ha saltat. Si passa
de 500k amb regularitat, baixa `autoCompactWindow` o fes `/clear` més sovint.
