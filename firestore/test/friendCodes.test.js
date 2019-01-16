const {
  apps,
  assertFails,
  assertSucceeds,
  initializeAdminApp,
  initializeTestApp,
  loadFirestoreRules
} = require("@firebase/testing");
const { projectId, uid, auth, rules } = require("./constants");

const firestore = initializeTestApp({ projectId, auth }).firestore();
const firestoreAdmin = initializeAdminApp({ projectId }).firestore();

beforeAll(() => loadFirestoreRules({ projectId, rules }));

afterAll(() => apps().map(app => app.delete()));

describe("friend codes", () => {
  const friendCodesRef = firestore.collection("friendCodes");

  describe("retrieving friend codes", async () => {
    test("it should fail generally", () => assertFails(friendCodesRef.get()));

    test("it should succeed only if trying to retrieve only one friend code which is mine", () =>
      assertSucceeds(
        friendCodesRef
          .where("user", "==", firestore.collection("users").doc(uid))
          .orderBy("issuedAt", "desc")
          .limit(1)
          .get()
      ));

    test("it should fail if trying to retrieve ones including other user's", () =>
      assertFails(
        friendCodesRef
          .orderBy("issuedAt", "desc")
          .limit(1)
          .get()
      ));

    test("it should fail if trying to retrieve more than 1 friend codes (no limitation)", () =>
      assertFails(
        friendCodesRef
          .where("user", "==", firestore.collection("users").doc(uid))
          .orderBy("issuedAt", "desc")
          .get()
      ));

    test("it should fail if trying to retrieve more than 1 friend codes (limit=2)", () =>
      assertFails(
        friendCodesRef
          .where("user", "==", firestore.collection("users").doc(uid))
          .orderBy("issuedAt", "desc")
          .limit(2)
          .get()
      ));
  });

  describe("deleteing a friend code", async () => {
    beforeEach(() =>
      Promise.all([
        firestoreAdmin
          .collection("friendCodes")
          .doc("deleteme")
          .set({
            issuedAt: Date(),
            user: firestore.collection("users").doc(uid)
          }),
        firestoreAdmin
          .collection("friendCodes")
          .doc("thisisnotyours")
          .set({
            issuedAt: Date(),
            user: firestore.collection("users").doc("anotheruserid")
          })
      ])
    );

    test("it should succeed only if trying to delete my friend code", () =>
      assertSucceeds(friendCodesRef.doc("deleteme").delete()));

    test("it should succeed if trying to delete another user's friend code", () =>
      assertFails(friendCodesRef.doc("thisisnotyours").delete()));
  });
});
