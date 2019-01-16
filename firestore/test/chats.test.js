const {
  apps,
  assertFails,
  assertSucceeds,
  initializeAdminApp,
  initializeTestApp,
  loadFirestoreRules
} = require("@firebase/testing");
const {
  firestore: { Timestamp }
} = require("@firebase/testing");
const { projectId, uid, auth, rules } = require("./constants");
const { everyTypeValueWithout, removeField } = require("./utilities");

const firestore = initializeTestApp({ projectId, auth }).firestore();
const firestoreAdmin = initializeAdminApp({ projectId }).firestore();

beforeAll(() => loadFirestoreRules({ projectId, rules }));

afterAll(() => apps().map(app => app.delete()));

describe("chats", () => {
  const chatsRef = firestore.collection("chats");

  describe("retrieving chats", () => {
    test("it should fail generally", () => assertFails(chatsRef.get()));

    test("it should succeed only if trying to retrieve ones which I'm in", () =>
      assertSucceeds(
        chatsRef
          .where(
            "members",
            "array-contains",
            firestore.collection("users").doc(uid)
          )
          .get()
      ));
  });

  describe("getting chats", () => {
    beforeEach(() =>
      Promise.all([
        firestoreAdmin
          .collection("chats")
          .doc("getme")
          .set({
            lastChatMessage: null,
            lastChatMessageCreatedAt: null,
            members: [
              firestore.collection("users").doc(uid),
              firestore.collection("users").doc("another")
            ]
          }),
        firestoreAdmin
          .collection("chats")
          .doc("thisisnotyours")
          .set({
            lastChatMessage: null,
            lastChatMessageCreatedAt: null,
            members: [
              firestore.collection("users").doc("another"),
              firestore.collection("users").doc("someone")
            ]
          })
      ])
    );

    test("it should fail generally", () =>
      assertFails(chatsRef.doc("thisisnotyours").get()));

    test("it should succeed only if trying to get one which I'm in", () =>
      assertSucceeds(chatsRef.doc("getme").get()));
  });

  describe("chat messages", () => {
    describe("retrieving chat messages", () => {
      describe("in the chat what you are in", () => {
        const chatRef = firestore.collection("chats").doc();
        const chatMessagesRef = chatRef.collection("messages");

        beforeEach(() =>
          firestoreAdmin
            .collection("chats")
            .doc(chatRef.id)
            .set({
              lastChatMessage: null,
              lastChatMessageCreatedAt: null,
              members: [
                firestore.collection("users").doc(uid),
                firestore.collection("users").doc("another")
              ]
            })
        );

        test("it should succeed", () => assertSucceeds(chatMessagesRef.get()));
      });

      describe("in the chat what you are not in", () => {
        const chatRef = firestore.collection("chats").doc();
        const chatMessagesRef = chatRef.collection("messages");

        beforeEach(() =>
          firestoreAdmin
            .collection("chats")
            .doc(chatRef.id)
            .set({
              lastChatMessage: null,
              lastChatMessageCreatedAt: null,
              members: [
                firestore.collection("users").doc("another"),
                firestore.collection("users").doc("someone")
              ]
            })
        );

        test("it should fail", () => assertFails(chatMessagesRef.get()));
      });
    });

    describe("getting a chat message", () => {
      describe("in the chat what you are in", () => {
        const chatRef = firestore.collection("chats").doc();
        const chatMessagesRef = chatRef.collection("messages");

        beforeEach(() =>
          Promise.all([
            firestoreAdmin
              .collection("chats")
              .doc(chatRef.id)
              .set({
                lastChatMessage: null,
                lastChatMessageCreatedAt: null,
                members: [
                  firestore.collection("users").doc(uid),
                  firestore.collection("users").doc("another")
                ]
              }),
            firestoreAdmin
              .collection("chats")
              .doc(chatRef.id)
              .collection("messages")
              .doc("getme")
              .set({
                type: "TEXT",
                from: firestore.collection("users").doc(uid),
                sentAt: Timestamp.now(),
                text: "Lorem ipsum"
              })
          ])
        );

        test("it should succeed", () =>
          assertSucceeds(chatMessagesRef.doc("getme").get()));
      });

      describe("in the chat what you are not in", () => {
        const chatRef = firestore.collection("chats").doc();
        const chatMessagesRef = chatRef.collection("messages");

        beforeEach(() =>
          Promise.all([
            firestoreAdmin
              .collection("chats")
              .doc(chatRef.id)
              .set({
                lastChatMessage: null,
                lastChatMessageCreatedAt: null,
                members: [
                  firestore.collection("users").doc("another"),
                  firestore.collection("users").doc("someone")
                ]
              }),
            firestoreAdmin
              .collection("chats")
              .doc(chatRef.id)
              .collection("messages")
              .doc("getme")
              .set({
                type: "TEXT",
                from: firestore.collection("users").doc(uid),
                sentAt: Timestamp.now(),
                text: "Lorem ipsum"
              })
          ])
        );

        test("it should succeed", () =>
          assertFails(chatMessagesRef.doc("getme").get()));
      });
    });

    describe("creating chat messages", () => {
      describe("in the chat what you are in", () => {
        const chatRef = firestore.collection("chats").doc();
        const chatMessagesRef = chatRef.collection("messages");

        const textChatMessageData = {
          type: "TEXT",
          from: firestore.collection("users").doc(uid),
          sentAt: Timestamp.now(),
          text: "Lorem ipsum"
        };

        beforeEach(() =>
          firestoreAdmin
            .collection("chats")
            .doc(chatRef.id)
            .set({
              lastChatMessage: null,
              lastChatMessageCreatedAt: null,
              members: [
                firestore.collection("users").doc(uid),
                firestore.collection("users").doc("someone")
              ]
            })
        );

        test("it should succeed if there's the proper data given", () =>
          assertSucceeds(chatMessagesRef.doc().set(textChatMessageData)));

        test("it should fail if the given data has any unnecessary field", () =>
          assertFails(
            chatMessagesRef.doc().set({ ...textChatMessageData, foo: "bar" })
          ));

        describe("it should fail if", () => {
          describe("data.type", () => {
            everyTypeValueWithout(firestore, "string", (value, type) => {
              test(`is not a string (${type})`, () =>
                assertFails(
                  chatMessagesRef
                    .doc()
                    .set({ ...textChatMessageData, type: value })
                ));
            });

            test('is a string but not "TEXT"', () =>
              assertFails(
                chatMessagesRef
                  .doc()
                  .set({ ...textChatMessageData, type: "TEST" })
              ));

            test("is omitted", () =>
              assertFails(
                chatMessagesRef
                  .doc()
                  .set(removeField(textChatMessageData, "type"))
              ));
          });
        });

        describe("it should fail if", () => {
          describe("data.from", () => {
            everyTypeValueWithout(firestore, "path", (value, type) => {
              test(`is not a path (${type})`, () =>
                assertFails(
                  chatMessagesRef
                    .doc()
                    .set({ ...textChatMessageData, from: value })
                ));
            });

            test("is a path but it is not pointing me", () =>
              assertFails(
                chatMessagesRef.doc().set({
                  ...textChatMessageData,
                  type: firestore.collection("users").doc("someone")
                })
              ));

            test("is omitted", () =>
              assertFails(
                chatMessagesRef
                  .doc()
                  .set(removeField(textChatMessageData, "from"))
              ));
          });
        });

        describe("it should fail if", () => {
          describe("data.sentAt", () => {
            everyTypeValueWithout(firestore, "timestamp", (value, type) => {
              test(`is not a timestamp (${type})`, () =>
                assertFails(
                  chatMessagesRef
                    .doc()
                    .set({ ...textChatMessageData, sentAt: value })
                ));
            });

            test("is omitted", () =>
              assertFails(
                chatMessagesRef
                  .doc()
                  .set(removeField(textChatMessageData, "sentAt"))
              ));
          });
        });

        describe("it should fail if", () => {
          describe("data.text", () => {
            everyTypeValueWithout(firestore, "string", (value, type) => {
              test(`is not a string (${type})`, () =>
                assertFails(
                  chatMessagesRef
                    .doc()
                    .set({ ...textChatMessageData, text: value })
                ));
            });

            test("is empty", () =>
              assertFails(
                chatMessagesRef.doc().set({ ...textChatMessageData, text: "" })
              ));

            test('is omitted even data.type is "TEXT"', () =>
              assertFails(
                chatMessagesRef
                  .doc()
                  .set(removeField(textChatMessageData, "text"))
              ));
          });
        });
      });

      describe("in the chat what you are in", () => {
        const chatRef = firestore.collection("chats").doc();
        const chatMessagesRef = chatRef.collection("messages");

        const textChatMessageData = {
          type: "TEXT",
          from: firestore.collection("users").doc(uid),
          sentAt: Timestamp.now(),
          text: "Lorem ipsum"
        };

        beforeEach(() =>
          firestoreAdmin
            .collection("chats")
            .doc(chatRef.id)
            .set({
              lastChatMessage: null,
              lastChatMessageCreatedAt: null,
              members: [
                firestore.collection("users").doc("another"),
                firestore.collection("users").doc("someone")
              ]
            })
        );

        test("it should fail even if there's the proper data given", () =>
          assertFails(chatMessagesRef.doc().set(textChatMessageData)));
      });
    });

    describe("readers", () => {
      describe("retrieving readers", () => {
        describe("in the chat what you are in", () => {
          const chatRef = firestore.collection("chats").doc();
          const chatMessageRef = chatRef.collection("messages").doc();

          beforeEach(() =>
            Promise.all([
              firestoreAdmin
                .collection("chats")
                .doc(chatRef.id)
                .set({
                  lastChatMessage: null,
                  lastChatMessageCreatedAt: null,
                  members: [
                    firestore.collection("users").doc(uid),
                    firestore.collection("users").doc("another")
                  ]
                }),
              firestoreAdmin
                .collection("chats")
                .doc(chatRef.id)
                .collection("messages")
                .doc(chatMessageRef.id)
                .set({
                  type: "TEXT",
                  from: firestore.collection("users").doc(uid),
                  sentAt: Timestamp.now(),
                  text: "Lorem ipsum"
                })
            ])
          );

          test("it should succeed", () =>
            assertSucceeds(chatMessageRef.collection("readers").get()));
        });

        describe("in the chat what you are not in", () => {
          const chatRef = firestore.collection("chats").doc();
          const chatMessageRef = chatRef.collection("messages").doc();

          beforeEach(() =>
            Promise.all([
              firestoreAdmin
                .collection("chats")
                .doc(chatRef.id)
                .set({
                  lastChatMessage: null,
                  lastChatMessageCreatedAt: null,
                  members: [
                    firestore.collection("users").doc("someone"),
                    firestore.collection("users").doc("another")
                  ]
                }),
              firestoreAdmin
                .collection("chats")
                .doc(chatRef.id)
                .collection("messages")
                .doc(chatMessageRef.id)
                .set({
                  type: "TEXT",
                  from: firestore.collection("users").doc(uid),
                  sentAt: Timestamp.now(),
                  text: "Lorem ipsum"
                })
            ])
          );

          test("it should succeed", () =>
            assertFails(chatMessageRef.collection("readers").get()));
        });
      });
    });
  });
});
