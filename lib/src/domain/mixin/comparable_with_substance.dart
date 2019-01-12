import 'package:caramel/domains.dart';

mixin ComparableWithSubstance<S extends Entity> on ReferenceEntity {
  /// Checks whether this and the thing [reference] referring to are the same.
  bool isSameWithEntity(S entity) => id == entity.id;
}
