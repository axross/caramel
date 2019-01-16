const fs = require("fs");
const path = require("path");

const projectId = `caramel-test-${Date.now()}`;
const uid = "T0Te5tF1re5t0reSecur1tyRule5";
const email = "test@axross.app";
const auth = { uid, email };
const rules = fs.readFileSync(path.resolve(__dirname, "../firestore.rules"), {
  encoding: "utf-8"
});

module.exports = { projectId, uid, email, auth, rules };
