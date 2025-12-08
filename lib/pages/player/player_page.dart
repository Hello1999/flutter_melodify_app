import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import '../../core/responsive/responsive.dart';
import '../../providers/player_provider.dart';
import '../../widgets/common/cached_image.dart';

class PlayerPage extends StatelessWidget {
  const PlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = ResponsiveBuilder.of(context);

    if (screenSize.isDesktop) {
      return _DesktopPlayerPage();
    }
    return _MobilePlayerPage();
  }
}

class _MobilePlayerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final playerProvider = context.watch<PlayerProvider>();
    final song = playerProvider.currentSong;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (song == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text('No song playing'),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primaryContainer.withValues(alpha: 0.5),
              colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_down),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'PLAYING FROM PLAYLIST',
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              letterSpacing: 1.2,
                            ),
                          ),
                          Text(
                            song.album,
                            style: textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () => _showSongOptions(context),
                    ),
                  ],
                ),
              ),

              // Album Art
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Hero(
                    tag: 'player_art_${song.id}',
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: AppCachedImage(
                        imageUrl: song.albumArt,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),

              // Song Info & Controls
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // Song Info
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                song.title,
                                style: textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                song.artist,
                                style: textTheme.bodyLarge?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            song.isLiked ? Icons.favorite : Icons.favorite_border,
                            color: song.isLiked ? colorScheme.primary : null,
                          ),
                          onPressed: playerProvider.toggleLike,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Progress Bar
                    ProgressBar(
                      progress: playerProvider.position,
                      buffered: playerProvider.bufferedPosition,
                      total: song.duration,
                      onSeek: playerProvider.seekTo,
                      barHeight: 4,
                      thumbRadius: 6,
                      thumbGlowRadius: 16,
                      baseBarColor: colorScheme.surfaceContainerHighest,
                      progressBarColor: colorScheme.primary,
                      bufferedBarColor: colorScheme.primary.withValues(alpha: 0.3),
                      thumbColor: colorScheme.primary,
                      thumbGlowColor: colorScheme.primary.withValues(alpha: 0.3),
                      timeLabelTextStyle: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Main Controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.shuffle,
                            color: playerProvider.shuffle
                                ? colorScheme.primary
                                : colorScheme.onSurfaceVariant,
                          ),
                          onPressed: playerProvider.toggleShuffle,
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_previous_rounded),
                          iconSize: 40,
                          onPressed: playerProvider.hasPrevious
                              ? playerProvider.previous
                              : null,
                        ),
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              playerProvider.isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              color: colorScheme.onPrimary,
                            ),
                            iconSize: 40,
                            onPressed: playerProvider.togglePlayPause,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_next_rounded),
                          iconSize: 40,
                          onPressed: playerProvider.hasNext
                              ? playerProvider.next
                              : null,
                        ),
                        IconButton(
                          icon: Icon(
                            _getRepeatIcon(playerProvider.repeatMode),
                            color: playerProvider.repeatMode != RepeatMode.off
                                ? colorScheme.primary
                                : colorScheme.onSurfaceVariant,
                          ),
                          onPressed: playerProvider.toggleRepeatMode,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Bottom Actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.devices),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.playlist_play),
                          onPressed: () => _showQueue(context),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getRepeatIcon(RepeatMode mode) {
    switch (mode) {
      case RepeatMode.off:
        return Icons.repeat;
      case RepeatMode.all:
        return Icons.repeat;
      case RepeatMode.one:
        return Icons.repeat_one;
    }
  }

  void _showSongOptions(BuildContext context) {
    final playerProvider = context.read<PlayerProvider>();
    final song = playerProvider.currentSong;
    if (song == null) return;

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: AppCachedImage(
                imageUrl: song.albumArt,
                width: 48,
                height: 48,
                borderRadius: BorderRadius.circular(4),
              ),
              title: Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text(song.artist),
            ),
            const Divider(),
            ListTile(
              leading: Icon(song.isLiked ? Icons.favorite : Icons.favorite_border),
              title: Text(song.isLiked ? 'Remove from Liked Songs' : 'Add to Liked Songs'),
              onTap: () {
                playerProvider.toggleLike();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.playlist_add),
              title: const Text('Add to playlist'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.album),
              title: const Text('View album'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('View artist'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showQueue(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => _QueueSheet(
          scrollController: scrollController,
        ),
      ),
    );
  }
}

