import 'package:caramel/domains.dart';

mixin ComparableWithReference<T, R extends IdentifiableBySubstanceId>
    on IdentifiableById<T> {
  /// Checks whether this and the thing [reference] referring to are the same.
  bool isSameWithReference(R reference) => id == reference.substanceId;
}
