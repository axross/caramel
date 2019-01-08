import 'package:cloud_firestore/cloud_firestore.dart'
    show Firestore, WriteBatch;
import 'package:meta/meta.dart';
import 'package:caramel/services.dart';

class FirestoreAtomicWriteCreator implements AtomicWriteCreator {
  FirestoreAtomicWriteCreator({@required Firestore firestore})
      : assert(firestore != null),
        _firestore = firestore;

  final Firestore _firestore;

  @override
  FirestoreAtomicWrite create() => FirestoreAtomicWrite(
        writeBatch: _firestore.batch(),
      );
}

class FirestoreAtomicWrite
    with AtomicWriteDistinguishable
    implements AtomicWrite {
  FirestoreAtomicWrite({@required WriteBatch writeBatch})
      : _writeBatch = writeBatch;

  final WriteBatch _writeBatch;

  @override
  WriteBatch get forFirestore => _writeBatch;

  @override
  Future<void> commit() => _writeBatch.commit();
}
