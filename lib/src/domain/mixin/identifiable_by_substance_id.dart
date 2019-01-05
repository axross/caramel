mixin IdentifiableBySubstanceId<T, S> {
  /// The refering value's `id`.
  String get substanceId;

  @override
  bool operator ==(Object other) =>
      other is IdentifiableBySubstanceId<T, S> &&
      other.substanceId == substanceId;

  @override
  int get hashCode => substanceId.hashCode;
}
