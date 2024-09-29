class RlAsset {
  const RlAsset.bitmap(this.path) : type = RlAssetType.bitmap;

  const RlAsset.vector(this.path) : type = RlAssetType.vector;

  final String path;
  final RlAssetType type;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RlAsset &&
          runtimeType == other.runtimeType &&
          path == other.path &&
          type == other.type;

  @override
  int get hashCode => path.hashCode ^ type.hashCode;

  @override
  String toString() {
    return 'RlAsset{path: $path, type: $type}';
  }
}

enum RlAssetType {
  bitmap,
  vector,
}
