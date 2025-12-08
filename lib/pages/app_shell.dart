import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/responsive/responsive.dart';
import '../providers/player_provider.dart';
import '../widgets/player/mini_player.dart';
import 'home/home_page.dart';
import 'search/search_page.dart';
import 'library/library_page.dart';
import 'profile/profile_page.dart';
import 'player/player_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    SearchPage(),
    LibraryPage(),
    ProfilePage(),
  ];

  final List<NavigationDestination> _destinations = const [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(Icons.search_outlined),
      selectedIcon: Icon(Icons.search),
      label: 'Search',
    ),
    NavigationDestination(
      icon: Icon(Icons.library_music_outlined),
      selectedIcon: Icon(Icons.library_music),
      label: 'Library',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outlined),
      selectedIcon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final playerProvider = context.watch<PlayerProvider>();
    final screenSize = ResponsiveBuilder.of(context);

    return Scaffold(
      body: _buildBody(screenSize),
      bottomNavigationBar: screenSize.isMobile
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Mini Player
                if (playerProvider.currentSong != null)
                  MiniPlayer(
                    onTap: () => _openPlayer(context),
                  ),
                // Navigation Bar
                NavigationBar(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (index) {
                    setState(() => _currentIndex = index);
                  },
                  destinations: _destinations,
                ),
              ],
            )
          : null,
    );
  }

  Widget _buildBody(ScreenSize screenSize) {
    final playerProvider = context.watch<PlayerProvider>();

    if (screenSize.isMobile) {
      return _pages[_currentIndex];
    }

    // Tablet/Desktop layout with side navigation
    return Row(
      children: [
        // Navigation Rail
        NavigationRail(
          extended: screenSize.width > Breakpoints.tablet,
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() => _currentIndex = index);
          },
          labelType: screenSize.width > Breakpoints.tablet
              ? NavigationRailLabelType.none
              : NavigationRailLabelType.selected,
          leading: _buildNavRailHeader(screenSize),
          trailing: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (playerProvider.currentSong != null)
                  _DesktopMiniPlayer(onTap: () => _openPlayer(context)),
                const SizedBox(height: 16),
              ],
            ),
          ),
          destinations: _destinations
              .map((d) => NavigationRailDestination(
                    icon: d.icon,
                    selectedIcon: d.selectedIcon,
                    label: Text(d.label),
                  ))
              .toList(),
        ),
        const VerticalDivider(width: 1, thickness: 1),
        // Main content
        Expanded(child: _pages[_currentIndex]),
      ],
    );
  }

  Widget _buildNavRailHeader(ScreenSize screenSize) {
    final colorScheme = Theme.of(context).colorScheme;
    final isExtended = screenSize.width > Breakpoints.tablet;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: isExtended
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.music_note_rounded,
                  color: colorScheme.primary,
                  size: 32,
                ),
                const SizedBox(width: 8),
                Text(
                  'Melodify',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            )
          : Icon(
              Icons.music_note_rounded,
              color: colorScheme.primary,
              size: 32,
            ),
    );
  }

  void _openPlayer(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PlayerPage(),
        fullscreenDialog: true,
      ),
    );
  }
}

class _DesktopMiniPlayer extends StatelessWidget {
  final VoidCallback onTap;

  const _DesktopMiniPlayer({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final playerProvider = context.watch<PlayerProvider>();
    final song = playerProvider.currentSong;
    final colorScheme = Theme.of(context).colorScheme;

    if (song == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Progress
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: playerProvider.progress,
                minHeight: 3,
                backgroundColor: colorScheme.surfaceContainerHighest,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    song.albumArt,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 40,
                      height: 40,
                      color: colorScheme.surfaceContainerHighest,
                      child: const Icon(Icons.music_note),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        song.title,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        song.artist,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous, size: 20),
                  onPressed: playerProvider.previous,
                  visualDensity: VisualDensity.compact,
                ),
                IconButton(
                  icon: Icon(
                    playerProvider.isPlaying ? Icons.pause : Icons.play_arrow,
                  ),
                  onPressed: playerProvider.togglePlayPause,
                  visualDensity: VisualDensity.compact,
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next, size: 20),
                  onPressed: playerProvider.next,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
