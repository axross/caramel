import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import config from '../config';
import onesignalAxios from '../singleton/onesignalAxios';
import firestore from '../singleton/firestore';

const onFriendshipDeleted = functions.firestore
  .document('users/{userId}/friendships/{friendshipId}')
  .onDelete(async (change, context) => {
    const heroId = context.params.userId;
    const heroRef = firestore.collection('users').doc(heroId);
    const changeData = change.data();
    const opponentRef = changeData['user'];
    const chatRef = changeData['chat'];

    if (!(opponentRef instanceof admin.firestore.DocumentReference)) {
      console.warn('The operation has been suspended. Because data.user was supposed to be a reference.');

      return;
    }

    if (!(chatRef instanceof admin.firestore.DocumentReference)) {
      console.warn('The operation has been suspended. Because data.chat was supposed to be a reference.');

      return;
    }

    const opponentFriendshipDocs = await opponentRef.collection('friendships').where('user', '==', heroRef).limit(1).get();

    if (opponentFriendshipDocs.empty) {
      console.warn('The operation has been suspended. Because the opponent doesn\'t have the friendship with the requester.');

      return;
    }

    const opponentFriendshipRef = opponentFriendshipDocs.docs[0].ref;

    const batch = firestore.batch();

    batch
      .delete(opponentFriendshipRef)
      .delete(chatRef);

    await batch.commit();
  });

export default onFriendshipDeleted;