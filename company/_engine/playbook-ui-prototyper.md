# Playbook — ui-prototyper

> El subagent `ui-prototyper` llegeix aquest fitxer abans de començar una feina nova.
> Neix buit de regles confirmades — es va omplint amb feina real. Cap regla sense evidència.

## Regles confirmades

> Dos tipus d'evidència poden confirmar una regla sense esperar tres casos:
> **(decisió)** — l'Adrià ho ha demanat explícitament.
> **(fet verificat)** — comportament d'una eina reproduït i comprovat en execució.
>
> La inferència a partir de resultats ("això sembla que funciona millor") sí que necessita
> **≥3 casos** i comença sempre com a hipòtesi.

1. **El prototip d'Stitch serveix per a l'estructura, no per a l'estètica.** La direcció
   visual final és una decisió pròpia per sobre del que proposa Stitch, partint de la marca
   del client. Els criteris de disseny de la casa (18 px, moviment al hero, res que soni a
   demo) manen sobre el que surti del generador.
   · *decisió, 2026-07-31*

2. **Aquest agent no implementa.** Entrega prototip, `DESIGN.md`, mapa de pantalles i spec;
   el codi és del `webapp-builder`. Separat perquè les regles de stack, TDD i credencials no
   es dupliquin en dos agents que després divergeixen.
   · *decisió, 2026-07-31*

## Hipòtesis en prova

*(cap encara — s'omplirà amb el primer projecte real)*

## Changelog

- **2026-07-31** · fitxer creat en néixer l'agent. Dues regles per decisió, cap hipòtesi.
  Sense feina real encara.
