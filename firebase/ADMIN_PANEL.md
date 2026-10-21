# Muslimin admin website

**URL:** https://litu173.github.io/Muslimin/admin/ – super admins only
(`users/{uid}.role == 'superAdmin'`). Everything it reads or writes is
enforced by `firestore.rules`, so the page being public is safe.

## One-time setup

1. **Deploy rules and indexes** (from `firebase/`):
   `firebase deploy --only firestore:rules,firestore:indexes`
   Indexes take a few minutes to build; until then some lists show
   "index still building".
2. **Google sign-in on the website:** Firebase console → Authentication →
   Settings → Authorised domains → add `litu173.github.io`.
   (Email/password sign-in works without this.)
3. **Instant notifications and account actions (free plan):** the website
   queues them in `adminJobs`; the GitHub workflow *Admin jobs*
   (`firebase/tools/admin_jobs.mjs`) runs them with the
   `FIREBASE_SERVICE_ACCOUNT` secret. Save a GitHub fine-grained token
   (repository `litu173/Muslimin` only, permission *Actions: read and write*)
   in the website's **App settings** to start the job immediately; without it
   the job runs every 15 minutes (GitHub may delay schedules).

## What it does

Dashboard · Masjids (search, filters, map, add, full editor with history
and undo) · Review (pending masjids, suggestions, problem reports) · Users
(roles, block volunteering, disable sign-in, delete, direct notification) ·
Locations (by country, district and thana coverage) · Activity (changes,
notices, channel messages, volunteers) · Notifications (everyone, a masjid's
followers, a channel, one user) · App settings (minimum app version, Home
banner, admins) · Admin log.

## Try it locally (no live data touched)

```
cd firebase && firebase emulators:start --only firestore,auth --project demo-muslimin
cd firebase/tools && FIRESTORE_EMULATOR_HOST=127.0.0.1:8080 \
  FIREBASE_AUTH_EMULATOR_HOST=127.0.0.1:9099 node seed_admin_emulator.mjs
python3 -m http.server 8765 --directory docs
```
Open http://localhost:8765/admin/?emu and sign in as admin@test.local /
admin123. The emulator needs Java 21+.
