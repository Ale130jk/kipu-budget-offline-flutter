/// Expected rule violation surfaced to the UI.
class DomainException implements Exception {
  const DomainException(this.message);

  final String message;

  @override
  String toString() => message;
}
