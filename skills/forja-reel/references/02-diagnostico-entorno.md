# FASE B — Diagnóstico de entorno (instalación opt-in, adaptada al perfil)

Regla: **nada se instala ni se configura sin un "sí" explícito.** Y solo se propone lo que el
perfil necesita de verdad. Aconseja según lo que la persona quiere hacer.

## 1. Derivar qué hace falta (desde `perfil.json`)

| Dependencia | Nivel | Se necesita si… |
|---|---|---|
| `ffmpeg` | **Imprescindible** | Siempre (corte, render, SFX) |
| `node` + `npx` | **Imprescindible** | Siempre (Hyperframes corre sobre node) |
| **Hyperframes** | **Imprescindible** | Siempre (motor de motion graphics) |
| **Groq** (`GROQ_API_KEY`) | **Muy recomendado · GRATIS** | Siempre — transcripción + compuerta de corte + revisor |
| **fal.ai** (`FAL_KEY`) | Opcional · **de pago** | Solo si `broll.ia == true` |
| **firecrawl** | Opcional | Solo si `broll.real == true` |
| `/watch` (skill) | Recomendado | Siempre (QC visual del render) |

Rellena `_deps_necesarias` en el perfil con la lista resultante.

## 2. Comprobar qué hay

Ejecuta y enseña el resultado en una tabla ✅/❌:

```bash
which ffmpeg; which ffprobe
node --version 2>/dev/null; npx --version 2>/dev/null
npx hyperframes --version 2>/dev/null || echo "hyperframes: no detectado"
python --version
# claves (sin imprimir el valor):
[ -n "$GROQ_API_KEY" ] && echo "GROQ: en entorno" || grep -q '^GROQ_API_KEY=' .env.local 2>/dev/null && echo "GROQ: en .env.local" || echo "GROQ: ❌"
[ -n "$FAL_KEY" ] && echo "FAL: en entorno" || grep -q '^FAL_KEY=' .env.local 2>/dev/null && echo "FAL: en .env.local" || echo "FAL: ❌"
ls ~/.claude/skills/watch >/dev/null 2>&1 && echo "watch: ✅" || echo "watch: ❌"
```

## 3. Resolver cada falta (pregunta sí/no, guía el paso a paso)

**ffmpeg** (imprescindible)
- macOS: `brew install ffmpeg` · Windows: `winget install Gyan.FFmpeg` · Linux: `sudo apt install ffmpeg`
- Si no lo quiere instalar: no se puede continuar; explícalo con cariño.

**node / npx** (imprescindible)
- macOS: `brew install node` · Windows: `winget install OpenJS.NodeJS` · o nvm.
- Comprueba `node --version` ≥ 18.

**Hyperframes** (imprescindible — el motor de motion)
- Se usa vía `npx hyperframes ...` (no requiere instalación global). Confirma que `npx hyperframes --version` responde; si no, `npm i -g hyperframes` (pregunta antes).
- Explica en una frase qué es: "el motor que convierte código en las animaciones del reel".

**Groq** (gratis, muy recomendado)
- Explica: "Es lo que escribe la transcripción del vídeo y permite cortar bien y revisar repeticiones. Tiene un plan **gratis** generoso."
- Paso a paso: crear cuenta en console.groq.com → API Keys → crear key → pégala. Guarda en `.env.local` del proyecto como `GROQ_API_KEY=...` (pregunta antes de escribir el archivo; nunca la imprimas).
- Si dice que no: avísale de que el corte automático y el control de repeticiones quedarán desactivados (degradación).

**fal.ai** (de pago — solo si pidió imágenes IA)
- Explica: "Genera las portadas/imágenes IA del cold open. **Es de pago** (céntimos por imagen). Solo hace falta si quieres ese tipo de visual."
- Si dice sí: cuenta en fal.ai → API key → `FAL_KEY=...` en `.env.local` (pregunta antes).
- Si dice no: marca `broll.ia=false`; el cold open usará resultado real / texto en vez de imagen IA.

**firecrawl** (opcional — solo si pidió B-roll real)
- Explica: "Sirve para traer capturas reales de webs/marcas que se vean en el vídeo."
- Si no lo tiene/quiere: el B-roll real se hará con capturas que aporte la persona, o se omite.

**/watch** (recomendado)
- Skill pública de control de calidad visual. Si falta, indícale cómo instalarla o degrada el QC a revisión manual de frames.

## 4. Cierre de fase

Enseña una tabla final: dependencia · estado · acción tomada. Confirma que el entorno está listo
(o que se continúa en modo degradado con X capacidades fuera) y pasa a la Fase C.
