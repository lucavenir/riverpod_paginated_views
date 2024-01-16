class DataNotFoundException implements Exception {
  const DataNotFoundException(this.message);
  final String message;
  @override
  String toString() => message;
}
