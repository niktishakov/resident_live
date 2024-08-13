import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'asset.dart';

class CoreAssetImage extends StatelessWidget {
  const CoreAssetImage(
    this.asset, {
    Key? key,
    this.width,
    this.height,
    this.color,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
  }) : super(key: key);

  final CoreAsset asset;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit fit;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    switch (asset.type) {
      case CoreAssetType.vector:
        return SvgPicture.asset(
          asset.path,
          width: width,
          height: height,
          color: color,
          fit: fit,
          alignment: alignment,
        );

      case CoreAssetType.bitmap:
        return ExcludeSemantics(
          child: Image.asset(
            asset.path,
            width: width,
            height: height,
            color: color,
            fit: fit,
            alignment: alignment,
          ),
        );
      default:
        return Container();
    }
  }
}
