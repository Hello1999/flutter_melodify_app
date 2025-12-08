class Song {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String albumArt;
  final Duration duration;
  final bool isLiked;
  final int playCount;
  final DateTime? addedAt;

  const Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.albumArt,
    required this.duration,
    this.isLiked = false,
    this.playCount = 0,
    this.addedAt,
  });

  Song copyWith({
    String? id,
    String? title,
    String? artist,
    String? album,
    String? albumArt,
    Duration? duration,
    bool? isLiked,
    int? playCount,
    DateTime? addedAt,
  }) {
    return Song(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      albumArt: albumArt ?? this.albumArt,
      duration: duration ?? this.duration,
      isLiked: isLiked ?? this.isLiked,
      playCount: playCount ?? this.playCount,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  String get durationString {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
