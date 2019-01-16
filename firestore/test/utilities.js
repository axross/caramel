const { firestore } = require("@firebase/testing");

const valueGenerator = new Map([
  ["string", () => "Lorem ipsum"],
  ["number", () => Number.MAX_SAFE_INTEGER],
  ["boolean", () => true],
  ["object", () => ({ foo: "bar" })],
  ["array", () => [1, 2, 3]],
  ["timestamp", () => firestore.Timestamp.now()],
  ["path", fs => fs.collection("somewhere").doc("something")]
]);

const types = Array.from(valueGenerator.keys());

const everyTypeValueWithout = (fs, type, callback) => {
  if (types.indexOf(type) === -1) {
    throw new Error(`type "${type}" is not supported.`);
  }

  for (const _type of types.filter(_type => _type !== type)) {
    callback(valueGenerator.get(_type)(fs), _type);
  }
};

module.exports.everyTypeValueWithout = everyTypeValueWithout;

const removeField = (object, key) =>
  Object.keys(object).reduce(
    (obj, k) => (k === key ? obj : { ...obj, [k]: object[k] }),
    {}
  );

module.exports.removeField = removeField;
