class Artist {
  final String id;
  final String name;
  final String imageUrl;
  final String bio;
  final int followers;
  final int monthlyListeners;
  final List<String> genres;
  final bool isVerified;

  const Artist({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.bio = '',
    this.followers = 0,
    this.monthlyListeners = 0,
    this.genres = const [],
    this.isVerified = false,
  });

  String get followersString {
    if (followers >= 1000000) {
      return '${(followers / 1000000).toStringAsFixed(1)}M';
    } else if (followers >= 1000) {
      return '${(followers / 1000).toStringAsFixed(1)}K';
    }
    return followers.toString();
  }

  String get monthlyListenersString {
    if (monthlyListeners >= 1000000) {
      return '${(monthlyListeners / 1000000).toStringAsFixed(1)}M monthly listeners';
    } else if (monthlyListeners >= 1000) {
      return '${(monthlyListeners / 1000).toStringAsFixed(0)}K monthly listeners';
    }
    return '$monthlyListeners monthly listeners';
  }
}
