import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/responsive/responsive.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/theme_provider.dart';
import '../../services/mock_data.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = ResponsiveBuilder.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Profile Header
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      colorScheme.primaryContainer,
                      colorScheme.surface,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: colorScheme.primary,
                        child: Text(
                          'U',
                          style: textTheme.displayMedium?.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'User Name',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '3 playlists · 24 following',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => _showSettings(context),
              ),
            ],
          ),

          // Stats
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(screenSize.horizontalPadding),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatItem(
                        value: '${MockData.songs.where((s) => s.isLiked).length}',
                        label: 'Liked Songs',
                      ),
                      _StatItem(
                        value: '${MockData.userPlaylists.length}',
                        label: 'Playlists',
                      ),
                      _StatItem(
                        value: '${MockData.artists.length}',
                        label: 'Following',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Quick Actions
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenSize.horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Actions',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                _ActionTile(
                  icon: Icons.history,
                  title: 'Listening History',
                  subtitle: 'See what you\'ve been playing',
                  onTap: () {},
                ),
                _ActionTile(
                  icon: Icons.download,
                  title: 'Downloads',
                  subtitle: 'Manage your offline music',
                  onTap: () {},
                ),
                _ActionTile(
                  icon: Icons.equalizer,
                  title: 'Audio Quality',
                  subtitle: 'Very High (320kbps)',
                  onTap: () {},
                ),
              ],
            ),
          ),

          // Theme Settings
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(screenSize.horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'Appearance',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          // Theme Mode
          SliverToBoxAdapter(
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: screenSize.horizontalPadding),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(themeProvider.themeModeIcon),
                    title: const Text('Theme Mode'),
                    subtitle: Text(themeProvider.themeModeLabel),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showThemeModeSelector(context),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: themeProvider.seedColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    title: const Text('Theme Color'),
                    subtitle: Text(themeProvider.colorOption.label),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showColorPicker(context),
                  ),
                ],
              ),
            ),
          ),

          // Account Settings
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(screenSize.horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'Account',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                _ActionTile(
                  icon: Icons.person,
                  title: 'Edit Profile',
                  onTap: () {},
                ),
                _ActionTile(
                  icon: Icons.notifications,
                  title: 'Notifications',
                  onTap: () {},
                ),
                _ActionTile(
                  icon: Icons.privacy_tip,
                  title: 'Privacy',
                  onTap: () {},
                ),
                _ActionTile(
                  icon: Icons.help,
                  title: 'Help & Support',
                  onTap: () {},
                ),
                _ActionTile(
                  icon: Icons.info,
                  title: 'About',
                  subtitle: 'Version 1.0.0',
                  onTap: () {},
                ),
              ],
            ),
          ),

          // Logout
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(screenSize.horizontalPadding),
              child: OutlinedButton(
                onPressed: () {},
                child: const Text('Log Out'),
              ),
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

  void _showSettings(BuildContext context) {
    // Navigate to full settings page
  }

  void _showThemeModeSelector(BuildContext context) {
    final themeProvider = context.read<ThemeProvider>();

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
                'Theme Mode',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            RadioGroup<ThemeMode>(
              groupValue: themeProvider.themeMode,
              onChanged: (value) {
                if (value != null) {
                  themeProvider.setThemeMode(value);
                  Navigator.pop(context);
                }
              },
              child: Column(
                children: [
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.system,
                    title: const Text('System'),
                    subtitle: const Text('Follow device settings'),
                    secondary: const Icon(Icons.brightness_auto),
                  ),
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.light,
                    title: const Text('Light'),
                    secondary: const Icon(Icons.light_mode),
                  ),
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.dark,
                    title: const Text('Dark'),
                    secondary: const Icon(Icons.dark_mode),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showColorPicker(BuildContext context) {
    final themeProvider = context.read<ThemeProvider>();

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
                'Theme Color',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: ThemeColorOption.values.map((option) {
                  final isSelected = option == themeProvider.colorOption;
                  return GestureDetector(
                    onTap: () {
                      themeProvider.setColorOption(option);
                      Navigator.pop(context);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: option.color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(
                                color: Theme.of(context).colorScheme.onSurface,
                                width: 3,
                              )
                            : null,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: option.color.withValues(alpha: 0.5),
                                  blurRadius: 8,
                                ),
                              ]
                            : null,
                      ),
                      child: isSelected
                          ? Icon(
                              Icons.check,
                              color: ThemeData.estimateBrightnessForColor(option.color) ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Text(
          value,
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
