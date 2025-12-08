import 'song.dart';

class Album {
  final String id;
  final String title;
  final String artist;
  final String artistId;
  final String coverImage;
  final int year;
  final List<Song> songs;
  final String? genre;
  final AlbumType type;

  const Album({
    required this.id,
    required this.title,
    required this.artist,
    required this.artistId,
    required this.coverImage,
    required this.year,
    required this.songs,
    this.genre,
    this.type = AlbumType.album,
  });

  int get songCount => songs.length;

  Duration get totalDuration {
    return songs.fold(Duration.zero, (sum, song) => sum + song.duration);
  }
}

enum AlbumType { album, single, ep }

extension AlbumTypeExtension on AlbumType {
  String get label {
    switch (this) {
      case AlbumType.album:
        return 'Album';
      case AlbumType.single:
        return 'Single';
      case AlbumType.ep:
        return 'EP';
    }
  }
}
