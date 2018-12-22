import 'package:meta/meta.dart';

abstract class User {
  final String uid;
  final String name;
  final Uri imageUrl;

  User({@required this.uid, @required this.name, @required this.imageUrl})
      : assert(uid != null),
        assert(name != null),
        assert(imageUrl != null);
}
