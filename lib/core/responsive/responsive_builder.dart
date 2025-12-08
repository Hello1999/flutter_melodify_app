import 'package:flutter/material.dart';
import 'breakpoints.dart';

/// 响应式布局构建器
/// 根据屏幕尺寸自动选择合适的布局
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ScreenSize screenSize) builder;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });

  static ScreenSize of(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return _getScreenSize(size);
  }

  static ScreenSize _getScreenSize(Size size) {
    final width = size.width;
    final height = size.height;
    final isPortrait = height > width;

    DeviceType deviceType;
    if (width < Breakpoints.mobile) {
      deviceType = DeviceType.mobile;
    } else if (width < Breakpoints.desktop) {
      deviceType = DeviceType.tablet;
    } else {
      deviceType = DeviceType.desktop;
    }

    return ScreenSize(
      width: width,
      height: height,
      deviceType: deviceType,
      isPortrait: isPortrait,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenSize = _getScreenSize(
          Size(constraints.maxWidth, constraints.maxHeight),
        );
        return builder(context, screenSize);
      },
    );
  }
}

/// 响应式数值
/// 根据设备类型返回不同的值
class ResponsiveValue<T> {
  final T mobile;
  final T? tablet;
  final T? desktop;

  const ResponsiveValue({
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  T getValue(ScreenSize screenSize) {
    switch (screenSize.deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }
}

/// 扩展方法：根据屏幕尺寸获取响应式值
extension ResponsiveExtension on BuildContext {
  ScreenSize get screenSize => ResponsiveBuilder.of(this);

  T responsive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    return ResponsiveValue<T>(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    ).getValue(screenSize);
  }
}
