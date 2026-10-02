#!/usr/bin/env python
"""COMPUERTA DURA — Verifica programáticamente que un corte está LIMPIO antes de animar.
Falla (exit 1) si hay silencios largos en el cuerpo o repeticiones. Es bloqueante: NO se
anima ni se entrega un corte que no pase esto.

Comprueba 3 cosas:
  1) Silencios >= --max-sil dentro del CUERPO (se permiten al final, p.ej. cierre "chao chao").
  2) N-gramas (2/3/4) consecutivos repetidos en la transcripción -> repetición audible.
  3) (info) duración total.

Uso:
  verify-cut.py --media corte.mp4 --transcript corte-word.json [--max-sil 0.6]
                [--noise -30dB] [--tail 1.5]
  (transcript = re-transcripción del CORTE ya hecho, word-level)

Exit 0 = PASA. Exit 1 = FALLA (imprime qué falla).
"""
import json, re, sys, subprocess, argparse

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--media", required=True)
    ap.add_argument("--transcript", required=True)
    ap.add_argument("--max-sil", type=float, default=0.6, help="silencio máx permitido en el cuerpo (s)")
    ap.add_argument("--noise", default="-30dB")
    ap.add_argument("--tail", type=float, default=1.5, help="margen final ignorado (cierre)")
    ap.add_argument("--allow", action="append", default=[],
        help="n-grama de repetición CERCANA confirmado como paralelismo retórico intencional "
             "(no toma doblada). Repetible. Solo úsalo tras LEER el texto y confirmar que "
             "no suena repetido. Ej: --allow 'lo veo para'")
    a = ap.parse_args()
    allow = {s.lower().strip() for s in a.allow}

    fails = []

    # duración
    dur = float(subprocess.run(["ffprobe","-v","error","-show_entries","format=duration",
        "-of","csv=p=0",a.media], capture_output=True, text=True).stdout.strip())

    # 1) silencios en el cuerpo
    out = subprocess.run(["ffmpeg","-hide_banner","-nostats","-i",a.media,
        "-af",f"silencedetect=noise={a.noise}:d={a.max_sil}","-f","null","-"],
        capture_output=True, text=True).stderr
    # start y duration salen en líneas distintas; se emparejan en orden de aparición
    starts = [float(m) for m in re.findall(r"silence_start: ([-\d.]+)", out)]
    sdurs  = [float(m) for m in re.findall(r"silence_duration: ([\d.]+)", out)]
    durs = list(zip(starts, sdurs))
    body_sil = [(s,sd) for (s,sd) in durs if max(0.0,s) < dur - a.tail]
    if body_sil:
        fails.append("SILENCIOS largos en el cuerpo (s, dur): " +
                     ", ".join(f"{s:.1f}s/{d:.2f}" for s,d in body_sil))

    # 2) repeticiones n-gram consecutivas
    words = json.load(open(a.transcript, encoding="utf-8")).get("words", [])
    wl = [w["word"].lower().strip("¿?¡!,.\"'") for w in words if w.get("word")]
    reps = []
    for n in (2,3,4):
        for i in range(len(wl)-2*n+1):
            x, y = wl[i:i+n], wl[i+n:i+2*n]
            if x == y and all(len(t) > 1 for t in x):
                reps.append((n, " ".join(x)))
    if reps:
        uniq = sorted(set(reps))
        fails.append("REPETICIONES consecutivas: " + "; ".join(f"[{n}] {g}" for n,g in uniq))

    # 2b) repeticiones CERCANAS no adyacentes (toma doblada con inciso en medio:
    #     p.ej. "quien entienda ... y es que es así ... quien entienda").
    #     verify consecutivo no las pilla. Busca un n-grama de CONTENIDO que reaparezca
    #     dentro de las siguientes GAP palabras. Filtra stopwords para no marcar muletillas.
    STOP = {"de","la","el","que","y","a","en","lo","un","una","o","se","es","le","su",
            "por","con","los","las","sea","te","me","va","al","ya","si","no","más","mas",
            "tu","mi","él","el","ese","eso","esto","esta","este","como","cómo"}
    GAP = 7
    near = []
    for n in (2,3):
        for i in range(len(wl)-n):
            x = wl[i:i+n]
            # el n-grama debe tener al menos una palabra de CONTENIDO (len>=4 y no stopword)
            if not any(len(t) >= 4 and t not in STOP for t in x):
                continue
            for j in range(i+n, min(i+n+GAP, len(wl)-n+1)):
                if wl[j:j+n] == x:
                    near.append((n, " ".join(x)))
                    break
    near = [(n,g) for (n,g) in near if g not in allow]   # quita paralelismos ya confirmados
    if near:
        uniq = sorted(set(near))
        fails.append("REPETICIONES cercanas SOSPECHOSAS (toma doblada con inciso). LEE el texto "
                     "y, por cada una: si es toma doblada -> arregla el corte; si es paralelismo "
                     "retórico intencional -> vuelve a correr con --allow '<n-grama>'. Sospechas: " +
                     "; ".join(f"[{n}] {g}" for n,g in uniq))

    print(f"duración: {dur:.2f}s")
    if fails:
        print("RESULTADO: ❌ FALLA")
        for f in fails: print("  -", f)
        return 1
    print("RESULTADO: ✅ PASA — sin silencios largos en el cuerpo, sin repeticiones.")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
