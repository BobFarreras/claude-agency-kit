# Fase 1 — Bloquear el corte (determinista por silencedetect)

Meta: corte ágil (≈60-90s), **sin silencios en el cuerpo, sin errores, sin una sola repetición**, validado por `verify-cut.py` (exit 0) antes de animar nada.

## MÉTODO CANÓNICO (2026-06-21) — scripts, no a mano

Los timestamps de Whisper son imprecisos → cortar por ellos deja silencios y repeticiones (falló 3 veces). El corte se hace por **islotes de voz de `silencedetect`** + **última toma** + **concat sin pausas**, con tres scripts:

```bash
# 0) transcribir el bruto UNA vez (word-level). Reutilizar para todo.
ffmpeg -i bruto.mp4 -vn -ac 1 -b:a 64k -y edicion/bruto-audio.m4a
bash ~/.claude/skills/<SKILL>/scripts/transcribe-groq.sh edicion/bruto-audio.m4a edicion/bruto-word.json

# 1) islotes + propuesta última-toma (silencedetect)
python ~/.claude/skills/<SKILL>/scripts/islands.py \
  --media bruto.mp4 --transcript edicion/bruto-word.json --out edicion/islands.json
#    -> revisa la tabla KEEP/DROP. Corrige a mano en islands.json los DROP que
#       la heurística no pilla: bloopers ("joder"), falsos arranques, tangentes, fragmentos.

# 2) montar el corte (pega islotes sin pausas; pad hacia dentro del silencio)
python ~/.claude/skills/<SKILL>/scripts/cut.py \
  --islands edicion/islands.json --out edicion/corte-final.mp4

# 3) COMPUERTA DURA (bloqueante): re-transcribir el corte y verificar
ffmpeg -i edicion/corte-final.mp4 -vn -ac 1 -b:a 64k -y edicion/cf.m4a
bash ~/.claude/skills/<SKILL>/scripts/transcribe-groq.sh edicion/cf.m4a edicion/transcript-final.json
python ~/.claude/skills/<SKILL>/scripts/verify-cut.py \
  --media edicion/corte-final.mp4 --transcript edicion/transcript-final.json
#    exit 0 = PASA. exit 1 = arregla islands.json (silencio/repetición que indique),
#    re-cut.py, re-verifica. ITERA hasta exit 0. No animes sin PASS.
```

**Por qué funciona:** silencedetect da límites exactos (no jitter), pegar islotes elimina las pausas internas de 5-9s (los "muchos silencios"), y quedarse con la última toma elimina las repeticiones. La compuerta caza lo que el ojo deja pasar (p.ej. "pues aquí tienes" doblado tras una pausa larga).

---

## Apoyo: conocimiento de patrones (para el ajuste semántico del paso 1)

Lo de abajo es el detector antiguo (`detect-repeats.py`) y los patrones de repetición observados. Útil para decidir los DROP semánticos en `islands.json`, pero el flujo canónico es islands→cut→verify.

> ⚠️ **`detect-repeats.py` no viene en el paquete.** No intentes ejecutarlo ni lo reescribas
> a medias: el flujo canónico no lo necesita. Lo que vale de esta sección es el **catálogo de
> patrones** — léelo y aplícalo a mano sobre `islands.json` al marcar los DROP.

## 1. Transcripción word-level

```bash
ffmpeg -i bruto.mp4 -vn -ac 1 -b:a 64k -y edicion/audio.m4a
bash ~/.claude/skills/<SKILL>/scripts/transcribe-groq.sh edicion/audio.m4a edicion/transcript.json
```
(Groq `whisper-large-v3-turbo`, `GROQ_API_KEY` de `Empresa/.env.local`, español, granularidad palabra+segmento. Si el audio >24MB, trocear con `ffmpeg -f segment` y concatenar.)

## 2. Detectar repeticiones, falsos arranques y tomas dobladas

```bash
python ~/.claude/skills/<SKILL>/scripts/detect-repeats.py edicion/transcript.json
```
Imprime tres cosas:
- **Segmentos casi-duplicados** (near-dup, sim≥0.5) — tomas repetidas obvias.
- **Trigramas word-level repetidos** — capturan repeticiones DENTRO de la frase que el nivel de segmento no ve. Ignora los que son contexto distinto a propósito (ej. "github acaba de" en "decirte" vs "publicar"; "con inteligencia artificial" en dos frases). El resto suelen ser repeticiones reales.
- **Palabras dragueadas** (duración >1.5s) — candidatas a toma doblada: una palabra que dura 3-7s casi siempre esconde un silencio o que la dijo dos veces. Confírmalo con silencedetect.

