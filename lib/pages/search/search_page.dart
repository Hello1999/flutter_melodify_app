import 'package:flutter/material.dart';
import '../../core/responsive/responsive.dart';
import '../../models/models.dart';
import '../../services/mock_data.dart';
import '../../widgets/common/common.dart';
import '../../widgets/cards/cards.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  String _searchQuery = '';
  bool _isSearching = false;

  List<Song> _songResults = [];
  List<Artist> _artistResults = [];
  List<Playlist> _playlistResults = [];
  List<Album> _albumResults = [];

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    setState(() {
      _searchQuery = query;
      _isSearching = query.isNotEmpty;

      if (_isSearching) {
        final lowerQuery = query.toLowerCase();

        _songResults = MockData.songs
            .where((s) =>
                s.title.toLowerCase().contains(lowerQuery) ||
                s.artist.toLowerCase().contains(lowerQuery))
            .toList();

        _artistResults = MockData.artists
            .where((a) => a.name.toLowerCase().contains(lowerQuery))
            .toList();

        _playlistResults = MockData.playlists
            .where((p) =>
                p.name.toLowerCase().contains(lowerQuery) ||
                p.description.toLowerCase().contains(lowerQuery))
            .toList();

        _albumResults = MockData.albums
            .where((a) =>
                a.title.toLowerCase().contains(lowerQuery) ||
                a.artist.toLowerCase().contains(lowerQuery))
            .toList();
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _isSearching = false;
    });
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = ResponsiveBuilder.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Search
          SliverAppBar(
            floating: true,
            pinned: true,
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                alignment: Alignment.bottomCenter,
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
                    Text(
                      'Search',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SearchBar(
                      controller: _searchController,
                      focusNode: _focusNode,
                      hintText: 'Songs, artists, or playlists',
                      leading: const Icon(Icons.search),
                      trailing: [
                        if (_searchQuery.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: _clearSearch,
                          ),
                      ],
                      onChanged: _performSearch,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content
          if (_isSearching)
            ..._buildSearchResults(screenSize)
          else
            ..._buildBrowseContent(screenSize),

          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 80),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSearchResults(ScreenSize screenSize) {
    final hasResults = _songResults.isNotEmpty ||
        _artistResults.isNotEmpty ||
        _playlistResults.isNotEmpty ||
        _albumResults.isNotEmpty;

    if (!hasResults) {
      return [
        SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  'No results found for "$_searchQuery"',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Try searching with different keywords',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ];
    }

    return [
      // Songs
      if (_songResults.isNotEmpty) ...[
        SliverToBoxAdapter(
          child: SectionHeader(
            title: 'Songs',
            subtitle: '${_songResults.length} results',
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => SongTile(
              song: _songResults[index],
              playlist: _songResults,
            ),
            childCount: _songResults.take(5).length,
          ),
        ),
        if (_songResults.length > 5)
          SliverToBoxAdapter(
            child: Center(
              child: TextButton(
                onPressed: () {},
                child: Text('Show all ${_songResults.length} songs'),
              ),
            ),
          ),
      ],

      // Artists
      if (_artistResults.isNotEmpty) ...[
        SliverToBoxAdapter(
          child: SectionHeader(
            title: 'Artists',
            subtitle: '${_artistResults.length} results',
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => ArtistTile(
              artist: _artistResults[index],
              onTap: () {},
            ),
            childCount: _artistResults.take(3).length,
          ),
        ),
      ],

      // Albums
      if (_albumResults.isNotEmpty) ...[
        SliverToBoxAdapter(
          child: SectionHeader(
            title: 'Albums',
            subtitle: '${_albumResults.length} results',
          ),
        ),
        SliverToBoxAdapter(
          child: _buildHorizontalAlbums(screenSize),
        ),
      ],

      // Playlists
      if (_playlistResults.isNotEmpty) ...[
        SliverToBoxAdapter(
          child: SectionHeader(
            title: 'Playlists',
            subtitle: '${_playlistResults.length} results',
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => PlaylistTile(
              playlist: _playlistResults[index],
              onTap: () {},
            ),
            childCount: _playlistResults.take(3).length,
          ),
        ),
      ],
    ];
  }

  Widget _buildHorizontalAlbums(ScreenSize screenSize) {
    final cardWidth = 140.0;

    return SizedBox(
      height: cardWidth + 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: screenSize.horizontalPadding),
        itemCount: _albumResults.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: AlbumCard(
              album: _albumResults[index],
              width: cardWidth,
              onTap: () {},
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildBrowseContent(ScreenSize screenSize) {
    final categories = MockData.categories;
    final columns = screenSize.gridColumns;

    return [
      SliverToBoxAdapter(
        child: SectionHeader(
          title: 'Browse All',
          subtitle: 'Explore by category',
        ),
      ),
      SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: screenSize.horizontalPadding),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            childAspectRatio: 1.8,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) => CategoryCard(
              category: categories[index],
              onTap: () {},
            ),
            childCount: categories.length,
          ),
        ),
      ),

      // Recent Searches
      SliverToBoxAdapter(
        child: SectionHeader(
          title: 'Recent Searches',
          trailing: TextButton(
            onPressed: () {},
            child: const Text('Clear'),
          ),
        ),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final items = [
              ('Luna Eclipse', Icons.person),
              ('Chill Vibes', Icons.playlist_play),
              ('Electronic', Icons.category),
              ('Summer Breeze', Icons.music_note),
            ];
            return ListTile(
              leading: Icon(items[index].$2),
              title: Text(items[index].$1),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {},
              ),
              onTap: () => _performSearch(items[index].$1),
            );
          },
          childCount: 4,
        ),
      ),
    ];
  }
}
