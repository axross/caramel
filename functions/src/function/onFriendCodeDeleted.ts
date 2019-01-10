import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import firestore from '../singleton/firestore';

const onFriendCodeDeleted = functions.firestore
  .document('friendCodes/{friendCodeId}')
  .onDelete(async (change) => {
    const friendCodeDoc = change;
    const friendCodeDocData = friendCodeDoc.data();
    const userRef: admin.firestore.DocumentReference = friendCodeDocData['user'];

    if (!(userRef instanceof admin.firestore.DocumentReference)) {
      throw new Error();
    }

    const otherFriendCodeDocsForSameUser = (await firestore.collection('friendCodes').where('user', '==', userRef).get()).docs;

    if (otherFriendCodeDocsForSameUser.length > 0) {
      return;
    }

    const newFriendCodeRef = firestore.collection('friendCodes').doc();

    await newFriendCodeRef.create({
      issuedAt: admin.firestore.FieldValue.serverTimestamp(),
      user: userRef,
    });

    console.info(
      `A friend code has been regenerated.
  friend code: ${newFriendCodeRef.id}
  user: ${userRef.id}`
    );
  });

export default onFriendCodeDeleted;