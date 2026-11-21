import 'package:material_ui/material_ui.dart';

import '../theme/app_dimens.dart';

enum WindowSize { compact, medium, expanded }

extension ResponsiveContext on BuildContext {
  WindowSize get windowSize {
    final width = MediaQuery.sizeOf(this).width;
    if (width < 600) return WindowSize.compact;
    if (width < 840) return WindowSize.medium;
    return WindowSize.expanded;
  }

  bool get isCompact => windowSize == WindowSize.compact;

  double get pagePadding => switch (windowSize) {
    WindowSize.compact => AppSpacing.lg,
    WindowSize.medium => AppSpacing.xl,
    WindowSize.expanded => AppSpacing.xxl,
  };

  int get gridColumns => switch (windowSize) {
    WindowSize.compact => 1,
    WindowSize.medium => 2,
    WindowSize.expanded => 3,
  };
}
