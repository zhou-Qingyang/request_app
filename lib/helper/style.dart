import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

SystemUiOverlayStyle getSystemUiOverlayStyle(bool isDark) {
  if (isDark) {
    return const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,                    // 状态栏背景透明
      statusBarIconBrightness: Brightness.light,            // 状态栏图标亮色
      statusBarBrightness: Brightness.dark,                 // iOS 状态栏样式
      systemNavigationBarColor: Color(0xFF000000),          // 底部导航栏黑色
      systemNavigationBarIconBrightness: Brightness.light,  // 导航栏图标亮色
      systemNavigationBarDividerColor: Colors.transparent,  // 导航栏分割线透明
    );
  } else {
    return const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,                    // 状态栏背景透明
      statusBarIconBrightness:  Brightness.dark,             // 状态栏图标暗色
      statusBarBrightness: Brightness.light,                // iOS 状态栏样式
      systemNavigationBarColor: Colors.white,               // 底部导航栏白色
      systemNavigationBarIconBrightness: Brightness.dark,   // 导航栏图标暗色
      systemNavigationBarDividerColor: Colors. transparent,  // 导航栏分割线透明
    );
  }
}

class Styles {
  static Color mainBackground = Color(0xFFF5F5F5);
  static Color mainFontColor = Color(0xFF262626);
  static Color grayFontColor = Color(0xFFAEC3FF);
  static Color orgFontColor = Color(0xFFf76a0c);
  static Color bluFontColor = Color(0xFF3f70f2);

  static Color chevronRightIconColor = Color(0xFFBBBBBB);
  static Color themeStartColor = Color(0xFF3a6efd);
  static Color themeEndColor =  Color(0xFFF5F5F5);

  static Color bottomBarSelected = Color(0xFF406ff4);
  static Color bottomBarUnSelected = Color(0xFF1f1f1f);

  static Color bellColor = Color(0xFF3b6ffe);
  static Color hexagonBorderColor = Colors.white.withOpacity(0.3);
}
