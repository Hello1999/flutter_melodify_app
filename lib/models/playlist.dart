import 'song.dart';

class Playlist {
  final String id;
  final String name;
  final String description;
  final String coverImage;
  final List<Song> songs;
  final String createdBy;
  final DateTime createdAt;
  final bool isPublic;
  final int followers;

  const Playlist({
    required this.id,
    required this.name,
    required this.description,
    required this.coverImage,
    required this.songs,
    required this.createdBy,
    required this.createdAt,
    this.isPublic = true,
    this.followers = 0,
  });

  int get songCount => songs.length;

  Duration get totalDuration {
    return songs.fold(Duration.zero, (sum, song) => sum + song.duration);
  }

  String get totalDurationString {
    final hours = totalDuration.inHours;
    final minutes = totalDuration.inMinutes % 60;
    if (hours > 0) {
      return '$hours hr $minutes min';
    }
    return '$minutes min';
  }

  Playlist copyWith({
    String? id,
    String? name,
    String? description,
    String? coverImage,
    List<Song>? songs,
    String? createdBy,
    DateTime? createdAt,
    bool? isPublic,
    int? followers,
  }) {
    return Playlist(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      coverImage: coverImage ?? this.coverImage,
      songs: songs ?? this.songs,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      isPublic: isPublic ?? this.isPublic,
      followers: followers ?? this.followers,
    );
  }
}
