// Firebase for the admin website. `?emu` connects to the local emulators
// (firebase emulators:start) so everything can be tried without touching
// the live database.
import { initializeApp } from 'https://www.gstatic.com/firebasejs/11.0.2/firebase-app.js';
import {
  getAuth, connectAuthEmulator, onAuthStateChanged, signInWithEmailAndPassword,
  GoogleAuthProvider, signInWithPopup, signOut, sendPasswordResetEmail,
} from 'https://www.gstatic.com/firebasejs/11.0.2/firebase-auth.js';
import {
  getFirestore, connectFirestoreEmulator, addDoc, collection, serverTimestamp,
} from 'https://www.gstatic.com/firebasejs/11.0.2/firebase-firestore.js';

export * from 'https://www.gstatic.com/firebasejs/11.0.2/firebase-firestore.js';

export const emu = new URLSearchParams(location.search).has('emu');

const app = initializeApp(emu
  ? { apiKey: 'demo-key', projectId: 'demo-muslimin', authDomain: 'localhost' }
  : {
    apiKey: 'AIzaSyAn1SeunTz0LLhU3_th4mZpafLe6CgLUqc',
    appId: '1:171155844004:web:d6704f37f8e5737e3e2f31',
    projectId: 'muslimin-app-bd',
    authDomain: 'muslimin-app-bd.firebaseapp.com',
  });

export const auth = getAuth(app);
export const db = getFirestore(app);
if (emu) {
  connectAuthEmulator(auth, 'http://127.0.0.1:9099', { disableWarnings: true });
  connectFirestoreEmulator(db, '127.0.0.1', 8080);
}

export {
  onAuthStateChanged, signInWithEmailAndPassword, signOut, sendPasswordResetEmail,
};
export const signInWithGoogle = () => signInWithPopup(auth, new GoogleAuthProvider());

/** The signed-in admin, set by app.js once the role is checked. */
export const me = { uid: '', name: '', email: '' };

/** Records an admin action (Activity log). Never blocks the action. */
export async function logAction(action, target, details = {}) {
  try {
    await addDoc(collection(db, 'adminLog'), {
      uid: me.uid, name: me.name, action, target, details, at: serverTimestamp(),
    });
  } catch (e) { console.warn('log failed', e); }
}

/** Firestore Timestamp / Date / millis -> Date (or null). */
export function toDate(v) {
  if (!v) return null;
  if (v.toDate) return v.toDate();
  if (v instanceof Date) return v;
  if (typeof v === 'number') return new Date(v);
  return null;
}

// Geohash (precision 9), the same as the app's GeoFirePoint, so masjids
// moved here are found by the app's nearby search.
const B32 = '0123456789bcdefghjkmnpqrstuvwxyz';
export function geohash(lat, lng, precision = 9) {
  let la = [-90, 90], lo = [-180, 180], hash = '', bit = 0, ch = 0, even = true;
  while (hash.length < precision) {
    const r = even ? lo : la, v = even ? lng : lat, mid = (r[0] + r[1]) / 2;
    if (v >= mid) { ch = (ch << 1) | 1; r[0] = mid; } else { ch <<= 1; r[1] = mid; }
    even = !even;
    if (++bit === 5) { hash += B32[ch]; bit = 0; ch = 0; }
  }
  return hash;
}
