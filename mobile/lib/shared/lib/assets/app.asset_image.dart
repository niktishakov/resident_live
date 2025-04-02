import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";

import "package:resident_live/shared/lib/assets/app.asset.dart";

class AppAssetImage extends StatelessWidget {
  const AppAssetImage(
    this.asset, {
    super.key,
    this.width,
    this.height,
    this.color,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
  });

  final AppAsset asset;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit fit;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    switch (asset.type) {
      case AppAssetType.vector:
        return SvgPicture.asset(
          asset.path,
          width: width,
          height: height,
          color: color,
          fit: fit,
          alignment: alignment,
        );

      case AppAssetType.bitmap:
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
