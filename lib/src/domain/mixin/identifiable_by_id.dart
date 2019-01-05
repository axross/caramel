mixin IdentifiableById<T> {
  /// The identification value.
  String get id;

  @override
  bool operator ==(Object other) =>
      other is IdentifiableById<T> && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
