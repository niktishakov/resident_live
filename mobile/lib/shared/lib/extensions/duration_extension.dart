extension DurationExt on Duration {
  String toMMSSString() {
    // Calculate remaining time
    final totalSeconds = inSeconds;
    final minutes = (totalSeconds / 60).floor();
    final seconds = totalSeconds % 60;

    // Format minutes and seconds to ensure two digits
    final formattedTime =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return formattedTime;
  }
}
