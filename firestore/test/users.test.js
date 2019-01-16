const {
  apps,
  assertFails,
  assertSucceeds,
  initializeTestApp,
  loadFirestoreRules
} = require("@firebase/testing");
const { projectId, uid, auth, rules } = require("./constants");
const { everyTypeValueWithout, removeField } = require("./utilities");

const firestore = initializeTestApp({ projectId, auth }).firestore();

beforeAll(() => loadFirestoreRules({ projectId, rules }));

afterAll(() => apps().map(app => app.delete()));

describe("users", () => {
  const userRef = firestore.collection("users").doc(uid);

  describe("devices", () => {
    const devicesRef = userRef.collection("devices");

    describe("creating a device", async () => {
      const data = {
        manufacturer: "Axross",
        model: "Fly Phone",
        os: "Fly OS",
        osVersion: "10.17.50",
        pushNotificationDestinationId: "00000000-0000-0000-0000-000000000000"
      };

      test("it should succeed only if there's proper data given to try creating a device", () =>
        assertSucceeds(devicesRef.doc().set(data)));

      test("it should fail if the given data has any unnecessary field", () =>
        assertFails(devicesRef.doc().set({ ...data, foo: "bar" })));

      describe("it should fail if", () => {
        for (const key of Object.keys(data)) {
          describe(`data.${key}`, () => {
            everyTypeValueWithout(firestore, "string", (value, type) => {
              test(`is not a string (${type})`, () =>
                assertFails(devicesRef.doc().set({ ...data, [key]: value })));
            });

            test("is empty", () =>
              assertFails(devicesRef.doc().set({ ...data, [key]: "" })));

            test("is omitted", () =>
              assertFails(devicesRef.doc().set(removeField(data, key))));
          });
        }
      });
    });

    describe("updating a device", async () => {
      beforeEach(() =>
        devicesRef.doc("updateme").set({
          manufacturer: "Axross",
          model: "Fly Phone",
          os: "Fly OS",
          osVersion: "10.17.50",
          pushNotificationDestinationId: "00000000-0000-0000-0000-000000000000"
        })
      );

      const newData = {
        manufacturer: "Postman",
        model: "fPhone",
        os: "fOS",
        osVersion: "11.38.41",
        pushNotificationDestinationId: "11111111-1111-1111-1111-111111111111"
      };

      test("it should succeed if trying to update a device with whole proper data", () =>
        assertSucceeds(devicesRef.doc("updateme").update(newData)));

      describe("it should succeed if trying to update fields partially", () => {
        Object.keys(newData).forEach(key => {
          test(`if the given data has only .${key}`, () =>
            assertSucceeds(
              devicesRef.doc("updateme").update({ [key]: newData[key] })
            ));

          test(`if the given data has almost whole apart from .${key}`, () =>
            assertSucceeds(
              devicesRef.doc("updateme").update(removeField(newData, key))
            ));
        });
      });

      describe("it should fail if", () => {
        for (const key of Object.keys(newData)) {
          describe(`data.${key}`, () => {
            everyTypeValueWithout(firestore, "string", (value, type) => {
              test(`is not a string (${type})`, () =>
                assertFails(
                  devicesRef.doc("updateme").set({ ...newData, [key]: value })
                ));
            });

            test("is empty", () =>
              assertFails(
                devicesRef.doc("updateme").update({ ...newData, [key]: "" })
              ));
          });
        }
      });

      test("it should fail if the given data has no field", () =>
        assertFails(
          devicesRef.doc("updateme").update({ ...newData, foo: "bar" })
        ));

      test("it should fail if the given data has any unnecessary field", () =>
        assertFails(
          devicesRef.doc("updateme").update({ ...newData, foo: "bar" })
        ));
    });
  });
});
