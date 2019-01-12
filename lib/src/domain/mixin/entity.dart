mixin Entity {
  /// The identification value.
  String get id;
}

mixin IdentifiableById<T> on Entity {
  @override
  bool operator ==(Object other) =>
      other is IdentifiableById<T> && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
