import 'package:caramel/domains.dart';

abstract class UserReference<T extends User>
    with ReferenceEntity, ComparableWithSubstance<T>, ComparableWithUser
    implements StatefulFuture<T> {}

abstract class OtherUserReference<T extends OtherUser>
    with ReferenceEntity, ComparableWithSubstance<T>, ComparableWithUser
    implements UserReference<T> {}

abstract class SignedInUserReference<T extends SignedInUser>
    with ReferenceEntity, ComparableWithSubstance<T>, ComparableWithUser
    implements UserReference<T> {}

mixin ComparableWithUser on ReferenceEntity {
  bool isSameWithUser(User entity) => id == entity.id;
}