Para una palabra dragueada o una zona sospechosa, mira la estructura habla/silencio:
```bash
ffmpeg -i corte.mp4 -af "silencedetect=noise=-30dB:d=0.18" -f null - 2>&1 | grep silence_start
```
Si ves habla–silencio–habla dentro de lo que el transcript marca como una palabra/frase → la dijo dos veces (toma doblada) o reinició la frase (falso arranque).

**Patrones reales vistos** (para que sepas qué buscar):
- *Toma doblada de palabra*: "masticadito" dicho 2 veces con un micro-silencio entre medias.
- *Falso arranque*: "Lo que ahora GitHub te lo da bastante…" (incompleto) y reinicia "Lo que ahora simplemente GitHub te lo da bastante masticadito para que…" (completa).
- *Restatement redundante*: "5 tasks, es decir, **tareas**, te hace una lista programada de **tareas**" → "tareas" dos veces.
- *Toma con/sin detalle*: "Gratis, licencia MIT…" vs "Gratis y con licencia MIT" → quédate con la última.
- *Eco al final*: "¿Te suena, no?" … "¿No?" repetido.

## 3. Regla de decisión: ÚLTIMA toma

Ante cualquier repetición, **conserva la ÚLTIMA toma completa** y elimina las anteriores (es la heurística del creador: "normalmente la buena es la final"). Excepción de sentido común: si la última está incompleta y la anterior es la completa, quédate con la completa — el criterio real es *que no suene repetido y tenga coherencia al leerlo seguido*.

## 4. Ejecutar el corte

Construye una lista de **keep-ranges** (segundos sobre el bruto) que excluya las tomas malas. Córtalo con ffmpeg `filter_complex` (trim+concat, re-encode, precisión de frame). Patrón:

```python
# keeps = [(start,end), ...]  en segundos
parts=[f"[0:v]trim={s}:{e},setpts=PTS-STARTPTS[v{i}];[0:a]atrim={s}:{e},asetpts=PTS-STARTPTS[a{i}]" for i,(s,e) in enumerate(keeps)]
concat="".join(f"[v{i}][a{i}]" for i in range(len(keeps)))+f"concat=n={len(keeps)}:v=1:a=1[v][a]"
# ffmpeg -y -i bruto -filter_complex "<parts;concat>" -map [v] -map [a] -c:v libx264 -crf 16 -preset medium -pix_fmt yuv420p -c:a aac -b:a 192k corte-content.mp4
```

Luego barre los silencios (incluye pausas internas y muertos largos):
```bash
auto-editor edicion/corte-content.mp4 --margin 0.18s --no-open -o edicion/corte-final.mp4
```

**Cortes mid-frase (quitar una repetición dentro de una frase):** los timestamps de whisper son imprecisos (±0.2-0.3s). NO cortes a ciegas por el timestamp de whisper — usa `silencedetect` para encontrar los límites de silencio reales alrededor de lo que quieres quitar y corta entre silencios. Verifica SIEMPRE re-transcribiendo (paso 5).

## 5. RE-VERIFICAR (sobre el corte ya hecho)

```bash
ffmpeg -i edicion/corte-final.mp4 -vn -ac 1 -b:a 64k -y edicion/audio-final.m4a
bash ~/.claude/skills/<SKILL>/scripts/transcribe-groq.sh edicion/audio-final.m4a edicion/transcript-final.json
python ~/.claude/skills/<SKILL>/scripts/detect-repeats.py edicion/transcript-final.json
```
Lee el texto completo del corte de principio a fin buscando frases reiniciadas o conceptos repetidos. **Si aparece cualquier repetición, recórtala (sobre el corte actual) y vuelve a re-verificar.** Itera hasta que `detect-repeats.py` solo deje los falsos positivos de contexto distinto. Solo entonces el corte está limpio.

> Comprueba la duración: objetivo 1–3 min. Si quedó <1 min, avisa a el creador (quizá cortaste de más).

## 6. COMPUERTA — aprobación del creador

Presenta: duración final, nº de cortes, **lista de qué se eliminó y por qué** (cada repetición/error). Abre el corte para que lo vea. **Espera su OK explícito.** No empieces la Fase 2 hasta que apruebe el corte. Este es el punto donde se evita el re-trabajo caro: una vez animes, recortar obliga a re-sincronizar todo.
