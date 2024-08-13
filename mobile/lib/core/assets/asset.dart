class CoreAsset {
  const CoreAsset.bitmap(this.path) : type = CoreAssetType.bitmap;

  const CoreAsset.vector(this.path) : type = CoreAssetType.vector;

  final String path;
  final CoreAssetType type;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoreAsset &&
          runtimeType == other.runtimeType &&
          path == other.path &&
          type == other.type;

  @override
  int get hashCode => path.hashCode ^ type.hashCode;

  @override
  String toString() {
    return 'CoreAsset{path: $path, type: $type}';
  }
}

enum CoreAssetType {
  bitmap,
  vector,
}
