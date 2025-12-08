# Melodify - Flutter Music Streaming App

一个功能完整的 Flutter 音乐流媒体应用，展示响应式设计、Material 3 主题系统和状态管理最佳实践。

## 功能特性

### 响应式/自适应设计
- **移动端**: 底部导航栏 + 迷你播放器
- **平板**: 侧边导航栏（收缩模式）
- **桌面**: 侧边导航栏（展开模式）+ 双栏布局

### 主题系统
- 5 种主题颜色：紫色、蓝色、绿色、橙色、粉色
- 3 种模式：跟随系统、明亮、暗黑
- 主题设置持久化存储

### 页面功能

| 页面 | 功能 |
|------|------|
| 首页 | 个性化问候、快速播放、推荐歌单、排行榜、新专辑、热门艺术家、分类浏览 |
| 搜索 | 实时搜索、结果分类展示、分类浏览 |
| 音乐库 | 筛选/排序、列表/网格切换、喜欢的歌曲、创建歌单 |
| 播放器 | 完整播放控制、进度条、随机/循环、播放队列 |
| 个人中心 | 用户统计、主题设置、账户管理 |
| 歌单详情 | 响应式布局、歌曲列表、播放操作 |

## 项目结构

```
lib/
├── main.dart                 # 应用入口
├── core/
│   ├── responsive/           # 响应式布局系统
│   │   ├── breakpoints.dart      # 断点定义
│   │   ├── responsive_builder.dart # 响应式构建器
│   │   └── adaptive_scaffold.dart  # 自适应脚手架
│   └── theme/                # 主题系统
│       ├── app_colors.dart       # 颜色定义
│       └── app_theme.dart        # ThemeData 配置
├── models/                   # 数据模型
│   ├── song.dart
│   ├── playlist.dart
│   ├── artist.dart
│   ├── album.dart
│   └── category.dart
├── providers/                # 状态管理
│   ├── theme_provider.dart       # 主题状态
│   └── player_provider.dart      # 播放器状态
├── services/
│   └── mock_data.dart        # 模拟数据
├── widgets/
│   ├── common/               # 通用组件
│   ├── cards/                # 卡片组件
│   └── player/               # 播放器组件
└── pages/
    ├── app_shell.dart        # 主导航框架
    ├── home/                 # 首页
    ├── search/               # 搜索页
    ├── library/              # 音乐库
    ├── player/               # 播放器页
    ├── profile/              # 个人中心
    └── playlist/             # 歌单详情
```

## 快速开始

### 环境要求
- Flutter SDK >= 3.0.0
- Dart >= 3.0.0

### 安装运行

```bash
# 克隆项目
git clone <repository-url>
cd melodify_app

# 安装依赖
flutter pub get

# 运行应用
flutter run

# 指定平台运行
flutter run -d windows
flutter run -d chrome
flutter run -d macos
```

## 依赖库

```yaml
dependencies:
  provider: ^6.1.2              # 状态管理
  shared_preferences: ^2.3.3    # 本地存储
  cached_network_image: ^3.4.1  # 图片缓存
  audio_video_progress_bar: ^2.0.3  # 进度条
  shimmer: ^3.0.0               # 加载动画
```

## Git 提交历史

项目按功能模块分阶段提交，便于学习：

```
18. chore: Add platform-specific configurations
17. feat: Complete app entry point and configuration
16. feat(pages): Add app shell with adaptive navigation
15. feat(pages): Create playlist detail page
14. feat(pages): Add profile page with settings
13. feat(pages): Implement full-screen player page
12. feat(pages): Create library page for user content
11. feat(pages): Add search page with real-time filtering
10. feat(pages): Implement home page with music discovery
9.  feat(widgets): Add mini player widget
8.  feat(widgets): Add card components for content display
7.  feat(widgets): Add common reusable widgets
6.  feat(providers): Implement state management providers
5.  feat(services): Add mock data service
4.  feat(models): Create data models for music entities
3.  feat(theme): Implement Material 3 theme system
2.  feat(core): Add responsive layout system
1.  chore: Initialize Flutter project with dependencies
```

## 学习路径

建议按以下顺序学习本项目：

1. **响应式布局** - `lib/core/responsive/`
2. **主题系统** - `lib/core/theme/`
3. **数据模型** - `lib/models/`
4. **状态管理** - `lib/providers/`
5. **通用组件** - `lib/widgets/`
6. **页面实现** - `lib/pages/`

详细学习指南请参阅 [LEARNING_GUIDE.md](./docs/LEARNING_GUIDE.md)

## 截图预览

应用支持多种屏幕尺寸和主题配色，在不同设备上都能提供良好的用户体验。

## License

MIT License
