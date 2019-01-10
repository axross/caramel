// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//   response.send("Hello from Firebase!");
// });

export { default as makeFriendshipByFriendCode } from './function/makeFriendshipByFriendCode';
export { default as onChatCreated } from './function/onChatCreated';
export { default as onChatDeleted } from './function/onChatDeleted';
export { default as onChatMessageCreated } from './function/onChatMessageCreated';
export { default as onFriendCodeDeleted } from './function/onFriendCodeDeleted';
export { default as onFriendshipDeleted } from './function/onFriendshipDeleted';
export { default as registerUser } from './function/registerUser';
