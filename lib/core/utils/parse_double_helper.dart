extension JsonParsing on Object? {
  double toDoubleOrZero([double fallback = 0.0]) {
    final value = this;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? fallback;
    return fallback;
  }
}
