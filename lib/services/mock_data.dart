import 'package:flutter/material.dart';
import '../models/models.dart';

class MockData {
  MockData._();

  // Picsum 图片 URL 生成器
  static String _albumArt(int id) => 'https://picsum.photos/seed/album$id/400/400';
  static String _artistImg(int id) => 'https://picsum.photos/seed/artist$id/400/400';
  static String _playlistImg(int id) => 'https://picsum.photos/seed/playlist$id/400/400';
  static String _categoryImg(int id) => 'https://picsum.photos/seed/category$id/400/400';

  // 歌曲数据
  static final List<Song> songs = [
    Song(id: '1', title: 'Midnight Dreams', artist: 'Luna Eclipse', album: 'Starlight', albumArt: _albumArt(1), duration: const Duration(minutes: 3, seconds: 45), playCount: 1234567, isLiked: true),
    Song(id: '2', title: 'Electric Waves', artist: 'Neon Pulse', album: 'Digital Horizon', albumArt: _albumArt(2), duration: const Duration(minutes: 4, seconds: 12), playCount: 987654),
    Song(id: '3', title: 'Summer Breeze', artist: 'Coastal Vibes', album: 'Ocean Songs', albumArt: _albumArt(3), duration: const Duration(minutes: 3, seconds: 28), playCount: 2345678, isLiked: true),
    Song(id: '4', title: 'City Lights', artist: 'Urban Soul', album: 'Metropolis', albumArt: _albumArt(4), duration: const Duration(minutes: 4, seconds: 5), playCount: 876543),
    Song(id: '5', title: 'Mountain High', artist: 'Echo Valley', album: 'Nature Calls', albumArt: _albumArt(5), duration: const Duration(minutes: 5, seconds: 15), playCount: 654321),
    Song(id: '6', title: 'Rainy Days', artist: 'Melancholy Moon', album: 'Emotions', albumArt: _albumArt(6), duration: const Duration(minutes: 3, seconds: 55), playCount: 543210, isLiked: true),
    Song(id: '7', title: 'Dance Floor', artist: 'Beat Machine', album: 'Club Nights', albumArt: _albumArt(7), duration: const Duration(minutes: 3, seconds: 32), playCount: 1876543),
    Song(id: '8', title: 'Acoustic Sunset', artist: 'Wooden Strings', album: 'Unplugged', albumArt: _albumArt(8), duration: const Duration(minutes: 4, seconds: 45), playCount: 432109),
    Song(id: '9', title: 'Future Bass', artist: 'Synth Master', album: 'Tomorrow', albumArt: _albumArt(9), duration: const Duration(minutes: 3, seconds: 18), playCount: 765432),
    Song(id: '10', title: 'Jazz Café', artist: 'Smooth Trio', album: 'Late Night', albumArt: _albumArt(10), duration: const Duration(minutes: 5, seconds: 30), playCount: 321098),
    Song(id: '11', title: 'Rock Anthem', artist: 'Thunder Band', album: 'Legends', albumArt: _albumArt(11), duration: const Duration(minutes: 4, seconds: 22), playCount: 2109876, isLiked: true),
    Song(id: '12', title: 'Hip Hop Flow', artist: 'Street Poet', album: 'Urban Tales', albumArt: _albumArt(12), duration: const Duration(minutes: 3, seconds: 48), playCount: 1543210),
    Song(id: '13', title: 'Classical Dreams', artist: 'Orchestra One', album: 'Symphony', albumArt: _albumArt(13), duration: const Duration(minutes: 6, seconds: 15), playCount: 234567),
    Song(id: '14', title: 'Country Road', artist: 'Dusty Boots', album: 'Homeland', albumArt: _albumArt(14), duration: const Duration(minutes: 3, seconds: 55), playCount: 456789),
    Song(id: '15', title: 'EDM Explosion', artist: 'Drop Master', album: 'Festival', albumArt: _albumArt(15), duration: const Duration(minutes: 4, seconds: 8), playCount: 1987654),
    Song(id: '16', title: 'R&B Groove', artist: 'Velvet Voice', album: 'Soulful', albumArt: _albumArt(16), duration: const Duration(minutes: 4, seconds: 35), playCount: 876543, isLiked: true),
    Song(id: '17', title: 'Indie Vibes', artist: 'Garage Band', album: 'DIY', albumArt: _albumArt(17), duration: const Duration(minutes: 3, seconds: 42), playCount: 345678),
    Song(id: '18', title: 'Pop Princess', artist: 'Star Girl', album: 'Spotlight', albumArt: _albumArt(18), duration: const Duration(minutes: 3, seconds: 25), playCount: 3210987, isLiked: true),
    Song(id: '19', title: 'Metal Thunder', artist: 'Iron Storm', album: 'Heavy', albumArt: _albumArt(19), duration: const Duration(minutes: 5, seconds: 45), playCount: 654321),
    Song(id: '20', title: 'Reggae Sun', artist: 'Island Rhythm', album: 'Caribbean', albumArt: _albumArt(20), duration: const Duration(minutes: 4, seconds: 12), playCount: 543210),
  ];

