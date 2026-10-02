# AGENTS.md — instruccions per a l'agent que acaba de clonar això

Aquest fitxer és per a **tu, l'agent**. El `README.md` és per a una persona.

Dues coses abans de res:

- **Això no és un projecte per compilar.** És configuració que ha d'acabar a `~/.claude`. No hi
  busquis `package.json` ni tests.
- **El `CLAUDE.md` d'aquest repositori és la càrrega, no les teves instruccions.** És el fitxer
  que s'instal·larà a `~/.claude/CLAUDE.md` i que a partir d'aleshores es carregarà a cada
  sessió. Les instruccions d'instal·lació són aquestes d'aquí.

## El que has de fer, en ordre

**1. Comprova que el clone està sencer.** Han de ser-hi `CLAUDE.md`, `install.ps1`, i les
carpetes `agents/` (10 fitxers), `skills/` (12 carpetes) i `company/`. Si en falta cap, para i
digues-ho: no instal·lis a mitges.

**2. Prova en sec.**

```powershell
.\install.ps1
```

Ensenya què copiaria i no toca res. Llegeix la taula i comprova que els números quadren amb el
punt 1.

**3. Instal·la.**

```powershell
.\install.ps1 -Apply
```

Copia `CLAUDE.md`, `agents/`, `company/` i les 12 skills a `~/.claude`, i **abans fa una còpia**
del que hi hagués a `~/.claude/backups/install-<data>/`. No toca `settings.json`.

**4. Llegeix la taula d'entorn que surt al final.** Per cada `False`, instal·la el que falta:

| Falta | Com |
| --- | --- |
| `node` | `winget install --id OpenJS.NodeJS.LTS -e` |
| `ffmpeg` | `winget install --id Gyan.FFmpeg -e` |
| `python` | `winget install --id Python.Python.3.12 -e` |
| `git` | `winget install --id Git.Git -e` |
| `chrome` | `winget install --id Google.Chrome -e` |

Després d'instal·lar, el terminal obert no veu el `PATH` nou: cal un terminal nou.

**5. La `GROQ_API_KEY` no la toques tu.** No la demanis pel xat, no la escriguis en cap fitxer i
no facis servir `setx`: tot el que passa pel terminal acaba en una captura o en una conversa.
Digues a la persona que la posi per la finestra de variables d'entorn de Windows (Variables
d'usuari → Nova → `GROQ_API_KEY`) i que reinicïi Claude Desktop. Comprova-ho sense ensenyar-la:

```powershell
[bool]$env:GROQ_API_KEY
```

Ha de dir `True`.

**6. Tres dependències no són en aquest repositori**, i sense elles `/reel` i `/video-ia` **no
funcionen**:

| Falta | Què és |
| --- | --- |
| `hyperframes`, `hyperframes-*` | El motor de motion graphics i de render |
| `media-use` | La resolució de materials (logos, imatges, veu, música) |
| `forja-reel` | El motor de tall i de QC. `/reel` i `/video-ia` criden els seus scripts de `~/.claude/skills/forja-reel/assets/motor-scripts/` a cada pas |

Són de tercers i no es publiquen aquí. **Demana-les a la persona** —les porta en un zip— i
descomprimeix-les a `~/.claude/skills/`. No les busquis per internet ni te les reescriguis: els
scripts del motor estan validats i una versió teva no ho està.

**7. Verifica.** Les tres coses, en aquest ordre:

```powershell
Get-ChildItem "$env:USERPROFILE\.claude\skills" -Directory | Select-Object -ExpandProperty Name
Test-Path "$env:USERPROFILE\.claude\CLAUDE.md"
Test-Path "$env:USERPROFILE\.claude\skills\forja-reel\assets\motor-scripts\cut.py"
```

I després, en una sessió nova: pregunta-li a la persona que et demani `/pla-social Nertel`. Si
carrega el context de marca i els playbooks, està bé instal·lat.

## El que NO has de fer

- **No editis els fitxers del clone** esperant que arribin a `~/.claude`. La direcció és
  `repositori → ~/.claude`, i només quan s'executa `install.ps1`. La configuració de debò
  s'edita a `~/.claude`.
- **No publiquis res** a cap repositori, ni aquí ni enlloc, sense que t'ho demanin.
- **No escriguis rutes amb el nom d'un usuari concret** (`C:\Users\algu\...`). Aquesta
  configuració es fa servir en més d'una màquina: `%USERPROFILE%`.
- **No instal·lis `-Apply` dues vegades seguides** per "assegurar-te". La segona còpia de
  seguretat sobreescriu el record del que hi havia abans de tot.

## Després

La configuració s'edita a `~/.claude` i es versiona en un repositori **privat** de l'empresa,
que no és aquest. Aquest kit és una exportació d'una sola direcció: el que canviïs aquí no torna
enlloc. Si la persona té accés al repositori privat, és d'allà que s'ha de sincronitzar, i
llavors aquest clone ja no fa falta.
