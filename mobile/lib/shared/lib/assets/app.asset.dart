class AppAsset {
  const AppAsset.bitmap(this.path) : type = AppAssetType.bitmap;

  const AppAsset.vector(this.path) : type = AppAssetType.vector;

  final String path;
  final AppAssetType type;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppAsset &&
          runtimeType == other.runtimeType &&
          path == other.path &&
          type == other.type;

  @override
  int get hashCode => path.hashCode ^ type.hashCode;

  @override
  String toString() {
    return "AppAsset{path: $path, type: $type}";
  }
}

enum AppAssetType {
  bitmap,
  vector,
}
