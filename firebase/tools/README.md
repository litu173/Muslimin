# Admin tools

## Import Bangladesh's masjids from OpenStreetMap

`masjids_bd.json` holds 10,650 named masjids from OpenStreetMap (© OpenStreetMap
contributors, ODbL), each with its district and upazila (boundaries: BBS / OCHA via
geoBoundaries, CC BY 3.0 IGO). Unnamed points and duplicates are left out.

The import creates each one as an **approved** masjid profile owned by the super
admin, with no jamat times yet (people nearby add them as volunteer editors).
Masjids already registered in the app are never touched: any OpenStreetMap masjid
within 40 m of one is skipped.

### Run it

1. Deploy the rules and indexes first (they add volunteers, reports and search):

   ```bash
   cd "/Users/mutaher/Work/Claude Work/Muslimin/firebase" && ~/.npm-global/bin/firebase deploy --only firestore:rules,firestore:indexes --project muslimin-app-bd
   ```

2. Get a service-account key: Firebase console → Project settings → Service
   accounts → **Generate new private key**. Save it **outside this repository**,
   e.g. `~/keys/muslimin-admin.json`. Never commit it.

3. Install and try a dry run (writes nothing):

   ```bash
   cd "/Users/mutaher/Work/Claude Work/Muslimin/firebase/tools" && npm install && GOOGLE_APPLICATION_CREDENTIALS=~/keys/muslimin-admin.json node import_osm_masjids.mjs masjids_bd.json --dry-run
   ```

4. Import:

   ```bash
   cd "/Users/mutaher/Work/Claude Work/Muslimin/firebase/tools" && GOOGLE_APPLICATION_CREDENTIALS=~/keys/muslimin-admin.json node import_osm_masjids.mjs masjids_bd.json
   ```

The free plan allows 20,000 writes a day; one run writes at most 18,000 (`--max`).
Running it again is safe – it skips everything already imported.

### Refresh the data

```bash
python3 prepare_osm_masjids.py overpass.json ADM2.geojson ADM3.geojson masjids_bd.json
```

`overpass.json`: Overpass API, `[out:json];nwr["amenity"="place_of_worship"]["religion"="muslim"](20.5,88.0,26.7,92.7);out center tags;`.
`ADM2/ADM3.geojson`: geoBoundaries `gbOpen/BGD/ADM2` and `ADM3`.

## Push notifications without the paid plan

Cloud Functions (in `../functions`) would send pushes instantly, but need the
Blaze plan. Instead, `.github/workflows/push.yml` runs `send_push.mjs` every
5 minutes on GitHub (free for public repositories). It sends new notices,
channel messages and jamat-time changes to the followers' / members' phones,
and approval news to masjid owners. GitHub can start a run a few minutes
late, so a push may take 5–15 minutes.

To switch it on, add the service-account key as a repository secret:

1. Firebase console → Project settings → Service accounts → **Generate new
   private key** (one click – each click makes another key).
2. Upload it as the secret (then delete the downloaded file):

   ```bash
   gh secret set FIREBASE_SERVICE_ACCOUNT --repo litu173/Muslimin < ~/Downloads/muslimin-app-bd-firebase-adminsdk-*.json && rm ~/Downloads/muslimin-app-bd-firebase-adminsdk-*.json
   ```

3. GitHub → Actions → **Push notifications** → **Run workflow** to try it.

GitHub pauses scheduled workflows after 60 days without any commit; re-enable
it on the Actions page if that happens.