  // 艺人数据
  static final List<Artist> artists = [
    Artist(id: 'a1', name: 'Luna Eclipse', imageUrl: _artistImg(1), bio: 'Electronic music producer from LA', followers: 2500000, monthlyListeners: 8500000, genres: ['Electronic', 'Pop'], isVerified: true),
    Artist(id: 'a2', name: 'Neon Pulse', imageUrl: _artistImg(2), bio: 'Synth-wave artist', followers: 1800000, monthlyListeners: 5200000, genres: ['Synthwave', 'Electronic'], isVerified: true),
    Artist(id: 'a3', name: 'Coastal Vibes', imageUrl: _artistImg(3), bio: 'Beach music collective', followers: 950000, monthlyListeners: 3200000, genres: ['Chill', 'Acoustic']),
    Artist(id: 'a4', name: 'Urban Soul', imageUrl: _artistImg(4), bio: 'R&B singer-songwriter', followers: 3200000, monthlyListeners: 12000000, genres: ['R&B', 'Soul'], isVerified: true),
    Artist(id: 'a5', name: 'Echo Valley', imageUrl: _artistImg(5), bio: 'Folk rock band', followers: 780000, monthlyListeners: 2100000, genres: ['Folk', 'Rock']),
    Artist(id: 'a6', name: 'Beat Machine', imageUrl: _artistImg(6), bio: 'DJ and producer', followers: 4500000, monthlyListeners: 18000000, genres: ['EDM', 'House'], isVerified: true),
    Artist(id: 'a7', name: 'Smooth Trio', imageUrl: _artistImg(7), bio: 'Jazz ensemble', followers: 320000, monthlyListeners: 890000, genres: ['Jazz', 'Blues']),
    Artist(id: 'a8', name: 'Thunder Band', imageUrl: _artistImg(8), bio: 'Rock legends', followers: 8900000, monthlyListeners: 25000000, genres: ['Rock', 'Alternative'], isVerified: true),
  ];

  // 专辑数据
  static final List<Album> albums = [
    Album(id: 'al1', title: 'Starlight', artist: 'Luna Eclipse', artistId: 'a1', coverImage: _albumArt(1), year: 2024, songs: songs.sublist(0, 5)),
    Album(id: 'al2', title: 'Digital Horizon', artist: 'Neon Pulse', artistId: 'a2', coverImage: _albumArt(2), year: 2024, songs: songs.sublist(1, 4)),
    Album(id: 'al3', title: 'Ocean Songs', artist: 'Coastal Vibes', artistId: 'a3', coverImage: _albumArt(3), year: 2023, songs: songs.sublist(2, 6)),
    Album(id: 'al4', title: 'Metropolis', artist: 'Urban Soul', artistId: 'a4', coverImage: _albumArt(4), year: 2024, songs: songs.sublist(3, 8)),
    Album(id: 'al5', title: 'Club Nights', artist: 'Beat Machine', artistId: 'a6', coverImage: _albumArt(7), year: 2024, songs: songs.sublist(6, 10)),
    Album(id: 'al6', title: 'Legends', artist: 'Thunder Band', artistId: 'a8', coverImage: _albumArt(11), year: 2023, songs: songs.sublist(10, 15)),
  ];

