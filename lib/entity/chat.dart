import 'package:meta/meta.dart';
import './user_reference.dart';

abstract class Chat {
  final String id;
  final List<UserReference> members;

  Chat({@required this.id, @required this.members})
      : assert(id != null),
        assert(members != null);
}
