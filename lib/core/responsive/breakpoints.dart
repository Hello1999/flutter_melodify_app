/// 响应式断点定义
/// 参考 Material Design 响应式布局指南
class Breakpoints {
  Breakpoints._();

  // 断点值
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
  static const double largeDesktop = 1800;

  // 内容最大宽度
  static const double maxContentWidth = 1400;

  // 边距
  static const double mobilePadding = 16;
  static const double tabletPadding = 24;
  static const double desktopPadding = 32;
}

/// 设备类型枚举
enum DeviceType { mobile, tablet, desktop }

/// 屏幕尺寸信息
class ScreenSize {
  final double width;
  final double height;
  final DeviceType deviceType;
  final bool isPortrait;

  const ScreenSize({
    required this.width,
    required this.height,
    required this.deviceType,
    required this.isPortrait,
  });

  bool get isMobile => deviceType == DeviceType.mobile;
  bool get isTablet => deviceType == DeviceType.tablet;
  bool get isDesktop => deviceType == DeviceType.desktop;
  bool get isLandscape => !isPortrait;

  // 获取合适的网格列数
  int get gridColumns {
    switch (deviceType) {
      case DeviceType.mobile:
        return isPortrait ? 2 : 3;
      case DeviceType.tablet:
        return isPortrait ? 3 : 4;
      case DeviceType.desktop:
        return width > Breakpoints.largeDesktop ? 6 : 5;
    }
  }

  // 获取合适的边距
  double get horizontalPadding {
    switch (deviceType) {
      case DeviceType.mobile:
        return Breakpoints.mobilePadding;
      case DeviceType.tablet:
        return Breakpoints.tabletPadding;
      case DeviceType.desktop:
        return Breakpoints.desktopPadding;
    }
  }
}