  // 播放列表数据
  static final List<Playlist> playlists = [
    Playlist(id: 'p1', name: 'Today\'s Top Hits', description: 'The hottest tracks right now', coverImage: _playlistImg(1), songs: songs.sublist(0, 10), createdBy: 'Melodify', createdAt: DateTime(2024, 1, 1), followers: 25000000),
    Playlist(id: 'p2', name: 'Chill Vibes', description: 'Relax and unwind', coverImage: _playlistImg(2), songs: songs.sublist(2, 8), createdBy: 'Melodify', createdAt: DateTime(2024, 2, 15), followers: 12000000),
    Playlist(id: 'p3', name: 'Workout Energy', description: 'Power through your workout', coverImage: _playlistImg(3), songs: songs.sublist(5, 12), createdBy: 'Melodify', createdAt: DateTime(2024, 3, 1), followers: 8500000),
    Playlist(id: 'p4', name: 'Late Night Jazz', description: 'Smooth jazz for late nights', coverImage: _playlistImg(4), songs: songs.sublist(8, 14), createdBy: 'Melodify', createdAt: DateTime(2023, 11, 20), followers: 3200000),
    Playlist(id: 'p5', name: 'Road Trip', description: 'Songs for the open road', coverImage: _playlistImg(5), songs: songs.sublist(10, 18), createdBy: 'Melodify', createdAt: DateTime(2024, 4, 10), followers: 6700000),
    Playlist(id: 'p6', name: 'Focus Flow', description: 'Concentration enhancing music', coverImage: _playlistImg(6), songs: songs.sublist(0, 6), createdBy: 'Melodify', createdAt: DateTime(2024, 5, 5), followers: 9800000),
    Playlist(id: 'p7', name: 'Party Starters', description: 'Get the party going', coverImage: _playlistImg(7), songs: songs.sublist(6, 15), createdBy: 'Melodify', createdAt: DateTime(2024, 1, 15), followers: 15000000),
    Playlist(id: 'p8', name: 'Acoustic Covers', description: 'Beautiful acoustic versions', coverImage: _playlistImg(8), songs: songs.sublist(7, 13), createdBy: 'Melodify', createdAt: DateTime(2023, 12, 1), followers: 4500000),
  ];

  // 分类数据
  static final List<MusicCategory> categories = [
    MusicCategory(id: 'c1', name: 'Pop', imageUrl: _categoryImg(1), color: Colors.pink),
    MusicCategory(id: 'c2', name: 'Hip-Hop', imageUrl: _categoryImg(2), color: Colors.orange),
    MusicCategory(id: 'c3', name: 'Rock', imageUrl: _categoryImg(3), color: Colors.red),
    MusicCategory(id: 'c4', name: 'Electronic', imageUrl: _categoryImg(4), color: Colors.purple),
    MusicCategory(id: 'c5', name: 'R&B', imageUrl: _categoryImg(5), color: Colors.indigo),
    MusicCategory(id: 'c6', name: 'Jazz', imageUrl: _categoryImg(6), color: Colors.brown),
    MusicCategory(id: 'c7', name: 'Classical', imageUrl: _categoryImg(7), color: Colors.blueGrey),
    MusicCategory(id: 'c8', name: 'Country', imageUrl: _categoryImg(8), color: Colors.amber),
    MusicCategory(id: 'c9', name: 'Latin', imageUrl: _categoryImg(9), color: Colors.deepOrange),
    MusicCategory(id: 'c10', name: 'K-Pop', imageUrl: _categoryImg(10), color: Colors.teal),
    MusicCategory(id: 'c11', name: 'Indie', imageUrl: _categoryImg(11), color: Colors.green),
    MusicCategory(id: 'c12', name: 'Metal', imageUrl: _categoryImg(12), color: Colors.grey),
  ];

  // 用户播放列表
  static final List<Playlist> userPlaylists = [
    Playlist(id: 'up1', name: 'My Favorites', description: 'Songs I love', coverImage: _playlistImg(21), songs: songs.where((s) => s.isLiked).toList(), createdBy: 'You', createdAt: DateTime(2024, 1, 1), isPublic: false),
    Playlist(id: 'up2', name: 'Gym Playlist', description: 'High energy workout music', coverImage: _playlistImg(22), songs: songs.sublist(6, 12), createdBy: 'You', createdAt: DateTime(2024, 3, 15), isPublic: false),
    Playlist(id: 'up3', name: 'Driving Mix', description: 'Perfect for long drives', coverImage: _playlistImg(23), songs: songs.sublist(0, 8), createdBy: 'You', createdAt: DateTime(2024, 2, 20), isPublic: true),
  ];

  // 最近播放
  static List<Song> get recentlyPlayed => songs.sublist(0, 8);

  // 热门歌曲排行
  static List<Song> get topCharts {
    final sorted = List<Song>.from(songs);
    sorted.sort((a, b) => b.playCount.compareTo(a.playCount));
    return sorted.take(10).toList();
  }

  // 新发布
  static List<Album> get newReleases => albums.where((a) => a.year == 2024).toList();

  // 推荐艺人
  static List<Artist> get recommendedArtists => artists.where((a) => a.isVerified).toList();

  // 格式化播放次数
  static String formatPlayCount(int count) {
    if (count >= 1000000000) {
      return '${(count / 1000000000).toStringAsFixed(1)}B';
    } else if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}
