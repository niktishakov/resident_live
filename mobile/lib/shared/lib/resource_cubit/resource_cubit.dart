/*
 * Copyright (C) 2024 Finharbor DOO. - All Rights Reserved
 *
 * Unauthorized copying or redistribution of this file in source and binary forms via any medium
 * is strictly prohibited.
 */

import "dart:async";

import "package:data/data.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:resident_live/app/injection.dart";
import "package:resident_live/shared/lib/resource_cubit/resource_action_mixin.dart";
import "package:resident_live/shared/lib/resource_cubit/safe_bloc.dart";

part "resource_cubit.freezed.dart";
part "resource_state.dart";

/// A function type that represents an asynchronous action that can be performed
/// by the [ResourceCubit]. It takes an optional argument of type [ArgsType] and
/// returns a [Future] of type [ReturnType].
typedef ResourceAction<ReturnType, ArgsType> = Future<ReturnType> Function([
  ArgsType? args,
]);

/// A [Cubit] that wraps a service action into stateful logic and emits corresponding
/// states at each stage of the request. This class provides an easy way to handle
/// resource loading, success, and error states in a clean and manageable way.
///
/// The [ResourceCubit] takes an action with optional arguments that can be recalled
/// later by calling [loadResource]. It can also load the resource on initialization
/// and run safe actions (cancel actions when the cubit is disposed).
///
/// Example usage:
/// ```dart
/// class MyResourceCubit extends ResourceCubit<MyDataType, MyArgsType> {
///   MyResourceCubit() : super(myService.getData, defaultArgs: MyArgsType());
/// }
/// ```
abstract class ResourceCubit<ResourceType, ArgsType> extends Cubit<ResourceState<ResourceType>> with SafeBlocMixin<ResourceState<ResourceType>>, ResourceActionMixin {
  /// Creates a [ResourceCubit] instance.
  ///
  /// The [action] parameter is a [ResourceAction] that defines the asynchronous
  /// operation to be performed. The [safeLoad] parameter determines whether the
  /// action should be run safely (canceled if the cubit is disposed). The
  /// [loadOnInit] parameter determines whether the resource should be loaded
  /// immediately upon initialization. The [defaultArgs] parameter provides default
  /// arguments for the action.
  ResourceCubit(
    this.action, {
    this.safeLoad = true,
    this.loadOnInit = true,
    this.defaultArgs,
  }) : super(const ResourceState.initial()) {
    if (loadOnInit) loadResource(defaultArgs);
  }

  /// Whether the action should be run safely (canceled if the cubit is disposed).
  final bool safeLoad;

  /// Whether the resource should be loaded immediately upon initialization.
  final bool loadOnInit;

  /// The asynchronous action to be performed, defined as a [ResourceAction].
  final ResourceAction<ResourceType, ArgsType> action;

  /// Default arguments for the action.
  final ArgsType? defaultArgs;

  /// Loads the resource using the provided [args] or the [defaultArgs].
  ///
  /// This method wraps the action in stateful logic, emitting corresponding
  /// states at each stage of the request:
  /// - [ResourceState.loading] when the action starts.
  /// - [ResourceState.data] when the action completes successfully.
  /// - [ResourceState.error] when an error occurs.
  ///
  /// If [safeLoad] is true, the action is wrapped in [runSafe] to ensure it
  /// is canceled if the cubit is disposed.
  ///
  /// Example:
  /// ```dart
  /// await myCubit.loadResource(MyArgsType());
  /// ```
  Future<void> loadResource([ArgsType? args]) {
    final logger = getIt<LoggerService>();
    return useResourceAction(
      safeLoad ? runSafe(action(args)) : action(args),
      onStart: () {
        logger.info("$runtimeType: loadResource($args}): onStart");
        emit(const ResourceState.loading());
      },
      onSuccess: (data) {
        logger.info("$runtimeType: loadResource($args}): onSuccess($data)");
        emit(ResourceState.data(data: data));
      },
      onError: (message, {exception}) {
        logger.error("$runtimeType: loadResource($args}): onError($message, $exception)");
        emit(ResourceState.error(errorMessage: message, cause: exception));
      },
    );
  }
}

class VoidResourceCubit<T> extends ResourceCubit<T, void> {
  VoidResourceCubit(
    Future<T> Function() fetch, {
    super.loadOnInit,
    super.safeLoad,
  }) : super(([_]) => fetch());
}
