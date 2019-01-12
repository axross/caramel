import 'package:caramel/domains.dart';

mixin ReferenceEntity {
  /// The identification value.
  String get id;
}

mixin IdentifiableBySubstanceId<T extends ReferenceEntity, S extends Entity>
    on ReferenceEntity {
  @override
  bool operator ==(Object other) =>
      other is IdentifiableBySubstanceId<T, S> && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
