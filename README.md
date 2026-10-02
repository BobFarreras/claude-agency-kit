# claude-agency-kit

La configuració de Claude Code d'una agència petita: **subagents, skills, playbooks i regles**
per fer webs, automatitzacions, agents de veu, documents visuals i vídeo vertical.

Això no és un framework ni una llibreria. Són fitxers de text que Claude Code llegeix de
`~/.claude`, i és exactament el que fem servir cada dia.

## Què hi ha

| Carpeta | Què és |
| --- | --- |
| `CLAUDE.md` | L'índex que es carrega sempre: qui som, l'stack, les convencions i les regles que no es negocien |
| `agents/` | 10 subagents: `webapp-builder`, `n8n-architect`, `doc-designer`, `social-strategist`, `reels-producer`, `ui-prototyper`, `tech-scout`, `vps-guardian`, `test-runner`, `Explore` |
| `skills/` | 12 skills amb `/nom`: `/reel`, `/video-ia`, `/pla-social`, `/youtube`, `/radar-social`, `/guia-visual`, `/presentacio`, `/portafoli`, `/proposta-client`, `/new-client-project`, `/optimitza-context`, `/revisio-playbooks` |
| `company/_engine/` | Els **playbooks**: el que cada agent ha après, amb la distinció entre *decisió*, *fet verificat* i *hipòtesi* |
| `company/docs-visuals/` | El sistema visual dels documents i la plantilla base |
| `company/marketing/` | Context de marca, els tres modes de producció de vídeo i les proves d'avatar |

La part que costa més de copiar i que val més són els **playbooks**. Cada regla hi porta com
s'ha sabut: una decisió es pren i s'escriu, un fet verificat ha passat de debò, i una hipòtesi
porta `n=` i no es dona per bona fins a tres casos. És el que evita que un agent repeteixi un
error que ja va cometre fa dos mesos.

## Instal·lar-ho

```powershell
git clone https://github.com/BobFarreras/claude-agency-kit.git
cd claude-agency-kit
.\install.ps1          # ensenya què canviaria
.\install.ps1 -Apply   # ho instal·la a ~/.claude
```

Si qui fa la instal·lació és un agent, té les instruccions a
[AGENTS.md](AGENTS.md) — ordre dels passos, com verificar-ho i què no ha de fer.

`-Apply` sobreescriu `CLAUDE.md`, `agents/`, `company/` i aquestes skills de `~/.claude`, i
**abans en fa una còpia** a `~/.claude/backups/install-<data>/`. No toca `settings.json` ni res
local.

Al final comprova què falta a la màquina: `node`, `ffmpeg`, `python`, `git`, Chrome i la
variable `GROQ_API_KEY`. Sense això les skills de vídeo no funcionen.

### Dependències que no són aquí

`/reel` i `/video-ia` necessiten tres skills de tercers que no es publiquen en aquest
repositori. `install.ps1` comprova si hi són i t'ho diu:

- **`hyperframes*`** — el motor de motion graphics i de render.
- **`media-use`** — la resolució de materials (logos, imatges, veu, música).
- **`forja-reel`** — el motor de tall, subtítols, lint de timeline i QC. Les dues skills criden
  els seus scripts (`assets/motor-scripts/`) a cada pas, així que sense ell no arrenquen.
- **`GROQ_API_KEY`** com a variable d'entorn de l'usuari, per transcriure. Posa-la per la
  finestra de variables d'entorn de Windows, **no pel terminal**: tot el que passa pel terminal
  acaba en una captura o en un xat.

## Què NO hi ha, i per què

Aquest kit surt d'una configuració real, i hi ha coses que no es publiquen:

- **La documentació del servidor** (IPs, topologia, Traefik, Docker, una auditoria de
  seguretat). L'agent `vps-guardian` hi és, però la carpeta que llegeix no: viu en un
  repositori privat. Si te'l fas servir, apunta-la a la teva.
- **El motor de reels de tercers** (`forja-reel`), que no és nostre.
- **Les credencials i les transcripcions de converses**, que no són configuració.
- **Els clients reals**: l'índex de `CLAUDE.md` va amb exemples.

L'exportació la fa un script que, abans de deixar publicar res, busca IPs, claus privades i
correus al que ha copiat i s'atura si en troba.

## Com fer-lo teu

1. `CLAUDE.md` primer: canvia qui sou, l'stack i les convencions de nomenclatura. És el fitxer
   que es carrega sempre, i tot el que hi sobra el pagues a cada sessió.
2. Esborra els agents que no facis servir. Un agent que no s'invoca mai és context mort.
3. **Buida els playbooks de `company/_engine/`** i comença els teus. Les nostres regles són
   nostres: "aquesta màquina no resol `localhost`" no et serveix de res.
4. El sistema visual (`company/docs-visuals/`) porta la nostra paleta i la nostra tipografia.
   Canvia-les o tots els teus documents semblaran els nostres.

## Llicència

MIT. Fes-ne el que vulguis; si et serveix, tant millor.
