extension DurationExt on Duration {
  String toMMSSString() {
    // Calculate remaining time
    final int totalSeconds = this.inSeconds;
    final int minutes = (totalSeconds / 60).floor();
    final int seconds = totalSeconds % 60;

    // Format minutes and seconds to ensure two digits
    final String formattedTime =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return formattedTime;
  }
}
