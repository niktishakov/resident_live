/// Custom errors for WorkmanagerService
class WorkmanagerServiceError extends Error {
  WorkmanagerServiceError(this.message);
  final String message;

  @override
  String toString() => message;
}

class WorkmanagerNotInitializedError extends WorkmanagerServiceError {
  WorkmanagerNotInitializedError()
      : super('WorkmanagerService must be initialized first');
}

class WorkmanagerNotReadyError extends WorkmanagerServiceError {
  WorkmanagerNotReadyError()
      : super('Workmanager is not ready. Call initialize() first');
}

class WorkmanagerInstanceError extends WorkmanagerServiceError {
  WorkmanagerInstanceError() : super('Instance was set to null after check');
}
