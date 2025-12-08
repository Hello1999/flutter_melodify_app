import 'package:flutter/material.dart';
import '../../core/responsive/responsive.dart';
import '../../models/album.dart';
import '../../services/mock_data.dart';
import '../../widgets/common/common.dart';
import '../../widgets/cards/cards.dart';
import '../playlist/playlist_detail_page.dart';

enum LibraryFilter { playlists, artists, albums }

enum LibrarySortBy { recent, alphabetical, creator }

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  LibraryFilter _filter = LibraryFilter.playlists;
  LibrarySortBy _sortBy = LibrarySortBy.recent;
  bool _isGridView = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = ResponsiveBuilder.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            pinned: true,
            expandedHeight: 140,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.fromLTRB(
                  screenSize.horizontalPadding,
                  0,
                  screenSize.horizontalPadding,
                  8,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: colorScheme.primaryContainer,
                          child: Text(
                            'U',
                            style: TextStyle(
                              color: colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Your Library',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => _showCreatePlaylistDialog(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Filter chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _FilterChip(
                            label: 'Playlists',
                            selected: _filter == LibraryFilter.playlists,
                            onSelected: () => setState(() => _filter = LibraryFilter.playlists),
                          ),
                          const SizedBox(width: 8),
                          _FilterChip(
                            label: 'Artists',
                            selected: _filter == LibraryFilter.artists,
                            onSelected: () => setState(() => _filter = LibraryFilter.artists),
                          ),
                          const SizedBox(width: 8),
                          _FilterChip(
                            label: 'Albums',
                            selected: _filter == LibraryFilter.albums,
                            onSelected: () => setState(() => _filter = LibraryFilter.albums),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Sort & View Toggle
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.horizontalPadding,
                vertical: 8,
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => _showSortOptions(context),
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.swap_vert, size: 20),
                          const SizedBox(width: 4),
                          Text(_getSortLabel()),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
                    onPressed: () => setState(() => _isGridView = !_isGridView),
                  ),
                ],
              ),
            ),
          ),

          // Content
          ..._buildContent(screenSize),

          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 80),
          ),
        ],
      ),
    );
  }

  String _getSortLabel() {
    switch (_sortBy) {
      case LibrarySortBy.recent:
        return 'Recents';
      case LibrarySortBy.alphabetical:
        return 'A-Z';
      case LibrarySortBy.creator:
        return 'Creator';
    }
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Sort by',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _SortOption(
              label: 'Recents',
              selected: _sortBy == LibrarySortBy.recent,
              onTap: () {
                setState(() => _sortBy = LibrarySortBy.recent);
                Navigator.pop(context);
              },
            ),
            _SortOption(
              label: 'Alphabetical',
              selected: _sortBy == LibrarySortBy.alphabetical,
              onTap: () {
                setState(() => _sortBy = LibrarySortBy.alphabetical);
                Navigator.pop(context);
              },
            ),
            _SortOption(
              label: 'Creator',
              selected: _sortBy == LibrarySortBy.creator,
              onTap: () {
                setState(() => _sortBy = LibrarySortBy.creator);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showCreatePlaylistDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Playlist'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Playlist name',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Created "${controller.text}"')),
              );
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildContent(ScreenSize screenSize) {
    switch (_filter) {
      case LibraryFilter.playlists:
        return _buildPlaylists(screenSize);
      case LibraryFilter.artists:
        return _buildArtists(screenSize);
      case LibraryFilter.albums:
        return _buildAlbums(screenSize);
    }
  }

  List<Widget> _buildPlaylists(ScreenSize screenSize) {
    final playlists = [...MockData.userPlaylists, ...MockData.playlists.take(4)];

    // Liked Songs item
    final likedSongs = [
      SliverToBoxAdapter(
        child: _LikedSongsItem(
          onTap: () {},
        ),
      ),
    ];

    if (_isGridView) {
      return [
        ...likedSongs,
        SliverPadding(
          padding: EdgeInsets.all(screenSize.horizontalPadding),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: screenSize.gridColumns,
              childAspectRatio: 0.8,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => PlaylistCard(
                playlist: playlists[index],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlaylistDetailPage(playlist: playlists[index]),
                  ),
                ),
              ),
              childCount: playlists.length,
            ),
          ),
        ),
      ];
    }

    return [
      ...likedSongs,
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => PlaylistTile(
            playlist: playlists[index],
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlaylistDetailPage(playlist: playlists[index]),
              ),
            ),
          ),
          childCount: playlists.length,
        ),
      ),
    ];
  }

  List<Widget> _buildArtists(ScreenSize screenSize) {
    final artists = MockData.artists;

    if (_isGridView) {
      return [
        SliverPadding(
          padding: EdgeInsets.all(screenSize.horizontalPadding),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: screenSize.gridColumns,
              childAspectRatio: 0.85,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => ArtistCard(
                artist: artists[index],
                onTap: () {},
              ),
              childCount: artists.length,
            ),
          ),
        ),
      ];
    }

    return [
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => ArtistTile(
            artist: artists[index],
            onTap: () {},
          ),
          childCount: artists.length,
        ),
      ),
    ];
  }

  List<Widget> _buildAlbums(ScreenSize screenSize) {
    final albums = MockData.albums;

    if (_isGridView) {
      return [
        SliverPadding(
          padding: EdgeInsets.all(screenSize.horizontalPadding),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: screenSize.gridColumns,
              childAspectRatio: 0.8,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => AlbumCard(
                album: albums[index],
                onTap: () {},
              ),
              childCount: albums.length,
            ),
          ),
        ),
      ];
    }

    return [
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final album = albums[index];
            return ListTile(
              leading: AppCachedImage(
                imageUrl: album.coverImage,
                width: 56,
                height: 56,
                borderRadius: BorderRadius.circular(4),
              ),
              title: Text(album.title, maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text(
                '${album.artist} · ${album.type.label}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            );
          },
          childCount: albums.length,
        ),
      ),
    ];
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      backgroundColor: colorScheme.surface,
      selectedColor: colorScheme.secondaryContainer,
      checkmarkColor: colorScheme.onSecondaryContainer,
      side: BorderSide(
        color: selected ? Colors.transparent : colorScheme.outline,
      ),
    );
  }
}

class _SortOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SortOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      title: Text(
        label,
        style: TextStyle(
          color: selected ? colorScheme.primary : null,
          fontWeight: selected ? FontWeight.w600 : null,
        ),
      ),
      trailing: selected ? Icon(Icons.check, color: colorScheme.primary) : null,
      onTap: onTap,
    );
  }
}

class _LikedSongsItem extends StatelessWidget {
  final VoidCallback? onTap;

  const _LikedSongsItem({this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final likedCount = MockData.songs.where((s) => s.isLiked).length;

    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colorScheme.primary, colorScheme.tertiary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          Icons.favorite,
          color: colorScheme.onPrimary,
        ),
      ),
      title: const Text('Liked Songs'),
      subtitle: Text(
        '$likedCount songs',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
