import * as admin from 'firebase-admin';
import { https } from 'firebase-functions';
import firestore from '../singleton/firestore';

const makeFriendshipByFriendCode = https.onCall(async (data, context) => {
  const heroId = context.auth.uid;
  const friendCode = data['friendCode'];

  if (typeof friendCode !== 'string') {
    throw new https.HttpsError('invalid-argument', `data.friendCode must be a string. (given: ${friendCode})`, { hero: heroId, friendCode });
  }

  const heroRef = firestore.collection('users').doc(heroId);

  let opponentRef: any;
  let heroFriendshipRef: any;
  let opponentFriendshipRef: any;
  let chatRef: any;



  await firestore.runTransaction(async (transaction) => {
    const friendCodeDoc = await firestore.collection('friendCodes').doc(friendCode).get();

    if (!friendCodeDoc.exists) {
      throw new https.HttpsError('not-found', `The friend code (${friendCode}) is not found.`, { hero: heroId, friendCode });
    }

    opponentRef = friendCodeDoc.data()['user'];

    if (!(opponentRef instanceof admin.firestore.DocumentReference)) {
      throw new https.HttpsError('internal', 'Something has gone wrong in the process.', { hero: heroId, friendCode });
    }

    if (heroRef.id == opponentRef.id) {
      throw new https.HttpsError('invalid-argument', `The friend code is pointing the requester himself.`, { hero: heroId, friendCode });
    }

    const otherFriendshipRefsWithSameOpponent = heroRef.collection('friendships').where('user', '==', opponentRef);
    const otherFriendshipDocsWithSameOpponent = (await transaction.get(otherFriendshipRefsWithSameOpponent)).docs;

    if (otherFriendshipDocsWithSameOpponent.length > 0) {
      throw new https.HttpsError('already-exists', `The user is already your friend.`, { hero: heroId, opponent: opponentRef.id, friendCode });
    }

    heroFriendshipRef = heroRef.collection('friendships').doc();
    opponentFriendshipRef = opponentRef.collection('friendships').doc();
    chatRef = firestore.collection('chats').doc();

    try {
      transaction
        .create(heroFriendshipRef, {
          user: opponentRef,
          chat: chatRef,
        })
        .create(opponentFriendshipRef, {
          user: heroRef,
          chat: chatRef,
        })
        .create(chatRef, {
          members: [heroRef, opponentRef],
          lastChatMessage: null,
          lastMessageCreatedAt: null,
        })
        .delete(friendCodeDoc.ref);
    } catch (err) {
      console.error(err);

      throw new https.HttpsError('internal', 'Something has gone wrong in the process.', { hero: heroId, friendCode });
    }
  });

  console.info(
    `The requester (id = ${heroRef.id}) and the user (id = ${opponentRef.id}) are now friends.
  friendship:
    The requester (id = ${heroRef.id}): ${heroFriendshipRef.id}
    The user (id = ${opponentRef.id}): ${opponentFriendshipRef.id}
  chat: ${chatRef.id}`
  );
});

export default makeFriendshipByFriendCode;