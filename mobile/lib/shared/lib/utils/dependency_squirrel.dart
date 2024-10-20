import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// !!! It does not listen to any change !!!
///
/// Finds the nearest object of type T that has been previously added to
/// the widget tree using Provider or any of the available widgets in this file.
///
/// Shortcut to call Provider.of with listen == false.
T find<T>(BuildContext context) {
  return Provider.of<T>(context, listen: false);
}

/// Wrap a subtree in a Listen widget to rebuild the subtree any time the
/// object of type T previously added to the widget tree changes.
class Listen<T> extends StatelessWidget {
  const Listen({super.key, required this.builder});

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    Provider.of<T>(context);
    return builder(context);
  }
}
