# Codi de tercers dins d'aquest repositori

Dues carpetes d'aquest kit **no són nostres**:

- `skills/forja-reel/`
- `skills/forja-reel-engine/`

Són una skill de tercers (una meta-skill en castellà que genera un editor de reels
personalitzat, amb un motor de tall, ritme, SFX i QC a dins). Les redistribuïm **tal com les vam
rebre**, amb les nostres correccions a sobre, perquè `/reel` i `/video-ia` criden els seus
scripts a cada pas i sense elles no arrenquen.

## El que hem de dir clarament

- **No en som els autors.** El paquet no portava fitxer de llicència, ni nom d'autor, ni URL
  d'origen, així que **no podem afirmar sota quines condicions es pot redistribuir**.
- **La llicència MIT d'aquest repositori no les cobreix.** Val per als nostres fitxers:
  `CLAUDE.md`, `agents/`, `company/` i les dotze skills nostres. Aquestes dues carpetes queden
  explícitament fora.
- **Les nostres correccions** sobre el motor (rutes, `python` en lloc de `python3`, encoding a
  Windows, 48 kHz, `transform` en lloc de `top/left`) estan als nostres fitxers i als playbooks,
  no en una versió alternativa del motor.

## Si n'ets l'autor

Escriu a `info@nertel.ai` i les traiem el mateix dia, o hi posem l'atribució i la llicència que
ens diguis. No hi ha cap intenció d'apropiar-se de res: estan aquí perquè la configuració no
funciona sense elles i volíem que el kit fos instal·lable d'una peça.

## Si ets qui es descarrega el kit

Pots fer servir la resta amb tota tranquil·litat. D'aquestes dues carpetes, **la condició legal
és desconeguda**: si les has de fer servir en un producte, busca l'origen i comprova-ho tu.
