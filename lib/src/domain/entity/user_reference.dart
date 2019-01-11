import 'package:caramel/domains.dart';

/// An entity of reference to [User].
abstract class UserReference
    with IdentifiableBySubstanceId<UserReference, User>
    implements StatefulFuture<User> {}

abstract class SignedInUserReference
    with IdentifiableBySubstanceId<SignedInUserReference, SignedInUser>
    implements StatefulFuture<SignedInUser> {}
