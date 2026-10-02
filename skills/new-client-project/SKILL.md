---
name: new-client-project
description: Crea l'esquelet complet per a un client nou (repo GitHub, projecte Vercel, projecte Supabase, Next.js base) seguint les convencions de l'empresa.
disable-model-invocation: true
---

Crea el projecte nou per al client `$ARGUMENTS` seguint aquests passos. Confirma amb la
persona abans d'executar qualsevol pas que creï un recurs de pagament.

1. **GitHub**
   ```
   gh repo create <org>/client-$ARGUMENTS-web --private --clone
   ```

2. **Next.js base**
   ```
   npx create-next-app@latest client-$ARGUMENTS-web --typescript --app --tailwind
   ```
   Substitueix l'estructura per defecte per la plantilla de l'empresa si n'hi ha una a
   `template/` dins d'aquesta mateixa carpeta.

3. **Vercel**
   ```
   vercel link
   ```
   Fes-ho dins del Team de l'empresa, i confirma que el projecte queda enllaçat al repo de
   GitHub perquè cada push desplegui automàticament.

4. **Supabase**
   ```
   supabase projects create client-$ARGUMENTS-prod --org-id <org-id>
   ```
   Copia les claus generades a les variables d'entorn de Vercel — mai en text pla dins del
   repo.

5. **Configuració de context** — perquè el projecte neixi ja estalviant. Crea
   `.claude/settings.json` (versionat, no el `.local.json`):
   ```json
   {
     "model": "sonnet",
     "autoCompactWindow": 300000
   }
   ```
   I un `CLAUDE.md` **curt** a l'arrel: què és el projecte, les comandes, i **on** són les
   normes. Mai hi copiïs les normes senceres — dues còpies d'una regla acaben divergint, i
   el fitxer es carrega a cada sessió i a cada subagent. Si més endavant el projecte creix,
   passa-hi `/optimitza-context`.

6. Afegeix el client a la taula "Índex de clients actius" del `CLAUDE.md` mestre de
   l'empresa.

7. Confirma amb la persona que tot està enllaçat correctament: el build de Vercel passa i
   la connexió a Supabase funciona des de l'app.
