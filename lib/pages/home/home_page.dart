import 'package:flutter/material.dart';
import '../../core/responsive/responsive.dart';
import '../../services/mock_data.dart';
import '../../widgets/common/common.dart';
import '../../widgets/cards/cards.dart';
import '../playlist/playlist_detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = ResponsiveBuilder.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            title: Row(
              children: [
                Icon(
                  Icons.music_note_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                const Text('Melodify'),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.history),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () {},
              ),
            ],
          ),

          // 问候语
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(screenSize.horizontalPadding),
              child: Text(
                _getGreeting(),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // 快捷播放网格
          SliverToBoxAdapter(
            child: _buildQuickPlayGrid(context, screenSize),
          ),

          // 为你推荐
          SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Made For You',
              subtitle: 'Personalized playlists',
              onSeeAll: () {},
            ),
          ),
          SliverToBoxAdapter(
            child: _buildPlaylistSection(context, screenSize),
          ),

          // 热门排行
          SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Top Charts',
              subtitle: 'Most played this week',
              onSeeAll: () {},
            ),
          ),
          SliverToBoxAdapter(
            child: _buildTopCharts(context),
          ),

          // 新发布
          SliverToBoxAdapter(
            child: SectionHeader(
              title: 'New Releases',
              subtitle: 'Fresh music for you',
              onSeeAll: () {},
            ),
          ),
          SliverToBoxAdapter(
            child: _buildAlbumSection(context, screenSize),
          ),

          // 推荐艺人
          SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Popular Artists',
              onSeeAll: () {},
            ),
          ),
          SliverToBoxAdapter(
            child: _buildArtistSection(context, screenSize),
          ),

          // 浏览类别
          SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Browse Categories',
              onSeeAll: () {},
            ),
          ),
          SliverToBoxAdapter(
            child: _buildCategorySection(context, screenSize),
          ),

          // 底部间距（为 mini player 留空间）
          const SliverToBoxAdapter(
            child: SizedBox(height: 80),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
  }

  Widget _buildQuickPlayGrid(BuildContext context, ScreenSize screenSize) {
    final playlists = MockData.playlists.take(6).toList();
    final columns = screenSize.isMobile ? 2 : (screenSize.isTablet ? 3 : 4);
    final itemsToShow = screenSize.isMobile ? 6 : playlists.length;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenSize.horizontalPadding),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          childAspectRatio: 3.5,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: itemsToShow,
        itemBuilder: (context, index) {
          final playlist = playlists[index];
          return _QuickPlayItem(
            playlist: playlist,
            onTap: () => _navigateToPlaylist(context, playlist),
          );
        },
      ),
    );
  }

  Widget _buildPlaylistSection(BuildContext context, ScreenSize screenSize) {
    final playlists = MockData.playlists;
    final cardWidth = context.responsive<double>(
      mobile: 150,
      tablet: 170,
      desktop: 180,
    );

    return SizedBox(
      height: cardWidth + 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: screenSize.horizontalPadding),
        itemCount: playlists.length,
        itemBuilder: (context, index) {
          final playlist = playlists[index];
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: PlaylistCard(
              playlist: playlist,
              width: cardWidth,
              onTap: () => _navigateToPlaylist(context, playlist),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopCharts(BuildContext context) {
    final songs = MockData.topCharts.take(5).toList();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: songs.length,
      itemBuilder: (context, index) {
        return SongTile(
          song: songs[index],
          playlist: songs,
          index: index,
          showIndex: true,
        );
      },
    );
  }

  Widget _buildAlbumSection(BuildContext context, ScreenSize screenSize) {
    final albums = MockData.newReleases;
    final cardWidth = context.responsive<double>(
      mobile: 150,
      tablet: 170,
      desktop: 180,
    );

    return SizedBox(
      height: cardWidth + 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: screenSize.horizontalPadding),
        itemCount: albums.length,
        itemBuilder: (context, index) {
          final album = albums[index];
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: AlbumCard(
              album: album,
              width: cardWidth,
              onTap: () {},
            ),
          );
        },
      ),
    );
  }

  Widget _buildArtistSection(BuildContext context, ScreenSize screenSize) {
    final artists = MockData.recommendedArtists;
    final cardSize = context.responsive<double>(
      mobile: 120,
      tablet: 140,
      desktop: 150,
    );

    return SizedBox(
      height: cardSize + 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: screenSize.horizontalPadding),
        itemCount: artists.length,
        itemBuilder: (context, index) {
          final artist = artists[index];
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ArtistCard(
              artist: artist,
              size: cardSize,
              onTap: () {},
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context, ScreenSize screenSize) {
    final categories = MockData.categories;
    final columns = screenSize.gridColumns;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenSize.horizontalPadding),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          childAspectRatio: 1.8,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return CategoryCard(
            category: category,
            onTap: () {},
          );
        },
      ),
    );
  }

  void _navigateToPlaylist(BuildContext context, playlist) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlaylistDetailPage(playlist: playlist),
      ),
    );
  }
}

class _QuickPlayItem extends StatelessWidget {
  final dynamic playlist;
  final VoidCallback? onTap;

  const _QuickPlayItem({
    required this.playlist,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(4),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            AppCachedImage(
              imageUrl: playlist.coverImage,
              width: 56,
              height: 56,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                playlist.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
