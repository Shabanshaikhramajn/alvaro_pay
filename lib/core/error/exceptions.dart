// Thrown by data sources; the repository layer catches these and
// converts them into typed Failures for the rest of the app to react to.
class ServerException implements Exception {
  const ServerException(this.message);
  final String message;
}

class ValidationException implements Exception {
  const ValidationException(this.message);
  final String message;
}

class InsufficientBalanceException implements Exception {
  const InsufficientBalanceException(this.message);
  final String message;
}
