/*
 * Copyright (C) 2024 Finharbor DOO. - All Rights Reserved 
 *
 * Unauthorized copying or redistribution of this file in source and binary forms via any medium 
 * is strictly prohibited.
 */

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:get_it/get_it.dart";
import "package:resident_live/shared/lib/resource_cubit/resource_cubit.dart";

Widget _defaultOrElseWidget() => const SizedBox.shrink();
Widget _defaultLoadingWidget() => const Center(child: CircularProgressIndicator.adaptive());
Widget _defaultErrorWidget(
  String? errorMessage,
  Exception? cause,
) {
  return Center(
    child: AlertDialog(
      title: const Text("Error"),
      content: Text(errorMessage ?? cause?.toString() ?? "Unknown error"),
      actions: [
        TextButton(onPressed: () {}, child: const Text("OK")),
      ],
    ),
  );
}

class ResourceBlocBuilder<CubitType extends StateStreamable<ResourceState<ResourceType>>, ResourceType> extends BlocBuilder<CubitType, ResourceState<ResourceType>> {
  ResourceBlocBuilder({
    Widget Function()? loading = _defaultLoadingWidget,
    Widget Function(ResourceType data)? data,
    Widget Function(String? errorMessage, Exception? cause)? error = _defaultErrorWidget,
    Widget Function() orElse = _defaultOrElseWidget,
    Widget Function()? initial,
    CubitType? bloc,
    super.buildWhen,
    super.key,
  }) : super(
          bloc: bloc ?? GetIt.I<CubitType>(),
          builder: (context, state) {
            return state.maybeWhen(
              orElse: orElse,
              loading: loading,
              error: error,
              data: data,
              initial: initial,
            );
          },
        );
}

class ResourceBlocListener<CubitType extends StateStreamable<ResourceState<ResourceType>>, ResourceType> extends BlocListener<CubitType, ResourceState<ResourceType>> {
  ResourceBlocListener({
    required super.listener,
    CubitType? bloc,
    super.listenWhen,
    super.child,
    super.key,
  }) : super(
          bloc: bloc ?? GetIt.I<CubitType>(),
        );
}

class ResourceBlocConsumer<CubitType extends StateStreamable<ResourceState<ResourceType>>, ResourceType> extends BlocConsumer<CubitType, ResourceState<ResourceType>> {
  ResourceBlocConsumer({
    required super.listener,
    Widget Function()? loading = _defaultLoadingWidget,
    Widget Function(ResourceType data)? data,
    Widget Function(String? errorMessage, Exception? cause)? error = _defaultErrorWidget,
    Widget Function() orElse = _defaultOrElseWidget,
    Widget Function()? initial,
    CubitType? bloc,
    super.buildWhen,
    super.listenWhen,
    super.key,
  }) : super(
          bloc: bloc ?? GetIt.I<CubitType>(),
          builder: (context, state) {
            return state.maybeWhen(
              orElse: orElse,
              loading: loading,
              error: error,
              data: data,
              initial: initial,
            );
          },
        );
}

class ActionBlocConsumer<CubitType extends StateStreamable<ResourceState<ResourceType>>, ResourceType> extends BlocConsumer<CubitType, ResourceState<ResourceType>> {
  ActionBlocConsumer({
    required super.listener,
    required super.builder,
    CubitType? bloc,
    super.key,
  }) : super(
          bloc: bloc ?? GetIt.I<CubitType>(),
          buildWhen: (previous, current) => previous.isLoading != current.isLoading,
          listenWhen: (previous, current) => previous.isSuccess != current.isSuccess || previous.isError != current.isError,
        );
}