class _DesktopPlayerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final playerProvider = context.watch<PlayerProvider>();
    final song = playerProvider.currentSong;
    final colorScheme = Theme.of(context).colorScheme;

    if (song == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Now Playing')),
        body: const Center(child: Text('No song playing')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing'),
      ),
      body: Row(
        children: [
          // Album Art Side
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.primaryContainer.withValues(alpha: 0.3),
                    colorScheme.surface,
                  ],
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(48),
                  child: AppCachedImage(
                    imageUrl: song.albumArt,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),
          // Controls Side
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Song Info
                  Text(
                    song.title,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    song.artist,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    song.album,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),

                  const Spacer(),

                  // Progress & Controls (similar to mobile)
                  ProgressBar(
                    progress: playerProvider.position,
                    buffered: playerProvider.bufferedPosition,
                    total: song.duration,
                    onSeek: playerProvider.seekTo,
                    barHeight: 6,
                    thumbRadius: 8,
                    baseBarColor: colorScheme.surfaceContainerHighest,
                    progressBarColor: colorScheme.primary,
                    bufferedBarColor: colorScheme.primary.withValues(alpha: 0.3),
                    thumbColor: colorScheme.primary,
                  ),

                  const SizedBox(height: 32),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.shuffle,
                          color: playerProvider.shuffle
                              ? colorScheme.primary
                              : null,
                        ),
                        iconSize: 28,
                        onPressed: playerProvider.toggleShuffle,
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.skip_previous_rounded),
                        iconSize: 48,
                        onPressed: playerProvider.previous,
                      ),
                      const SizedBox(width: 16),
                      FloatingActionButton.large(
                        onPressed: playerProvider.togglePlayPause,
                        child: Icon(
                          playerProvider.isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          size: 48,
                        ),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.skip_next_rounded),
                        iconSize: 48,
                        onPressed: playerProvider.next,
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: Icon(
                          playerProvider.repeatMode == RepeatMode.one
                              ? Icons.repeat_one
                              : Icons.repeat,
                          color: playerProvider.repeatMode != RepeatMode.off
                              ? colorScheme.primary
                              : null,
                        ),
                        iconSize: 28,
                        onPressed: playerProvider.toggleRepeatMode,
                      ),
                    ],
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QueueSheet extends StatelessWidget {
  final ScrollController scrollController;

  const _QueueSheet({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final playerProvider = context.watch<PlayerProvider>();
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 32,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  'Queue',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: playerProvider.clearQueue,
                  child: const Text('Clear'),
                ),
              ],
            ),
          ),

          // Now Playing
          if (playerProvider.currentSong != null)
            Container(
              color: colorScheme.primaryContainer.withValues(alpha: 0.3),
              child: ListTile(
                leading: AppCachedImage(
                  imageUrl: playerProvider.currentSong!.albumArt,
                  width: 48,
                  height: 48,
                  borderRadius: BorderRadius.circular(4),
                ),
                title: Text(
                  playerProvider.currentSong!.title,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(playerProvider.currentSong!.artist),
                trailing: Icon(
                  playerProvider.isPlaying ? Icons.equalizer : Icons.pause,
                  color: colorScheme.primary,
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Next in queue',
                style: textTheme.titleSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),

          // Queue List
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: playerProvider.queue.length,
              itemBuilder: (context, index) {
                if (index == playerProvider.currentIndex) {
                  return const SizedBox.shrink();
                }

                final song = playerProvider.queue[index];
                return ListTile(
                  leading: AppCachedImage(
                    imageUrl: song.albumArt,
                    width: 48,
                    height: 48,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  title: Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text(song.artist),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => playerProvider.removeFromQueue(index),
                  ),
                  onTap: () => playerProvider.playFromQueue(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
