import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/responsive/responsive.dart';
import '../../models/playlist.dart';
import '../../providers/player_provider.dart';
import '../../widgets/common/cached_image.dart';
import '../../widgets/cards/song_tile.dart';
import '../../services/mock_data.dart';

class PlaylistDetailPage extends StatefulWidget {
  final Playlist playlist;

  const PlaylistDetailPage({
    super.key,
    required this.playlist,
  });

  @override
  State<PlaylistDetailPage> createState() => _PlaylistDetailPageState();
}

class _PlaylistDetailPageState extends State<PlaylistDetailPage> {
  bool _isLiked = false;
  bool _isDownloaded = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = ResponsiveBuilder.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final playerProvider = context.read<PlayerProvider>();

    if (screenSize.isDesktop) {
      return _buildDesktopLayout(context, screenSize);
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header with gradient
          SliverAppBar(
            expandedHeight: 360,
            pinned: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Background blur
                  AppCachedImage(
                    imageUrl: widget.playlist.coverImage,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          colorScheme.surface.withValues(alpha: 0.8),
                          colorScheme.surface,
                        ],
                      ),
                    ),
                  ),
                  // Content
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: AppCachedImage(
                            imageUrl: widget.playlist.coverImage,
                            width: 160,
                            height: 160,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.playlist.name,
                          style: textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.playlist.description,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: colorScheme.primaryContainer,
                              child: Text(
                                widget.playlist.createdBy[0],
                                style: textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                widget.playlist.createdBy,
                                style: textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '· ${MockData.formatPlayCount(widget.playlist.followers)} likes',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Action Buttons
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _isLiked ? Icons.favorite : Icons.favorite_border,
                      color: _isLiked ? colorScheme.primary : null,
                    ),
                    onPressed: () => setState(() => _isLiked = !_isLiked),
                  ),
                  IconButton(
                    icon: Icon(
                      _isDownloaded
                          ? Icons.download_done
                          : Icons.download_outlined,
                      color: _isDownloaded ? colorScheme.primary : null,
                    ),
                    onPressed: () {
                      setState(() => _isDownloaded = !_isDownloaded);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            _isDownloaded
                                ? 'Downloaded playlist'
                                : 'Removed download',
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () => _showPlaylistOptions(context),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.shuffle),
                    onPressed: () {
                      playerProvider.toggleShuffle();
                      playerProvider.play(
                        widget.playlist.songs.first,
                        playlist: widget.playlist.songs,
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  FloatingActionButton(
                    heroTag: 'play_fab',
                    onPressed: () {
                      playerProvider.play(
                        widget.playlist.songs.first,
                        playlist: widget.playlist.songs,
                      );
                    },
                    child: const Icon(Icons.play_arrow),
                  ),
                ],
              ),
            ),
          ),

          // Song count and duration
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '${widget.playlist.songCount} songs · ${widget.playlist.totalDurationString}',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),

          // Songs
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final song = widget.playlist.songs[index];
                return SongTile(
                  song: song,
                  playlist: widget.playlist.songs,
                  index: index,
                  showIndex: true,
                );
              },
              childCount: widget.playlist.songs.length,
            ),
          ),

          // Recommended section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    'Recommended',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Based on this playlist',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final song = MockData.songs[index + 5];
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
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Added "${song.title}" to playlist')),
                      );
                    },
                  ),
                  onTap: () => playerProvider.play(song),
                );
              },
              childCount: 5,
            ),
          ),

          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, ScreenSize screenSize) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final playerProvider = context.read<PlayerProvider>();

    return Scaffold(
      body: Row(
        children: [
          // Left side - Playlist info
          SizedBox(
            width: 350,
            child: Container(
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
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: AppCachedImage(
                          imageUrl: widget.playlist.coverImage,
                          width: 240,
                          height: 240,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        widget.playlist.name,
                        style: textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.playlist.description,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${widget.playlist.songCount} songs · ${widget.playlist.totalDurationString}',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          FilledButton.icon(
                            onPressed: () {
                              playerProvider.play(
                                widget.playlist.songs.first,
                                playlist: widget.playlist.songs,
                              );
                            },
                            icon: const Icon(Icons.play_arrow),
                            label: const Text('Play'),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton.icon(
                            onPressed: () {
                              playerProvider.toggleShuffle();
                              playerProvider.play(
                                widget.playlist.songs.first,
                                playlist: widget.playlist.songs,
                              );
                            },
                            icon: const Icon(Icons.shuffle),
                            label: const Text('Shuffle'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              _isLiked ? Icons.favorite : Icons.favorite_border,
                              color: _isLiked ? colorScheme.primary : null,
                            ),
                            onPressed: () => setState(() => _isLiked = !_isLiked),
                          ),
                          IconButton(
                            icon: const Icon(Icons.download_outlined),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.share),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.more_horiz),
                            onPressed: () => _showPlaylistOptions(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Right side - Song list
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  pinned: true,
                  title: Text(widget.playlist.name),
                ),
                // Header row
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        const SizedBox(width: 48),
                        const Expanded(flex: 4, child: Text('TITLE')),
                        const Expanded(flex: 3, child: Text('ALBUM')),
                        const Expanded(flex: 2, child: Text('DATE ADDED')),
                        const SizedBox(width: 80, child: Icon(Icons.access_time, size: 16)),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: Divider()),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final song = widget.playlist.songs[index];
                      return _DesktopSongRow(
                        song: song,
                        index: index,
                        playlist: widget.playlist.songs,
                      );
                    },
                    childCount: widget.playlist.songs.length,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPlaylistOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: AppCachedImage(
                imageUrl: widget.playlist.coverImage,
                width: 48,
                height: 48,
                borderRadius: BorderRadius.circular(4),
              ),
              title: Text(widget.playlist.name),
              subtitle: Text('by ${widget.playlist.createdBy}'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.playlist_add),
              title: const Text('Add to queue'),
              onTap: () {
                for (final song in widget.playlist.songs) {
                  context.read<PlayerProvider>().addToQueue(song);
                }
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Added to queue')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.radio),
              title: const Text('Start radio'),
              onTap: () => Navigator.pop(context),
            ),
            if (widget.playlist.createdBy == 'You')
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit playlist'),
                onTap: () => Navigator.pop(context),
              ),
            if (widget.playlist.createdBy == 'You')
              ListTile(
                leading: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
                title: Text(
                  'Delete playlist',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                onTap: () => Navigator.pop(context),
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _DesktopSongRow extends StatefulWidget {
  final dynamic song;
  final int index;
  final List<dynamic> playlist;

  const _DesktopSongRow({
    required this.song,
    required this.index,
    required this.playlist,
  });

  @override
  State<_DesktopSongRow> createState() => _DesktopSongRowState();
}

class _DesktopSongRowState extends State<_DesktopSongRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final playerProvider = context.watch<PlayerProvider>();
    final isPlaying = playerProvider.currentSong?.id == widget.song.id;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        color: _isHovered ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.5) : null,
        child: ListTile(
          onTap: () => playerProvider.play(widget.song, playlist: widget.playlist.cast()),
          leading: SizedBox(
            width: 32,
            child: _isHovered
                ? Icon(
                    isPlaying && playerProvider.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: colorScheme.primary,
                  )
                : Text(
                    '${widget.index + 1}',
                    style: textTheme.bodyMedium?.copyWith(
                      color: isPlaying ? colorScheme.primary : colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
          ),
          title: Row(
            children: [
              AppCachedImage(
                imageUrl: widget.song.albumArt,
                width: 40,
                height: 40,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.song.title,
                      style: textTheme.bodyMedium?.copyWith(
                        color: isPlaying ? colorScheme.primary : null,
                        fontWeight: isPlaying ? FontWeight.w600 : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      widget.song.artist,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  widget.song.album,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  '3 days ago',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              SizedBox(
                width: 80,
                child: Row(
                  children: [
                    if (_isHovered)
                      IconButton(
                        icon: Icon(
                          widget.song.isLiked ? Icons.favorite : Icons.favorite_border,
                          size: 20,
                          color: widget.song.isLiked ? colorScheme.primary : null,
                        ),
                        onPressed: () {},
                      )
                    else
                      const SizedBox(width: 40),
                    Text(
                      widget.song.durationString,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
