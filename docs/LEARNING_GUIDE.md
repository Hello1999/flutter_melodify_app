# Melodify 学习指南

本指南将带你深入理解 Flutter 响应式设计和主题系统的实现。

## 目录

1. [响应式布局系统](#1-响应式布局系统)
2. [Material 3 主题系统](#2-material-3-主题系统)
3. [状态管理 (Provider)](#3-状态管理-provider)
4. [组件化开发](#4-组件化开发)
5. [页面开发实践](#5-页面开发实践)
6. [Git 工作流](#6-git-工作流)

---

## 1. 响应式布局系统

### 1.1 断点定义

```dart
// lib/core/responsive/breakpoints.dart

class Breakpoints {
  static const double mobile = 600;   // 小于 600px 为移动端
  static const double tablet = 900;   // 600-900px 为平板
  static const double desktop = 1200; // 大于 900px 为桌面端
}

enum DeviceType { mobile, tablet, desktop }
```

**设计原则**:
- 使用常量定义断点，便于全局统一修改
- 枚举类型确保设备类型有限且可控

### 1.2 ResponsiveBuilder 组件

```dart
// lib/core/responsive/responsive_builder.dart

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext, ScreenSize) builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenSize = ScreenSize(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
        );
        return builder(context, screenSize);
      },
    );
  }
}
```

**核心概念**:
- `LayoutBuilder`: 获取父容器约束
- `ScreenSize`: 封装屏幕信息和响应式方法

### 1.3 ScreenSize 辅助类

```dart
class ScreenSize {
  final double width;
  final double height;

  // 判断设备类型
  bool get isMobile => width < Breakpoints.mobile;
  bool get isTablet => width >= Breakpoints.mobile && width < Breakpoints.tablet;
  bool get isDesktop => width >= Breakpoints.tablet;

  // 响应式网格列数
  int get gridColumns {
    if (isMobile) return 2;
    if (isTablet) return 3;
    return 4;
  }

  // 响应式内边距
  double get horizontalPadding {
    if (isMobile) return 16;
    if (isTablet) return 24;
    return 32;
  }
}
```

### 1.4 Context 扩展方法

```dart
extension ResponsiveExtension on BuildContext {
  // 便捷获取 ScreenSize
  ScreenSize get screenSize => ResponsiveBuilder.of(this);

  // 根据设备类型返回不同值
  T responsive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final size = screenSize;
    if (size.isDesktop) return desktop ?? tablet ?? mobile;
    if (size.isTablet) return tablet ?? mobile;
    return mobile;
  }
}
```

**使用示例**:
```dart
// 在 Widget 中使用
final cardWidth = context.responsive<double>(
  mobile: 150,
  tablet: 170,
  desktop: 200,
);
```

### 1.5 自适应导航

```dart
// 移动端: 底部导航栏
if (screenSize.isMobile) {
  return Scaffold(
    body: _pages[_currentIndex],
    bottomNavigationBar: NavigationBar(
      selectedIndex: _currentIndex,
      onDestinationSelected: (index) => setState(() => _currentIndex = index),
      destinations: _destinations,
    ),
  );
}

// 平板/桌面: 侧边导航栏
return Row(
  children: [
    NavigationRail(
      extended: screenSize.width > Breakpoints.tablet,  // 桌面端展开
      selectedIndex: _currentIndex,
      onDestinationSelected: (index) => setState(() => _currentIndex = index),
      destinations: _railDestinations,
    ),
    Expanded(child: _pages[_currentIndex]),
  ],
);
```

---

## 2. Material 3 主题系统

### 2.1 ColorScheme.fromSeed

Material 3 引入了种子颜色概念，从一个颜色自动生成完整配色方案：

```dart
// lib/core/theme/app_theme.dart

static ThemeData lightTheme(Color seedColor) {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: Brightness.light,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    // ... 其他配置
  );
}
```

**ColorScheme 包含的颜色**:
- `primary`, `onPrimary`: 主色及其上的文字颜色
- `secondary`, `onSecondary`: 次要色
- `tertiary`, `onTertiary`: 第三色
- `surface`, `onSurface`: 表面色
- `error`, `onError`: 错误色
- `outline`, `outlineVariant`: 边框色
- `surfaceContainerHighest`: 容器色（多个层级）

### 2.2 主题颜色选项

```dart
// lib/core/theme/app_colors.dart

enum ThemeColorOption {
  purple(Color(0xFF6750A4), 'Purple'),
  blue(Color(0xFF1976D2), 'Blue'),
  green(Color(0xFF388E3C), 'Green'),
  orange(Color(0xFFE65100), 'Orange'),
  pink(Color(0xFFD81B60), 'Pink');

  final Color color;
  final String label;

  const ThemeColorOption(this.color, this.label);
}
```

### 2.3 ThemeData 完整配置

```dart
return ThemeData(
  useMaterial3: true,
  colorScheme: colorScheme,

  // 应用栏主题
  appBarTheme: AppBarTheme(
    backgroundColor: colorScheme.surface,
    foregroundColor: colorScheme.onSurface,
    elevation: 0,
    scrolledUnderElevation: 1,
  ),

  // 卡片主题
  cardTheme: CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    color: colorScheme.surfaceContainerHighest,
  ),

  // 按钮主题
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  ),

  // 导航栏主题
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: colorScheme.surface,
    indicatorColor: colorScheme.secondaryContainer,
    labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
  ),

  // ... 更多组件主题
);
```

### 2.4 使用主题

```dart
// 在 Widget 中获取主题
final colorScheme = Theme.of(context).colorScheme;
final textTheme = Theme.of(context).textTheme;

// 使用颜色
Container(
  color: colorScheme.primaryContainer,
  child: Text(
    'Hello',
    style: textTheme.titleLarge?.copyWith(
      color: colorScheme.onPrimaryContainer,
    ),
  ),
)
```

### 2.5 颜色透明度 (Material 3 方式)

```dart
// 旧方式 (不推荐)
color.withOpacity(0.5)

// 新方式 (推荐)
color.withValues(alpha: 0.5)
```

---

## 3. 状态管理 (Provider)

### 3.1 ThemeProvider

```dart
// lib/providers/theme_provider.dart

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeColorOption _colorOption = ThemeColorOption.purple;

  ThemeMode get themeMode => _themeMode;
  Color get seedColor => _colorOption.color;

  // 加载保存的设置
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeIndex = prefs.getInt('theme_mode');
    if (themeModeIndex != null) {
      _themeMode = ThemeMode.values[themeModeIndex];
    }
    notifyListeners();  // 通知监听者更新
  }

  // 设置主题模式
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_mode', mode.index);
  }
}
```

### 3.2 PlayerProvider

```dart
// lib/providers/player_provider.dart

class PlayerProvider extends ChangeNotifier {
  Song? _currentSong;
  List<Song> _queue = [];
  Duration _position = Duration.zero;
  bool _shuffle = false;
  RepeatMode _repeatMode = RepeatMode.off;

  // 播放歌曲
  Future<void> play(Song song, {List<Song>? playlist}) async {
    _currentSong = song;
    _position = Duration.zero;

    if (playlist != null) {
      _queue = List.from(playlist);
    }

    _startPositionTimer();  // 开始模拟进度
    notifyListeners();
  }

  // 播放/暂停切换
  void togglePlayPause() {
    if (_playerState == PlayerState.playing) {
      pause();
    } else {
      resume();
    }
  }
}
```

### 3.3 Provider 配置

```dart
// main.dart

void main() async {
  final themeProvider = ThemeProvider();
  await themeProvider.loadSettings();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider(create: (_) => PlayerProvider()),
      ],
      child: const MelodifyApp(),
    ),
  );
}
```

### 3.4 使用 Provider

```dart
// 读取状态 (会监听变化并重建)
final themeProvider = context.watch<ThemeProvider>();

// 读取状态 (不监听变化)
final playerProvider = context.read<PlayerProvider>();

// 调用方法
playerProvider.play(song);
themeProvider.setThemeMode(ThemeMode.dark);
```

---

## 4. 组件化开发

### 4.1 通用组件

```dart
// lib/widgets/common/cached_image.dart

class AppCachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (_, __) => Shimmer.fromColors(
          // 加载占位
        ),
        errorWidget: (_, __, ___) => Container(
          // 错误占位
        ),
      ),
    );
  }
}
```

### 4.2 卡片组件

```dart
// lib/widgets/cards/song_tile.dart

class SongTile extends StatelessWidget {
  final Song song;
  final List<Song>? playlist;
  final int? index;
  final bool showIndex;

  @override
  Widget build(BuildContext context) {
    final playerProvider = context.read<PlayerProvider>();

    return ListTile(
      leading: // 封面图
      title: // 歌曲名
      subtitle: // 艺术家
      trailing: // 更多按钮
      onTap: () => playerProvider.play(song, playlist: playlist),
    );
  }
}
```

### 4.3 Barrel 文件

```dart
// lib/widgets/cards/cards.dart

export 'song_tile.dart';
export 'playlist_card.dart';
export 'artist_card.dart';
export 'album_card.dart';
export 'category_card.dart';
```

使用时只需一个 import:
```dart
import '../../widgets/cards/cards.dart';
```

---

## 5. 页面开发实践

### 5.1 SliverAppBar + CustomScrollView

```dart
Scaffold(
  body: CustomScrollView(
    slivers: [
      SliverAppBar(
        expandedHeight: 200,
        pinned: true,
        flexibleSpace: FlexibleSpaceBar(
          background: // 背景内容
        ),
      ),
      SliverToBoxAdapter(
        child: // 普通内容
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => // 列表项
          childCount: items.length,
        ),
      ),
    ],
  ),
)
```

### 5.2 响应式页面布局

```dart
@override
Widget build(BuildContext context) {
  final screenSize = ResponsiveBuilder.of(context);

  // 根据设备类型返回不同布局
  if (screenSize.isDesktop) {
    return _buildDesktopLayout(context);
  }
  return _buildMobileLayout(context);
}

Widget _buildDesktopLayout(BuildContext context) {
  return Row(
    children: [
      // 左侧面板
      SizedBox(
        width: 350,
        child: // 固定内容
      ),
      // 右侧滚动内容
      Expanded(
        child: // 滚动列表
      ),
    ],
  );
}
```

### 5.3 底部弹出菜单

```dart
void _showOptions(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit'),
            onTap: () => Navigator.pop(context),
          ),
          // 更多选项...
        ],
      ),
    ),
  );
}
```

---

## 6. Git 工作流

### 6.1 提交信息规范

使用 Conventional Commits 规范：

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

**类型 (type)**:
- `feat`: 新功能
- `fix`: 修复 bug
- `docs`: 文档修改
- `style`: 代码格式修改
- `refactor`: 重构
- `test`: 测试相关
- `chore`: 构建/工具相关

**示例**:
```bash
git commit -m "feat(theme): Implement Material 3 theme system

Add complete theming with dynamic colors:
- app_colors.dart: 5 color options
- app_theme.dart: Light and dark ThemeData"
```

### 6.2 开发流程

1. **功能分支开发**
```bash
git checkout -b feature/search-page
# 开发...
git add .
git commit -m "feat(pages): Add search page"
git checkout master
git merge feature/search-page
```

2. **查看提交历史**
```bash
git log --oneline           # 简洁历史
git log --graph             # 图形化历史
git show <commit-hash>      # 查看提交详情
```

3. **回到特定版本学习**
```bash
git checkout d9c2d09        # 切换到响应式系统提交
# 学习代码...
git checkout master         # 返回最新
```

### 6.3 本项目的提交顺序

按照真实开发流程，从基础到完整：

1. 项目初始化和依赖
2. 核心系统 (响应式 → 主题)
3. 数据层 (模型 → Mock 数据)
4. 状态管理 (Provider)
5. UI 组件 (通用 → 专用)
6. 页面 (首页 → 其他页面)
7. 整合和配置

---

## 学习建议

1. **按 Git 历史顺序学习**: 使用 `git checkout` 切换到不同提交，逐步理解项目演进
2. **修改代码实验**: 尝试修改断点值、主题颜色，观察效果
3. **添加新功能**: 尝试添加新页面、新组件，巩固学习
4. **阅读官方文档**: 结合 Flutter 官方文档深入理解 API

## 推荐资源

- [Flutter 官方文档](https://docs.flutter.dev/)
- [Material 3 设计规范](https://m3.material.io/)
- [Provider 文档](https://pub.dev/packages/provider)
- [Conventional Commits](https://www.conventionalcommits.org/)
