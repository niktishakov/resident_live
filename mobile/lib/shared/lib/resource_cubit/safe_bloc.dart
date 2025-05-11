/*
 * Copyright (C) 2024 Finharbor DOO. - All Rights Reserved
 *
 * Unauthorized copying or redistribution of this file in source and binary forms via any medium
 * is strictly prohibited.
 */

import "package:async/async.dart";
import "package:bloc/bloc.dart";

/// A mixin that provides safe execution and cancellation of asynchronous operations
/// within a BlocBase. It ensures that any long-running operations are properly
/// canceled when the bloc is closed, preventing memory leaks and ensuring clean
/// resource management.
///
/// [State] The type of state used by the BlocBase.
///
/// ### Usage:
///
/// To use the `SafeBlocMixin`, simply include it in your bloc class:
///
/// ```dart
/// class MyBloc extends Bloc<MyEvent, MyState> with SafeBlocMixin {
///   // Your bloc implementation here
/// }
/// ```
///
/// This mixin is particularly useful for managing asynchronous operations within
/// blocs, especially when dealing with network requests, database queries, or
/// any other potentially long-running tasks.
mixin SafeBlocMixin<State> on BlocBase<State> {
  /// A set that keeps track of all the [CancelableOperation] instances that are
  /// currently running. It is used to manage and cancel these operations when needed.
  final _cancelableOperationsSet = <CancelableOperation>{};

  /// Executes a given asynchronous action safely.
  ///
  /// This method wraps the provided action in a [CancelableOperation].
  /// It ensures that the operation can be canceled
  /// if the bloc is closed before the action completes.
  ///
  /// - Parameter action: The asynchronous action to execute.
  /// - Returns: The result of the action.
  Future<T> runSafe<T>(Future<T> action) {
    final cancelableOperation = CancelableOperation.fromFuture(action);
    _cancelableOperationsSet.add(cancelableOperation);
    return cancelableOperation.value.whenComplete(() => _cancelableOperationsSet.remove(cancelableOperation));
  }

  /// Cancels all active [CancelableOperation] before closing the bloc.
  ///
  /// This overrides the `close` method of `BlocBase`, ensuring that all running operations
  /// are properly terminated when the bloc is closed.
  ///
  /// - Returns: A future that completes when the bloc is closed.
  @override
  Future<void> close() {
    for (final cancelableOperation in _cancelableOperationsSet) {
      cancelableOperation.cancel();
    }
    return super.close();
  }
}
