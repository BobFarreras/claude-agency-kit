# [Nom de l'empresa] — context general

> Aquest fitxer es carrega sempre que Claude Code treballa en un projecte de l'empresa.
> Mantén-lo curt: els detalls llargs viuen en skills o subagents, que només es carreguen quan calen.

## Qui som

[Nom de l'empresa] ofereix automatitzacions (n8n), aplicacions web i agents de veu per a
clients petits i mitjans.

## Stack tecnològic estàndard

- Frontend/backend: TypeScript + Next.js (App Router)
- Desplegament: Vercel — Team: `<nom-del-team>`
- Base de dades / auth / storage: Supabase — Organització: `<nom-org>` (un projecte per client)
- Control de versions: GitHub — Organització: `<nom-org>` (un repo privat per client)
- Automatitzacions: n8n autohostat a la VPS de l'empresa (`<host-vps>`)
- Metodologia: TDD (tests abans del codi) + SDD (spec curta abans d'implementar)

## Convencions de nomenclatura

- Repos: `client-<nom-client>-web`, `client-<nom-client>-automations`
- Projectes Vercel: `client-<nom-client>`
- Projectes Supabase: `client-<nom-client>-prod`
- Workflows n8n: prefixats amb el nom del client, amb error handling estàndard (veure subagent `n8n-architect`)

## Regles que no es negocien

- Mai reutilitzar credencials entre clients.
- Cap credencial en text pla dins d'un repo. Sempre variables d'entorn de Vercel o secrets de la VPS.
- Cap funcionalitat es dona per acabada sense tests (veure subagent `webapp-builder`).
- Cap disseny surt amb l'estètica per defecte de Tailwind/shadcn sense personalitzar.

## Índex de clients actius

| Client | Repo | Projecte Vercel | Projecte Supabase | Notes |
| --- | --- | --- | --- | --- |
| (exemple) Client A | client-a-web | client-a | client-a-prod | — |
| (exemple) Client B | client-b-web | client-b | client-b-prod | — |

## On viuen les coses

Tot penja de `%USERPROFILE%\Desktop\empresa\`:

> `%USERPROFILE%` és la carpeta de l'usuari de la màquina (`C:\Users\<usuari>`). Està escrit
> així perquè la configuració es fa servir en **dues màquines** amb usuaris diferents: cap ruta
> d'aquests fitxers porta el nom d'un usuari concret.


| Carpeta | Què hi va | Git |
| --- | --- | --- |
| `company-config/` | La configuració: `CLAUDE.md`, agents, skills, playbooks, sistema visual, documentació de la VPS. S'edita a `~/.claude/` i se sincronitza aquí amb `sync.ps1` | Sí, privat |
| `clients/<client>/` | El codi de cada client, un repo per client | Sí, un per client |
| `entregues/` | **El que produeixen els agents**: documents, presentacions, propostes, portafolis i reels | No — hi ha PDF i MP4 |

**Configuració i entregues no van mai al mateix lloc.** La configuració es versiona; les
entregues es guarden. La convenció de carpetes és a `entregues/README.md`: una carpeta per
entrega amb data al davant (`AAAA-MM-DD-nom-curt`), amb el material original i un README curt
a dins.

Els agents que produeixen fitxers hi escriuen per defecte, **mai a una carpeta temporal**:
el que es guarda al `scratchpad` es perd.

## On trobar més detall

- Disseny i metodologia de desenvolupament web → subagent `webapp-builder`
- Prototip visual d'una idea encara sense forma, amb Google Stitch → subagent `ui-prototyper`, que entrega el `DESIGN.md` al `webapp-builder`
- Patrons i convencions n8n → subagent `n8n-architect`
- Infraestructura física (VPS, Traefik, Docker) → subagent `vps-guardian`. **La documentació
  del servidor no és en aquest kit públic** (porta IPs i una auditoria): viu en un repositori
  privat. La carpeta esperada és
  `~/.claude/company/vps/`, que té el seu propi `CLAUDE.md` d'índex. Dues màquines:
  `SERVIDOR-ACTUAL.md` (VpsIA) i `SERVIDOR-NERTEL.md` (Nertel, de l'Enric)
- Vigilància de canvis externs al stack → subagent `tech-scout`
- Contingut per a xarxes socials, amb el reel o la publicació ja renderitzats → subagent `reels-producer`
- Estratègia de xarxes socials — què es publica, on i amb quin angle → subagent
  `social-strategist`, i el context de marca a `~/.claude/company/marketing/`
- Executar tests, lint, typecheck o build sense abocar-ne la sortida al context → subagent `test-runner` (Haiku)
- Buscar per una base de codi sense arrossegar-ne els fitxers → subagent `Explore` (Haiku)
- Documents visuals (guies, presentacions, portafolis, propostes) → subagent `doc-designer`, i el sistema visual a `~/.claude/company/docs-visuals/SISTEMA-VISUAL.md`
- Crear un projecte nou per a un client → skill `/new-client-project`
- Muntar un reel a partir d'una gravació en brut → skill `/reel`
- Peça vertical sense càmera (narració, captures i motion graphics) → skill `/video-ia`
- Pla de contingut del mes → skill `/pla-social`; vídeo de YouTube → skill `/youtube`;
  lectura de mètriques publicades → skill `/radar-social`
- Convertir una guia densa en una pàgina entenedora i animada → skill `/guia-visual`
- Presentació, cas de portafoli o proposta comercial → skills `/presentacio`, `/portafoli`, `/proposta-client`
- Reduir el consum de context d'un projecte de codi → skill `/optimitza-context`, i la guia a `~/.claude/company/_engine/ESTALVI-DE-CONTEXT.md`
- Com aprenen i milloren els agents amb el temps → `~/.claude/company/_engine/METODE-APRENENTATGE.md`, i la revisió periòdica amb `/revisio-playbooks`
