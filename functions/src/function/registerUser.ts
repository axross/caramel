import * as admin from 'firebase-admin';
import { https } from 'firebase-functions';
import firestore from '../singleton/firestore';

const registerUser = https.onCall(async (_, context) => {
  const heroId = context.auth.uid;

  if (!(typeof heroId == 'string')) {
    throw new https.HttpsError('unauthenticated', 'This function requires the user to be authenticated.', {
      id: heroId,
    });
  }

  const heroRef = firestore.collection('users').doc(heroId);
  const heroDeviceDoc = heroRef.collection('devices').doc();
  const friendCodeRef = firestore.collection('friendCodes').doc();

  await firestore.runTransaction(async (transaction) => {
    const heroDoc = await transaction.get(heroRef);

    if (heroDoc.exists) {
      throw new https.HttpsError('already-exists', '', {
        id: heroId,
      });
    }

    transaction.create(heroRef, {
      name: 'No Name',
      imageUrl: 'gs://caramel-b3766.appspot.com/profile_images/0000000000000000000000000000000000000000000000000000000000000000.png',
      isProfileInitialized: false,
    });

    transaction.create(friendCodeRef, {
      issuedAt: admin.firestore.FieldValue.serverTimestamp(),
      user: heroRef,
    });
  });

  console.info(
    `The user has been created.
  user: ${heroRef.id}
  first friend code: ${friendCodeRef.id}`
  );
});

export default registerUser;