import { DocumentReference } from '@google-cloud/firestore';
import { addDays, differenceInMilliseconds } from 'date-fns';
import * as functions from 'firebase-functions';
import { URL } from 'url';
import config from '../config';
import onesignalAxios from '../singleton/onesignalAxios';
import storageBucket from '../singleton/storageBucket';

const onChatMessageWritten = functions.firestore
  .document('chats/{chatId}/messages/{messageId}')
  .onWrite(async (change, context) => {
    const chatMessageDoc = change.after.data();
    const chatMessageType = chatMessageDoc['type'];

    const userDoc = await (chatMessageDoc['from'] as DocumentReference).get();
    const userId = userDoc.id;
    const userData = userDoc.data();
    const userName = userData['name'];
    const userImageUrl = new URL(userData['imageUrl']);

    let body = '';

    if (chatMessageType == 'TEXT') {
      body = chatMessageDoc['text'];
    } else {
      throw new Error('invalid type');
    }

    const temporaryImageUrlExpire = addDays(new Date(), 30);
    const [temporaryImageUrl] = await storageBucket.file(userImageUrl.pathname).getSignedUrl({ action: 'read', expires: temporaryImageUrlExpire, });
    const targetTag = `chats/${context.params.chatId}?without=${userId}`;

    const response = await onesignalAxios.post('/notifications', {
      app_id: config.onesignal.app_id,
      filters: [{ field: "tag", key: targetTag, relation: "exists", }],
      headings: {
        en: userName,
      },
      contents: {
        en: body,
      },
      data: {
        type: 'chatMessage',
        chatId: context.params.chatId,
        chatMessageId: context.params.messageId,
      },
      large_icon: temporaryImageUrl,
      android_channel_id: config.onesignal.channel_ids.chat_message,
      ios_sound: 'notification.wav',
      android_group: `chats/${context.params.chatId}`,
      android_group_message: {
        en: `You have $[notif_count] new messages: ${body}`,
      },
      thread_id: `chats/${context.params.chatId}`,
      summary_arg: userName,
      summary_arg_count: 1,
    });

    console.log(`A push notification (id: ${response.data['id']}) has been sent.\n  sender name: ${userName}\n  image url: ${temporaryImageUrl} (expires: ${temporaryImageUrlExpire})\n  target tag: ${targetTag} (${differenceInMilliseconds(new Date(), context.timestamp)})\n  recipients: ${response.data['recipients']}`);
  });

export default onChatMessageWritten;