#!/usr/bin/env bash
# transcribe-groq.sh <audio> <salida.json> [idioma]
#
# Transcripción word-level con Groq (whisper-large-v3-turbo). Es el paso 0 del motor:
# islands.py y verify-cut.py necesitan este JSON.
#
# Requiere GROQ_API_KEY en el entorno. La clave NUNCA se imprime ni se pasa por la línea
# de comandos: viaja en una cabecera leída directamente del entorno.
#
# Si el audio pasa de ~24 MB (límite de la API), se trocea con ffmpeg y se recomponen
# los timestamps con el desplazamiento de cada trozo.
set -euo pipefail

SRC="${1:-}"
OUT="${2:-}"
LANG="${3:-es}"
MODEL="${GROQ_WHISPER_MODEL:-whisper-large-v3-turbo}"
API="https://api.groq.com/openai/v1/audio/transcriptions"
LIMIT_BYTES=24000000

if [ -z "$SRC" ] || [ -z "$OUT" ]; then
  echo "uso: transcribe-groq.sh <audio> <salida.json> [idioma]" >&2; exit 2
fi
if [ ! -f "$SRC" ]; then
  echo "ERROR: no existe el audio: $SRC" >&2; exit 2
fi
if [ -z "${GROQ_API_KEY:-}" ]; then
  cat >&2 <<'MSG'
ERROR: falta GROQ_API_KEY en el entorno.

Sin transcripción no hay corte automático ni compuerta de repeticiones.
Consíguela gratis en https://console.groq.com y guárdala como variable de entorno de
usuario. NO la escribas en ningún archivo del repositorio.
MSG
  exit 3
fi
for bin in curl ffmpeg ffprobe python; do
  command -v "$bin" >/dev/null 2>&1 || { echo "ERROR: falta '$bin' en el PATH" >&2; exit 4; }
done

mkdir -p "$(dirname "$OUT")"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# Una llamada a la API. $1 = archivo, $2 = json de salida.
pedir() {
  local f="$1" o="$2" code
  code=$(curl -sS -w '%{http_code}' -o "$o" -X POST "$API" \
    -H "Authorization: Bearer ${GROQ_API_KEY}" \
    -F "file=@${f}" \
    -F "model=${MODEL}" \
    -F "language=${LANG}" \
    -F "temperature=0" \
    -F "response_format=verbose_json" \
    -F "timestamp_granularities[]=word" \
    -F "timestamp_granularities[]=segment")
  if [ "$code" != "200" ]; then
    echo "ERROR: Groq respondió $code" >&2
    # El cuerpo de error de Groq no contiene la clave; se puede mostrar.
    head -c 600 "$o" >&2; echo >&2
    [ "$code" = "401" ] && echo "→ la clave no es válida o ha caducado." >&2
    [ "$code" = "429" ] && echo "→ límite de peticiones; espera un momento y reintenta." >&2
    exit 5
  fi
}

SIZE=$(python -c "import os,sys;print(os.path.getsize(sys.argv[1]))" "$SRC")

if [ "$SIZE" -le "$LIMIT_BYTES" ]; then
  pedir "$SRC" "$OUT"
else
  echo "audio de $((SIZE/1000000)) MB: troceando en bloques de 10 min…" >&2
  ffmpeg -v error -i "$SRC" -f segment -segment_time 600 -c copy "$TMP/part-%03d.${SRC##*.}"
  i=0
  for p in "$TMP"/part-*; do
    pedir "$p" "$TMP/tr-$(printf '%03d' $i).json"
    i=$((i+1))
  done
  # Recomponer: desplazar los tiempos de cada trozo por su posición real.
  python - "$TMP" "$OUT" <<'PY'
import json, glob, os, sys, subprocess
tmp, out = sys.argv[1], sys.argv[2]
partes = sorted(glob.glob(os.path.join(tmp, "part-*")))
trozos = sorted(glob.glob(os.path.join(tmp, "tr-*.json")))
texto, words, segments, offset = [], [], [], 0.0
for p, t in zip(partes, trozos):
    dur = float(subprocess.run(
        ["ffprobe","-v","error","-show_entries","format=duration","-of","csv=p=0",p],
        capture_output=True, text=True).stdout.strip() or 0)
    d = json.load(open(t, encoding="utf-8"))
    texto.append(d.get("text","").strip())
    for w in d.get("words") or []:
        w["start"] = w.get("start",0)+offset; w["end"] = w.get("end",0)+offset
        words.append(w)
    for s in d.get("segments") or []:
        s["start"] = s.get("start",0)+offset; s["end"] = s.get("end",0)+offset
        segments.append(s)
    offset += dur
json.dump({"text":" ".join(texto).strip(), "words":words, "segments":segments},
          open(out,"w",encoding="utf-8"), ensure_ascii=False)
PY
fi

# Comprobación: sin words[] el resto del motor no funciona.
# PYTHONIOENCODING: en Windows la consola es cp1252 y cualquier carácter no-ASCII
# (incluido un acento en un mensaje de error) revienta el print con UnicodeEncodeError.
PYTHONIOENCODING=utf-8 python - "$OUT" <<'PY'
import json, sys
d = json.load(open(sys.argv[1], encoding="utf-8"))
n = len(d.get("words") or [])
if n == 0:
    print("ERROR: la transcripción no trae timestamps por palabra (words[] vacío).\n"
          "islands.py y verify-cut.py no pueden funcionar así.", file=sys.stderr)
    sys.exit(6)
dur = (d["words"][-1].get("end") or 0)
print(f"OK: {n} palabras, {dur:.1f}s → {sys.argv[1]}")
PY
