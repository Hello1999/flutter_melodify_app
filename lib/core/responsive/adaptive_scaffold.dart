import 'package:flutter/material.dart';
import 'breakpoints.dart';
import 'responsive_builder.dart';

/// 自适应 Scaffold
/// 在移动端显示底部导航，在桌面端显示侧边导航
class AdaptiveScaffold extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<NavigationDestination> destinations;
  final List<Widget> bodies;
  final Widget? floatingActionButton;
  final PreferredSizeWidget? appBar;

  const AdaptiveScaffold({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.destinations,
    required this.bodies,
    this.floatingActionButton,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, screenSize) {
        // 移动端：底部导航
        if (screenSize.isMobile) {
          return _buildMobileLayout(context);
        }

        // 平板/桌面：侧边导航
        return _buildDesktopLayout(context, screenSize);
      },
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: bodies[currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: destinations,
      ),
      floatingActionButton: floatingActionButton,
    );
  }

  Widget _buildDesktopLayout(BuildContext context, ScreenSize screenSize) {
    final colorScheme = Theme.of(context).colorScheme;
    final isExtended = screenSize.width > Breakpoints.tablet;

    return Scaffold(
      appBar: appBar,
      body: Row(
        children: [
          // 侧边导航栏
          NavigationRail(
            extended: isExtended,
            selectedIndex: currentIndex,
            onDestinationSelected: onDestinationSelected,
            backgroundColor: colorScheme.surface,
            labelType: isExtended
                ? NavigationRailLabelType.none
                : NavigationRailLabelType.selected,
            leading: isExtended
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
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
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Icon(
                      Icons.music_note_rounded,
                      color: colorScheme.primary,
                      size: 32,
                    ),
                  ),
            destinations: destinations
                .map((d) => NavigationRailDestination(
                      icon: d.icon,
                      selectedIcon: d.selectedIcon,
                      label: Text(d.label),
                    ))
                .toList(),
          ),
          const VerticalDivider(width: 1, thickness: 1),
          // 主内容区域
          Expanded(child: bodies[currentIndex]),
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
