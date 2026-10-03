// Muslimin – Cloud Functions
//
// 1. New notice  -> push to everyone who follows that masjid (FCM topic `masjid_<id>`).
// 2. Jamat time changed -> push "Jamat time updated" to followers.
// 3. Masjid approved / rejected -> push to the owner's devices.
const { onDocumentCreated, onDocumentUpdated } = require("firebase-functions/v2/firestore");
const { initializeApp } = require("firebase-admin/app");
const { getFirestore } = require("firebase-admin/firestore");
const { getMessaging } = require("firebase-admin/messaging");

initializeApp();

const REGION = "asia-south1";

exports.onNoticeCreated = onDocumentCreated({ document: "notices/{id}", region: REGION }, async (event) => {
  const n = event.data?.data();
  if (!n) return;
  await getMessaging().send({
    topic: `masjid_${n.masjidId}`,
    notification: { title: n.masjidName, body: n.title },
    data: { type: "notice", masjidId: n.masjidId, noticeId: event.params.id },
    android: { notification: { channelId: "notices" } },
  });
});

exports.onMasjidUpdated = onDocumentUpdated({ document: "masjids/{id}", region: REGION }, async (event) => {
  const before = event.data.before.data();
  const after = event.data.after.data();
  const id = event.params.id;

  if (before.status !== after.status && ["approved", "rejected"].includes(after.status)) {
    const owner = await getFirestore().doc(`users/${after.ownerUid}`).get();
    const tokens = owner.get("fcmTokens") || [];
    if (tokens.length) {
      const approved = after.status === "approved";
      await getMessaging().sendEachForMulticast({
        tokens,
        notification: {
          title: approved ? "Masjid profile approved" : "Masjid profile not approved",
          body: approved
            ? `${after.name} is now visible to Muslims nearby.`
            : `${after.name}: ${after.rejectionReason || "Please review and resubmit."}`,
        },
        data: { type: "masjid_status", masjidId: id, status: after.status },
      });
    }
  }

  if (after.status === "approved" && JSON.stringify(before.jamat) !== JSON.stringify(after.jamat)) {
    await getMessaging().send({
      topic: `masjid_${id}`,
      notification: { title: after.name, body: "Jamat time has been updated" },
      data: { type: "jamat_updated", masjidId: id },
      android: { notification: { channelId: "notices" } },
    });
  }
});
