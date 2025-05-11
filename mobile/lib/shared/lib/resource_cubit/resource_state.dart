/*
 * Copyright (C) 2024 Finharbor DOO. - All Rights Reserved
 *
 * Unauthorized copying or redistribution of this file in source and binary forms via any medium
 * is strictly prohibited.
 */

part of "resource_cubit.dart";

/// A state class that represents different stages of a resource request.
/// This class is generated using the `freezed` package and includes states
/// for initial, loading, successful data, and error states.
///
/// The [ResourceState] class provides utility getters to check the current state:
/// - [isLoading] returns `true` if the state is [ResourceState.loading].
/// - [isSuccess] returns `true` if the state is [ResourceState.data].
/// - [isError] returns `true` if the state is [ResourceState.error].
///
/// Example usage:
/// ```dart
/// void handleState(ResourceState<MyDataType> state) {
///   if (state.isLoading) {
///     print('Loading...');
///   } else if (state.isSuccess) {
///     print('Data: ${state.data}');
///   } else if (state.isError) {
///     print('Error: ${state.errorMessage}');
///   }
/// }
/// ```
@freezed
class ResourceState<T> with _$ResourceState<T> {
  const ResourceState._();

  /// Represents the initial state before any action has been taken.
  const factory ResourceState.initial() = _Initial;

  /// Represents the loading state while the resource is being fetched.
  const factory ResourceState.loading() = _Loading;

  /// Represents the successful state when the resource has been fetched successfully.
  ///
  /// The [data] parameter holds the fetched data of type [T].
  const factory ResourceState.data({required T data}) = _Data;

  /// Represents the error state when an error occurs during the resource fetching.
  ///
  /// The [errorMessage] parameter holds the error message, which can be null.
  const factory ResourceState.error({required String? errorMessage, Exception? cause}) = _Error;

  /// Returns `true` if the state is [ResourceState.data].
  bool get isSuccess => maybeMap(
        data: (_) => true,
        orElse: () => false,
      );

  /// Returns `true` if the state is [ResourceState.loading].
  bool get isLoading => maybeMap(
        loading: (_) => true,
        orElse: () => false,
      );

  /// Returns `true` if the state is [ResourceState.error].
  bool get isError => maybeMap(
        error: (_) => true,
        orElse: () => false,
      );

  /// Returns the data if the state is [ResourceState.data], otherwise returns null.
  T? get data => maybeMap(
        data: (data) => data.data,
        orElse: () => null,
      );

  /// Returns the error message if the state is [ResourceState.error], otherwise returns null.
  String? get errorMessage => maybeMap(
        error: (error) => error.errorMessage,
        orElse: () => null,
      );

  /// Returns the error cause if the state is [ResourceState.error], otherwise returns null.
  Exception? get errorCause => maybeMap(
        error: (error) => error.cause,
        orElse: () => null,
      );
}
