---
name: revisio-playbooks
description: Revisió periòdica (mensual recomanat) que repassa la feina recent de cada agent i proposa diffs concrets als seus playbooks, sempre amb aprovació humana. Fes-la servir amb /revisio-playbooks.
disable-model-invocation: true
---

Revisa la feina recent (projectes de clients acabats, incidents, automatitzacions noves)
des de l'última revisió i, per a cada agent (`webapp-builder`, `n8n-architect`,
`vps-guardian`, `reels-producer`, `doc-designer`, `social-strategist`):

1. Busca patrons: què s'ha repetit, què ha funcionat bé, què ha fallat i per què.
2. Per cada patró amb **≥3 casos reals** en la mateixa direcció, proposa pujar-lo a "regla
   confirmada" al `~/.claude/company/_engine/playbook-<agent>.md` corresponent.
3. Per patrons amb menys evidència, proposa'ls com a "hipòtesi en prova".
4. Si algun fet contradiu una regla ja confirmada, digues-ho explícitament — rebaixar-la és
   tan important com confirmar noves regles.
5. Presenta els canvis proposats com una llista clara de diffs (què línia canvia i per
   què), **mai els apliquis directament**.
6. Un cop la persona aprovi (totes, algunes, o cap), aplica només els aprovats i afegeix
   una línia al `Changelog` de cada playbook tocat, amb data i evidència.

Si fa més d'un mes des de l'última revisió i encara no hi ha prou feina real acumulada per
treure cap patró amb evidència, digues-ho amb normalitat — un playbook gairebé buit als
primers mesos és l'esperat, no un error.
