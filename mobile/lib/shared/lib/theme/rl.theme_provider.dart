import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'rl.theme.dart';

/// Note this provider does not use the standard [BaseNotifier] found in the mobile package in order to minimise dependencies
class RlThemeProvider extends ChangeNotifier {
  RlThemeProvider(this._rlTheme);

  bool _mounted = true;

  RlTheme _rlTheme;
  RlTheme get rlTheme => _rlTheme;

  void setNewTheme(RlTheme theme) {
    _rlTheme = theme;
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (_mounted) {
      super.notifyListeners();
    }
  }
}

/// Note these extension methods do not use the standard [find<T>] found in the mobile package in order to minimise dependencies
extension AiThemeBuildContextExtension on BuildContext {
  RlTheme get rlTheme {
    return Provider.of<RlThemeProvider>(this, listen: false)._rlTheme;
  }

  void changeTheme(RlTheme? value) {
    if (value != null) {
      final rlThemeProvider = Provider.of<RlThemeProvider>(this, listen: false);
      rlThemeProvider._rlTheme = value;
      rlThemeProvider.notifyListeners();
    }
  }

  /// skip any of the [min] and [max] params to avoid clamping
  ///
  /// context.textScaleFactorClamped() will result in MediaQuery.of(context).textScaleFactor
  double textScaleFactorClamped({double? min, double? max}) {
    final textScaleFactor = MediaQuery.of(this).textScaleFactor;

    if (min == null && max == null) {
      return textScaleFactor;
    }

    if (max == null) {
      final _min = min!;
      return textScaleFactor.clamp(_min, _min + textScaleFactor);
    }

    if (min == null) {
      return textScaleFactor.clamp(0, max) as double;
    }

    return textScaleFactor.clamp(min, max);
  }

  double get size40 => 40;

  double get loadingIndicatorSize => 40;

  double get badgeSize32 => 32;

  double get iconSize16 => 16;

  double get iconSize20 => 20;

  double get iconSize24 => 24;

  double get iconSize32 => 32;

  double get iconSize48 => 48;

  double get iconSize56 => 56;

  double get iconSize64 => 64;

  double get iconSize112 => 112;

  double get iconSize112WithBreakout => iconSize112 + iconSize16;

  SizedBox get vBoxBetweenButtons => const SizedBox(height: 16);

  SizedBox get vBox10PctScreenHeight {
    final height = MediaQuery.of(this).size.height;
    return SizedBox(height: height * 0.10);
  }

  SizedBox get vBox4 => const SizedBox(height: 4);

  SizedBox get vBox8 => const SizedBox(height: 8);

  SizedBox get vBox12 => const SizedBox(height: 12);

  SizedBox get vBox16 => const SizedBox(height: 16);

  SizedBox get vBox24 => const SizedBox(height: 24);

  SizedBox get vBox32 => const SizedBox(height: 32);

  SizedBox get vBox40 => const SizedBox(height: 40);

  SizedBox get vBox56 => const SizedBox(height: 56);

  SizedBox get hBoxBetweenButtons => const SizedBox(width: 16);

  SizedBox get hBox4 => const SizedBox(width: 4);

  SizedBox get hBox8 => const SizedBox(width: 8);

  SizedBox get hBox12 => const SizedBox(width: 12);

  SizedBox get hBox16 => const SizedBox(width: 16);

  SizedBox get hBox24 => const SizedBox(width: 24);

  SizedBox get hBox32 => const SizedBox(width: 32);

  SizedBox get hBox40 => const SizedBox(width: 40);

  SizedBox get hBox56 => const SizedBox(width: 56);

  EdgeInsetsGeometry get allPadding4 => const EdgeInsets.all(4);

  EdgeInsetsGeometry get allPadding8 => const EdgeInsets.all(8);

  EdgeInsetsGeometry get allPadding12 => const EdgeInsets.all(12);

  EdgeInsetsGeometry get allPadding16 => const EdgeInsets.all(16);

  EdgeInsetsGeometry get allPadding20 => const EdgeInsets.all(20);

  EdgeInsetsGeometry get allPadding24 => const EdgeInsets.all(24);

  EdgeInsetsGeometry get paddingEdges8 =>
      const EdgeInsets.symmetric(horizontal: 8);

  EdgeInsetsGeometry get paddingEdges12 =>
      const EdgeInsets.symmetric(horizontal: 12);

  EdgeInsetsGeometry get paddingEdges16 =>
      const EdgeInsets.symmetric(horizontal: 16);

  EdgeInsetsGeometry get paddingEdges20 =>
      const EdgeInsets.symmetric(horizontal: 20);

  EdgeInsetsGeometry get paddingEdges24 =>
      const EdgeInsets.symmetric(horizontal: 24);
  EdgeInsetsGeometry get paddingEdges30 =>
      const EdgeInsets.symmetric(horizontal: 30);

  EdgeInsetsGeometry get paddingLeft8 => const EdgeInsets.only(left: 8);

  EdgeInsetsGeometry get paddingLeft16 => const EdgeInsets.only(left: 16);

  EdgeInsetsGeometry get paddingLeft20 => const EdgeInsets.only(left: 20);

  EdgeInsetsGeometry get paddingLeft24 => const EdgeInsets.only(left: 24);

  EdgeInsetsGeometry get paddingRight8 => const EdgeInsets.only(right: 8);

  EdgeInsetsGeometry get paddingRight24 => const EdgeInsets.only(right: 24);

  EdgeInsetsGeometry get paddingVertical8 =>
      const EdgeInsets.symmetric(vertical: 8);

  EdgeInsetsGeometry get paddingVertical16 =>
      const EdgeInsets.symmetric(vertical: 16);

  EdgeInsetsGeometry get paddingVertical24 =>
      const EdgeInsets.symmetric(vertical: 24);

  EdgeInsetsGeometry get paddingVertical30 =>
      const EdgeInsets.symmetric(vertical: 30);

  EdgeInsetsGeometry get tabPaddingEdges =>
      const EdgeInsets.symmetric(horizontal: 4);

  EdgeInsetsGeometry get textFieldContentPadding =>
      const EdgeInsets.only(bottom: 8);

  double get edge12 => 12;

  double get edge16 => 16;
}
