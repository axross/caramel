import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import config from '../config';
import onesignalAxios from '../singleton/onesignalAxios';

const onChatCreated = functions.firestore
  .document('chats/{chatId}')
  .onCreate(async (change) => {
    const chatDoc = change;
    const chatDocData = chatDoc.data();
    const userRefs: admin.firestore.DocumentReference[] = chatDocData['members'];

    if (!Array.isArray(userRefs)) {
      throw new Error();
    }

    if (userRefs.some((memberRef) => !(memberRef instanceof admin.firestore.DocumentReference))) {
      throw new Error();
    }

    const tagsEachUserRef = new Map<admin.firestore.DocumentReference, string[]>();
    const deviceDocsEachUserRef = new Map<admin.firestore.DocumentReference, admin.firestore.DocumentSnapshot[]>();

    for (const userRef of userRefs) {
      const otherUserRefs = userRefs.filter(ur => ur !== userRef);

      tagsEachUserRef.set(userRef, otherUserRefs.map(otherUserRef => `chats/${chatDoc.id}?without=${otherUserRef.id}`));
    }

    await Promise.all(userRefs.map(async userRef => {
      const deviceDocs = (await userRef.collection('devices').get()).docs;

      deviceDocsEachUserRef.set(userRef, deviceDocs);
    }));

    const tagsEachNotificationDestinationId = new Map<string, string[]>();

    for (const userRef of userRefs) {
      for (const deviceDoc of deviceDocsEachUserRef.get(userRef)) {
        tagsEachNotificationDestinationId.set(deviceDoc.data()['pushNotificationDestinationId'], tagsEachUserRef.get(userRef));
      }
    }

    await Array.from(tagsEachNotificationDestinationId.entries()).map(([pushNotificationDestinationId, tags]) => onesignalAxios.put(`/players/${pushNotificationDestinationId}`, {
      appId: config.onesignal.app_id,
      tags: tags.reduce((obj, tag) => ({ ...obj, [tag]: true }), {}),
    }));

    console.info(
      `Push notification tags have been set.
  chat: ${chatDoc.id}
  push notification tags:
${Array.from(tagsEachNotificationDestinationId.entries()).map(([pushNotificationDestinationId, tags]) => `    ${pushNotificationDestinationId}: ${tags.map(tag => `"${tag}"`).join(', ')}`).join('\n')}`
    );
  });

export default onChatCreated;