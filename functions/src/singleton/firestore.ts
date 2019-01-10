import app from './firebaseApp';

const firestore = app.firestore();

firestore.settings({
  timestampsInSnapshots: true,
});

export default firestore;
