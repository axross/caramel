import 'package:cloud_firestore/cloud_firestore.dart' show WriteBatch;
import 'package:caramel/services.dart';

abstract class AtomicWriteCreator {
  AtomicWrite create();
}

abstract class AtomicWrite with AtomicWriteDistinguishable {
  WriteBatch get forFirestore;

  Future<void> commit();
}

mixin AtomicWriteDistinguishable {
  bool get isOnFirestore => this is FirestoreAtomicWrite;
}
