/*
 * Copyright (C) 2024 Finharbor DOO. - All Rights Reserved
 *
 * Unauthorized copying or redistribution of this file in source and binary forms via any medium
 * is strictly prohibited.
 */

import "dart:async";

import "package:data/data.dart";
import "package:resident_live/app/injection.dart";

/// A function that is called to indicate the start of an action.
///
/// This callback can be used to perform any setup or display a loading indicator
/// before the action begins.
typedef ResourceStartAction = void Function();

/// A function that is called when an action completes successfully.
///
/// The [data] parameter represents the result of the action. The type [T] corresponds
/// to the type of data expected from the successful completion of the action.
typedef ResourceSuccessAction<T> = void Function(T data);

/// A function that is called when an error occurs during an action.
///
/// The [errorMessage] parameter provides details about the error. It can be null
/// if no specific message is available. This callback can be used to handle errors
/// and display error messages to the user.
typedef ResourceErrorAction = void Function(
  String? errorMessage, {
  Exception? exception,
});

/// A function that is called after an action completes, regardless of success or failure.
///
/// This callback can be used to perform cleanup tasks, such as hiding loading indicators
/// or resetting state.
typedef ResourceFinallyAction = void Function();

/// A mixin that wraps a service or repository action into a try-catch block.
/// This mixin provides callbacks for different states, making it easier to
/// manage the lifecycle of an asynchronous action. It can be used with blocs,
/// cubits, or any other classes that need to wrap async actions.
///
/// The mixin defines four callbacks:
/// - [ResourceStartAction] to indicate the start of an action.
/// - [ResourceSuccessAction] to handle successful completion with data of type [T].
/// - [ResourceErrorAction] to handle errors.
/// - [ResourceFinallyAction] to execute code after completion.
///
/// Example usage:
/// ```dart
/// class MyBloc extends Cubit<MyState> with ResourceActionMixin {
///   Future<void> fetchData() {
///     return useResourceAction(
///       myService.getData(),
///       onStart: () => emit(MyLoadingState()),
///       onSuccess: (data) => emit(MyLoadedState(data)),
///       onError: (error) => emit(MyErrorState(error)),
///       onFinally: () => print('Action completed'),
///     );
///   }
/// }
/// ```
mixin ResourceActionMixin {
  /// Wraps an asynchronous [action] with try-catch logic and provides
  /// optional callbacks for different states.
  ///
  /// - [onStart] is called before the action starts.
  /// - [onSuccess] is called with the result if the action completes successfully.
  /// - [onError] is called with an error message if the action throws an exception.
  /// - [onFinally] is called after the action completes, whether successful or not.
  ///
  /// The [action] parameter must be a [Future] that returns a value of type [T].
  /// The [T] type represents the data type expected from the successful action.
  ///
  /// This method can be used to wrap API calls, database queries, or any
  /// other asynchronous operations that may fail.
  ///
  /// Example:
  /// ```dart
  /// await useResourceAction(
  ///   someService.fetchData(),
  ///   onStart: () => print('Loading...'),
  ///   onSuccess: (data) => print('Data loaded: $data'),
  ///   onError: (error) => print('Error: $error'),
  ///   onFinally: () => print('Action completed'),
  /// );
  /// ```
  Future<void> useResourceAction<T>(
    FutureOr<T> action, {
    ResourceStartAction? onStart,
    ResourceSuccessAction<T>? onSuccess,
    ResourceErrorAction? onError,
    ResourceFinallyAction? onFinally,
  }) async {
    final logger = getIt<LoggerService>();
    onStart?.call();
    try {
      final resource = await action;
      onSuccess?.call(resource);
    } on Exception catch (error, stackTrace) {
      logger.error(runtimeType.toString(), error: error, stackTrace: stackTrace);
      onError?.call(error.toString(), exception: error);
    } catch (error, stackTrace) {
      logger.error(runtimeType.toString(), error: error, stackTrace: stackTrace);
      rethrow;
    } finally {
      onFinally?.call();
    }
  }
}
